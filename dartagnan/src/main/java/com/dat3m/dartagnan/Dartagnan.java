package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.configuration.ProgressModel;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.expression.ExpressionPrinter;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.witness.ParserWitness;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.smt.ModelExt;
import com.dat3m.dartagnan.utils.ExitCode;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.VerificationTask.VerificationTaskBuilder;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
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
import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.log.BasicLogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;
import org.sosy_lab.java_smt.api.SolverException;
import java.nio.file.*;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Stream;
import com.dat3m.dartagnan.utils.printer.OutputLogger;
import com.dat3m.dartagnan.utils.printer.OutputLogger.ResultSummary;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionInfo.collectOptions;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.utils.ExitCode.*;
import static com.dat3m.dartagnan.utils.GitInfo.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.witness.WitnessType.GRAPHML;
import static com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer.generateGraphvizFile;
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
        return Configuration.builder()
                .addConverter(ProgressModel.Hierarchy.class, ProgressModel.HIERARCHY_CONVERTER)
                .loadFromSource(source, ".", ".").build();
    }

    private static SolverContext createSolverContext(Configuration config, ShutdownNotifier notifier, Solvers solver) throws Exception {
        // Try using NativeLibraries::loadLibrary. Fallback to System::loadLibrary
        // if NativeLibraries failed, for example, because the operating system is
        // not supported,
        try {
            return SolverContextFactory.createSolverContext(
                config,
                BasicLogManager.create(config),
                notifier,
                solver);
        } catch (Exception e) {
            SolverContextFactory factory = new SolverContextFactory(
                config,
                BasicLogManager.create(config),
                notifier,
                System::loadLibrary);
            return factory.generateContext(solver);
        }
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

        File fileModel = new File(Arrays.stream(args).filter(a -> a.endsWith(".cat")).findFirst()
                .orElseThrow(() -> new IllegalArgumentException("CAT model not given or format not recognized")));
        logger.info("CAT file path: {}", fileModel);
        Wmm mcm = new ParserCat(Path.of(o.getCatIncludePath())).parse(fileModel);

        final OutputLogger output = new OutputLogger(fileModel, config);

        final List<File> files = new ArrayList();
        Stream.of(args)
            .map(File::new)
            .forEach(file -> {
                if (file.exists()) {
                    final String path = file.getAbsolutePath();
                    logger.info("Program(s) path: {}", path);
                    if (file.isDirectory()) {
                        files.addAll(getProgramsFiles(path));
                    } else if (file.isFile() && supportedFormats.stream().anyMatch(file.getName()::endsWith)) {
                        files.add(file);
                    }
                }
            });
        if (files.isEmpty()) {
            throw new IllegalArgumentException("Path to input program(s) not given or format not recognized");
        }

        EnumSet<Property> properties = o.getProperty();

        WitnessGraph witness = new WitnessGraph();
        if (o.runValidator()) {
            logger.info("Witness path: {}", o.getWitnessPath());
            witness = new ParserWitness().parse(new File(o.getWitnessPath()));
        }

        if (properties.contains(DATARACEFREEDOM) && properties.size() > 1) {
            System.out.println("Data race detection cannot be combined with other properties");
                if(!(files.size() > 1)) {
                    System.exit(1);
                }
        }

        ResultSummary summary = null;
        for (File f : files) {

            ShutdownManager sdm = ShutdownManager.create();
            Thread t = new Thread(() -> {
                try {
                    if (o.hasTimeout()) {
                        // Converts timeout from secs to millisecs
                        Thread.sleep(1000L * o.getTimeout());
                        sdm.requestShutdown("Shutdown Request");
                    }
                } catch (InterruptedException e) {
                    // Verification ended, nothing to be done.
                }
            });

            try {
                VerificationTaskBuilder builder = VerificationTask.builder()
                        .withConfig(config)
                        .withProgressModel(o.getProgressModel())
                        .withWitness(witness);
                Program p = new ProgramParser().parse(f);
                // If the arch has been set during parsing (this only happens for litmus tests)
                // and the user did not explicitly add the target option, we use the one
                // obtained during parsing.
                if (p.getArch() != null && !config.hasProperty(TARGET)) {
                    builder = builder.withTarget(p.getArch());
                }
                VerificationTask task = builder.build(p, mcm, properties);

                long startTime = System.currentTimeMillis();
                t.start();
                Configuration solverConfig = Configuration.builder()
                        .setOption(PHANTOM_REFERENCES, valueOf(o.usePhantomReferences()))
                        .build();
                try (SolverContext ctx = createSolverContext(
                        solverConfig,
                        sdm.getNotifier(),
                        o.getSolver());
                        ProverWithTracker prover = new ProverWithTracker(ctx,
                            o.getDumpSmtLib() ? GlobalSettings.getOutputDirectory() + String.format("/%s.smt2", p.getName()) : "",
                            ProverOptions.GENERATE_MODELS)) {
                    ModelChecker modelChecker;
                    if (properties.contains(DATARACEFREEDOM)) {
                        modelChecker = DataRaceSolver.run(ctx, prover, task);
                    } else {
                        // Property is either PROGRAM_SPEC, TERMINATION, or CAT_SPEC
                        modelChecker = switch (o.getMethod()) {
                            case EAGER -> AssumeSolver.run(ctx, prover, task);
                            case LAZY -> RefinementSolver.run(ctx, prover, task);
                        };
                    }

                    // Verification ended, we can interrupt the timeout Thread
                    t.interrupt();
                    long endTime = System.currentTimeMillis();

                    summary = summaryFromResult(task, prover, modelChecker, f.toString(), (endTime - startTime));

                    if (modelChecker.hasModel() && o.getWitnessType().generateGraphviz()) {
                        generateExecutionGraphFile(task, prover, modelChecker, o.getWitnessType());
                    }
                    // We only generate SVCOMP witnesses if we are not validating one.
                    if (o.getWitnessType().equals(GRAPHML) && !o.runValidator()) {
                        generateWitnessIfAble(task, prover, modelChecker, summary.details());
                    }
                }
            } catch (InterruptedException e) {
                final long time = 1000L * o.getTimeout();
                summary = new ResultSummary(f.toString(), "", TIMEDOUT, "", "", "", time, TIMEOUT_ELAPSED);
            } catch (Exception e) {
                final String reason = e.getClass().getSimpleName();
                final String details = "\t" + Optional.ofNullable(e.getMessage()).orElse("Unknown error occurred");
                summary = new ResultSummary(f.toString(), "", ERROR, "", reason, details, 0, UNKNOWN_ERROR);
            }
            output.addResult(summary);
        }
        output.toStdOut(files.size() > 1);
        if (summary != null) {
            // Running batch mode results in normal termination independent of the individual results
            System.exit((files.size() > 1 ? NORMAL_TERMINATION : summary.code()).asInt());
        }
    }

    public static List<File> getProgramsFiles(String path) {
        List<File> files = new ArrayList<File>();
        try (Stream<Path> stream = Files.walk(Paths.get(path))) {
            files = stream.filter(Files::isRegularFile)
                .filter(p -> supportedFormats.stream().anyMatch(p.toString()::endsWith))
                .map(Path::toFile)
                .sorted(Comparator.comparing(File::toString))
                .toList();
        } catch (IOException e) {
            logger.error("There was an I/O error when accessing path " + path);
            System.exit(UNKNOWN_ERROR.asInt());
        }
        return files;
    }

    public static File generateExecutionGraphFile(VerificationTask task, ProverEnvironment prover, ModelChecker modelChecker,
                                                  WitnessType witnessType)
            throws SolverException, IOException {
        Preconditions.checkArgument(modelChecker.hasModel(), "No execution graph to generate.");

        final EncodingContext encodingContext = modelChecker instanceof RefinementSolver refinementSolver ?
            refinementSolver.getContextWithFullWmm() : modelChecker.getEncodingContext();
        final ExecutionModelNext model = new ExecutionModelManager().buildExecutionModel(
            encodingContext, new ModelExt(prover.getModel())
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
            ModelChecker modelChecker, String details) {
        // ------------------ Generate Witness, if possible ------------------
        final EnumSet<Property> properties = task.getProperty();
        if (task.getProgram().getFormat().equals(SourceLanguage.LLVM) && modelChecker.hasModel()
                && (properties.contains(PROGRAM_SPEC) || properties.contains(DATARACEFREEDOM)) && properties.size() == 1
                && modelChecker.getResult() != UNKNOWN) {
            try {
                WitnessBuilder w = WitnessBuilder.of(modelChecker.getEncodingContext(), prover,
                        modelChecker.getResult(), details);
                if (w.canBeBuilt()) {
                    w.build().write();
                }
            } catch (InvalidConfigurationException e) {
                logger.warn(e.getMessage());
            }
        }
    }

    public static ResultSummary summaryFromResult(VerificationTask task, ProverEnvironment prover,
            ModelChecker modelChecker, String path, long time) throws SolverException {
        // ----------------- Generate output of verification result -----------------
        final Program p = task.getProgram();
        final EnumSet<Property> props = task.getProperty();
        final Result result = modelChecker.getResult();
        final EncodingContext encCtx = modelChecker.getEncodingContext();
        final IREvaluator model = modelChecker.hasModel()
                ? new IREvaluator(encCtx, new ModelExt(prover.getModel()))
                : null;
        final boolean hasViolations = result == FAIL && (model != null);
        final boolean hasViolationsWithoutWitness = result == FAIL && (model == null);

        String reason = "";
        StringBuilder details = new StringBuilder();
        // We only show the condition if this is the reason of the failure
        String condition = "";
        final boolean ignoreFilter = task.getConfig().hasProperty(IGNORE_FILTER_SPECIFICATION) && task.getConfig().getProperty(IGNORE_FILTER_SPECIFICATION).equals("true");
        final boolean nonEmptyFilter = !(p.getFilterSpecification() instanceof BoolLiteral bLit) || !bLit.getValue();
        final String filter = !ignoreFilter && nonEmptyFilter ? p.getFilterSpecification().toString() : "";

        final SyntacticContextAnalysis synContext = newInstance(p);
        if (hasViolations) {
            printWarningIfThreadStartFailed(p, model);
            if (props.contains(PROGRAM_SPEC) && model.propertyViolated(PROGRAM_SPEC)) {
                reason = ResultSummary.PROGRAM_SPEC_REASON;
                condition = getSpecificationString(p);
                List<Assert> violations = p.getThreadEvents(Assert.class)
                    .stream().filter(ass -> model.assertionViolated(ass))
                    .toList();
                for (Assert ass : violations) {
                    final String callStack = makeContextString(synContext.getContextInfo(ass).getContextOfType(CallContext.class), " -> ");
                    details
                            .append("\tE").append(ass.getGlobalId())
                            .append(":\t")
                            .append(callStack.isEmpty() ? callStack : callStack + " -> ")
                            .append(getSourceLocationString(ass))
                            .append(": ").append(ass.getErrorMessage())
                            .append("\n");
                }
                // In validation mode, we expect to find the violation, thus NORMAL_TERMINATION
                ExitCode code = task.getWitness().isEmpty() ? PROGRAM_SPEC_VIOLATION : NORMAL_TERMINATION;
                return new ResultSummary(path, filter, FAIL, condition, reason, details.toString(), time, code);
            }
            if (props.contains(TERMINATION) && model.propertyViolated(TERMINATION)) {
                reason = ResultSummary.TERMINATION_REASON;
                for (Event e : p.getThreadEvents()) {
                    final boolean isStuckLoop = e instanceof CondJump jump
                            && e.hasTag(Tag.NONTERMINATION) && !e.hasTag(Tag.BOUND)
                            && model.jumpTaken(jump);
                    final boolean isStuckBarrier = e instanceof BlockingEvent barrier
                            && model.isBlocked(barrier);

                    if (isStuckLoop || isStuckBarrier) {
                        final String callStack = makeContextString(
                                synContext.getContextInfo(e).getContextOfType(CallContext.class), " -> ");
                        details
                                .append("\tE").append(e.getGlobalId())
                                .append(":\t")
                                .append(callStack.isEmpty() ? callStack : callStack + " -> ")
                                .append(getSourceLocationString(e))
                                .append("\n");
                    }
                }
                // In validation mode, we expect to find the violation, thus NORMAL_TERMINATION
                ExitCode code = task.getWitness().isEmpty() ? TERMINATION_VIOLATION : NORMAL_TERMINATION;
                return new ResultSummary(path, filter, FAIL, condition, reason, details.toString(), time, code);
            }
            if (props.contains(DATARACEFREEDOM) && model.propertyViolated(DATARACEFREEDOM)) {
                reason = ResultSummary.SVCOMP_RACE_REASON;
                // In validation mode, we expect to find the violation, thus NORMAL_TERMINATION
                ExitCode code = task.getWitness().isEmpty() ? DATA_RACE_FREEDOM_VIOLATION : NORMAL_TERMINATION;
                return new ResultSummary(path, filter, FAIL, condition, reason, details.toString(), time, code);
            }
            final List<Axiom> violatedCATSpecs = !props.contains(CAT_SPEC) ? List.of()
                    : task.getMemoryModel().getAxioms().stream()
                    .filter(Axiom::isFlagged)
                    .filter(model::isFlaggedAxiomViolated)
                    .toList();
            if (!violatedCATSpecs.isEmpty()) {
                reason = ResultSummary.CAT_SPEC_REASON;
                // In validation mode, we expect to find the violation, thus NORMAL_TERMINATION
                ExitCode code = task.getWitness().isEmpty() ? CAT_SPEC_VIOLATION : NORMAL_TERMINATION;
                return new ResultSummary(path, filter, FAIL, condition, reason, modelChecker.getFlaggedPairsOutput(), time, code);
            }
        } else if (hasViolationsWithoutWitness) {
            // Only for programs with exists/forall specifications
            reason = ResultSummary.PROGRAM_SPEC_REASON;
            condition = getSpecificationString(p);
        } else if (result == UNKNOWN && modelChecker.hasModel()) {
            // We reached unrolling bounds.
            final List<Event> reachedBounds = p.getThreadEventsWithAllTags(Tag.BOUND)
                    .stream().filter(model::isExecuted)
                    .toList();
            reason = ResultSummary.BOUND_REASON;
            for (Event bound : reachedBounds) {
                details
                        .append("\t")
                        .append(synContext.getSourceLocationWithContext(bound, true))
                        .append("\n");
            }
            try {
                increaseBoundAndDump(reachedBounds, task.getConfig());
            } catch (IOException e) {
                logger.warn("Failed to save bounds file: {}", e.getLocalizedMessage());
            }
        }
        // We consider those cases without an explicit return to yield normal termination.
        // This includes verification of litmus code, independent of the verification result.
        // In validation mode, we expect to find the violation, thus the WITNESS_NOT_VALIDATED error
        ExitCode code = task.getWitness().isEmpty() ? NORMAL_TERMINATION : WITNESS_NOT_VALIDATED;
        return new ResultSummary(path, filter, result, condition, reason, details.toString(), time, code);
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

    private static void printWarningIfThreadStartFailed(Program p, IREvaluator model) {
        p.getThreads().stream().filter(t ->
                t.getEntry().isSpawned()
                && model.isExecuted(t.getEntry().getCreator())
                && !model.threadHasStarted(t)
        ).forEach(t -> System.out.printf(
                "[WARNING] The call to pthread_create of thread %s failed. To force thread creation to succeed use --%s=true%n",
                t, OptionNames.THREAD_CREATE_ALWAYS_SUCCEEDS
        ));
    }

    private static String getSpecificationString(Program program) {
        final StringBuilder sb = new StringBuilder();
        final SourceLanguage format = program.getFormat();
        if (format == SourceLanguage.LITMUS || format == SourceLanguage.SPV) {
            sb.append(program.getSpecificationType().toString().toLowerCase()).append(" ");
            if (program.getSpecification() != null) {
                sb.append(new ExpressionPrinter(true).visit(program.getSpecification()));
            }
            sb.append("\n");
        }
        return sb.toString();
    }

}
