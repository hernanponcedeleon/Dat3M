package com.dat3m.dartagnan.verification;

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
import com.dat3m.dartagnan.utils.printer.OutputLogger.ResultSummary;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.witness.WitnessType;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.base.Preconditions;
import org.apache.commons.csv.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionNames.BOUNDS_SAVE_PATH;
import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;
import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.*;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.getSourceLocationString;
import static com.dat3m.dartagnan.utils.ExitCode.*;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.Result.ERROR;
import static com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer.generateGraphvizFile;

public class TaskResultAnalyzer {

    private static final Logger logger = LoggerFactory.getLogger(TaskResultAnalyzer.class);

    private TaskResultAnalyzer() {
    }

    public static TaskResultAnalyzer create() {
        return new TaskResultAnalyzer();
    }

    public ResultSummary getSummaryFromException(Exception exception, String programPath) {
        final String message = exception.getMessage() != null ? exception.getMessage() : "Unknown error occurred";
        final String details = "\t" + message;

        if (exception instanceof InterruptedException) {
            final ExitCode exitCode =
                    message.contains("Timeout") ? TIMEOUT_ELAPSED
                    : message.contains("canceled") ? CANCELED
                    : UNKNOWN_ERROR;
            return new ResultSummary(programPath, "", INTERRUPTED, "", "", details, 0, exitCode);
        } else {
            final String reason = exception.getClass().getSimpleName();
            return new ResultSummary(programPath, "", ERROR, "", reason, details, 0, UNKNOWN_ERROR);
        }
    }

    public ResultSummary getSummaryFromSolver(TaskSolver solver, String programPath) {
        final VerificationTask task = solver.getTask();
        final Result result = solver.getResult();
        final Program p = task.getProgram();
        final EnumSet<Property> props = task.getProperty();
        final IREvaluator model = solver.hasModel() ? solver.getModel() : null;
        final boolean hasViolationsWithModel = result == FAIL && model != null;
        final boolean hasViolationsWithoutWitness = result == FAIL && model == null;
        final long time = solver.getRuntime();

        // ----------------- Generate output of verification result -----------------
        final String filter = getFilterString(task);
        final SyntacticContextAnalysis synContext = newInstance(p);
        String reason = "";
        StringBuilder details = new StringBuilder();
        // We only show the condition if this is the reason of the failure
        String condition = "";
        if (hasViolationsWithModel) {

            if (props.contains(PROGRAM_SPEC) && model.propertyViolated(PROGRAM_SPEC)) {
                reason = ResultSummary.PROGRAM_SPEC_REASON;
                condition = getSpecificationString(p);
                List<Assert> violations = p.getThreadEvents(Assert.class)
                        .stream().filter(model::assertionViolated)
                        .toList();
                for (Assert ass : violations) {
                    appendTo(details, ass, synContext);
                }
                return new ResultSummary(programPath, filter, FAIL, condition, reason, details.toString(), time, PROGRAM_SPEC_VIOLATION);
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
                        appendTo(details, e, synContext);
                    }
                }
                return new ResultSummary(programPath, filter, FAIL, condition, reason, details.toString(), time, TERMINATION_VIOLATION);
            }

            if (props.contains(DATARACEFREEDOM) && model.propertyViolated(DATARACEFREEDOM)) {
                reason = ResultSummary.SVCOMP_RACE_REASON;
                return new ResultSummary(programPath, filter, FAIL, condition, reason, details.toString(), time, DATA_RACE_FREEDOM_VIOLATION);
            }

            if (props.contains(TRACKABILITY) && model.propertyViolated(TRACKABILITY)) {
                reason = ResultSummary.SVCOMP_UNTRACKABLE_OBJECT_REASON;
                for (MemoryObject o : p.getMemory().getObjects()) {
                    if (model.isLeaked(o) && !model.isTrackable(o)) {
                        appendTo(details, o.getAllocationSite(), synContext);
                    }
                }
                return new ResultSummary(programPath, filter, FAIL, condition, reason, details.toString(), time, MEMORY_TRACKABILITY_VIOLATION);
            }

            if (props.contains(CAT_SPEC)) {
                final List<Axiom> violatedCATSpecs = task.getMemoryModel().getAxioms().stream()
                        .filter(Axiom::isFlagged)
                        .filter(model::isFlaggedAxiomViolated)
                        .toList();
                if (!violatedCATSpecs.isEmpty()) {
                    reason = ResultSummary.CAT_SPEC_REASON;
                    return new ResultSummary(programPath, filter, FAIL, condition, reason, getFlaggedPairsOutput(task, model, synContext), time, CAT_SPEC_VIOLATION);
                }
            }
        } else if (hasViolationsWithoutWitness) {
            // Only for programs with exists/forall specifications
            reason = ResultSummary.PROGRAM_SPEC_REASON;
            condition = getSpecificationString(p);
        } else if (result == UNKNOWN && model != null) {
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
            ExitCode code = BOUNDED_RESULT;
            return new ResultSummary(programPath, filter, result, condition, reason, details.toString(), time, code);
        }

        // We consider those cases without an explicit return to yield normal termination.
        // This includes verification of litmus code, independent of the verification result.
        return new ResultSummary(programPath, filter, result, condition, reason, details.toString(), time, NORMAL_TERMINATION);
    }

    public File generateWitnessIfAble(TaskSolver solver, WitnessType witnessType, String filename,
                                      boolean generateWitnessForUnknown) throws IOException {
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
                        getOrCreateOutputDirectory() + "/", filename,
                        synContext, witnessType.convertToPng(), task.getConfig());
            }
        }

        return null;
    }

    // =========================================== Utility =================================================

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
                            synContext.getContextInfo(e1).getContextOfType(SyntacticContextAnalysis.CallContext.class),
                            callSeparator);
                    final String callStackSecond = makeContextString(
                            synContext.getContextInfo(e2).getContextOfType(SyntacticContextAnalysis.CallContext.class),
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

}
