package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.google.common.base.Preconditions;

import java.util.*;

public class IRHelper {

    private IRHelper() {}

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

    public static List<Event> getEventsFromTo(Event from, Event to, boolean endInclusive) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction());
        final List<Event> events = new ArrayList<>();
        Event cur = from;
        do {
            final boolean reachedEnd = (cur == to);
            if (!reachedEnd || endInclusive) {
                events.add(cur);
            }
            if (reachedEnd) {
                break;
            }
            cur = cur.getSuccessor();
        } while (cur != null);
        assert cur != null;

        return events;
    }

    public static List<Event> copyEvents(Collection<? extends Event> events,
                                         Map<Register, Register> regReplacement,
                                         Map<Event, Event> copyContext) {
        final List<Event> copies = new ArrayList<>();
        for (Event e : events) {
            final Event copy = e.getCopy();
            copies.add(copy);
            copyContext.put(e, copy);
        }

        final ExprTransformer regSubstitutor = new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                return regReplacement.getOrDefault(reg, reg);
            }
        };

        for (Event copy : copies) {
            if (copy instanceof EventUser user) {
                user.updateReferences(copyContext);
            }
            if (copy instanceof RegReader reader) {
                reader.transformExpressions(regSubstitutor);
            }
            if (copy instanceof LlvmCmpXchg xchg) {
                xchg.setStructRegister(0, (Register)xchg.getStructRegister(0).accept(regSubstitutor));
                xchg.setStructRegister(1, (Register)xchg.getStructRegister(1).accept(regSubstitutor));
            } else if (copy instanceof RegWriter regWriter) {
                regWriter.setResultRegister((Register) regWriter.getResultRegister().accept(regSubstitutor));
            }

        }

        return copies;
    }

    public static List<Event> copyPath(Event from, Event to,
                                       Map<Register, Register> regReplacement,
                                       Map<Event, Event> copyContext) {
        return copyEvents(getEventsFromTo(from, to, false), regReplacement, copyContext);
    }

    public static Map<Register, Register> copyOverRegisters(Iterable<Register> toCopy, Function target,
                                                            java.util.function.Function<Register, String> registerRename,
                                                            boolean guaranteeFreshRegisters) {
        final Map<Register, Register> registerMap = new HashMap<>();
        for (Register reg : toCopy) {
            final String name = registerRename.apply(reg);
            final Register copiedReg = guaranteeFreshRegisters ?
                    target.newRegister(name, reg.getType())
                    : target.getOrNewRegister(name, reg.getType());
            registerMap.put(reg, copiedReg);
        }
        return registerMap;
    }

    public static boolean isBackJump(CondJump jump) {
        return jump.getLocalId() > jump.getLabel().getLocalId();
    }
}
