package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
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
import static com.dat3m.dartagnan.configuration.OptionNames.ALLOW_PARTIAL_EXECUTIONS;
import static com.dat3m.dartagnan.configuration.OptionNames.MERGE_CF_VARS;
import static com.dat3m.dartagnan.expression.utils.Utils.*;

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
        dep = context.requires(Dependency.class);
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
                dep.encode(ctx));
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

        Memory memory = program.getMemory();;
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

    public BooleanFormula encodeFinalRegisterValues(SolverContext ctx) {
        checkInitialized();
        logger.info("Encoding final register values");

        FormulaManager fmgr = ctx.getFormulaManager();
        BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

        BooleanFormula enc = bmgr.makeTrue();
        for(Map.Entry<Register,List<Event>> e : dep.finalWriters().entrySet()) {
            Formula value = e.getKey().getLastValueExpr(ctx);
            List<Event> writers = e.getValue();
            int i = 0;
            if(writers.get(0) == null) {
                BooleanFormula clause = generalZero(value, ctx);
                for(Event w : writers.subList(1, writers.size())) {
                    clause = bmgr.or(clause, w.exec());
                }
                enc = bmgr.and(enc, clause);
                i = 1;
            }
            while(i < writers.size()) {
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
                i++;
            }
        }
        return enc;
    }
}