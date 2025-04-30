package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.google.common.base.Preconditions;
import com.google.common.base.Verify;

import java.util.*;
import java.util.function.Consumer;

public class IRHelper {

    private IRHelper() {}

    public static boolean isInitThread(Thread thread) {
        return thread.getEntry().getSuccessor() instanceof Init;
    }

    public static boolean isBackJump(CondJump jump) {
        return jump.getLocalId() > jump.getLabel().getLocalId();
    }

    /*
        Returns true if the syntactic successor of <e> (e.getSuccessor()) is not (generally) a semantic successor,
        because <e> always jumps/branches/terminates etc.
    */
    public static boolean isAlwaysBranching(Event e) {
        return e instanceof Return
                || e instanceof AbortIf abort && abort.getCondition() instanceof BoolLiteral b && b.getValue()
                || e instanceof CondJump jump && jump.isGoto();
    }

    public static Set<Event> bulkDelete(Set<Event> toBeDeleted) {
        final Set<Event> nonDeleted = new HashSet<>();
        for (Event e : toBeDeleted) {
            if (toBeDeleted.containsAll(e.getUsers())) {
                e.forceDelete();
            } else {
                nonDeleted.add(e);
            }
        }
        return nonDeleted;
    }

    public static Event replaceWithMetadata(Event event, Event replacement) {
        event.replaceBy(replacement);
        replacement.copyAllMetadataFrom(event);
        return replacement;
    }

    public static List<Event> replaceWithMetadata(Event event, List<Event> replacement) {
        event.replaceBy(replacement);
        replacement.forEach(ev -> ev.copyAllMetadataFrom(event));
        return replacement;
    }

    public static List<Event> getEventsFromTo(Event from, Event to, boolean endInclusive) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction());
        final List<Event> events = new ArrayList<>();
        Event cur = from;
        do {
            final boolean endReached = (cur == to);
            if (!endReached || endInclusive) {
                events.add(cur);
            }
            if (endReached) {
                break;
            }
            cur = cur.getSuccessor();
        } while (cur != null);
        Verify.verify(cur != null, "Event '{}' is not before '{}'", from, to);

        return events;
    }

    public static List<Event> copyEvents(Collection<? extends Event> events,
                                         Consumer<Event> copyUpdater,
                                         Map<Event, Event> copyContext) {
        final List<Event> copies = new ArrayList<>();
        for (Event e : events) {
            final Event copy = e.getCopy();
            copyUpdater.accept(copy);
            copies.add(copy);
            copyContext.put(e, copy);
        }

        copies.stream().filter(EventUser.class::isInstance).map(EventUser.class::cast)
                .forEach(user -> user.updateReferences(copyContext));

        return copies;
    }

    public static List<Event> copyPath(Event from, Event toExclusive,
                                       Consumer<Event> copyUpdater,
                                       Map<Event, Event> copyContext) {
        return copyEvents(getEventsFromTo(from, toExclusive, false), copyUpdater, copyContext);
    }

    public static Consumer<Event> makeRegisterReplacer(Map<Register, Register> regReplacer) {
        final ExprTransformer regSubstitutor =  new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                return regReplacer.getOrDefault(reg, reg);
            }
        };
        return event -> {
            if (event instanceof RegReader reader) {
                reader.transformExpressions(regSubstitutor);
            }
            if (event instanceof LlvmCmpXchg xchg) {
                xchg.setStructRegister(0, (Register)xchg.getStructRegister(0).accept(regSubstitutor));
                xchg.setStructRegister(1, (Register)xchg.getStructRegister(1).accept(regSubstitutor));
            } else if (event instanceof RegWriter regWriter) {
                regWriter.setResultRegister((Register) regWriter.getResultRegister().accept(regSubstitutor));
            }
        };
    }

    public static Map<Register, Register> copyOverRegisters(Iterable<Register> toCopy, Function target,
                                                            java.util.function.Function<Register, String> registerRenaming,
                                                            boolean guaranteeFreshRegisters) {
        final Map<Register, Register> registerMap = new HashMap<>();
        for (Register reg : toCopy) {
            final String name = registerRenaming.apply(reg);
            final Register copiedReg = guaranteeFreshRegisters ?
                    target.newRegister(name, reg.getType())
                    : target.getOrNewRegister(name, reg.getType());
            registerMap.put(reg, copiedReg);
        }
        return registerMap;
    }
}
