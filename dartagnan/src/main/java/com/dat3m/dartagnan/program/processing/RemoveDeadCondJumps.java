package com.dat3m.dartagnan.program.processing;

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
        Map<Event, List<Event>> predecessorsMap = new HashMap<>();
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
            		List<Event> predecessors = predecessorsMap.getOrDefault(jump.getLabel(), new ArrayList<>());
            		predecessors.add(jump);
                	predecessorsMap.put(jump.getLabel(), predecessors);
        		}
        	}
        	if(current.getSuccessor() instanceof Label) {
            	if(current instanceof CondJump && ((CondJump)current).isGoto()) {
            		// current is not a predecessor
            	} else {
            		List<Event> predecessors = predecessorsMap.getOrDefault(current.getSuccessor(), new ArrayList<>());
            		predecessors.add(current);
                	predecessorsMap.put(current.getSuccessor(), predecessors);
            	}
        	}
        	current = current.getSuccessor();
        }
        // We check which ifs can be removed
        for(Event label : predecessorsMap.keySet()) {
        	Event next = label.getSuccessor();
        	// We never remove BOUND events
			if(next instanceof CondJump && !next.is(Tag.BOUND) && predecessorsMap.get(label).stream().allMatch(e -> mutuallyExclusiveIfs((CondJump)next, e))) {
				removed.add(next);
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
    	return jump.getGuard() instanceof BExprUn && e instanceof CondJump && ((BExprUn)jump.getGuard()).getInner().equals(((CondJump)e).getGuard());
    }
}