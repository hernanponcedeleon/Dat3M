package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RemoveDeadCondJumps implements FunctionProcessor {

    private static final Logger logger = LogManager.getLogger(RemoveDeadCondJumps.class);

    private RemoveDeadCondJumps() {
    }

    public static RemoveDeadCondJumps newInstance() {
        return new RemoveDeadCondJumps();
    }

    public static RemoveDeadCondJumps fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Function function) {
        eliminateDeadCondJumps(function);
    }

    private void eliminateDeadCondJumps(Function function) {

        List<Event> toBeRemoved = new ArrayList<>();
        Map<Label, List<Event>> immediateLabelPredecessors = new HashMap<>();
        // We fill the map of predecessors
        Event current = function.getEntry();
        while (current != null) {
            final Event pred = current.getPredecessor();
            if (current instanceof CondJump jump) {
                // After constant propagation some jumps have False as condition and are dead
                if (jump.isDead()) {
                    toBeRemoved.add(jump);
                } else {
                    immediateLabelPredecessors.computeIfAbsent(jump.getLabel(), key -> new ArrayList<>()).add(jump);
                }
            } else if (current instanceof Label label && pred != null && !(pred instanceof CondJump jump && jump.isGoto())) {
                immediateLabelPredecessors.computeIfAbsent(label, key -> new ArrayList<>()).add(pred);
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
            if (next instanceof CondJump jump && preds.stream().allMatch(e -> mutuallyExclusiveIfs(jump, e))) {
                toBeRemoved.add(next);
            }
            if (preds.size() == 1 && preds.get(0).getSuccessor().equals(label)) {
                toBeRemoved.add(label);
            }
        }

        // Make sure to not remove "NOOPT" events.
        toBeRemoved.removeIf(e -> e.hasTag(Tag.NOOPT));

        // Here is the actual removal
        boolean isCurDead = false;
        Event cur = function.getEntry();
        while (cur != null) {
            final Event succ = cur.getSuccessor();
            if (isCurDead && cur instanceof Label && !immediateLabelPredecessors.getOrDefault(cur, List.of()).isEmpty()) {
                // We reached a label that has a non-dead predecessor, hence we reset the isCurDead flag.
                isCurDead = false;
            }
            if (isCurDead && cur instanceof CondJump jump && immediateLabelPredecessors.containsKey(jump.getLabel())) {
                // We encountered a dead jump, so we remove it as a possible predecessor of its jump target
                immediateLabelPredecessors.get(jump.getLabel()).remove(cur);
            }
            if (isCurDead && immediateLabelPredecessors.containsKey(cur.getSuccessor())) {
                // We encountered a dead event which is a predecessor of a label,
                // so we remove it as a possible predecessor of the label.
                immediateLabelPredecessors.get(cur.getSuccessor()).remove(cur);
            }
            if ((isCurDead || toBeRemoved.contains(cur)) && !cur.hasTag(Tag.NOOPT)) {
                // If the current event is dead or can be removed for another reason, we try to delete it
                if (cur instanceof Label label) {
                    //FIXME: We sometimes mark labels that still have jumps to them for deletion.
                    // We should make sure to also mark the jumps for deletion, rather than explicitly deleting them here.
                    label.getJumpSet().forEach(Event::tryDelete);
                }
                if (!cur.tryDelete()) {
                    logger.warn("Failed to delete event: {}:   {}", cur.getLocalId(), cur);
                }
            }
            if (cur instanceof CondJump jump && jump.isGoto()) {
                // The immediate successor of a goto is dead by default
                // (unless it is a label with other possible predecessors, which we check for in the first conditional)
                isCurDead = true;
            }
            cur = succ;
        }
    }

    private boolean mutuallyExclusiveIfs(CondJump jump, Event e) {
        if (!(e instanceof CondJump other)) {
            return false;
        }
        if (jump.getGuard() instanceof BoolUnaryExpr jumpGuard && jumpGuard.getOperand().equals(other.getGuard())
                || other.getGuard() instanceof BoolUnaryExpr otherGuard && otherGuard.getOperand().equals(jump.getGuard())) {
            return true;
        }
        if (jump.getGuard() instanceof IntCmpExpr a1 && other.getGuard() instanceof IntCmpExpr a2) {
            return a1.getKind().inverted() == a2.getKind() && a1.getLeft().equals(a2.getLeft()) && a1.getRight().equals(a2.getRight());
        }
        return false;
    }
}