package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.program.event.core.Label;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/*
    This pass replaces the following code patterns:

    ------ Pattern 1:
    goto L1                         goto L2 // Forwarded
    ...                             ...
    L1            ======>           L1
    goto L2                         goto L2
    ...                             ...
    L2                              L2

    ------ Pattern 2:
    goto L1                         goto L2: // Forwarded
    ...           ======>           ...
    L1:                             L1:
    L2:                             L2:

    In both cases, the label 'L1' and possibly the intermediary jump 'goto L2'
    may become dead code. Other simplification passes will delete those.
 */
public class JumpForwarding implements FunctionProcessor {

    private JumpForwarding() { }

    public static JumpForwarding newInstance() {
        return new JumpForwarding();
    }

    @Override
    public void run(Function function) {
        if (!function.hasBody()) {
            return;
        }

        final List<ForwardingEdge> forwardingEdges = computeForwarding(function);
        for (ForwardingEdge edge : forwardingEdges) {
            final Map<Event, Event> forwardingMap = Map.of(edge.from(), edge.to());
            edge.from().getJumpSet().forEach(j -> j.updateReferences(forwardingMap));
        }
    }

    private List<ForwardingEdge> computeForwarding(Function function) {
        final List<ForwardingEdge> forwardingEdges = new ArrayList<>();
        for (Label label : function.getEvents(Label.class)) {
            if (label.getSuccessor() instanceof CondJump jump && jump.isGoto()) {
                if (isValidForwarding(label, jump)) {
                    forwardingEdges.add(new ForwardingEdge(label, jump.getLabel()));
                }
            } else if (label.getSuccessor() instanceof Label other) {
                if (isValidForwarding(label, null)) {
                    forwardingEdges.add(new ForwardingEdge(label, other));
                }
            }
        }

        return forwardingEdges;
    }

    private boolean isValidForwarding(Label from, CondJump over) {
        if (from.hasTag(Tag.NOOPT)) {
            return false;
        }
        if (!from.getUsers().stream().allMatch(e -> e instanceof CondJump j && !(j instanceof IfAsJump))) {
            // Only forward if all users are plain jumps (no if-as-jumps, nor special events)
            return false;
        }

        // Check if forwarding over jump is valid (if jump is present)
        if (over == null) {
            return true;
        }
        if (over.hasTag(Tag.NOOPT) || over.hasTag(Tag.SPINLOOP) || over.hasTag(Tag.BOUND)) {
            return false;
        }
        if (IRHelper.isBackJump(over)) {
            // Don't forward over backjumps
            return false;
        }

        return true;
    }

    private record ForwardingEdge(Label from, Label to) {
        @Override
        public String toString() {
            return "E%s --> E%s :: %s --> %s".formatted(from.getGlobalId(), to.getGlobalId(), from, to);
        }
    }

}
