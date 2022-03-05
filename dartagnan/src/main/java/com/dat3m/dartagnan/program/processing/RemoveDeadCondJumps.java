package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RemoveDeadCondJumps implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(RemoveDeadCondJumps.class);

    private RemoveDeadCondJumps() { }

    public static RemoveDeadCondJumps newInstance() {
        return new RemoveDeadCondJumps();
    }

    public static RemoveDeadCondJumps fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "The program needs to be unrolled before performing " + getClass().getSimpleName());
        logger.info(String.format("#Events before %s: %s", getClass().getSimpleName(), + program.getEvents().size()));

        for (Thread t : program.getThreads()) {
            eliminateDeadCondJumps(t);
            t.clearCache();
        }
        program.clearCache(false);

        logger.info(String.format("#Events after %s: %s", getClass().getSimpleName(), + program.getEvents().size()));
    }

    private void eliminateDeadCondJumps(Thread thread) {
        Map<Event, List<Event>> immediateLabelPredecessors = new HashMap<>();
        List<Event> removed = new ArrayList<>();

        Event pred = thread.getEntry();
        Event current = pred.getSuccessor();

        // We fill the map of predecessors
        while (current != null) {
        	if(current instanceof CondJump) {
        		CondJump jump = (CondJump)current;
        		// After constant propagation some jumps have False as condition and are dead
        		// But we still need to keep BOUND events
        		if(jump.isDead() && !jump.is(Tag.BOUND)) {
        			removed.add(jump);
        		} else {
                    immediateLabelPredecessors.computeIfAbsent(jump.getLabel(), key -> new ArrayList<>()).add(jump);
        		}
        	} else if(current instanceof Label && !(pred instanceof CondJump && ((CondJump)pred).isGoto())) {
                immediateLabelPredecessors.computeIfAbsent(current, key -> new ArrayList<>()).add(pred);
        	}
            pred = current;
        	current = current.getSuccessor();
        }
        // We check which ifs can be removed
        for(Event label : immediateLabelPredecessors.keySet()) {
        	Event next = label.getSuccessor();
            List<Event> preds = immediateLabelPredecessors.get(label);
        	// We never remove BOUND events
			if(next instanceof CondJump && !next.is(Tag.BOUND) && preds.stream().allMatch(e -> mutuallyExclusiveIfs((CondJump)next, e))) {
				removed.add(next);
			}
            if (next != null && preds.size() == 1 && preds.get(0).getSuccessor().equals(label)) {
                removed.add(label);
            }
        }
        // Here is the actual removal
        pred = null;
        Event cur = thread.getEntry();
        while (cur != null) {
            if (removed.contains(cur)) {
                cur.delete(pred);
                cur = pred;
            }
            pred = cur;
            cur = cur.getSuccessor();
        }
   }
    
    private boolean mutuallyExclusiveIfs(CondJump jump, Event e) {
        if (!(e instanceof CondJump)) {
            return false;
        }
        CondJump jump2 = (CondJump) e;
        if (jump.getGuard() instanceof BExprUn && ((BExprUn)jump.getGuard()).getInner().equals(jump2.getGuard())
                || jump2.getGuard() instanceof BExprUn && ((BExprUn)jump2.getGuard()).getInner().equals(jump.getGuard())) {
            return true;
        }
        if (jump.getGuard() instanceof Atom && jump2.getGuard() instanceof Atom) {
            Atom a1 = (Atom) jump.getGuard();
            Atom a2 = (Atom) jump2.getGuard();
            return a1.getOp().inverted() == a2.getOp() && a1.getLHS().equals(a2.getLHS()) && a1.getRHS().equals(a2.getRHS());
        }
        return false;
    }
}