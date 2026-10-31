package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.IntCmpExpr;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RemoveDeadCondJumps implements FunctionProcessor {

    private static final Logger logger = LoggerFactory.getLogger(RemoveDeadCondJumps.class);

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
        // For each label, what is known about some guard when control reaches it (one entry per incoming edge)
        Map<Label, List<EntryCondition>> entryConditions = new HashMap<>();
        // We fill the map of predecessors
        Event current = function.getEntry();
        while (current != null) {
            final Event pred = current.getPredecessor();
            if (current instanceof CondJump jump) {
                // After constant propagation some jumps have False as condition and are dead
                if (jump.isDead()) {
                    toBeRemoved.add(jump);
                } else {
                    immediateLabelPredecessors.computeIfAbsent(jump.getLabel(), _ -> new ArrayList<>()).add(jump);
                    // Taking the jump means that its guard holds
                    entryConditions.computeIfAbsent(jump.getLabel(), _ -> new ArrayList<>())
                            .add(new EntryCondition(jump.getGuard(), true));
                }
            } else if (current instanceof Label label && pred != null && !(pred instanceof CondJump jump && jump.isGoto())) {
                immediateLabelPredecessors.computeIfAbsent(label, _ -> new ArrayList<>()).add(pred);
                // Falling through a jump means that its guard does not hold, other events tell us nothing
                entryConditions.computeIfAbsent(label, _ -> new ArrayList<>())
                        .add(pred instanceof CondJump predJump ? new EntryCondition(predJump.getGuard(), false) : EntryCondition.UNKNOWN);
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
            // If a jump is only reachable, when its guard is false, it is dead.
            if (next instanceof CondJump jump && entryConditions.get(label).stream().allMatch(c -> c.impliesNot(jump.getGuard()))) {
                toBeRemoved.add(next);
            }
            // If a label is only accessible from its predecessor, it can be removed as well.
            if (preds.size() == 1 && preds.getFirst().getSuccessor().equals(label)) {
                if (preds.getFirst() instanceof CondJump jump && jump.getLabel().equals(label)) {
                    assert jump.isDead() || jump.isGoto();
                    toBeRemoved.add(jump);
                }
                toBeRemoved.add(label);
            }
        }

        // Make sure to not remove "NOOPT" or "BOUND" events.
        toBeRemoved.removeIf(e -> e.hasTag(Tag.NOOPT) || e.hasTag(Tag.BOUND));

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
                if (!cur.tryDelete()) {
                    logger.debug("Failed to delete event: {}:   {}", cur.getLocalId(), cur);
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

    // What is known when control reaches a label through one incoming edge: "guard" evaluates to "holds".
    // A null guard means that nothing is known.
    private record EntryCondition(Expression guard, boolean holds) {

        private static final EntryCondition UNKNOWN = new EntryCondition(null, false);

        private boolean impliesNot(Expression other) {
            if (guard == null) {
                return false;
            }
            return holds ? isNegation(guard, other) : guard.equals(other);
        }
    }

    private static boolean isNegation(Expression a, Expression b) {
        if (a instanceof BoolUnaryExpr notA && notA.getOperand().equals(b)
                || b instanceof BoolUnaryExpr notB && notB.getOperand().equals(a)) {
            return true;
        }
        if (a instanceof IntCmpExpr a1 && b instanceof IntCmpExpr a2) {
            return a1.getKind().inverted() == a2.getKind() && a1.getLeft().equals(a2.getLeft()) && a1.getRight().equals(a2.getRight());
        }
        return false;
    }
}