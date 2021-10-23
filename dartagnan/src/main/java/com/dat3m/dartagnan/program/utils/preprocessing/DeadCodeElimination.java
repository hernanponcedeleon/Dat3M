package com.dat3m.dartagnan.program.utils.preprocessing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.HashSet;
import java.util.Set;


public class DeadCodeElimination implements ProgramPreprocessor {

    private static final Logger logger = LogManager.getLogger(DeadCodeElimination.class);

    public DeadCodeElimination() { }

    @Override
    public void run(Program program) {
        if (program.isUnrolled()) {
            throw new IllegalStateException("Dead code elimination should be performed before unrolling.");
        }
        int id = 0;
        for (Thread t : program.getThreads()) {
            eliminateDeadCode(t, id);
            t.clearCache();
            id = t.getExit().getOId() + 1;
        }
        program.clearCache();

        logger.info("#Events after DCE: " + program.getEvents().size());
    }

    private void eliminateDeadCode(Thread thread, int startId) {
        Event entry = thread.getEntry();
        Event exit = thread.getExit();

        if (entry.is(EType.INIT)) {
            return;
        }

        Set<Event> reachableEvents = new HashSet<>();
        computeReachableEvents(entry, reachableEvents);

        Event pred = null;
        Event cur = entry;
        int id = startId;
        while (cur != null) {
            if (!reachableEvents.contains(cur) && cur != exit) {
                cur.delete(pred);
                cur = pred;
            } else {
                cur.setOId(id++);
            }
            pred = cur;
            cur = cur.getSuccessor();
        }
    }

    private void computeReachableEvents(Event e, Set<Event> reachable) {
        if (reachable.contains(e))
            return;

        while (e != null && reachable.add(e)) {
            if (e instanceof CondJump) {
                CondJump j = (CondJump) e;
                if (j.isGoto()) {
                    e = j.getLabel();
                    continue;
                }
                else {
                    computeReachableEvents(j.getLabel(), reachable);
                }
            }
            e = e.getSuccessor();
        }
    }


}
