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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        int nextId = 0;
        for(Thread thread : program.getThreads()){
            nextId = unrollThreadAndUpdate(thread, bound, nextId);
        }
        program.clearCache(false);
        program.markAsUnrolled(bound);

        logger.info("Program unrolled {} times", bound);
        if(print) {
        	System.out.println("===== Program after unrolling =====");
        	System.out.println(new Printer().print(program));
        	System.out.println("===================================");
        }
}

    private int unrollThreadAndUpdate(Thread t, int bound, int nextId){
        unrollThread(t, bound);
        t.clearCache();
        for (Event e : t.getEvents()) {
            e.setUId(nextId++);
        }

        return nextId;
    }

    private void unrollThread(Thread thread, int defaultBound) {
        Event cur = thread.getEntry();
        Map<Label, Integer> boundAnnotationMap = new HashMap<>();
        LoopBound curBoundAnn = null;

        while (cur != null) {
            Event next = cur.getSuccessor();
            if (cur instanceof LoopBound) {
                if (curBoundAnn != null) {
                    logger.warn("Found loop bound annotation that overwrites a previous, unused annotation.");
                }
                curBoundAnn = (LoopBound) cur;
            } else if (curBoundAnn != null && cur instanceof Label) {
                Label label = (Label)cur;
                if (label.getJumpSet().stream().anyMatch(jump -> jump.getOId() > label.getOId())) {
                    // The label denotes the beginning of a loop, and we found a LoopBound annotation before,
                    // so we remember the bound and reset the annotation tracker.
                    boundAnnotationMap.put(label, curBoundAnn.getBound());
                    curBoundAnn = null;
                }
            } else if (cur instanceof CondJump && ((CondJump) cur).getLabel().getOId() < cur.getOId()) {
                CondJump jump = (CondJump) cur;
                if (jump.getLabel().getJumpSet().stream().allMatch(x -> x.getOId() <= jump.getOId())) {
                    int bound;
                    if (boundAnnotationMap.containsKey(jump.getLabel())) {
                        bound = boundAnnotationMap.get(jump.getLabel());
                    } else if (jump.is(Tag.SPINLOOP)) {
                        // We let annotations get precedence over the default bound of spin loops.
                        bound = 1;
                    } else {
                        bound = defaultBound;
                    }
                    unrollLoop(jump, bound);
                }
            }
            cur = next;
        }
    }

    private void unrollLoop(CondJump loopBackJump, int bound) {
        Label loopBegin = loopBackJump.getLabel();
        Preconditions.checkArgument(bound >= 1, "Positive unrolling bound expected.");
        Preconditions.checkArgument(loopBegin.getOId() < loopBackJump.getOId(),
                "The jump does not belong to a loop.");
        Preconditions.checkArgument(loopBackJump.getUId() < 0, "The loop has already been unrolled");

        // (1) Collect continue points of the loop
        List<CondJump> continues = new ArrayList<>();
        for (Event e = loopBegin; e != null && e != loopBackJump; e = e.getSuccessor()) {
            if (e instanceof CondJump && ((CondJump)e).getLabel() == loopBegin) {
                continues.add((CondJump) e);
            }
        }
        continues.add(loopBackJump);

        // (2) Collect forward jumps from the outside into the loop
        List<CondJump> enterJumps = new ArrayList<>();
        for (Event e = loopBegin; e != null && e != loopBackJump; e = e.getSuccessor()) {
            if (e instanceof Label) {
                Label label = (Label) e;
                label.getJumpSet().stream()
                        .filter(j -> j.getOId() < loopBegin.getOId())
                        .forEach(enterJumps::add);
            }
        }

        int iterCounter = 0;
        while (--bound >= 0) {
            iterCounter++;
            if (bound == 0) {
                Label exit = (Label) loopBackJump.getThread().getExit();
                loopBegin.setName(loopBegin.getName() + "_" + iterCounter);
                for (CondJump cont : continues) {
                    if (!cont.isGoto()) {
                        logger.warn("Conditional jump {} was replaced by unconditional bound event", cont);
                    }
                    CondJump boundEvent = EventFactory.newGoto(exit);
                    boundEvent.addFilters(cont.getFilters()); // Keep tags of original jump.
                    boundEvent.addFilters(Tag.BOUND, Tag.EARLYTERMINATION, Tag.NOOPT);

                    cont.getPredecessor().setSuccessor(boundEvent);
                    boundEvent.setSuccessor(cont.getSuccessor());
                    cont.delete();
                }
            } else {
                Map<Event, Event> copyCtx = new HashMap<>();
                List<Event> copies = copyPath(loopBegin, loopBackJump, copyCtx);
                ((Label)copyCtx.get(loopBegin)).setName(loopBegin.getName() + "_" + iterCounter);

                // Insert copies at right place
                loopBegin.getPredecessor().setSuccessor(copies.get(0));
                copies.get(copies.size() - 1).setSuccessor(loopBegin);

                // Update entering jumps to go to the copies.
                for (CondJump enterJump : enterJumps) {
                    enterJump.updateReferences(copyCtx);
                }
                enterJumps.clear();

                // All "continues" that were copied need to get updated to jump forward to the next iteration.
                for (CondJump cont : continues) {
                    if (cont == loopBackJump) {
                        continue;
                    }
                    CondJump copy = (CondJump) copyCtx.get(cont);
                    copy.updateReferences(Map.of(copy.getLabel(), loopBegin));
                    enterJumps.add(cont);
                }

            }
        }
    }

    private List<Event> copyPath(Event from, Event until, Map<Event, Event> copyContext) {
        List<Event> copies = new ArrayList<>();
        Event cur = from;
        while(cur != null && !cur.equals(until)){
            Event copy = cur.getCopy();
            copies.add(copy);
            copyContext.put(cur, copy);
            cur = cur.getSuccessor();
        }
        Event pred = null;
        for (Event e : copies) {
            e.setPredecessor(pred);
            e.updateReferences(copyContext);
            pred = e;
        }
        return copies;
    }
}