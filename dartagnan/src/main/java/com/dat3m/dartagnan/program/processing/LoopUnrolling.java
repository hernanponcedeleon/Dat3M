package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.GlobalSettings;
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
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopBound;
import com.dat3m.dartagnan.program.event.metadata.UnrollingBound;
import com.dat3m.dartagnan.program.event.metadata.UnrollingId;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.*;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.csv.CSVRecord;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;
import java.util.*;
import java.util.function.Predicate;

import static com.dat3m.dartagnan.configuration.OptionNames.BOUND;

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

    public int getUnrollingBound() { return bound; }
    public void setUnrollingBound(int bound) {
        Preconditions.checkArgument(bound >= 1, "The unrolling bound must be positive.");
        this.bound = bound;
    }

    // =====================================================================

    private LoopUnrolling() { }

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
        final int defaultBound = this.bound;
        program.getFunctions().forEach(this::run);
        program.getThreads().forEach(this::run);
        program.markAsUnrolled(defaultBound);
        IdReassignment.newInstance().run(program); // Reassign ids because of newly created events

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
        final Map<CondJump, Integer> loopBoundsMapFromFile = loadLoopBoundsMapFromFile(func);
        Map<CondJump, Integer> mergedBounds = new HashMap<>(loopBoundsMap);
        loopBoundsMapFromFile.forEach((key, value) -> mergedBounds.merge(key, value, Math::max));
        func.getEvents(CondJump.class).stream()
                .filter(mergedBounds::containsKey)
                .forEach(j -> unrollLoop(j, mergedBounds.get(j)));
        }

    private Map<CondJump, Integer> loadLoopBoundsMapFromFile(Function func) {
        Map<CondJump, Integer> loopBoundsMapFromFile = new HashMap<>();
        try (Reader reader = new FileReader(GlobalSettings.getBoundsFile())) {
            Iterable<CSVRecord> records = CSVFormat.DEFAULT.parse(reader);
            for (CSVRecord record : records) {
                int nexId = Integer.parseInt(record.get(0));
                int nextBound = Integer.parseInt(record.get(1));
                Predicate<Event> predicate = e -> e.getGlobalId() == nexId;
                if(func.getEvents(CondJump.class).stream().anyMatch(predicate)) {
                    CondJump loop = func.getEvents(CondJump.class).stream().filter(predicate).findAny().get();
                    loopBoundsMapFromFile.put(loop, nextBound);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return loopBoundsMapFromFile;
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
        return loopBoundsMap;
    }

    private void unrollLoop(CondJump loopBackJump, int bound) {
        final Label loopBegin = loopBackJump.getLabel();
        Preconditions.checkArgument(bound >= 1, "Positive unrolling bound expected.");
        Preconditions.checkArgument(loopBegin.getLocalId() < loopBackJump.getLocalId(),
                "The jump does not belong to a loop.");

        dumpBoundIfMissing(loopBackJump, bound);
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
                final Map<Event, Event> copyCtx = new HashMap<>();
                final List<Event> copies = copyPath(loopBegin, loopBackJump, copyCtx);

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
                loopBeginCopy.setName(String.format("%s%s%s%d", loopBegin.getName(), LOOP_INFO_SEPARATOR, LOOP_INFO_ITERATION_SUFFIX, iterCounter));
                loopBeginCopy.addTags(Tag.NOOPT);
            }
        }
    }

    private List<Event> copyPath(Event from, Event until, Map<Event, Event> copyContext) {
        final List<Event> copies = new ArrayList<>();

        Event cur = from;
        while(cur != null && !cur.equals(until)){
            final Event copy = cur.getCopy();
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

    private void dumpBoundIfMissing(Event jump, Integer bound) {
        String evId = String.valueOf(jump.getMetadata(UnrollingId.class).value());
        final SyntacticContextAnalysis synContext = SyntacticContextAnalysis.newInstance(jump.getFunction().getProgram());
        String sourceLoc = synContext.getSourceLocationWithContext(jump, false);
        try (Reader reader = new FileReader(GlobalSettings.getBoundsFile());
                Writer writer = new FileWriter(GlobalSettings.getBoundsFile(), true);
                CSVPrinter csvPrinter = new CSVPrinter(writer, CSVFormat.DEFAULT)) {
            boolean found = false;
            for (CSVRecord record : CSVFormat.DEFAULT.parse(reader)) {
                String nextId = record.get(0);
                if (found = nextId.equals(evId)) {
                    break;
                }
            }
            if (!found) {
                csvPrinter.printRecord(evId, bound.toString(), sourceLoc);
            }
            csvPrinter.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}