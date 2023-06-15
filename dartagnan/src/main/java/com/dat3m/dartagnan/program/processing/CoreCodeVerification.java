package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStoreExclusive;
import org.sosy_lab.common.configuration.Configuration;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    This pass checks that the program contains only core-level events.
    NOTE: Subclasses of core events are not automatically considered core events themselves and may raise an error.
 */
public class CoreCodeVerification implements ProgramProcessor {

    public static CoreCodeVerification fromConfig(Configuration config) {
        return new CoreCodeVerification();
    }

    /*
        TODO: We list all core events explicitly because we have no marker to distinguish them from non-core events.
         Introducing a CoreEvent interface or a @Core annotation would do the trick.
     */
    private static final Set<Class<? extends Event>> CORE_CLASSES = new HashSet<>(Arrays.asList(
            Load.class, Store.class, Init.class, GenericMemoryEvent.class, Fence.class,
            CondJump.class, IfAsJump.class, ExecutionStatus.class, Label.class, Local.class,
            Skip.class, Assume.class, RMWStore.class, RMWStoreExclusive.class
    ));

    @Override
    public void run(Program program) {

        final List<Event> nonCoreEvents = program.getEvents().stream().
                filter(e -> !(e instanceof CodeAnnotation) && !CORE_CLASSES.contains(e.getClass())).toList();
        if (!nonCoreEvents.isEmpty()) {
            System.out.println("ERROR: Found non-core events.");
            for (Event e : nonCoreEvents) {
                System.out.printf("%2s: %-30s  %s %n", e.getGlobalId(), e, e.getClass().getSimpleName());
            }
            throw new MalformedProgramException("ERROR: Found non-core events.");
        }
    }

}
