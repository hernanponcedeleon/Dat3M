package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.ControlBarrier;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.google.common.collect.Lists.reverse;
import static java.util.stream.Collectors.*;

@Options
public class ProgramEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(ProgramEncoder.class);

    // =========================== Configurables ===========================

    @Option(name = INITIALIZE_REGISTERS,
            description = "Assume thread-local variables start off containing zero.",
            secure = true)
    private boolean initializeRegisters = false;

    @Option(name = IGNORE_FILTER_SPECIFICATION,
            description = "Ignore final states filter",
            secure = true)
    private boolean ignoreFilterSpec = false;

    // =====================================================================

    private final EncodingContext context;
    private final ExecutionAnalysis exec;
    private final ReachingDefinitionsAnalysis definitions;

    private ProgramEncoder(EncodingContext c) {
        Preconditions.checkArgument(c.getTask().getProgram().isCompiled(), "The program must be compiled before encoding.");
        context = c;
        c.getAnalysisContext().requires(BranchEquivalence.class);
        this.exec = c.getAnalysisContext().requires(ExecutionAnalysis.class);
        this.definitions = c.getAnalysisContext().requires(ReachingDefinitionsAnalysis.class);
    }

    public static ProgramEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        ProgramEncoder encoder = new ProgramEncoder(context);
        context.getTask().getConfig().inject(encoder);
        logger.info("{}: {}", INITIALIZE_REGISTERS, encoder.initializeRegisters);
        logger.info("{}: {}", IGNORE_FILTER_SPECIFICATION, encoder.ignoreFilterSpec);
        return encoder;
    }

    // ====================================== Encoding ======================================

    public BooleanFormula encodeFullProgram() {
        return context.getBooleanFormulaManager().and(
                encodeControlBarriers(),
                encodeConstants(),
                encodeMemory(),
                encodeControlFlow(),
                encodeFinalRegisterValues(),
                encodeFilter(),
                encodeDependencies());
    }

    public BooleanFormula encodeConstants() {
        List<BooleanFormula> enc = new ArrayList<>();
        for (NonDetValue value : context.getTask().getProgram().getConstants()) {
            final Formula formula = context.encodeFinalExpression(value);
            if (formula instanceof IntegerFormula intFormula && value.getType() instanceof IntegerType intType) {
                // This special case is for when we encode BVs with integers.
                final IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
                final IntegerFormula min = imgr.makeNumber(intType.getMinimumValue(value.isSigned()));
                final IntegerFormula max = imgr.makeNumber(intType.getMaximumValue(value.isSigned()));
                enc.add(imgr.greaterOrEquals(intFormula, min));
                enc.add(imgr.lessOrEquals(intFormula, max));
            }
        }
        return context.getBooleanFormulaManager().and(enc);
    }

    // ====================================== Control flow ======================================

    private boolean isInitThread(Thread thread) {
        return thread.getEntry().getSuccessor() instanceof Init;
    }

    /*
        A thread is enabled if it has no creator or the corresponding ThreadCreate
        event was executed (and didn't fail spuriously).
        // TODO: We could make ThreadCreate "not executed" if it fails rather than guessing the success state here.
        // FIXME: The guessing allows for mismatches: the spawning may succeed but the guess says it doesn't.
     */
    private BooleanFormula threadIsEnabled(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final ThreadStart start = thread.getEntry();
        if (!start.isSpawned()) {
            return bmgr.makeTrue();
        } else if (!start.mayFailSpuriously()) {
            return context.execution(start.getCreator());
        } else {
            final String spawnSuccessVarName = "__spawnSuccess#" + thread.getId();
            return bmgr.and(context.execution(start.getCreator()), bmgr.makeVariable(spawnSuccessVarName));
        }
    }

    private BooleanFormula threadHasStarted(Thread thread) {
        return context.execution(thread.getEntry());
    }

    // NOTE: A thread that was never spawned is also non-terminating.
    private BooleanFormula threadHasTerminated(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return bmgr.and(
                context.execution(thread.getExit()), // Also guarantees that we are not stuck in a barrier
                bmgr.not(threadIsStuckInLoop(thread))
        );
    }

    // NOTE: Stuckness also considers bound events, i.e., insufficiently unrolled loops.
    private BooleanFormula threadIsStuckInLoop(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> nonTerminationWitnesses = new ArrayList<>();
        for (CondJump jump : thread.getEvents(CondJump.class)) {
            if (jump.hasTag(Tag.NONTERMINATION)) {
                nonTerminationWitnesses.add(bmgr.and(
                        context.execution(jump),
                        context.jumpCondition(jump)
                ));
            }
        }

        return bmgr.or(nonTerminationWitnesses);
    }

    private BooleanFormula barrierIsBlocking(ControlBarrier barrier) {
        final BooleanFormulaManager bmgr = context.getFormulaManager().getBooleanFormulaManager();
        return bmgr.and(
                context.controlFlow(barrier),
                bmgr.not(context.execution(barrier))
        );
    }

    private BooleanFormula threadIsStuckInBarrier(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return thread.getEvents(ControlBarrier.class).stream()
                .map(this::barrierIsBlocking)
                .reduce(bmgr.makeFalse(), bmgr::or);
    }

    private int getWorkgroupId(Thread thread) {
        ScopeHierarchy hierarchy = thread.getScopeHierarchy();
        if (hierarchy != null) {
            int id = hierarchy.getScopeId(Tag.Vulkan.WORK_GROUP);
            if (id < 0) {
                id = hierarchy.getScopeId(Tag.PTX.CTA);
            }
            return id;
        }
        throw new IllegalArgumentException("Attempt to compute workgroup ID " +
                "for a non-hierarchical thread");
    }

    public BooleanFormula encodeControlFlow() {
        logger.info("Encoding program control flow with progress model {}", context.getTask().getProgressModel());

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final ForwardProgressEncoder progressEncoder = new ForwardProgressEncoder();
        List<BooleanFormula> enc = new ArrayList<>();
        for(Thread t : context.getTask().getProgram().getThreads()){
            enc.add(encodeConsistentThreadCF(t));
            if (isInitThread(t)) {
                // Init threads are always scheduled fairly
                enc.add(progressEncoder.encodeFairForwardProgress(t));
            }
        }
        enc.add(encodeForwardProgress(context.getTask().getProgram(), context.getTask().getProgressModel()));
        return bmgr.and(enc);
    }

    /*
        A thread has consistent control flow if every event in the cf
           (1) has a predecessor
        OR (2) is the ThreadStart event and the thread is enabled
        This does NOT encode any forward progress guarantees.
        TODO: Refactor out the awkward .encodeExec calls
     */
    private BooleanFormula encodeConsistentThreadCF(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final ThreadStart startEvent = thread.getEntry();
        final List<BooleanFormula> enc = new ArrayList<>();

        enc.add(bmgr.implication(threadHasStarted(thread), threadIsEnabled(thread)));
        enc.add(startEvent.encodeExec(context));

        for(final Event cur : startEvent.getSuccessor().getSuccessors()) {
            final Event pred = cur.getPredecessor();
            // Immediate control flow
            BooleanFormula cfCond = context.controlFlow(pred);
            if (pred instanceof CondJump jump) {
                cfCond = bmgr.and(cfCond, bmgr.not(context.jumpCondition(jump)));
            } else if (pred instanceof ControlBarrier) {
                cfCond = bmgr.and(cfCond, context.execution(pred));
            }

            if (cur instanceof Label label) {
                for (CondJump jump : label.getJumpSet()) {
                    cfCond = bmgr.or(cfCond, bmgr.and(context.controlFlow(jump), context.jumpCondition(jump)));
                }
            }

            // cf(cur) => exists pred: cf(pred) && "pred->cur"
            enc.add(bmgr.implication(context.controlFlow(cur), cfCond));
            // encode execution semantics
            enc.add(cur.encodeExec(context));
            // TODO: Maybe add "exec => cf" implications automatically.
            //  We probably never want events that can execute without being in the control-flow.
        }
        return bmgr.and(enc);
    }

    private BooleanFormula encodeControlBarriers() {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        Map<Integer, List<ControlBarrier>> groups = context.getTask().getProgram().getThreads().stream()
                .filter(Thread::hasScope)
                .collect(groupingBy(this::getWorkgroupId,
                        flatMapping(t -> t.getEvents(ControlBarrier.class).stream(), toList())));

        for (List<ControlBarrier> events : groups.values()) {
            for (ControlBarrier e1 : events) {
                Expression id1 = e1.getId();
                BooleanFormula allCF = context.controlFlow(e1);
                for (ControlBarrier e2 : events) {
                    if (!e1.getThread().equals(e2.getThread())) {
                        Expression id2 = e2.getId();
                        BooleanFormula sameId = context.equal(context.encodeExpressionAt(id1, e1), context.encodeExpressionAt(id2, e2));
                        BooleanFormula cf = bmgr.or(context.controlFlow(e2), bmgr.not(sameId));
                        allCF = bmgr.and(allCF, cf);
                    }
                }
                enc = bmgr.and(enc, bmgr.equivalence(allCF, context.execution(e1)));
            }
        }
        return enc;
    }

    private BooleanFormula encodeForwardProgress(Program program, ProgressModel progressModel) {
        final ForwardProgressEncoder progressEncoder = new ForwardProgressEncoder();
        return switch (progressModel) {
            case FAIR -> progressEncoder.encodeFairForwardProgress(program);
            case HSA -> progressEncoder.encodeHSAForwardProgress(program);
            case OBE -> progressEncoder.encodeOBEForwardProgress(program);
            case UNFAIR -> progressEncoder.encodeUnfairForwardProgress(program);
        };
    }

    // ====================================== Memory layout ======================================

    // Encodes the address values and sizes of memory objects.
    public BooleanFormula encodeMemory() {
        logger.info("Encoding memory");
        return encodeMemoryLayout(context.getTask().getProgram().getMemory());
    }

    private BooleanFormula encodeMemoryLayout(Memory memory) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingHelper helper = new EncodingHelper(context.getFormulaManager());
        final List<BooleanFormula> enc = new ArrayList<>();

        // TODO: We could sort the objects to generate better encoding:
        //  "static -> dynamic with known size -> dynamic with unknown size"
        //  For the former two we can then statically assign addresses as we do now and
        //  only the latter needs dynamic encodings.
        final List<MemoryObject> memoryObjects = ImmutableList.copyOf(memory.getObjects());
        for (int i = 0; i < memoryObjects.size(); i++) {
            final MemoryObject cur = memoryObjects.get(i);
            final Formula addr = context.address(cur);
            final Formula size = context.size(cur);
            final Formula alignment;

            // Encode size & compute alignment
            if (cur.isStaticallyAllocated()) {
                enc.add(helper.equals(size, context.encodeFinalExpression(cur.size())));
                alignment = context.encodeFinalExpression(cur.alignment());
            } else {
                // Non-allocated objects, i.e. objects whose Alloc event was not executed, get size 0
                enc.add(helper.equals(size,
                                bmgr.ifThenElse(context.execution(cur.getAllocationSite()),
                                        context.encodeExpressionAt(cur.size(), cur.getAllocationSite()),
                                        helper.value(BigInteger.ZERO, helper.typeOf(size)))
                        )
                );
                // Non-allocated objects with variable alignment get alignment 1
                alignment = cur.hasKnownAlignment() ? context.encodeExpressionAt(cur.alignment(), cur.getAllocationSite())
                        : bmgr.ifThenElse(context.execution(cur.getAllocationSite()),
                        context.encodeExpressionAt(cur.alignment(), cur.getAllocationSite()),
                        helper.value(BigInteger.ONE, helper.typeOf(size)));
            }

            // Encode address (we even give non-allocated objects a proper, well-aligned address)
            final MemoryObject prev = i > 0 ? memoryObjects.get(i - 1) : null;
            if (prev == null) {
                // First object is placed at alignment
                enc.add(helper.equals(addr, alignment));
            } else {
                final Formula prevAddr = context.address(prev);
                final Formula prevSize = context.size(prev);
                final Formula nextAvailableAddr = helper.add(prevAddr, prevSize);
                final Formula nextAlignedAddr = helper.add(nextAvailableAddr,
                        helper.subtract(alignment, helper.remainder(nextAvailableAddr, alignment))
                );
                enc.add(helper.equals(addr, nextAlignedAddr));
            }
        }

        return bmgr.and(enc);
    }

    // ====================================== Data flow ======================================

    /**
     * @return
     * Describes that for each pair of events, if the reader uses the result of the writer,
     * then the value the reader gets from the register is exactly the value that the writer computed.
     * Also, the reader may only use the value of the latest writer that is executed.
     * Also, if no fitting writer is executed, the reader uses 0.
     */
    public BooleanFormula encodeDependencies() {
        logger.info("Encoding dependencies");
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        for (RegReader reader : context.getTask().getProgram().getThreadEvents(RegReader.class)) {
            final ReachingDefinitionsAnalysis.Writers writers = definitions.getWriters(reader);
            for (Register register : writers.getUsedRegisters()) {
                final Formula value = context.encodeExpressionAt(register, reader);
                final List<BooleanFormula> overwrite = new ArrayList<>();
                final ReachingDefinitionsAnalysis.RegisterWriters reg = writers.ofRegister(register);
                for (RegWriter writer : reverse(reg.getMayWriters())) {
                    BooleanFormula edge;
                    if (reg.getMustWriters().contains(writer)) {
                        if (exec.isImplied(reader, writer) && reader.cfImpliesExec()) {
                            // This special case is important. Usually, we encode "dep => regValue = regWriterResult"
                            // By getting rid of the guard "dep" in this special case, we end up with an unconditional
                            // "regValue = regWriterResult", which allows the solver to eliminate one of the variables
                            // in preprocessing.
                            assert reg.getMayWriters().size() == 1;
                            edge = bmgr.makeTrue();
                        } else {
                            edge = bmgr.and(context.execution(writer), context.controlFlow(reader));
                        }
                    } else {
                        edge = context.dependency(writer, reader);
                        enc.add(bmgr.equivalence(edge, bmgr.and(context.execution(writer), context.controlFlow(reader), bmgr.not(bmgr.or(overwrite)))));
                    }
                    enc.add(bmgr.implication(edge, context.equal(value, context.result(writer))));
                    overwrite.add(context.execution(writer));
                }
                if(initializeRegisters && !reg.mustBeInitialized()) {
                    overwrite.add(bmgr.not(context.controlFlow(reader)));
                    overwrite.add(context.equalZero(value));
                    enc.add(bmgr.or(overwrite));
                }
            }
        }
        return bmgr.and(enc);
    }

    public BooleanFormula encodeFilter() {
        if (!ignoreFilterSpec && context.getTask().getProgram().getFilterSpecification() != null) {
            return context.encodeFinalExpressionAsBoolean(context.getTask().getProgram().getFilterSpecification());
        }
        return context.getBooleanFormulaManager().makeTrue();
    }

    public BooleanFormula encodeFinalRegisterValues() {
        final BooleanFormulaManager bmgr = context.getFormulaManager().getBooleanFormulaManager();
        if (context.getTask().getProgram().getFormat() != Program.SourceLanguage.LITMUS) {
            // LLVM code does not have assertions over final register values, so we do not need to encode them.
            logger.info("Skipping encoding of final register values: C-Code has no assertions over those values.");
            return bmgr.makeTrue();
        }

        logger.info("Encoding final register values");
        List<BooleanFormula> enc = new ArrayList<>();
        final ReachingDefinitionsAnalysis.Writers finalState = definitions.getFinalWriters();
        for (Register register : finalState.getUsedRegisters()) {
            final Formula value = context.encodeFinalExpression(register);
            final ReachingDefinitionsAnalysis.RegisterWriters registerWriters = finalState.ofRegister(register);
            final List<RegWriter> writers = registerWriters.getMayWriters();
            if (initializeRegisters && !registerWriters.mustBeInitialized()) {
                List<BooleanFormula> clause = new ArrayList<>();
                clause.add(context.equalZero(value));
                for (Event w : writers) {
                    clause.add(context.execution(w));
                }
                enc.add(bmgr.or(clause));
            }
            for (int i = 0; i < writers.size(); i++) {
                final RegWriter writer = writers.get(i);
                List<BooleanFormula> clause = new ArrayList<>();
                clause.add(context.equal(value, context.result(writer)));
                clause.add(bmgr.not(context.execution(writer)));
                for (Event w : writers.subList(i + 1, writers.size())) {
                    if (!exec.areMutuallyExclusive(writer, w)) {
                        clause.add(context.execution(w));
                    }
                }
                enc.add(bmgr.or(clause));
            }
        }
        return bmgr.and(enc);
    }

    // ============================================ Forward progress ============================================

    private class ForwardProgressEncoder {

        /*
            Encodes fair forward progress for a single thread: the thread will eventually get scheduled (if it is enabled).
            In particular, if the thread is enabled then it will eventually execute.
         */
        private BooleanFormula encodeFairForwardProgress(Thread thread) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final List<BooleanFormula> enc = new ArrayList<>();

            // An enabled thread eventually gets started/scheduled
            enc.add(bmgr.implication(threadIsEnabled(thread), threadHasStarted(thread)));

            // For every event in the cf a successor will be in the cf (unless a barrier is blocking).
            for (Event cur : thread.getEvents()) {
                if (cur == thread.getExit()) {
                    break;
                }
                final List<Event> succs = new ArrayList<>();
                final BooleanFormula curCf = context.controlFlow(cur);
                final BooleanFormula isNotBlocked = cur instanceof ControlBarrier ? context.execution(cur) : bmgr.makeTrue();

                succs.add(cur.getSuccessor());
                if (cur instanceof CondJump jump) {
                    succs.add(jump.getLabel());
                }
                enc.add(bmgr.implication(bmgr.and(curCf, isNotBlocked), bmgr.or(Lists.transform(succs, context::controlFlow))));
            }
            return bmgr.and(enc);
        }

        /*
            Minimal progress means that at least one thread must get scheduled, i.e., the execution cannot just stop.
            In particular, a single-threaded program must progress and concurrent programs with only finite threads
            must terminate (unless blocked).

            NOTE: For producing correct verdicts on loop-based nontermination, we do not really require
                  minimal progress guarantees.
                  This may change in the presence of control barriers, depending on how they affect scheduling,
                  i.e., do blocked threads remain eligible for scheduling?
         */
        private BooleanFormula encodeMinimalProgress(Program program) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

            BooleanFormula allThreadsTerminated = bmgr.makeTrue();
            BooleanFormula aThreadIsStuck = bmgr.makeFalse();
            for (Thread t : program.getThreads()) {
                if (isInitThread(t)) {
                    continue;
                }
                allThreadsTerminated = bmgr.and(allThreadsTerminated,
                        bmgr.or(bmgr.not(threadIsEnabled(t)), threadHasTerminated(t))
                );
                // Here we assume that a thread stuck in a barrier is eligible for scheduling
                // so we can (unfairly) schedule the blocked thread indefinitely
                // TODO: We may revise this and disallow blocked threads from getting scheduled again.
                aThreadIsStuck = bmgr.or(aThreadIsStuck,
                        bmgr.or(threadIsStuckInLoop(t), threadIsStuckInBarrier(t))
                );
            }

            return bmgr.or(allThreadsTerminated, aThreadIsStuck);
        }

        // ---------------------------------------------------------------------------

        // FAIR: All threads have fair forward progress
        private BooleanFormula encodeFairForwardProgress(Program program) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final List<BooleanFormula> enc = new ArrayList<>();
            for (Thread thread : program.getThreads()) {
                if (!isInitThread(thread)) {
                    // We skip init threads because they get special treatment.
                    enc.add(encodeFairForwardProgress(thread));
                }
            }
            return bmgr.and(enc);
        }

        // UNFAIR: No threads have fair forward progress
        private BooleanFormula encodeUnfairForwardProgress(Program program) {
            return encodeMinimalProgress(program);
        }

        // OBE: All executing threads are scheduled fairly.
        private BooleanFormula encodeOBEForwardProgress(Program program) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final List<BooleanFormula> enc = new ArrayList<>();
            for (Thread thread : program.getThreads()) {
                if (isInitThread(thread)) {
                    continue;
                }
                final BooleanFormula wasScheduledOnce = threadHasStarted(thread);
                final BooleanFormula fairProgress = encodeFairForwardProgress(thread);
                enc.add(bmgr.implication(wasScheduledOnce, fairProgress));
            }
            enc.add(encodeMinimalProgress(program));
            return bmgr.and(enc);
        }

        // HSA: Lowest id thread is scheduled fairly.
        private BooleanFormula encodeHSAForwardProgress(Program program) {
            final List<Thread> threads = new ArrayList<>(program.getThreads());
            threads.sort(Comparator.comparingInt(Thread::getId));
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

            final List<BooleanFormula> enc = new ArrayList<>();
            for (int i = 0; i < threads.size(); i++) {
                final Thread thread = threads.get(i);
                if (isInitThread(thread)) {
                    continue;
                }
                final List<BooleanFormula> allLowerIdThreadsTerminated = new ArrayList<>();
                for (Thread t : threads.subList(0, i)) {
                    allLowerIdThreadsTerminated.add(bmgr.or(threadHasTerminated(t), bmgr.not(threadIsEnabled(t))));
                }
                final BooleanFormula threadHasLowestIdAmongActiveThreads = bmgr.and(allLowerIdThreadsTerminated);
                final BooleanFormula fairProgress = encodeFairForwardProgress(thread);
                enc.add(bmgr.implication(threadHasLowestIdAmongActiveThreads, fairProgress));
            }
            enc.add(encodeMinimalProgress(program));
            return bmgr.and(enc);
        }

    }
}

