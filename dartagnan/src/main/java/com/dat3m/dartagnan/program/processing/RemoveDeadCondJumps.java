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
        program.getThreads().forEach(this::eliminateDeadCondJumps);
        logger.info(String.format("#Events after %s: %s", getClass().getSimpleName(), + program.getEvents().size()));
    }

    private void eliminateDeadCondJumps(Thread thread) {

        List<Event> toBeRemoved = new ArrayList<>();
        Map<Label, List<Event>> immediateLabelPredecessors = new HashMap<>();
        // We fill the map of predecessors
        Event current = thread.getEntry();
        while (current != null) {
            final Event pred = current.getPredecessor();
        	if (current instanceof CondJump) {
        		final CondJump jump = (CondJump)current;
        		// After constant propagation some jumps have False as condition and are dead
        		if(jump.isDead()) {
        			toBeRemoved.add(jump);
        		} else {
                    immediateLabelPredecessors.computeIfAbsent(jump.getLabel(), key -> new ArrayList<>()).add(jump);
        		}
        	} else if (current instanceof Label && !(pred instanceof CondJump && ((CondJump)pred).isGoto())) {
                immediateLabelPredecessors.computeIfAbsent((Label)current, key -> new ArrayList<>()).add(pred);
        	}
        	current = current.getSuccessor();
        }

        // We check which "ifs" can be removed
        for (Label label : immediateLabelPredecessors.keySet()) {
        	final Event next = label.getSuccessor();
            final List<Event> preds = immediateLabelPredecessors.get(label);
            if (next == null) {
                continue;
            }
			if (next instanceof CondJump && preds.stream().allMatch(e -> mutuallyExclusiveIfs((CondJump)next, e))) {
				toBeRemoved.add(next);
			}
            if (preds.size() == 1 && preds.get(0).getSuccessor().equals(label)) {
                toBeRemoved.add(label);
            }
        }

        // Make sure to not remove "NOOPT" events.
        toBeRemoved.removeIf(e -> e.is(Tag.NOOPT));

        // Here is the actual removal
        boolean isCurDead = false;
        Event cur = thread.getEntry();
        while (cur != null) {
            final Event succ = cur.getSuccessor();
            if(isCurDead && cur instanceof Label && !immediateLabelPredecessors.getOrDefault(cur,List.of()).isEmpty()) {
                // We reached a label that has a non-dead predecessor, hence we reset the isCurDead flag.
                isCurDead = false;
            }
            if(isCurDead && cur instanceof CondJump && immediateLabelPredecessors.containsKey(((CondJump) cur).getLabel())) {
                // We encountered a dead jump, so we remove it as a possible predecessor of its jump target
                immediateLabelPredecessors.get(((CondJump) cur).getLabel()).remove(cur);
            }
            if(isCurDead && immediateLabelPredecessors.containsKey(cur.getSuccessor())) {
                // We encountered a dead event which is a predecessor of a label,
                // so we remove it as a possible predecessor of the label.
                immediateLabelPredecessors.get(cur.getSuccessor()).remove(cur);
            }
            if((isCurDead || toBeRemoved.contains(cur)) && !cur.is(Tag.NOOPT)) {
                // If the current event is dead or can be removed for another reason, we delete it
                cur.delete();
            }
            if(cur instanceof CondJump && ((CondJump) cur).isGoto()) {
                // The immediate successor of a goto is dead by default
                // (unless it is a label with other possible predecessors, which we check for in the first conditional)
                isCurDead = true;
            }
            cur = succ;
        }
   }
    
    private boolean mutuallyExclusiveIfs(CondJump jump, Event e) {
        if (!(e instanceof CondJump)) {
            return false;
        }
        final CondJump other = (CondJump) e;
        if (jump.getGuard() instanceof BExprUn && ((BExprUn)jump.getGuard()).getInner().equals(other.getGuard())
                || other.getGuard() instanceof BExprUn && ((BExprUn) other.getGuard()).getInner().equals(jump.getGuard())) {
            return true;
        }
        if (jump.getGuard() instanceof Atom && other.getGuard() instanceof Atom) {
            final Atom a1 = (Atom) jump.getGuard();
            final Atom a2 = (Atom) other.getGuard();
            return a1.getOp().inverted() == a2.getOp() && a1.getLHS().equals(a2.getLHS()) && a1.getRHS().equals(a2.getRHS());
        }
        return false;
    }
}