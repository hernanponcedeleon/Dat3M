package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTask.VerificationTaskBuilder;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.DataRaceSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.witness.WitnessType;
import com.dat3m.dartagnan.witness.graphml.WitnessBuilder;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.sosy_lab.common.ShutdownManager;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
import org.sosy_lab.java_smt.api.SolverException;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.GlobalSettings.logGlobalSettings;
import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.PHANTOM_REFERENCES;
import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.utils.GitInfo.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.witness.WitnessType.GRAPHML;
import static com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer.generateGraphvizFile;
import static java.lang.Boolean.FALSE;
import static java.lang.Boolean.TRUE;
import static java.lang.String.valueOf;

@Options
public class Dartagnan extends BaseOptions {

    private static final Logger logger = LogManager.getLogger(Dartagnan.class);

    private static final Set<String> supportedFormats =
            ImmutableSet.copyOf(Arrays.asList(".litmus", ".c", ".i", ".ll"));

    private Dartagnan(Configuration config) throws InvalidConfigurationException {
        config.recursiveInject(this);
    }

    public static void main(String[] args) throws Exception {

        initGitInfo();

        if (Arrays.asList(args).contains("--help")) {
            collectOptions();
            return;
        }

        if (Arrays.asList(args).contains("--version")) {
            final MavenXpp3Reader mvnReader = new MavenXpp3Reader();
            final FileReader fileReader = new FileReader(System.getenv("DAT3M_HOME") + "/pom.xml");
            final String version = String.format("%s (commit %s)", mvnReader.read(fileReader).getVersion(), getGitId());
            System.out.println(version);
            return;
        }

        logGitInfo();

        String[] argKeyword = Arrays.stream(args)
                .filter(s -> s.startsWith("-"))
                .toArray(String[]::new);
        Configuration config = Configuration.fromCmdLineArguments(argKeyword);
        Dartagnan o = new Dartagnan(config);

        GlobalSettings.configure(config);
        logGlobalSettings();

        File fileProgram = new File(Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(a::endsWith))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Input program not given or format not recognized")));
        logger.info("Program path: " + fileProgram);

        File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst()
                .orElseThrow(() -> new IllegalArgumentException("CAT model not given or format not recognized")));
        logger.info("CAT file path: " + fileModel);

        Wmm mcm = new ParserCat().parse(fileModel);
        Program p = new ProgramParser().parse(fileProgram);
        EnumSet<Property> properties = o.getProperty();

        WitnessGraph witness = new WitnessGraph();
        if (o.runValidator()) {
            logger.info("Witness path: " + o.getWitnessPath());
            witness = new ParserWitness().parse(new File(o.getWitnessPath()));
        }

        VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(config)
                .withWitness(witness);
        // If the arch has been set during parsing (this only happens for litmus tests)
        // and the user did not explicitly add the target option, we use the one
        // obtained during parsing.
        if (p.getArch() != null && !config.hasProperty(TARGET)) {
            builder = builder.withTarget(p.getArch());
        }
        VerificationTask task = builder.build(p, mcm, properties);

        ShutdownManager sdm = ShutdownManager.create();
        Thread t = new Thread(() -> {
            try {
                if (o.hasTimeout()) {
                    // Converts timeout from secs to millisecs
                    Thread.sleep(1000L * o.getTimeout());
                    sdm.requestShutdown("Shutdown Request");
                    logger.warn("Shutdown Request");
                }
            } catch (InterruptedException e) {
                // Verification ended, nothing to be done.
            }
        });

        try {
            long startTime = System.currentTimeMillis();
            t.start();
            Configuration solverConfig = Configuration.builder()
                    .setOption(PHANTOM_REFERENCES, valueOf(o.usePhantomReferences()))
                    .build();
            try (SolverContext ctx = SolverContextFactory.createSolverContext(
                    solverConfig,
                    BasicLogManager.create(solverConfig),
                    sdm.getNotifier(),
                    o.getSolver());
                    ProverEnvironment prover = ctx.newProverEnvironment(ProverOptions.GENERATE_MODELS)) {
                ModelChecker modelChecker;
                if (properties.contains(DATARACEFREEDOM)) {
                    if (properties.size() > 1) {
                        System.out.println("Data race detection cannot be combined with other properties");
                        System.exit(1);
                    }
                    modelChecker = DataRaceSolver.run(ctx, prover, task);
                } else {
                    // Property is either PROGRAM_SPEC, LIVENESS, or CAT_SPEC
                    modelChecker = switch (o.getMethod()) {
                        case EAGER -> AssumeSolver.run(ctx, prover, task);
                        case LAZY -> RefinementSolver.run(ctx, prover, task);
                    };
                }

                // Verification ended, we can interrupt the timeout Thread
                t.interrupt();

                if (modelChecker.hasModel() && o.getWitnessType().generateGraphviz()) {
                    generateExecutionGraphFile(task, prover, modelChecker, o.getWitnessType());
                }

                long endTime = System.currentTimeMillis();
                String summary = generateResultSummary(task, prover, modelChecker);
                System.out.print(summary);
                System.out.println("Total verification time: " + Utils.toTimeString(endTime - startTime));

                // We only generate witnesses if we are not validating one.
                if (o.getWitnessType().equals(GRAPHML) && !o.runValidator()) {
                    generateWitnessIfAble(task, prover, modelChecker, summary);
                }
            }
        } catch (InterruptedException e) {
            logger.warn("Timeout elapsed. The SMT solver was stopped");
            System.out.println("TIMEOUT");
            System.exit(0);
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            System.out.println("ERROR");
            System.exit(1);
        }
    }

    public static File generateExecutionGraphFile(VerificationTask task, ProverEnvironment prover, ModelChecker modelChecker,
                                                  WitnessType witnessType)
            throws InvalidConfigurationException, SolverException, IOException {
        Preconditions.checkArgument(modelChecker.hasModel(), "No execution graph to generate.");

        final ExecutionModel m = ExecutionModel.withContext(modelChecker.getEncodingContext());
        m.initialize(prover.getModel());
        final SyntacticContextAnalysis synContext = newInstance(task.getProgram());
        final String progName = task.getProgram().getName();
        final int fileSuffixIndex = progName.lastIndexOf('.');
        final String name = progName.isEmpty() ? "unnamed_program" :
                (fileSuffixIndex == - 1) ? progName : progName.substring(0, fileSuffixIndex);
        // RF edges give both ordering and data flow information, thus even when the pair is in PO
        // we get some data flow information by observing the edge
        // FR edges only give ordering information which is known if the pair is also in PO
        // CO edges only give ordering information which is known if the pair is also in PO
        return generateGraphvizFile(m, 1, (x, y) -> true, (x, y) -> !x.getThread().equals(y.getThread()),
                (x, y) -> !x.getThread().equals(y.getThread()), getOrCreateOutputDirectory() + "/", name,
                synContext, witnessType.convertToPng());
    }

    private static void generateWitnessIfAble(VerificationTask task, ProverEnvironment prover,
            ModelChecker modelChecker, String summary) {
        // ------------------ Generate Witness, if possible ------------------
        final EnumSet<Property> properties = task.getProperty();
        if (task.getProgram().getFormat().equals(SourceLanguage.LLVM) && modelChecker.hasModel()
                && properties.contains(PROGRAM_SPEC) && properties.size() == 1
                && modelChecker.getResult() != UNKNOWN) {
            try {
                WitnessBuilder w = WitnessBuilder.of(modelChecker.getEncodingContext(), prover,
                        modelChecker.getResult(), summary);
                if (w.canBeBuilt()) {
                    w.build().write();
                }
            } catch (InvalidConfigurationException e) {
                logger.warn(e.getMessage());
            }
        }
    }

    public static String generateResultSummary(VerificationTask task, ProverEnvironment prover,
            ModelChecker modelChecker) throws SolverException {
        // ----------------- Generate output of verification result -----------------
        final Program p = task.getProgram();
        final EnumSet<Property> props = task.getProperty();
        final Result result = modelChecker.getResult();
        final EncodingContext encCtx = modelChecker.getEncodingContext();
        final Model model = modelChecker.hasModel() ? prover.getModel() : null;
        final boolean hasViolations = result == FAIL && (model != null);
        final boolean hasPositiveWitnesses = result == PASS && (model != null);

        StringBuilder summary = new StringBuilder();

        if (p.getFormat() != SourceLanguage.LITMUS) {
            final SyntacticContextAnalysis synContext = newInstance(p);
            if (hasViolations) {
                printWarningIfThreadStartFailed(p, encCtx, prover);
                if (props.contains(PROGRAM_SPEC) && FALSE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
                    summary.append("===== Program specification violation found =====\n");
                    for (Assert ass : p.getThreadEvents(Assert.class)) {
                        final boolean isViolated = TRUE.equals(model.evaluate(encCtx.execution(ass)))
                                && FALSE.equals(
                                        model.evaluate(encCtx.encodeExpressionAsBooleanAt(ass.getExpression(), ass)));
                        if (isViolated) {
                            final String callStack = makeContextString(
                                    synContext.getContextInfo(ass).getContextOfType(CallContext.class), " -> ");
                            summary
                                    .append("\tE").append(ass.getGlobalId())
                                    .append(":\t")
                                    .append(callStack.isEmpty() ? callStack : callStack + " -> ")
                                    .append(getSourceLocationString(ass))
                                    .append(": ").append(ass.getErrorMessage())
                                    .append("\n");
                        }
                    }
                    summary.append("=================================================\n");
                }
                if (props.contains(LIVENESS) && FALSE.equals(model.evaluate(LIVENESS.getSMTVariable(encCtx)))) {
                    summary.append("============ Liveness violation found ============\n");
                    for (CondJump e : p.getThreadEvents(CondJump.class)) {
                        if (e.hasTag(Tag.SPINLOOP) && TRUE.equals(model.evaluate(encCtx.execution(e)))
                                && TRUE.equals(model.evaluate(encCtx.jumpCondition(e)))) {
                            final String callStack = makeContextString(
                                    synContext.getContextInfo(e).getContextOfType(CallContext.class), " -> ");
                            summary
                                    .append("\tE").append(e.getGlobalId())
                                    .append(":\t")
                                    .append(callStack.isEmpty() ? callStack : callStack + " -> ")
                                    .append(getSourceLocationString(e))
                                    .append("\n");
                        }
                    }
                    summary.append("=================================================\n");
                }
                final List<Axiom> violatedCATSpecs = task.getMemoryModel().getAxioms().stream()
                        .filter(Axiom::isFlagged)
                        .filter(ax -> props.contains(CAT_SPEC)
                                && FALSE.equals(model.evaluate(CAT_SPEC.getSMTVariable(ax, encCtx))))
                        .toList();
                if (!violatedCATSpecs.isEmpty()) {
                    summary.append("======= CAT specification violation found =======\n");
                    // Computed by the model checker since it needs access to the WmmEncoder
                    summary.append(modelChecker.getFlaggedPairsOutput());
                    summary.append("=================================================\n");
                }
            } else if (hasPositiveWitnesses) {
                if (props.contains(PROGRAM_SPEC) && TRUE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
                    // The check above is just a sanity check: the program spec has to be true
                    // because it is the only property that got encoded.
                    summary.append("Program specification witness found.").append("\n");
                }
            } else if (result == UNKNOWN && modelChecker.hasModel()) {
                // We reached unrolling bounds.
                summary.append("=========== Not fully unrolled loops ============\n");
                for (Event ev : p.getThreadEventsWithAllTags(Tag.BOUND)) {
                    final boolean isReached = TRUE.equals(model.evaluate(encCtx.execution(ev)));
                    if (isReached) {
                        summary
                                .append("\t")
                                .append(synContext.getSourceLocationWithContext(ev, true))
                                .append("\n");
                    }
                }
                summary.append("=================================================\n");
            }
            summary.append(result).append("\n");
        } else {
            // Litmus-specific output format that matches with Herd7 (as good as it can)
            if (p.getFilterSpecification() != null) {
                summary.append("Filter ").append(p.getFilterSpecification().toStringWithType()).append("\n");
            }

            // NOTE: We cannot produce an output that matches herd7 when checking for both program spec and cat properties.
            // This requires two SMT-queries because a single model is unlikely to witness/falsify both properties
            // simultaneously.
            // Instead, if we check for multiple safety properties, we find the first one and
            // generate output based on its type (Program spec OR CAT property)
            // TODO: Perform two separate checks

            if (hasPositiveWitnesses) {
                // We have a positive witness or no violations, then the program must be ok.
                // NOTE: We also treat the UNKNOWN case as positive, assuming that
                // looping litmus tests are unusual.
                summary.append("Condition ").append(p.getSpecification().toStringWithType()).append("\n");
                summary.append("Ok").append("\n");
            } else if (hasViolations) {
                if (props.contains(PROGRAM_SPEC) && FALSE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
                    // Program spec violated
                    summary.append("Condition ").append(p.getSpecification().toStringWithType()).append("\n");
                    summary.append("No").append("\n");
                } else {
                    final List<Axiom> violatedCATSpecs = task.getMemoryModel().getAxioms().stream()
                            .filter(Axiom::isFlagged)
                            .filter(ax -> props.contains(CAT_SPEC)
                                    && FALSE.equals(model.evaluate(CAT_SPEC.getSMTVariable(ax, encCtx))))
                            .toList();
                    for (Axiom violatedAx : violatedCATSpecs) {
                        summary.append("Flag ")
                                .append(Optional.ofNullable(violatedAx.getName()).orElse(violatedAx.getNameOrTerm()))
                                .append("\n");
                    }
                }
            } else {
                // We have neither a witness nor a violation ...
                if (result == UNKNOWN) {
                    // Sanity check: UNKNOWN is not an expected result for litmus tests
                    logger.warn("Unexpected result for litmus test: {}", result);
                    summary.append(result).append("\n");
                } else if (task.getProperty().contains(PROGRAM_SPEC)) {
                    // ... which can be good or bad (no witness = bad, not violation = good)
                    summary.append("Condition ").append(p.getSpecification().toStringWithType()).append("\n");
                    summary.append(result == PASS ? "Ok" : "No").append("\n");
                }
            }
        }
        return summary.toString();
    }

    private static void printWarningIfThreadStartFailed(Program p, EncodingContext encoder, ProverEnvironment prover)
            throws SolverException {
        for (Event e : p.getThreadEvents()) {
            if (e.hasTag(Tag.STARTLOAD)
                    && BigInteger.ZERO.equals(prover.getModel().evaluate(encoder.value((Load) e)))) {
                // This msg should be displayed even if the logging is off
                System.out.printf(
                        "[WARNING] The call to pthread_create of thread %s failed. To force thread creation to succeed use --%s=true%n",
                        e.getThread(), OptionNames.THREAD_CREATE_ALWAYS_SUCCEEDS);
                break;
            }
        }
    }
}
