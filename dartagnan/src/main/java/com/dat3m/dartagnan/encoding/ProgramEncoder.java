package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.*;
import java.util.function.BiFunction;

import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

@Options
public class ProgramEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(ProgramEncoder.class);

    // =========================== Configurables ===========================

    @Option(name = "encoding.useFixedMemory",
            description = "Pre-assigns fixed values to dynamically allocated objects if possible.",
            secure = true)
    private boolean shouldUseFixedMemoryEncoding = false;

    public boolean shouldUseFixedMemoryEncoding() { return shouldUseFixedMemoryEncoding; }
    public void setShouldUseFixedMemoryEncoding(boolean value) { shouldUseFixedMemoryEncoding = value; }

    @Option(name = "encoding.allowPartialExecutions",
            description = "Allows to terminate executions on the first found violation." +
                    "This is not allowed on Litmus tests due to their different assertion condition.",
            secure = true)
    private boolean shouldAllowPartialExecutions = false;

    public boolean shouldAllowPartialExecutions() { return shouldAllowPartialExecutions; }
    public void setShouldAllowPartialExecutions(boolean value) { shouldAllowPartialExecutions = value; }

    @Option(name = "encoding.mergeCFVars",
            description = "Merges control flow variables of events with identical control-flow behaviour.",
            secure = true)
    private boolean shouldMergeCFVars = true;

    public boolean shouldMergeCFVars() { return shouldMergeCFVars; }
    public void setShouldMergeCFVars(boolean value) { shouldMergeCFVars = value; }

    // =====================================================================

    private Program program;
    private VerificationTask task;

    private ProgramEncoder(Configuration config) throws InvalidConfigurationException  {
        config.inject(this);
    }

    public static ProgramEncoder fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ProgramEncoder(config);
    }


    public void initialise(VerificationTask task, SolverContext ctx) {
        Preconditions.checkState(task.getProgram().isCompiled(), "The program needs to be compiled first.");

        this.task = task;
        this.program = task.getProgram();
        for(Event e : program.getEvents()){
            initEvent(e, task, ctx);
        }
    }

    private void initEvent(Event e, VerificationTask task, SolverContext ctx){
        Preconditions.checkState(e.getCId() >= 0,"Event cID is negative for %s. Event was not compiled yet?", e);
        FormulaManager fmgr = ctx.getFormulaManager();

        boolean mergeVars = shouldMergeCFVars && !shouldAllowPartialExecutions;
        String repr = mergeVars ? task.getBranchEquivalence().getRepresentative(e).repr() : e.repr();
        e.setCfVar(fmgr.makeVariable(BooleanType, "cf(" + repr + ")"));

        e.initialise(task, ctx);
    }

    public BooleanFormula encodeControlFlow(SolverContext ctx) {
        Preconditions.checkState(task != null, "The encoder needs to get initialized for encoding first.");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        logger.info("Encoding program control flow");

        BooleanFormula enc = bmgr.makeTrue();
        for(Thread t : program.getThreads()){
            enc = bmgr.and(enc, encodeThreadCF(t, ctx));
        }
        return enc;
    }

    private BooleanFormula encodeThreadCF(Thread thread, SolverContext ctx){
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

    public BooleanFormula encodeFinalRegisterValues(SolverContext ctx){
        Preconditions.checkState(task != null, "The encoder needs to get initialized for encoding first.");
        logger.info("Encoding final register values");

        FormulaManager fmgr = ctx.getFormulaManager();
        BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

        Map<Register, List<Event>> eMap = new HashMap<>();
        for(Event e : program.getCache().getEvents(FilterBasic.get(EType.REG_WRITER))){
            Register reg = ((RegWriter)e).getResultRegister();
            eMap.computeIfAbsent(reg, key -> new ArrayList<>()).add(e);
        }

        BranchEquivalence eq = task.getBranchEquivalence();
        BooleanFormula enc = bmgr.makeTrue();
        for (Register reg : eMap.keySet()) {
            Thread thread = program.getThreads().get(reg.getThreadId());

            List<Event> events = eMap.get(reg);
            events.sort(Collections.reverseOrder());

            // =======================================================
            // Optimizations that remove registers which are guaranteed to get overwritten
            //TODO: Make sure that this is correct even for EXCL events
            for (int i = 0; i < events.size(); i++) {
                if (eq.isImplied(thread.getExit(), events.get(i))) {
                    events = events.subList(0, i + 1);
                    break;
                }
            }
            final List<Event> events2 = events;
            events.removeIf(x -> events2.stream().anyMatch(y -> y.getCId() > x.getCId() && eq.isImplied(x, y)));
            // ========================================================


            for(int i = 0; i <  events.size(); i++){
                Event w1 = events.get(i);
                BooleanFormula lastModReg = w1.exec();
                for(int j = 0; j < i; j++){
                    Event w2 = events.get(j);
                    if (!eq.areMutuallyExclusive(w1, w2)) {
                        lastModReg = bmgr.and(lastModReg, bmgr.not(w2.exec()));
                    }
                }

                BooleanFormula same =  generalEqual(reg.getLastValueExpr(ctx), ((RegWriter)w1).getResultRegisterExpr(), ctx);
                enc = bmgr.and(enc, bmgr.implication(lastModReg, same));
            }
        }
        return enc;
    }

    public BooleanFormula encodeNoBoundEventExec(SolverContext ctx){
        Preconditions.checkState(task != null, "The encoder needs to get initialized for encoding first.");

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        for(Event e : program.getCache().getEvents(FilterBasic.get(EType.BOUND))){
            enc = bmgr.and(enc, bmgr.not(e.exec()));
        }
        return enc;
    }

    public BooleanFormula encodeAssertions(SolverContext ctx) {
        Preconditions.checkState(task != null, "The encoder needs to get initialized for encoding first.");

        logger.info("Encoding assertions");
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        BooleanFormula assertionEncoding = program.getAss().encode(ctx);
        if (program.getAssFilter() != null) {
            assertionEncoding = bmgr.and(assertionEncoding, program.getAssFilter().encode(ctx));
        }
        return assertionEncoding;
    }

}
