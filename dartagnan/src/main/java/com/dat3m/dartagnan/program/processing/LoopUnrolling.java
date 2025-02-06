package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.ControlBarrier;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopBound;
import com.dat3m.dartagnan.program.event.metadata.UnrollingBound;
import com.dat3m.dartagnan.program.event.metadata.UnrollingId;
import com.google.common.base.Preconditions;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.*;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.*;

@Options
public class LoopUnrolling implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(LoopUnrolling.class);

    public static final String LOOP_LABEL_IDENTIFIER = ".loop";
    public static final String LOOP_INFO_SEPARATOR = "/";
    public static final String LOOP_INFO_ITERATION_SUFFIX = "itr_";
    public static final String LOOP_INFO_BOUND_SUFFIX = "bound";

    // =========================== Configurables ===========================

    @Option(name = BOUND,
            description = "Unrolls loops up to loopBound many times.",
            secure = true)
    @IntegerOption(min = 1)
    private int bound = 1;

    public int getUnrollingBound() {
        return bound;
    }

    public void setUnrollingBound(int bound) {
        Preconditions.checkArgument(bound >= 1, "The unrolling bound must be positive.");
        this.bound = bound;
    }

    @Option(name = BOUNDS_LOAD_PATH,
            description = "Path to the CSV file containing loop bounds.",
            secure = true)
    private String boundsLoadPath = "";

    @Option(name = BOUNDS_SAVE_PATH,
            description = "Path to the CSV file to save loop bounds.",
            secure = true)
    private String boundsSavePath = "";

    // =====================================================================

    // We use this once for loading bounds from files (if any), and then to track
    // all computed loop bounds for later storing them into a file (if desired).
    private Map<Function, Map<CondJump, Integer>> globalLoopBoundsMap = new HashMap<>();

    private LoopUnrolling() {
    }

    private LoopUnrolling(Configuration config) throws InvalidConfigurationException {
        this();
        config.inject(this);
    }

    public static LoopUnrolling fromConfig(Configuration config) throws InvalidConfigurationException {
        return new LoopUnrolling(config);
    }

    public static LoopUnrolling newInstance() {
        return new LoopUnrolling();
    }


    @Override
    public void run(Program program) {
        if (program.isUnrolled()) {
            logger.warn("Skipped unrolling: Program is already unrolled.");
            return;
        }

        globalLoopBoundsMap = loadLoopBoundsMapFromFile(program, boundsLoadPath);

        final int defaultBound = this.bound;
        program.getFunctions().forEach(this::run);
        program.getThreads().forEach(this::run);
        program.markAsUnrolled(defaultBound);
        IdReassignment.newInstance().run(program); // Reassign ids because of newly created events

        dumpLoopBoundsMapToFile(program, globalLoopBoundsMap, boundsSavePath);
        globalLoopBoundsMap = null; // Save up some memory

        logger.info("Program unrolled {} times", defaultBound);
    }

    private void run(Function function) {
        function.getEvents().forEach(e -> e.setMetadata(new UnrollingId(e.getGlobalId()))); // Track ids before unrolling
        unrollLoopsInFunction(function, bound);
    }

    private void unrollLoopsInFunction(Function func, int defaultBound) {
        if (!func.hasBody()) {
            return;
        }
        final Map<CondJump, Integer> loopBoundsMap = computeLoopBoundsMap(func, defaultBound);
        func.getEvents(CondJump.class).stream()
                .filter(loopBoundsMap::containsKey)
                .forEach(j -> unrollLoop(j, loopBoundsMap.get(j)));
    }

    private Map<CondJump, Integer> computeLoopBoundsMap(Function func, int defaultBound) {
        LoopBound curBoundAnnotation = null;
        final Map<CondJump, Integer> loopBoundsMap = new HashMap<>();
        for (Event event : func.getEvents()) {
            if (event instanceof LoopBound boundAnnotation) {
                // Track LoopBound annotation
                if (curBoundAnnotation != null) {
                    logger.warn("Found loop bound annotation that overwrites a previous, unused annotation.");
                }
                curBoundAnnotation = boundAnnotation;
            } else if (event instanceof Label label) {
                final Optional<CondJump> backjump = label.getJumpSet().stream()
                        .filter(j -> j.getLocalId() > label.getLocalId()).findFirst();
                final boolean isLoop = backjump.isPresent();

                if (isLoop) {
                    // Bound annotation > Spin loop tag > default bound
                    final int bound = curBoundAnnotation != null ? curBoundAnnotation.getConstantBound()
                            : label.hasTag(Tag.SPINLOOP) ? 1 : defaultBound;
                    loopBoundsMap.put(backjump.get(), bound);
                    curBoundAnnotation = null;
                }
            }
        }

        // Merge with loaded bounds if those exist.
        if(globalLoopBoundsMap.containsKey(func)) {
            final Map<CondJump, Integer> loopBoundsMapFromFile = globalLoopBoundsMap.get(func);
            loopBoundsMapFromFile.forEach((key, value) -> loopBoundsMap.merge(key, value, Math::max));
        }
        // Remember bounds for function for dumping.
        globalLoopBoundsMap.put(func, loopBoundsMap);

        return loopBoundsMap;
    }

    private void unrollLoop(CondJump loopBackJump, int bound) {
        final Label loopBegin = loopBackJump.getLabel();
        Preconditions.checkArgument(bound >= 1, "Positive unrolling bound expected.");
        Preconditions.checkArgument(loopBegin.getLocalId() < loopBackJump.getLocalId(),
                "The jump does not belong to a loop.");

        int iterCounter = 0;
        while (++iterCounter <= bound) {
            if (iterCounter == bound) {
                // Update loop iteration label
                final String loopName = loopBegin.getName();
                loopBegin.setName(String.format("%s%s%s%d", loopName, LOOP_INFO_SEPARATOR, LOOP_INFO_ITERATION_SUFFIX, iterCounter));
                loopBegin.addTags(Tag.NOOPT);

                // This is the last iteration, so we replace the back jump by a bound event.
                final Event boundEvent = newBoundEvent(loopBackJump.getFunction());
                loopBackJump.replaceBy(boundEvent);

                // Mark end of loop, so we can find it later again
                final Label endOfLoopMarker = EventFactory.newLabel(String.format("%s%s%s", loopName, LOOP_INFO_SEPARATOR, LOOP_INFO_BOUND_SUFFIX));
                endOfLoopMarker.addTags(Tag.NOOPT);
                boundEvent.getPredecessor().insertAfter(endOfLoopMarker);

                boundEvent.copyAllMetadataFrom(loopBackJump);
                boundEvent.setMetadata(new UnrollingBound(bound));
                endOfLoopMarker.copyAllMetadataFrom(loopBackJump);

            } else {
                final String loopId = String.format("%s%s%s%d", loopBegin.getName(), LOOP_INFO_SEPARATOR, LOOP_INFO_ITERATION_SUFFIX, iterCounter);
                final Map<Event, Event> copyCtx = new HashMap<>();
                final List<Event> copies = copyPath(loopBegin, loopBackJump, copyCtx, loopId);

                // Insert copy of the loop
                loopBegin.getPredecessor().insertAfter(copies);
                if (iterCounter == 1) {
                    // This is the first unrolling; every outside jump to the loop header
                    // gets updated to jump to the first iteration instead.
                    final List<CondJump> loopEntryJumps = loopBegin.getJumpSet().stream()
                            .filter(j -> j != loopBackJump).toList();
                    loopEntryJumps.forEach(j -> j.updateReferences(copyCtx));
                }

                // Rename label of iteration.
                final Label loopBeginCopy = ((Label)copyCtx.get(loopBegin));
                loopBeginCopy.setName(loopId);
                loopBeginCopy.addTags(Tag.NOOPT);
            }
        }
    }

    private List<Event> copyPath(Event from, Event until, Map<Event, Event> copyContext, String loopId) {
        final List<Event> copies = new ArrayList<>();
        Event cur = from;
        while(cur != null && !cur.equals(until)){
            final Event copy = cur.getCopy();
            if (cur instanceof ControlBarrier curBar && copy instanceof ControlBarrier copyBar) {
                copyBar.setInstanceId(String.format("%s.%s", curBar.getInstanceId(), loopId));
            }
            copies.add(copy);
            copyContext.put(cur, copy);
            cur = cur.getSuccessor();
        }

        copies.stream()
                .filter(EventUser.class::isInstance).map(EventUser.class::cast)
                .forEach(e -> e.updateReferences(copyContext));
        return copies;
    }

    private Event newBoundEvent(Function func) {
        final Event boundEvent = func instanceof Thread thread ?
                EventFactory.newGoto((Label) thread.getExit()) :
                EventFactory.newAbortIf(ExpressionFactory.getInstance().makeTrue());
        boundEvent.addTags(Tag.BOUND, Tag.NONTERMINATION, Tag.NOOPT);
        return boundEvent;
    }

    // ------------------------------------------------------------------------
    // Functions related to loading and storing bound maps

    private boolean pathIsSpecified(String path) {
        return !path.isEmpty();
    }

    public static int getPersistentLoopId(CondJump loopBackjump) {
        final UnrollingId id = loopBackjump.getMetadata(UnrollingId.class);
        return id != null ? id.value() : loopBackjump.getGlobalId();
    }

    public static int getUnrollingBoundAnnotation(CondJump boundEvent) {
        Preconditions.checkArgument(boundEvent.hasTag(Tag.BOUND));
        return boundEvent.getMetadata(UnrollingBound.class).value();
    }

    private Map<Function, Map<CondJump, Integer>> loadLoopBoundsMapFromFile(Program program, String filePath) {
        if (!pathIsSpecified(filePath)) {
            return new HashMap<>();
        }
        if (!Files.exists(Path.of(filePath))) {
            logger.warn("There is no bounds file at path {} . Using default bounds.", filePath);
            return new HashMap<>();
        }

        // Compute mapping from ids to loop events
        final Map<Integer, CondJump> idToJump = new HashMap<>();
        program.getFunctions().forEach(f -> f.getEvents(CondJump.class).forEach(
                jump -> idToJump.put(getPersistentLoopId(jump), jump))
        );

        // Read CSV file to find bounds for loop events
        final Map<Function, Map<CondJump, Integer>> loopBoundsMapPerFunction = new HashMap<>();
        try (Reader reader = new FileReader(filePath)) {
            Iterable<CSVRecord> records = CSVFormat.DEFAULT.parse(reader);
            for (CSVRecord record : records) {
                final int loopId = Integer.parseInt(record.get(0));
                final int bound = Integer.parseInt(record.get(1));
                final CondJump loopJump = idToJump.get(loopId);
                if (loopJump == null) {
                    logger.warn("Loaded bounds file does not match with the program. Ignoring file.");
                    loopBoundsMapPerFunction.clear();
                    break;
                }
                loopBoundsMapPerFunction
                        .computeIfAbsent(loopJump.getFunction(), key -> new HashMap<>())
                        .put(loopJump, bound);
            }
        } catch (IOException e) {
            logger.warn("Failed to read bounds file: {}", e.getLocalizedMessage());
        }

        return loopBoundsMapPerFunction;
    }

    private void dumpLoopBoundsMapToFile(Program program, Map<Function, Map<CondJump, Integer>> loopBounds, String filePath) {
        if (!pathIsSpecified(filePath)) {
            return;
        }

        final SyntacticContextAnalysis synContext = SyntacticContextAnalysis.newInstance(program);
        try (CSVPrinter csvPrinter = new CSVPrinter( new FileWriter(filePath, false), CSVFormat.DEFAULT)) {
            for (Map<CondJump, Integer> loopBoundsMap : loopBounds.values()) {
                for (Map.Entry<CondJump, Integer> entry : loopBoundsMap.entrySet()) {
                    final CondJump loopJump = entry.getKey();
                    final int loopId = getPersistentLoopId(loopJump);
                    final int loopBound = entry.getValue();
                    final String sourceLoc = synContext.getSourceLocationWithContext(loopJump, false);
                    csvPrinter.printRecord(loopId, loopBound, sourceLoc);
                }
            }
            csvPrinter.flush();
        } catch (IOException e) {
            logger.warn("Failed to save bounds file: {}", e.getLocalizedMessage());
        }
    }

}