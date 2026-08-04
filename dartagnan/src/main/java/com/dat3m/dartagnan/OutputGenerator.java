package com.dat3m.dartagnan;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionPrinter;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.utils.ExitCode;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.witness.WitnessType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.base.Charsets;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.SPV;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.utils.ExitCode.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer.generateGraphvizFile;

@Options
public class OutputGenerator {

    private static final Logger logger = LoggerFactory.getLogger(OutputGenerator.class);

    private static final String PROGRAM_SPEC_REASON = "Program specification violation found";
    private static final String TERMINATION_REASON = "Termination violation found";
    private static final String CAT_SPEC_REASON = "CAT specification violation found";
    private static final String SVCOMP_UNTRACKABLE_OBJECT_REASON = "Untrackable object found";
    private static final String BOUND_REASON = "Not fully unrolled loops";

    // ==================================== Configurables ====================================

    @Option(
            name = WITNESS,
            description = "Type of the violation graph to generate in the output directory.")
    private WitnessType witnessType = WitnessType.getDefault();

    @Option(name=WITNESS_FILENAME,
            description="Name for the witness graph file.",
            secure=true)
    private String witnessFilename = "";

    @Option(name=WITNESS_UNKNOWN,
            description="Generate witness graph even if result is UNKNOWN.",
            secure=true)
    private boolean generateWitnessForUnknown = false;

    // ====================================================================================

    private boolean isBatchMode = false;
    private int batchIndex = -1;
    private Path witnessFile = null;

    public void setBatchMode(boolean isBatchMode) {
        this.isBatchMode = isBatchMode;
    }

    public Optional<Path> getWitnessFile() {
        return  Optional.ofNullable(witnessFile);
    }

    private OutputGenerator(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
    }

    public static OutputGenerator create(Configuration config) throws InvalidConfigurationException {
        return new OutputGenerator(config);
    }

    public Output getOutputFromException(Exception exception, String programPath) {
        final String message = exception.getMessage() != null ? exception.getMessage() : "Unknown error occurred";
        final String details = "\t" + message;
        
        if (exception instanceof InterruptedException) {
            final ExitCode exitCode =
                    message.contains("Timeout") ? TIMEOUT_ELAPSED
                    : message.contains("canceled") ? CANCELED
                    : UNKNOWN_ERROR;
            return new Output(exitCode, toSummary(programPath, "", INTERRUPTED, "", "", details, 0));
        } else {
            final String reason = exception.getClass().getSimpleName();
            return new Output(UNKNOWN_ERROR, toSummary(programPath, "", ERROR, "", reason, details, 0));
        }
    }

    public Output getOutputFromSolver(TaskSolver solver, String programPath) {
        final VerificationTask task = solver.getTask();
        final Result result = solver.getResult();
        final Program p = task.getProgram();
        final EnumSet<Property> props = task.getProperty();
        final IREvaluator model = solver.hasModel() ? solver.getModel() : null;
        final boolean hasViolationsWithModel = result == FAIL && model != null;
        final boolean hasViolationsWithoutWitness = result == FAIL && model == null;
        final long time = solver.getRuntime();

        // ----------------- Generate optional witness -----------------
        batchIndex++;
        try {
            witnessFile = generateWitnessIfAble(solver, getWitnessFilename(programPath));
        } catch (IOException ignored) {
            witnessFile = null;
        }

        // ----------------- Generate output of verification result -----------------
        final String filter = getFilterString(task);
        final SyntacticContextAnalysis synContext = newInstance(p);

        String reason = "";
        StringBuilder details = new StringBuilder();
        // We only show the condition if this is the reason of the failure
        String condition = "";
        if (hasViolationsWithModel) {
            if (props.contains(PROGRAM_SPEC) && model.propertyViolated(PROGRAM_SPEC)) {
                reason = PROGRAM_SPEC_REASON;
                condition = getSpecificationString(p);
                List<Assert> violations = p.getThreadEvents(Assert.class)
                        .stream().filter(model::assertionViolated)
                        .toList();
                for (Assert ass : violations) {
                    appendTo(details, ass, synContext);
                }
                return new Output(PROGRAM_SPEC_VIOLATION, toSummary(programPath, filter, FAIL, condition, reason, details.toString(), time));
            }

            if (props.contains(TERMINATION) && model.propertyViolated(TERMINATION)) {
                reason = TERMINATION_REASON;
                for (Event e : p.getThreadEvents()) {
                    final boolean isStuckLoop = e instanceof CondJump jump
                            && e.hasTag(Tag.NONTERMINATION) && !e.hasTag(Tag.BOUND)
                            && model.jumpTaken(jump);
                    final boolean isStuckBarrier = e instanceof BlockingEvent barrier
                            && model.isBlocked(barrier);

                    if (isStuckLoop || isStuckBarrier) {
                        appendTo(details, e, synContext);
                    }
                }
                return new Output(TERMINATION_VIOLATION, toSummary(programPath, filter, FAIL, condition, reason, details.toString(), time));
            }

            if (props.contains(TRACKABILITY) && model.propertyViolated(TRACKABILITY)) {
                reason = SVCOMP_UNTRACKABLE_OBJECT_REASON;
                for (MemoryObject o : p.getMemory().getObjects()) {
                    if (model.isLeaked(o) && !model.isTrackable(o)) {
                        appendTo(details, o.getAllocationSite(), synContext);
                    }
                }
                return new Output(MEMORY_TRACKABILITY_VIOLATION, toSummary(programPath, filter, FAIL, condition, reason, details.toString(), time));
            }

            if (props.contains(CAT_SPEC)) {
                final List<Axiom> violatedCATSpecs = task.getMemoryModel().getAxioms().stream()
                        .filter(Axiom::isFlagged)
                        .filter(model::isFlaggedAxiomViolated)
                        .toList();
                if (!violatedCATSpecs.isEmpty()) {
                    reason = CAT_SPEC_REASON;
                    return new Output(CAT_SPEC_VIOLATION, toSummary(programPath, filter, FAIL, condition, reason, getFlaggedPairsOutput(task, model, synContext), time));
                }
            }
        } else if (hasViolationsWithoutWitness) {
            // Only for programs with exists/forall specifications
            reason = PROGRAM_SPEC_REASON;
            condition = getSpecificationString(p);
        } else if (result == UNKNOWN && model != null) {
            // We reached unrolling bounds.
            final List<Event> reachedBounds = p.getThreadEventsWithAllTags(Tag.BOUND)
                    .stream().filter(model::isExecuted)
                    .toList();
            reason = BOUND_REASON;
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
            return new Output(BOUNDED_RESULT, toSummary(programPath, filter, result, condition, reason, details.toString(), time));
        }

        // We consider those cases without an explicit return to yield normal termination.
        // This includes verification of litmus code, independent of the verification result.
        return new Output(NORMAL_TERMINATION, toSummary(programPath, filter, result, condition, reason, details.toString(), time));
    }

    private Path generateWitnessIfAble(TaskSolver solver, String filename) throws IOException {
        if (!solver.hasModel()
                || (solver.getResult() == UNKNOWN && !generateWitnessForUnknown)
                || witnessType == WitnessType.NONE) {
            return null;
        }

        final VerificationTask task = solver.getTask();
        switch (witnessType) {
            case DOT, PNG -> {
                final SyntacticContextAnalysis synContext = newInstance(task.getProgram());
                final ExecutionModelNext model = solver.getExecutionGraph();
                // RF edges give both ordering and data flow information, thus even when the pair is in PO
                // we get some data flow information by observing the edge
                // CO edges only give ordering information which is known if the pair is also in PO
                return generateGraphvizFile(model, task.getProgram().getName(), (x, y) -> true,
                        (x, y) -> !x.getThreadModel().getThread().equals(y.getThreadModel().getThread()),
                        getOrCreateOutputDirectory(), filename,
                        synContext, witnessType.convertToPng(), task.getConfig());
            }
        }

        return null;
    }

    // =========================================== Utility =================================================

    private String getWitnessFilename(String progFile) {
        final String batchSuffix = isBatchMode ? "-batch#" + batchIndex : "";
        return !witnessFilename.isBlank()
                ? witnessFilename + batchSuffix
                : Utils.getNameWithoutExtension(progFile);
    }

    private static void increaseBoundAndDump(List<Event> boundEvents, Configuration config) throws IOException {
        if(!config.hasProperty(BOUNDS_SAVE_PATH)) {
            return;
        }
        final Path boundsFile = Path.of(config.getProperty(BOUNDS_SAVE_PATH));

        // Parse old entries
        final List<CSVRecord> entries;
        try (CSVParser parser = CSVParser.parse(boundsFile, Charsets.UTF_8, CSVFormat.DEFAULT)) {
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
        try (CSVPrinter csvPrinter = new CSVPrinter(Files.newBufferedWriter(boundsFile), CSVFormat.DEFAULT)) {
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

    private static void appendTo(StringBuilder details, Event event, SyntacticContextAnalysis synContext) {
        details.append("\t").append(synContext.getSourceLocationWithContext(event, true));
        if (event instanceof Assert ass) {
            details.append(": ").append(ass.getErrorMessage());
        }
        details.append("\n");
    }

    private static String getFlaggedPairsOutput(VerificationTask task, IREvaluator model, SyntacticContextAnalysis synContext) {
        if (!task.getProperty().contains(CAT_SPEC)) {
            return "";
        }

        final Wmm wmm = task.getMemoryModel();
        final StringBuilder output = new StringBuilder();
        for (Axiom ax : wmm.getAxioms()) {
            if (ax.isFlagged() && model.isFlaggedAxiomViolated(ax)) {
                StringBuilder violatingPairs = new StringBuilder("\tFlag " + Optional.ofNullable(ax.getName()).orElse(ax.getRelation().getNameOrTerm())).append("\n");
                model.eventGraph(ax.getRelation()).apply((e1, e2) -> {
                    final String callSeparator = " -> ";
                    final String callStackFirst = makeContextString(
                            synContext.getContextInfo(e1).getContextOfType(CallContext.class),
                            callSeparator);
                    final String callStackSecond = makeContextString(
                            synContext.getContextInfo(e2).getContextOfType(CallContext.class),
                            callSeparator);

                    violatingPairs
                            .append("\t").append(callStackFirst).append(callStackFirst.isEmpty() ? "" : callSeparator)
                            .append(getSourceLocationString(e1))
                            .append(" / ").append(callStackSecond).append(callStackSecond.isEmpty() ? "" : callSeparator)
                            .append(getSourceLocationString(e2))
                            .append("\t(E").append(e1.getGlobalId())
                            .append(" / E").append(e2.getGlobalId()).append(")")
                            .append("\n");
                });
                output.append(violatingPairs);
            }
        }

        return output.toString();
    }

    private static String getSpecificationString(Program program) {
        if (!List.of(LITMUS, SPV).contains(program.getFormat())) {
            return "";
        }

        final StringBuilder sb = new StringBuilder();
        sb.append(program.getSpecificationType().toString().toLowerCase()).append(" ");
        // TODO: Can the spec really be null here?
        if (program.getSpecification() != null) {
            sb.append(new ExpressionPrinter(true).visit(program.getSpecification()));
        }
        sb.append("\n");
        return sb.toString();
    }

    private static String getFilterString(VerificationTask task) {
        if ("true".equals(task.getConfig().getProperty(IGNORE_FILTER_SPECIFICATION)))
            return "";

        final Expression filter = task.getProgram().getFilterSpecification();
        final boolean isTrivialFilter = filter instanceof BoolLiteral bLit && bLit.getValue();
        return isTrivialFilter ? "" : filter.toString();
    }

    private static String toSummary(String test, String filter, Result result, String condition,
                                    String reason, String details, long time) {

        final String shownFilter = !filter.isEmpty() ? String.format("Filter: %s%n", filter) : "";
        final String shownCondition = !condition.isEmpty() ? String.format("Condition: %s", condition) : "";
        final String shownReason = result != PASS && !reason.isEmpty() ? String.format("Reason: %s%n", reason) : "";
        final String shownDetails = !details.isEmpty() ? String.format("Details:%n%s", details) : "";
        final String shownTime = time > 0 ? String.format("Time: %s", Utils.toTimeString(time)) : "";

        return String.format("Test: %s%n%sResult: %s%n%s%s%s%s",
                test, shownFilter, result, shownReason, shownCondition, shownDetails, shownTime);
    }

}
