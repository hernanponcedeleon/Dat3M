package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.lang.svcomp.LoopBound;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.*;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.BOUND;
import static com.dat3m.dartagnan.configuration.OptionNames.PRINT_PROGRAM_AFTER_UNROLLING;

@Options
public class LoopUnrolling implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(LoopUnrolling.class);

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

    @Option(name = PRINT_PROGRAM_AFTER_UNROLLING,
            description = "Prints the program after unrolling.",
            secure = true)
    private boolean print = false;

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
        program.getEvents().forEach(e -> e.setUId(e.getGlobalId())); // Track ids before unrolling
        program.getThreads().forEach(thread -> unrollLoopsInThread(thread, defaultBound));
        program.clearCache(true);
        program.markAsUnrolled(defaultBound);
        EventIdReassignment.newInstance().run(program); // Reassign ids because of newly created events

        logger.info("Program unrolled {} times", defaultBound);
        if(print) {
        	System.out.println("===== Program after unrolling =====");
        	System.out.println(new Printer().print(program));
        	System.out.println("===================================");
        }
    }

    private void unrollLoopsInThread(Thread thread, int defaultBound){
        final Map<CondJump, Integer> loopBoundsMap = computeLoopBoundsMap(thread, defaultBound);
        thread.getEvents().stream()
                .filter(CondJump.class::isInstance).map(CondJump.class::cast)
                .filter(loopBoundsMap::containsKey)
                .forEach(j -> unrollLoop(j, loopBoundsMap.get(j)));
    }

    private Map<CondJump, Integer> computeLoopBoundsMap(Thread thread, int defaultBound) {

        LoopBound curBoundAnnotation = null;
        final Map<CondJump, Integer> loopBoundsMap = new HashMap<>();
        for (Event event : thread.getEvents()) {
            if (event instanceof LoopBound) {
                // Track LoopBound annotation
                if (curBoundAnnotation != null) {
                    logger.warn("Found loop bound annotation that overwrites a previous, unused annotation.");
                }
                curBoundAnnotation = (LoopBound) event;
            } else if (event instanceof Label) {
                final Label label = (Label) event;
                final Optional<CondJump> backjump = label.getJumpSet().stream()
                        .filter(j -> j.getGlobalId() > label.getGlobalId()).findFirst();
                final boolean isLoop = backjump.isPresent();

                if (isLoop) {
                    // Bound annotation > Spin loop tag > default bound
                    final int bound = curBoundAnnotation != null ? curBoundAnnotation.getBound()
                            : label.is(Tag.SPINLOOP) ? 1 : defaultBound;
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
        Preconditions.checkArgument(loopBegin.getGlobalId() < loopBackJump.getGlobalId(),
                "The jump does not belong to a loop.");

        int iterCounter = 0;
        while (++iterCounter <= bound) {
            if (iterCounter == bound) {
                // Mark end of loop
                loopBackJump.insertAfter(
                        EventFactory.newStringAnnotation(String.format("// End of Loop: %s", loopBegin.getName())));

                // Update loop iteration label
                loopBegin.setName(String.format("%s/itr_%d", loopBegin.getName(), iterCounter));
                loopBegin.addFilters(Tag.NOOPT);

                // This is the last iteration, so we replace the back jump by a bound event.
                final Label threadExit = (Label) loopBackJump.getThread().getExit();
                final CondJump boundEvent = EventFactory.newGoto(threadExit);
                boundEvent.addFilters(loopBackJump.getFilters()); // Keep tags of original jump.
                boundEvent.addFilters(Tag.BOUND, Tag.EARLYTERMINATION, Tag.NOOPT);
                loopBackJump.replaceBy(boundEvent);

            } else {
                final Map<Event, Event> copyCtx = new HashMap<>();
                final List<Event> copies = copyPath(loopBegin, loopBackJump, copyCtx);

                // Insert copy of the loop
                loopBegin.getPredecessor().insertAfter(copies);
                if (iterCounter == 1) {
                    // This is the first unrolling; every outside jump to the loop header
                    // gets updated to jump to the first iteration instead.
                    final List<Event> loopEntryJumps = loopBegin.getJumpSet().stream()
                            .filter(j -> j != loopBackJump).collect(Collectors.toList());
                    loopEntryJumps.forEach(j -> j.updateReferences(copyCtx));
                }

                // Rename label of iteration.
                final Label loopBeginCopy = ((Label)copyCtx.get(loopBegin));
                loopBeginCopy.setName(String.format("%s/itr_%d", loopBegin.getName(), iterCounter));
                loopBeginCopy.addFilters(Tag.NOOPT);
            }
        }
    }

    private List<Event> copyPath(Event from, Event until, Map<Event, Event> copyContext) {
        final List<Event> copies = new ArrayList<>();

        Event cur = from;
        Event lastCopy = null;
        while(cur != null && !cur.equals(until)){
            final Event copy = cur.getCopy();
            copy.setPredecessor(lastCopy);
            copies.add(copy);
            copyContext.put(cur, copy);
            lastCopy = copy;
            cur = cur.getSuccessor();
        }

        copies.forEach(e -> e.updateReferences(copyContext));
        return copies;
    }
}