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

    public static List<Event> getEventsFromTo(Event from, Event to) {
        Preconditions.checkArgument(from.getFunction() == to.getFunction());
        final List<Event> events = new ArrayList<>();
        Event cur = from;
        do {
            events.add(cur);
            if (cur == to) {
                break;
            }
            cur = cur.getSuccessor();
        } while (cur != null);
        assert cur != null;

        return events;
    }

    public static List<Event> copyPath(Event from, Event until, Map<Event, Event> copyContext,
                                       Map<Register, Register> regReplacement) {
        final List<Event> copies = new ArrayList<>();

        Event cur = from;
        while (cur != null && !cur.equals(until)) {
            final Event copy = cur.getCopy();
            copies.add(copy);
            copyContext.put(cur, copy);
            cur = cur.getSuccessor();
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

    /*
        Returns true if the syntactic successor of <e> (e.getSuccessor()) is not (generally) a semantic successor,
        because <e> always jumps/branches/terminates etc.
     */
    public static boolean isAlwaysBranching(Event e) {
        return e instanceof Return
                || e instanceof AbortIf abort && abort.getCondition() instanceof BoolLiteral b && b.getValue()
                || e instanceof CondJump jump && jump.isGoto();
    }
}
