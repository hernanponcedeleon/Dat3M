package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.expression.ExpressionPrinter;
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
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTask.VerificationTaskBuilder;
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
import com.google.common.io.CharSource;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
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
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Path;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
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

    private static final Set<String> supportedFormats = ImmutableSet.copyOf(ProgramParser.SUPPORTED_EXTENSIONS);

    private Dartagnan(Configuration config) throws InvalidConfigurationException {
        config.recursiveInject(this);
    }

    private static Configuration loadConfiguration(String[] args) throws InvalidConfigurationException, IOException {
        final var preamble = new StringBuilder();
        final var options = new StringBuilder();
        for (String argument : args) {
            if (argument.startsWith("--")) {
                options.append(argument.substring("--".length())).append("\n");
            } else if (argument.endsWith(".properties")) {
                preamble.append("#include ").append(argument).append("\n");
            }
        }
        final CharSource source = CharSource.concat(CharSource.wrap(preamble), CharSource.wrap(options));
        return Configuration.builder().loadFromSource(source, ".", ".").build();
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

        Configuration config = loadConfiguration(args);
        Dartagnan o = new Dartagnan(config);

        File fileProgram = new File(Arrays.stream(args).filter(a -> supportedFormats.stream().anyMatch(a::endsWith))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Input program not given or format not recognized")));
        logger.info("Program path: {}", fileProgram);

        File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst()
                .orElseThrow(() -> new IllegalArgumentException("CAT model not given or format not recognized")));
        logger.info("CAT file path: {}", fileModel);


        Wmm mcm = new ParserCat(Path.of(o.getCatIncludePath())).parse(fileModel);
        Program p = new ProgramParser().parse(fileProgram);
        EnumSet<Property> properties = o.getProperty();

        WitnessGraph witness = new WitnessGraph();
        if (o.runValidator()) {
            logger.info("Witness path: {}", o.getWitnessPath());
            witness = new ParserWitness().parse(new File(o.getWitnessPath()));
        }

        VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(config)
                .withProgressModel(o.getProgressModel())
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
                    ProverWithTracker prover = new ProverWithTracker(ctx,
                        o.getDumpSmtLib() ? GlobalSettings.getOutputDirectory() + String.format("/%s.smt2", p.getName()) : "",
                        ProverOptions.GENERATE_MODELS)) {
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

        final EncodingContext encodingContext = modelChecker instanceof RefinementSolver refinementSolver ?
            refinementSolver.getContextWithFullWmm() : modelChecker.getEncodingContext();
        final ExecutionModelNext model = new ExecutionModelManager().buildExecutionModel(
            encodingContext, prover.getModel()
        );
        final SyntacticContextAnalysis synContext = newInstance(task.getProgram());
        final String progName = task.getProgram().getName();
        final int fileSuffixIndex = progName.lastIndexOf('.');
        final String name = progName.isEmpty() ? "unnamed_program" :
                (fileSuffixIndex == - 1) ? progName : progName.substring(0, fileSuffixIndex);
        // RF edges give both ordering and data flow information, thus even when the pair is in PO
        // we get some data flow information by observing the edge
        // CO edges only give ordering information which is known if the pair is also in PO
        return generateGraphvizFile(model, 1, (x, y) -> true,
                (x, y) -> !x.getThreadModel().getThread().equals(y.getThreadModel().getThread()),
                getOrCreateOutputDirectory() + "/", name,
                synContext, witnessType.convertToPng(), encodingContext.getTask().getConfig());
    }

    private static void generateWitnessIfAble(VerificationTask task, ProverEnvironment prover,
            ModelChecker modelChecker, String summary) {
        // ------------------ Generate Witness, if possible ------------------
        final EnumSet<Property> properties = task.getProperty();
        if (task.getProgram().getFormat().equals(SourceLanguage.LLVM) && modelChecker.hasModel()
                && (properties.contains(PROGRAM_SPEC) || properties.contains(DATARACEFREEDOM)) && properties.size() == 1
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
                if (props.contains(DATARACEFREEDOM) && FALSE.equals(model.evaluate(DATARACEFREEDOM.getSMTVariable(encCtx)))) {
                    summary.append("============= SVCOMP data race found ============\n");
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
                final List<Event> reachedBounds = new ArrayList<>();
                for (Event ev : p.getThreadEventsWithAllTags(Tag.BOUND)) {
                    if (TRUE.equals(model.evaluate(encCtx.execution(ev)))) {
                        reachedBounds.add(ev);
                    }
                }
                summary.append("=========== Not fully unrolled loops ============\n");
                for (Event bound : reachedBounds) {
                    summary
                            .append("\t")
                            .append(synContext.getSourceLocationWithContext(bound, true))
                            .append("\n");
                }
                summary.append("=================================================\n");

                try {
                    increaseBoundAndDump(reachedBounds, task.getConfig());
                } catch (IOException e) {
                    logger.warn("Failed to save bounds file: {}", e.getLocalizedMessage());
                }
            }
            summary.append(result).append("\n");
        } else {
            // Litmus-specific output format that matches with Herd7 (as good as it can)
            if (p.getFilterSpecification() != null) {
                summary.append("Filter ").append(p.getFilterSpecification()).append("\n");
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
                printSpecification(summary, p);
                summary.append("Ok").append("\n");
            } else if (hasViolations) {
                if (props.contains(PROGRAM_SPEC) && FALSE.equals(model.evaluate(PROGRAM_SPEC.getSMTVariable(encCtx)))) {
                    // Program spec violated
                    printSpecification(summary, p);
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
                    printSpecification(summary, p);
                    summary.append(result == PASS ? "Ok" : "No").append("\n");
                }
            }
        }
        return summary.toString();
    }

    private static void increaseBoundAndDump(List<Event> boundEvents, Configuration config) throws IOException {
        if(!config.hasProperty(BOUNDS_SAVE_PATH)) {
            return;
        }
        final File boundsFile = new File(config.getProperty(BOUNDS_SAVE_PATH));

        // Parse old entries
        final List<CSVRecord> entries;
        try (CSVParser parser = CSVParser.parse(new FileReader(boundsFile), CSVFormat.DEFAULT)) {
            entries = parser.getRecords();
        }

        // Compute update for entries
        final Map<Integer, Integer> loopId2UpdatedBound = new HashMap<>();
        for (Event e : boundEvents) {
            assert e instanceof CondJump;
            final CondJump loopJump = (CondJump) e;
            final int loopId = LoopUnrolling.getPersistentLoopId(loopJump);
            final int bound = LoopUnrolling.getUnrollingBoundAnnotation(loopJump);
            loopId2UpdatedBound.put(loopId, bound + 1);
        }

        // Write new entries
        try (CSVPrinter csvPrinter = new CSVPrinter(new FileWriter(boundsFile, false), CSVFormat.DEFAULT)) {
            for (CSVRecord entry : entries) {
                final int entryId = Integer.parseInt(entry.get(0));
                if (!loopId2UpdatedBound.containsKey(entryId)) {
                    csvPrinter.printRecord(entry);
                } else {
                    final String[] content = entry.values();
                    content[1] = String.valueOf(loopId2UpdatedBound.get(entryId));
                    csvPrinter.printRecord(Arrays.asList(content));
                }
            }
            csvPrinter.flush();
        }
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

    private static void printSpecification(StringBuilder sb, Program program) {
        sb.append("Condition ").append(program.getSpecificationType().toString().toLowerCase()).append(" ");
        boolean init = false;
        if (program.getSpecification() != null) {
            sb.append(new ExpressionPrinter(true).visit(program.getSpecification()));
            init = true;
        }
        for (Assert assertion : program.getThreadEvents(Assert.class)) {
            sb.append(init ? " && " : "").append(assertion.getExpression()).append("%").append(assertion.getGlobalId());
            init = true;
        }
        sb.append("\n");
    }
}
