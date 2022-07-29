package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.*;
import java.util.function.BiFunction;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqualZero;
import static com.google.common.collect.Lists.reverse;

@Options
public class ProgramEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(ProgramEncoder.class);

    // =========================== Configurables ===========================

    @Option(name = ALLOW_PARTIAL_EXECUTIONS,
            description = "Allows to terminate executions on the first found violation. " +
                    "This is not allowed on Litmus tests due to their different assertion condition.",
            secure = true)
    private boolean shouldAllowPartialExecutions = false;

    @Option(name = MERGE_CF_VARS,
            description = "Merges control flow variables of events with identical control-flow behaviour.",
            secure = true)
    private boolean shouldMergeCFVars = true;

    @Option(name = INITIALIZE_REGISTERS,
            description = "Assume thread-local variables start off containing zero.",
            secure = true)
    private boolean initializeRegisters = false;

    // =====================================================================

    private final Program program;
    private final BranchEquivalence eq;
    private final ExecutionAnalysis exec;
    private final Dependency dep;
    private boolean isInitialized = false;

    private ProgramEncoder(Program program, Context context, Configuration config) throws InvalidConfigurationException {
        Preconditions.checkArgument(program.isCompiled(), "The program must be compiled before encoding.");
        this.program = Preconditions.checkNotNull(program);
        this.eq = context.requires(BranchEquivalence.class);
        this.exec = context.requires(ExecutionAnalysis.class);
        this.dep = context.requires(Dependency.class);
        config.inject(this);

        logger.info("{}: {}", ALLOW_PARTIAL_EXECUTIONS, shouldAllowPartialExecutions);
        logger.info("{}: {}", MERGE_CF_VARS, shouldMergeCFVars);
    }

    public static ProgramEncoder fromConfig(Program program, Context context, Configuration config) throws InvalidConfigurationException {
        return new ProgramEncoder(program, context, config);
    }

    // ============================== Initialization ==============================

    public void initializeEncoding(SolverContext ctx) {
        for(Event e : program.getEvents()){
            initEvent(e, ctx);
        }
        isInitialized = true;
    }

    private void initEvent(Event e, SolverContext ctx){
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        boolean mergeVars = shouldMergeCFVars && !shouldAllowPartialExecutions;
        String repr = mergeVars ? eq.getRepresentative(e).repr() : e.repr();
        e.setCfVar(bmgr.makeVariable("cf(" + repr + ")"));
        e.initializeEncoding(ctx);
    }

    private void checkInitialized() {
        Preconditions.checkState(isInitialized, "initializeEncoding must get called before encoding.");
    }

    // ============================== Encoding ==============================

    public BooleanFormula encodeFullProgram(SolverContext ctx) {
        return ctx.getFormulaManager().getBooleanFormulaManager().and(
                encodeMemory(ctx),
                encodeControlFlow(ctx),
                encodeFinalRegisterValues(ctx),
                encodeFilter(ctx),
                encodeDependencies(ctx));
    }

    public BooleanFormula encodeControlFlow(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding program control flow");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        
        BooleanFormula enc = bmgr.makeTrue();
        for(Thread t : program.getThreads()){
            enc = bmgr.and(enc, encodeThreadCF(t, ctx));
        }
        return enc;
    }

    private BooleanFormula encodeThreadCF(Thread thread, SolverContext ctx){
        checkInitialized();
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        BiFunction<BooleanFormula, BooleanFormula, BooleanFormula> cfEncoder = shouldAllowPartialExecutions ?
                bmgr::implication : bmgr::equivalence;
        Map<Label, Set<Event>> labelJumpMap = new HashMap<>();

        Event pred = null;
        for(Event e : thread.getEntry().getSuccessors()) {

            // Immediate control flow
            BooleanFormula cfCond = pred == null ? bmgr.makeTrue() : pred.cf();
            if (pred instanceof CondJump) {
                CondJump jump = (CondJump) pred;
                cfCond = bmgr.and(cfCond, bmgr.not(jump.getGuard().toBoolFormula(jump, ctx)));
                // NOTE: we need to register the actual jumps here, because the
                // listener sets of labels is too large (it contains old copies)
                labelJumpMap.computeIfAbsent(jump.getLabel(), key -> new HashSet<>()).add(jump);
            }

            // Control flow via jumps
            if (e instanceof Label) {
                for (Event jump : labelJumpMap.getOrDefault(e, Collections.emptySet())) {
                    CondJump j = (CondJump)jump;
                    cfCond = bmgr.or(cfCond, bmgr.and(j.cf(), j.getGuard().toBoolFormula(j, ctx)));
                }
            }

            enc = bmgr.and(enc, cfEncoder.apply(e.cf(), cfCond), e.encodeExec(ctx));
            pred = e;
        }
        return enc;
    }

    // Assigns each Address a fixed memory address.
    public BooleanFormula encodeMemory(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding fixed memory");

        Memory memory = program.getMemory();
        FormulaManager fmgr = ctx.getFormulaManager();
        
        BooleanFormula[] addrExprs;

        if(ARCH_PRECISION > -1) {
        	BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();	
            addrExprs = memory.getObjects().stream()
                    .map(addr -> bvmgr.equal((BitvectorFormula)addr.toIntFormula(ctx), 
                    		bvmgr.makeBitvector(ARCH_PRECISION, addr.getValue().intValue())))
                    .toArray(BooleanFormula[]::new);        	
        } else {
            IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
            addrExprs = memory.getObjects().stream()
                    .map(addr -> imgr.equal((IntegerFormula)addr.toIntFormula(ctx),
                    		imgr.makeNumber(addr.getValue().intValue())))
                    .toArray(BooleanFormula[]::new);        	
        }
        return fmgr.getBooleanFormulaManager().and(addrExprs);
    }

    /**
     * Simple formula proposing the execution of two events.
     * Does not test for mutual exclusion.
     * @param first
     * Some event of a program to be encoded.
     * @param second
     * Another event of the same program.
     * @param exec
     * Analysis performed on the associated program.
     * @param ctx
     * Builder of expressions and formulas.
     * @return
     * Proposition that both {@code first} and {@code second} are included in the modelled execution.
     */
    public static BooleanFormula execution(Event first, Event second, ExecutionAnalysis exec, SolverContext ctx) {
        boolean b = first.getCId() < second.getCId();
        Event x = b ? first : second;
        Event y = b ? second : first;
        if(x.exec()==y.exec() || exec.isImplied(x,y)) {
            return x.exec();
        }
        if(exec.isImplied(y,x)) {
            return y.exec();
        }
        return ctx.getFormulaManager().getBooleanFormulaManager().and(x.exec(),y.exec());
    }

    /**
     * @param writer
     * Overwrites some register.
     * @param reader
     * Happens on the same thread as {@code writer} and could use its value,
     * meaning that {@code writer} appears in {@code may(reader,R)} for some register {@code R}.
     * @param ctx
     * Builder of expressions and formulas.
     * @return
     * Proposition that {@code reader} directly uses the value from {@code writer}, if both are executed.
     * Contextualized with the result of {@link #encodeDependencies(SolverContext) encode}.
     */
    public BooleanFormula dependencyEdge(Event writer, Event reader, SolverContext ctx) {
        Preconditions.checkArgument(writer instanceof RegWriter || reader instanceof ExecutionStatus);

        if(reader instanceof ExecutionStatus) {
            // RISCV store conditionals are not instances of RegWriter, but they still propagate dependencies.
            // The propagation with future events follows from the status writing to the register.
            // We achieve this by using an instance of ExecutionStatus that tracks dependencies.
            // BasicRegRelation will add the corresponding pair to the maxTupleSet if dependency is tracked.
            // Thus, the whole dependency depends on the store being executed.
            ExecutionStatus status = (ExecutionStatus)reader;
            Preconditions.checkArgument(status.doesTrackDep(),
                    "ExecutionStatus %s does not track dependencies", status);
            Preconditions.checkArgument(status.getStatusEvent().equals(writer),
                    "ExecutionStatus %s tracks %s, but %s was provided.",
                    status, status.getStatusEvent(), writer);
            return execution(writer, reader, exec, ctx);
        } else {
            Register register = ((RegWriter) writer).getResultRegister();
            Dependency.State r = dep.of(reader, register);
            Preconditions.checkArgument(r.may.contains(writer));
            BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
            return r.must.contains(writer) ?
                    execution(writer, reader, exec, ctx) :
                    dependencyEdgeVariable(writer, reader, bmgr);
        }
    }

    /**
     * @param ctx
     * Builder of expressions and formulas.
     * @return
     * Describes that for each pair of events, if the reader uses the result of the writer,
     * then the value the reader gets from the register is exactly the value that the writer computed.
     * Also, the reader may only use the value of the latest writer that is executed.
     * Also, if no fitting writer is executed, the reader uses 0.
     */
    public BooleanFormula encodeDependencies(SolverContext ctx) {
        logger.info("Encoding dependencies");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for(Map.Entry<Event,Map<Register,Dependency.State>> e : dep.getAll()) {
            Event reader = e.getKey();
            for(Map.Entry<Register,Dependency.State> r : e.getValue().entrySet()) {
                Formula value = r.getKey().toIntFormula(reader, ctx);
                Dependency.State state = r.getValue();
                BooleanFormula overwrite = bmgr.makeFalse();
                for(Event writer : reverse(state.may)) {
                    assert writer instanceof RegWriter;
                    BooleanFormula edge;
                    if(state.must.contains(writer)) {
                        if (exec.isImplied(reader, writer) && reader.cfImpliesExec()) {
                            // This special case is important. Usually, we encode "dep => regValue = regWriterResult"
                            // By getting rid of the guard "dep" in this special case, we end up with an unconditional
                            // "regValue = regWriterResult", which allows the solver to eliminate one of the variables
                            // in preprocessing.
                            assert state.may.size() == 1;
                            edge = bmgr.makeTrue();
                        } else {
                            edge = bmgr.and(writer.exec(), reader.cf());
                        }
                    } else {
                        edge = dependencyEdgeVariable(writer, reader, bmgr);
                        enc = bmgr.and(enc, bmgr.equivalence(edge, bmgr.and(writer.exec(), reader.cf(), bmgr.not(overwrite))));
                    }
                    enc = bmgr.and(enc, bmgr.implication(edge, generalEqual(value, ((RegWriter) writer).getResultRegisterExpr(), ctx)));
                    overwrite = bmgr.or(overwrite, writer.exec());
                }
                if(initializeRegisters && !state.initialized) {
                    enc = bmgr.and(enc, bmgr.or(overwrite, bmgr.not(reader.cf()), generalEqualZero(value, ctx)));
                }
            }
        }
        return enc;
    }

    public BooleanFormula encodeFilter(SolverContext ctx) {
    	return program.getAssFilter() != null ? 
    			program.getAssFilter().encode(ctx) :
    			ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }
    
    public BooleanFormula encodeFinalRegisterValues(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding final register values");

        FormulaManager fmgr = ctx.getFormulaManager();
        BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

        if (program.getFormat() == Program.SourceLanguage.BOOGIE) {
            // Boogie does not have assertions over final register values, so we do not need to encode them.
            return bmgr.makeTrue();
        }

        BooleanFormula enc = bmgr.makeTrue();
        for(Map.Entry<Register,Dependency.State> e : dep.finalWriters().entrySet()) {
            Formula value = e.getKey().getLastValueExpr(ctx);
            Dependency.State state = e.getValue();
            List<Event> writers = state.may;
            if(initializeRegisters && !state.initialized) {
                BooleanFormula clause = generalEqualZero(value, ctx);
                for(Event w : writers) {
                    clause = bmgr.or(clause, w.exec());
                }
                enc = bmgr.and(enc, clause);
            }
            for(int i = 0; i < writers.size(); i++) {
                Event writer = writers.get(i);
                BooleanFormula clause = bmgr.or(
                        generalEqual(value, ((RegWriter) writer).getResultRegisterExpr(), ctx),
                        bmgr.not(writer.exec()));
                for(Event w : writers.subList(i + 1, writers.size())) {
                    if(!exec.areMutuallyExclusive(writer, w)) {
                        clause = bmgr.or(clause, w.exec());
                    }
                }
                enc = bmgr.and(enc, clause);
            }
        }
        return enc;
    }

    private static BooleanFormula dependencyEdgeVariable(Event writer, Event reader, BooleanFormulaManager bmgr) {
        return bmgr.makeVariable("__dep " + writer.getCId() + " " + reader.getCId());
    }
}
