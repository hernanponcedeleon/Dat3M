package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.core.threading.ThreadCreate;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import org.sosy_lab.common.configuration.Configuration;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    This pass checks that the function contains only core-level events.
    NOTE: Subclasses of core events are not automatically considered core events themselves and may raise an error.
 */
public class CoreCodeVerification implements FunctionProcessor {

    public static CoreCodeVerification fromConfig(Configuration config) {
        return new CoreCodeVerification();
    }

    /*
        TODO: We list all core events explicitly because we have no marker to distinguish them from non-core events.
         Introducing a CoreEvent interface or a @Core annotation would do the trick.
     */
    private static final Set<Class<? extends Event>> CORE_CLASSES = new HashSet<>(Arrays.asList(
            Load.class, Store.class, Init.class, GenericMemoryEvent.class, GenericVisibleEvent.class,
            CondJump.class, IfAsJump.class, ExecutionStatus.class, Label.class, Local.class,
            Skip.class, Assume.class, RMWStore.class, RMWStoreExclusive.class,
            Assert.class,
            ThreadCreate.class, ThreadArgument.class, ThreadStart.class,
            FenceWithId.class, // For PTX and Vulkan
            BeginAtomic.class, EndAtomic.class
            // We add SVCOMP atomic blocks here as well, despite them not being part of the core package.
            // TODO: We might want to find a more systematic way to extend the core with these custom events.
    ));

    @Override
    public void run(Function function) {
        final List<Event> nonCoreEvents = function.getEvents().stream().
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
