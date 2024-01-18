package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.Set;

public class UnreachableCodeElimination implements FunctionProcessor {

    private UnreachableCodeElimination() { }

    public static UnreachableCodeElimination newInstance() {
        return new UnreachableCodeElimination();
    }

    public static UnreachableCodeElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Function function) {
        if (!function.hasBody()) {
            return;
        }

        final Event entry = function.getEntry();
        // When running on threads, we avoid deleting the exit event.
        final Event exit = function instanceof Thread ? function.getExit() : null;

        final Set<Event> reachableEvents = new HashSet<>();
        collectReachableEvents(entry, reachableEvents);

        function.getEvents().stream()
                .filter(e -> !reachableEvents.contains(e) && e != exit && !e.hasTag(Tag.NOOPT))
                .forEach(e -> {
                    if (e.getUsers().stream().noneMatch(reachableEvents::contains)) {
                        // We force delete in case there are cyclic references among dead events that prevent
                        // normal deletion. We also only delete if the event is not referenced by a reachable one.
                        //TODO: Maybe it is best to declare events as reachable, when they are referenced by
                        // reachable events?
                        e.forceDelete();
                    }
                });
    }

    // Modifies the second parameter
    private void collectReachableEvents(Event start, Set<Event> reachable) {
        Event e = start;
        while (e != null && reachable.add(e)) {
            if (isTerminator(e)) {
                break;
            }
            if (e instanceof CondJump jump) {
                final Label jumpTarget = jump.getLabel();
                if (jump.isGoto()) {
                    e = jumpTarget;
                } else {
                    collectReachableEvents(jumpTarget, reachable);
                    e = e.getSuccessor();
                }
            } else {
                e = e.getSuccessor();
            }
        }
    }

    private boolean isTerminator(Event e) {
        return e instanceof Return
                || e instanceof AbortIf abort && abort.getCondition() instanceof BConst b && b.getValue();
    }

}