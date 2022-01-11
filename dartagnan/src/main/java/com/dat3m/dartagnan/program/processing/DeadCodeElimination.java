package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EType;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.Set;

public class DeadCodeElimination implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(DeadCodeElimination.class);

    private DeadCodeElimination() { }

    public static DeadCodeElimination newInstance() {
        return new DeadCodeElimination();
    }

    public static DeadCodeElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), "Dead code elimination should be performed before unrolling.");

        logger.info("#Events before DCE: " + program.getEvents().size());

        int id = 0;
        for (Thread t : program.getThreads()) {
            eliminateDeadCode(t, id);
            t.clearCache();
            id = t.getExit().getOId() + 1;
        }
        program.clearCache(false);

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
        if (reachable.contains(e)) {
            return;
        }

        while (e != null && reachable.add(e)) {
            if (e instanceof CondJump) {
                CondJump j = (CondJump) e;
                if (j.isGoto()) {
                    e = j.getLabel();
                    continue;
                } else {
                    computeReachableEvents(j.getLabel(), reachable);
                }
            }
            e = e.getSuccessor();
        }
    }
}