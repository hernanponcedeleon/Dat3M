package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.core.special.StateSnapshot;
import com.dat3m.dartagnan.program.event.core.threading.*;
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
            Skip.class, RMWStore.class, RMWStoreExclusive.class, Alloc.class,
            Assume.class, Assert.class,
            ThreadCreate.class, ThreadJoin.class, ThreadArgument.class, ThreadStart.class, ThreadReturn.class,
            ControlBarrier.class, NamedBarrier.class,
            BeginAtomic.class, EndAtomic.class,
            StateSnapshot.class
            // We add SVCOMP atomic blocks here as well, despite them not being part of the core package.
            // TODO: We might want to find a more systematic way to extend the core with these custom events.
    ));

    @Override
    public void run(Function function) {
        final List<Event> nonCoreEvents = function.getEvents().stream().
                filter(e -> !(e instanceof CodeAnnotation) && !CORE_CLASSES.contains(e.getClass())).toList();
        if (!nonCoreEvents.isEmpty()) {
            StringBuilder msg = new StringBuilder();
            for (Event e : nonCoreEvents) {
                msg.append(String.format("\t%2s: %-30s  %s %n", e.getGlobalId(), e, e.getClass().getSimpleName()));
            }
            throw new MalformedProgramException("Found non-core events.\n" + msg);
        }
    }
}
