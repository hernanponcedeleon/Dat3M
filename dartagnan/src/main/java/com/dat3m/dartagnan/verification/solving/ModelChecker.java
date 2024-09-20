package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.exception.UnsatisfiedRequirementException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.*;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.processing.WmmProcessingManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.Optional;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static java.lang.Boolean.FALSE;

public abstract class ModelChecker {

    protected Result res = Result.UNKNOWN;
    protected EncodingContext context;
    private String flaggedPairsOutput = "";

    public final Result getResult() {
        return res;
    }
    public EncodingContext getEncodingContext() {
        return context;
    }
    public final String getFlaggedPairsOutput() {
        return flaggedPairsOutput;
    }

    public boolean hasModel() {
        final Property.Type propType = Property.getCombinedType(context.getTask().getProperty(), context.getTask());
        final boolean hasViolationWitnesses = res == FAIL && propType == Property.Type.SAFETY;
        final boolean hasPositiveWitnesses = res == PASS && propType == Property.Type.REACHABILITY;
        final boolean hasReachedBounds = res == UNKNOWN && propType == Property.Type.SAFETY;
        return (hasViolationWitnesses || hasPositiveWitnesses || hasReachedBounds);
    }

    /**
     * Performs all modifications to a parsed program.
     * @param task Program, target memory model and property to be checked.
     * @param config User-defined options to further specify the behavior.
     * @exception InvalidConfigurationException Some user-defined option does not match the format.
     */
    public static void preprocessProgram(VerificationTask task, Configuration config) throws InvalidConfigurationException {
        Program program = task.getProgram();
        ProcessingManager.fromConfig(config).run(program);
    }
    public static void preprocessMemoryModel(VerificationTask task, Configuration config) throws InvalidConfigurationException{
        final Wmm memoryModel = task.getMemoryModel();
        WmmProcessingManager.fromConfig(config).run(memoryModel);
    }

    /**
     * Performs all static program analyses.
     * @param task Program, target memory model and property to be checked.
     * @param analysisContext Collection of static analyses already performed for this task.
     *                        Also receives the results.
     * @param config User-defined options to further specify the behavior.
     * @exception InvalidConfigurationException Some user-defined option does not match the format.
     * @exception UnsatisfiedRequirementException Some static analysis is missing.
     */
    public static void performStaticProgramAnalyses(VerificationTask task, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        Program program = task.getProgram();
        analysisContext.register(BranchEquivalence.class, BranchEquivalence.fromConfig(program, config));
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, task.getProgressModel(), analysisContext, config));
        analysisContext.register(ReachingDefinitionsAnalysis.class, ReachingDefinitionsAnalysis.fromConfig(program, analysisContext, config));
        analysisContext.register(AliasAnalysis.class, AliasAnalysis.fromConfig(program, analysisContext, config));
        analysisContext.register(ThreadSymmetry.class, ThreadSymmetry.fromConfig(program, config));
        for(Thread thread : program.getThreads()) {
            for(Event e : thread.getEvents()) {
                // Some events perform static analyses by themselves (e.g. Svcomp's EndAtomic)
                // which may rely on previous "global" analyses
                e.runLocalAnalysis(program, analysisContext);
            }
        }
    }

    /**
     * Performs all memory-model-based static analyses.
     * @param task Program, target memory model and property to be checked.
     * @param analysisContext Collection of static analyses already performed for this task.
     *                        Also receives the results.
     * @param config User-defined options to further specify the behavior.
     * @exception InvalidConfigurationException Some user-defined option does not match the format.
     * @exception UnsatisfiedRequirementException Some static analysis is missing.
     */
    public static void performStaticWmmAnalyses(VerificationTask task, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        analysisContext.register(WmmAnalysis.class, WmmAnalysis.fromConfig(task.getMemoryModel(), task.getProgram().getArch(), config));
        analysisContext.register(RelationAnalysis.class, RelationAnalysis.fromConfig(task, analysisContext, config));
    }

    protected void saveFlaggedPairsOutput(Wmm wmm, WmmEncoder encoder, ProverEnvironment prover, EncodingContext ctx, Program program) throws SolverException {
        if (!ctx.getTask().getProperty().contains(CAT_SPEC)) {
            return;
        }
        final Model model = prover.getModel();
        final SyntacticContextAnalysis synContext = newInstance(program);
        for(Axiom ax : wmm.getAxioms()) {
            if(ax.isFlagged() && FALSE.equals(model.evaluate(CAT_SPEC.getSMTVariable(ax, ctx)))) {
                StringBuilder violatingPairs = new StringBuilder("Flag " + Optional.ofNullable(ax.getName()).orElse(ax.getRelation().getNameOrTerm())).append("\n");
                encoder.getEventGraph(ax.getRelation(), model).apply((e1, e2) -> {
                    final String callSeparator = " -> ";
                    final String callStackFirst = makeContextString(
                            synContext.getContextInfo(e1).getContextOfType(CallContext.class),
                            callSeparator);
                    final String callStackSecond = makeContextString(
                            synContext.getContextInfo(e2).getContextOfType(CallContext.class),
                            callSeparator);

                    violatingPairs
                            .append("\tE").append(e1.getGlobalId())
                            .append(" / E").append(e2.getGlobalId())
                            .append("\t").append(callStackFirst).append(callStackFirst.isEmpty() ? "" : callSeparator)
                            .append(getSourceLocationString(e1))
                            .append(" / ").append(callStackSecond).append(callStackSecond.isEmpty() ? "" : callSeparator)
                            .append(getSourceLocationString(e2))
                            .append("\n");
                });
                flaggedPairsOutput += violatingPairs.toString();
            }
        }
    }

}
