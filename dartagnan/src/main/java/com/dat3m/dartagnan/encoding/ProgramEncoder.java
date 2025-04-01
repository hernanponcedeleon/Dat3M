package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadJoin;
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
import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.dat3m.dartagnan.configuration.OptionNames.INITIALIZE_REGISTERS;
import static com.google.common.collect.Lists.reverse;
import static java.util.stream.Collectors.groupingBy;
import static java.util.stream.Collectors.toMap;

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
                encodeNamedControlBarriers(),
                encodeThreadJoining(),
                encodeConstants(),
                encodeMemory(),
                encodeControlFlow(),
                encodeFinalRegisterValues(),
                encodeFilter(),
                encodeDependencies()
        );
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

    private BooleanFormula threadHasTerminatedNormally(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final BooleanFormula exception = thread.getEvents(CondJump.class).stream()
                .filter(jump -> jump.hasTag(Tag.EXCEPTIONAL_TERMINATION))
                .map(context::jumpTaken)
                .reduce(bmgr.makeFalse(), bmgr::or);
        return bmgr.and(threadHasTerminated(thread), bmgr.not(exception));
    }

    // NOTE: Stuckness also considers bound events, i.e., insufficiently unrolled loops.
    private BooleanFormula threadIsStuckInLoop(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return thread.getEvents(CondJump.class).stream()
                .filter(jump -> jump.hasTag(Tag.NONTERMINATION))
                .map(context::jumpTaken)
                .reduce(bmgr.makeFalse(), bmgr::or);
    }

    private BooleanFormula threadIsBlocked(Thread thread) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return thread.getEvents(BlockingEvent.class).stream()
                .map(context::blocked)
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
                cfCond = bmgr.and(cfCond, bmgr.not(context.jumpTaken(jump)));
            } else if (pred instanceof BlockingEvent barrier) {
                cfCond = bmgr.and(cfCond, context.unblocked(barrier));
            }

            if (cur instanceof Label label) {
                for (CondJump jump : label.getJumpSet()) {
                    cfCond = bmgr.or(cfCond, context.jumpTaken(jump));
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

    private BooleanFormula encodeThreadJoining() {
        final Program program = context.getTask().getProgram();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        List<BooleanFormula> enc = new ArrayList<>();
        for (ThreadJoin join : program.getThreadEvents(ThreadJoin.class)) {
            final BooleanFormula joinCf = context.controlFlow(join);
            final BooleanFormula joinExec = context.execution(join);
            final BooleanFormula terminated = threadHasTerminatedNormally(join.getJoinThread());

            enc.add(bmgr.implication(joinExec, terminated));
            enc.add(bmgr.implication(bmgr.and(terminated, joinCf), joinExec));
            // TODO: Encode retVal.
        }

        return bmgr.and(enc);
    }

    private BooleanFormula encodeControlBarriers() {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        Map<String, BooleanFormula> allCfVariables = new HashMap<>();

        Map<String, List<ControlBarrier>> barriers = context.getTask().getProgram().getThreadEvents(ControlBarrier.class).stream()
                .filter(b -> !(b instanceof NamedBarrier))
                .collect(groupingBy(b -> "all_barriers_" + getWorkgroupId(b.getThread()) + "@" + b.getInstanceId()));

        Map<String, BooleanFormula> allCfConjunctions = barriers.entrySet().stream()
                .collect(toMap(Map.Entry::getKey, e -> bmgr.and(e.getValue().stream().map(context::controlFlow).toList())));

        for (Map.Entry<String, BooleanFormula> entry : allCfConjunctions.entrySet()) {
            BooleanFormula variable = bmgr.makeVariable(entry.getKey());
            allCfVariables.put(entry.getKey(), variable);
            enc = bmgr.and(enc, bmgr.equivalence(variable, entry.getValue()));
        }

        for (Map.Entry<String, List<ControlBarrier>> entry : barriers.entrySet()) {
            BooleanFormula variable = allCfVariables.get(entry.getKey());
            for (ControlBarrier barrier : entry.getValue()) {
                enc = bmgr.and(enc, bmgr.equivalence(variable, context.execution(barrier)));
            }
        }
        return enc;
    }

    private BooleanFormula encodeNamedControlBarriers() {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();

        Map<String, List<NamedBarrier>> barriers = context.getTask().getProgram().getThreadEvents(NamedBarrier.class).stream()
                .collect(groupingBy(b -> getWorkgroupId(b.getThread()) + "@" + b.getInstanceId()));

        for (List<NamedBarrier> events : barriers.values()) {
            for (NamedBarrier e1 : events) {
                List<NamedBarrier> other = events;
                if (e1.getResourceId() instanceof IntLiteral) {
                    other = events.stream()
                            .filter(e2 -> !(e2.getResourceId() instanceof IntLiteral) || e1.getResourceId().equals(e2.getResourceId()))
                            .toList();
                }
                if (e1.getQuorum() != null) {
                    enc = bmgr.and(enc, encodeNamedBarrierCfQuorum(e1, other));
                } else {
                    enc = bmgr.and(enc, encodeNamedBarrierCfAll(e1, other));
                }
            }
        }
        return enc;
    }

    private BooleanFormula encodeNamedBarrierCfAll(NamedBarrier e1, List<NamedBarrier> events) {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        Expression id1 = e1.getResourceId();
        BooleanFormula allCF = bmgr.makeTrue();
        for (NamedBarrier e2 : events) {
            BooleanFormula sameId = context.equal(context.encodeExpressionAt(id1, e1), context.encodeExpressionAt(e2.getResourceId(), e2));
            BooleanFormula cf = bmgr.or(context.controlFlow(e2), bmgr.not(sameId));
            allCF = bmgr.and(allCF, cf);
        }
        return bmgr.and(context.sync(e1), bmgr.equivalence(allCF, context.execution(e1)));
    }

    /*
     * Variables:
     * - `bool: sync(e: NamedBarrier)` : defines whether `e` is in `syncbar` relation
     * - `int: quorum(e: NamedBarrier)` : a parameter of `e` defining the minimal number of threads to reach the barrier
     * - `cf_count(e: NamedBarrier)` : the number of threads that reached the barrier in control flow
     * - `sync_count(e: NamedBarrier)` : the number of threads that synchronize on the barrier
     *
     * Note: `cf_count` and `sync_count` cannot use a single variable for the whole barrier and must be defined for each
     * event, because for PTX `resourceId` may vary in different executions.
     *
     * Constraints:
     * - `sync(e) => exec(e)`
     * - `exec(e) <=> (cf(e) /\ (sync_count(e) >= quorum(e)))`
     * - `(cf_count(e) >= quorum(e)) => (sync_count(e) >= quorum(e))`
     * - `cf_count(e) <=> sum((cf(e1) /\ sameId(e, e1)), (cf(e2) /\ sameId(e, e2)), .., (cf(en) /\ sameId(e, en)))`
     * - `sync_count(e) <=> sum((sync(e1) /\ sameId(e, e1)), (sync(e2) /\ sameId(e, e2)), .., (sync(en) /\ sameId(e, en)))`
     */
    private BooleanFormula encodeNamedBarrierCfQuorum(NamedBarrier e1, List<NamedBarrier> events) {
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
        Expression id1 = e1.getResourceId();

        List<IntegerFormula> cfCountMembers = new ArrayList<>();
        List<IntegerFormula> syncCountMembers = new ArrayList<>();
        for (NamedBarrier e2 : events) {
            BooleanFormula sameId = context.equal(context.encodeExpressionAt(id1, e1), context.encodeExpressionAt(e2.getResourceId(), e2));
            IntegerFormula iCf = context.toInteger(bmgr.and(sameId, context.controlFlow(e2)));
            IntegerFormula iSync = context.toInteger(bmgr.and(sameId, context.sync(e2)));
            cfCountMembers.add(iCf);
            syncCountMembers.add(iSync);
        }

        IntegerFormula cfCount = imgr.makeVariable("cf_count(" + e1.getGlobalId() + ")");
        IntegerFormula syncCount = imgr.makeVariable("sync_count(" + e1.getGlobalId() + ")");
        BooleanFormula hasQuorum = bmgr.makeVariable("quorum(" + e1.getGlobalId() + ")");
        Formula quorum = context.encodeExpressionAt(e1.getQuorum(), e1);

        BooleanFormula enc = bmgr.equivalence(hasQuorum, context.encodeComparison(IntCmpOp.GTE, syncCount, quorum));
        enc = bmgr.and(enc, bmgr.equivalence(context.execution(e1), bmgr.and(context.controlFlow(e1), hasQuorum)));
        enc = bmgr.and(enc, bmgr.implication(context.encodeComparison(IntCmpOp.GTE, cfCount, quorum), hasQuorum));
        enc = bmgr.and(enc, imgr.equal(cfCount, imgr.sum(cfCountMembers)));
        enc = bmgr.and(enc, imgr.equal(syncCount, imgr.sum(syncCountMembers)));

        return bmgr.and(enc, bmgr.implication(context.sync(e1), context.execution(e1)));
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
                final BooleanFormula isNotBlocked = cur instanceof BlockingEvent cb ? context.unblocked(cb) : bmgr.makeTrue();

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
                        bmgr.or(threadIsStuckInLoop(t), threadIsBlocked(t))
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

