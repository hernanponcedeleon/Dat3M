package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.exception.UnsatisfiedRequirementException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.specification.AbstractAssert;
import com.dat3m.dartagnan.program.specification.AssertCompositeAnd;
import com.dat3m.dartagnan.program.specification.AssertInline;
import com.dat3m.dartagnan.program.specification.AssertTrue;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.program.event.Tag.ASSERTION;
import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.lang.Boolean.FALSE;

public abstract class ModelChecker {

    protected Result res = Result.UNKNOWN;
    protected EncodingContext context;

    public final Result getResult() {
        return res;
    }
    public EncodingContext getEncodingContext() {
        return context;
    }

    public boolean hasModel() {
        final Property.Type propType = Property.getCombinedType(context.getTask().getProperty(), context.getTask());
        final boolean hasViolationWitnesses = res == FAIL && propType == Property.Type.SAFETY;
        final boolean hasPositiveWitnesses = res == PASS && propType == Property.Type.REACHABILITY;
        return (hasViolationWitnesses || hasPositiveWitnesses);
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
        // This is used to distinguish between Litmus tests (whose assertions are defined differently)
        // and C/Boogie tests.
        if(program.getFormat() != Program.SourceLanguage.LITMUS) {
            computeSpecificationFromProgramAssertions(program);
        }
    }
    public static void preprocessMemoryModel(VerificationTask task) throws InvalidConfigurationException {
        task.getMemoryModel().simplify();
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
        analysisContext.register(ExecutionAnalysis.class, ExecutionAnalysis.fromConfig(program, analysisContext, config));
        analysisContext.register(Dependency.class, Dependency.fromConfig(program, analysisContext, config));
        analysisContext.register(AliasAnalysis.class, AliasAnalysis.fromConfig(program, config));
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
        analysisContext.register(WmmAnalysis.class, WmmAnalysis.fromConfig(task.getMemoryModel(), config));
        analysisContext.register(RelationAnalysis.class, RelationAnalysis.fromConfig(task, analysisContext, config));
    }

    private static void computeSpecificationFromProgramAssertions(Program program) {
        // We generate a program-spec from the user-placed assertions inside the C/Boogie-code.
        // For litmus tests, this function should not be called.
        List<Event> assertions = program.getCache().getEvents(FilterBasic.get(ASSERTION));
        AbstractAssert spec = new AssertTrue();
        if(!assertions.isEmpty()) {
            spec = new AssertInline((Local)assertions.get(0));
            for(int i = 1; i < assertions.size(); i++) {
                spec = new AssertCompositeAnd(spec, new AssertInline((Local)assertions.get(i)));
            }
        }
        spec.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        program.setSpecification(spec);
    }

    protected void logFlaggedPairs(Wmm wmm, WmmEncoder encoder, ProverEnvironment prover, Logger logger, EncodingContext ctx) throws SolverException {
        if (!logger.isDebugEnabled() || !ctx.getTask().getProperty().contains(CAT_SPEC)) {
            return;
        }
        Model model = prover.getModel();
        for(Axiom ax : wmm.getAxioms()) {
            if(ax.isFlagged() && FALSE.equals(model.evaluate(CAT_SPEC.getSMTVariable(ax, ctx)))) {
                logger.debug("Flag " + Optional.ofNullable(ax.getName()).orElse(ax.getRelation().getNameOrTerm()));
                StringBuilder violatingPairs = new StringBuilder("\n ===== The following pairs belong to the relation ===== \n");
                for(Tuple tuple : encoder.getTuples(ax.getRelation(), model)) {
                    violatingPairs.append("\t").append(tuple.getFirst().getGlobalId())
                            .append(" -> ").append(tuple.getSecond().getGlobalId());
                }
                logger.debug(violatingPairs.toString());
            }
        }
    }

}
