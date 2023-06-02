package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashSet;
import java.util.Set;

public class UnreachableCodeElimination implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(UnreachableCodeElimination.class);

    private UnreachableCodeElimination() { }

    public static UnreachableCodeElimination newInstance() {
        return new UnreachableCodeElimination();
    }

    public static UnreachableCodeElimination fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(!program.isUnrolled(), "Dead code elimination should be performed before unrolling.");

        logger.info("#Events before DCE: " + program.getEvents().size());
        program.getThreads().forEach(this::eliminateDeadCode);
        logger.info("#Events after DCE: " + program.getEvents().size());
    }

    private void eliminateDeadCode(Thread thread) {
        final AbstractEvent entry = thread.getEntry();
        final AbstractEvent exit = thread.getExit();

        if (entry.hasTag(Tag.INIT)) {
            return;
        }

        final Set<AbstractEvent> reachableEvents = new HashSet<>();
        computeReachableEvents(entry, reachableEvents);

        thread.getEvents().stream()
                .filter(e -> !reachableEvents.contains(e) && e != exit && !e.hasTag(Tag.NOOPT))
                .forEach(AbstractEvent::delete);
    }

    // Modifies the second parameter
    private void computeReachableEvents(AbstractEvent start, Set<AbstractEvent> reachable) {
        AbstractEvent e = start;
        while (e != null && reachable.add(e)) {
            if (e instanceof CondJump) {
                final CondJump jump = (CondJump) e;
                final Label jumpTarget = jump.getLabel();

                if (jump.isGoto()) {
                    e = jumpTarget;
                } else {
                    computeReachableEvents(jumpTarget, reachable);
                    e = e.getSuccessor();
                }
            } else {
                e = e.getSuccessor();
            }
        }
    }
}