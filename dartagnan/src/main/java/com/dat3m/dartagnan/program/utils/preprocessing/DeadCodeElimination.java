package com.dat3m.dartagnan.program.utils.preprocessing;

import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.If;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.Thread;

import java.util.HashSet;
import java.util.Set;


//TODO: Add support for Ifs
public class DeadCodeElimination {

    private final Thread thread;

    public DeadCodeElimination(Thread t) {
        this.thread = t;
    }

    private void eliminateDeadCode(int startId) {
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
            } else if (e instanceof If) {
            	//TODO(TH): implement
            }
            e = e.getSuccessor();
        }
    }

    public void apply(int startId) {
        eliminateDeadCode(startId);
    }
}
