package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag.Linux;

import java.util.Arrays;
import java.util.List;

public class LkmmProcedures {

    public static List<String> LKMMPROCEDURES = Arrays.asList(
            "__LKMM_LOAD",
            "__LKMM_STORE",
            "__LKMM_XCHG",
            "__LKMM_CMPXCHG",
            "__LKMM_ATOMIC_FETCH_OP",
            "__LKMM_ATOMIC_OP",
            "__LKMM_ATOMIC_OP_RETURN",
            "__LKMM_FENCE",
            "__LKMM_SPIN_LOCK",
            "__LKMM_SPIN_UNLOCK");

    public static boolean handleLkmmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        if (LKMMPROCEDURES.stream().noneMatch(funcName::equals)) {
            return false;
        }

        final String registerName = ctx.call_params().Ident(0).getText();
        final Register reg = visitor.getScopedRegister(registerName); // May be NULL

        final List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
        final Expression p0 = (Expression) params.get(0).accept(visitor);
        final Expression p1 = params.size() > 1 ? (Expression)params.get(1).accept(visitor) : null;
        final Expression p2 = params.size() > 2 ? (Expression)params.get(2).accept(visitor) : null;
        final Expression p3 = params.size() > 3 ? (Expression)params.get(3).accept(visitor) : null;

        String mo;
        IOpBin op;
        switch (funcName) {
            case "__LKMM_LOAD" -> {
                mo = Linux.intToMo(((IConst) p1).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newLKMMLoad(reg, p0, mo));
            }
            case "__LKMM_STORE" -> {
                mo = Linux.intToMo(((IConst) p2).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newLKMMStore(p0, p1, mo.equals(Linux.MO_MB) ? Linux.MO_ONCE : mo));
                if (mo.equals(Linux.MO_MB)) {
                    visitor.addEvent(EventFactory.Linux.newMemoryBarrier());
                }
            }
            case "__LKMM_XCHG" -> {
                mo = Linux.intToMo(((IConst) p2).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newRMWExchange(p0, reg, p1, mo));
            }
            case "__LKMM_CMPXCHG" -> {
                mo = Linux.intToMo(((IConst) p3).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newRMWCompareExchange(p0, reg, p1, p2, mo));
            }
            case "__LKMM_ATOMIC_FETCH_OP" -> {
                mo = Linux.intToMo(((IConst) p2).getValueAsInt());
                op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newRMWFetchOp(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP_RETURN" -> {
                mo = Linux.intToMo(((IConst) p2).getValueAsInt());
                op = IOpBin.intToOp(((IConst) p3).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newRMWOpReturn(p0, reg, p1, op, mo));
            }
            case "__LKMM_ATOMIC_OP" -> {
                op = IOpBin.intToOp(((IConst) p2).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newRMWOp( p0, p1, op));
            }
            case "__LKMM_FENCE" -> {
                String fence = Linux.intToMo(((IConst) p0).getValueAsInt());
                visitor.addEvent(EventFactory.Linux.newLKMMFence(fence));
            }
            case "__LKMM_SPIN_LOCK" -> {
                visitor.addEvent(EventFactory.Linux.newLock(p0));
            }
            case "__LKMM_SPIN_UNLOCK" -> {
                visitor.addEvent(EventFactory.Linux.newUnlock(p0));
            }
            default -> {
                return false;
            }
        }
        return true;
    }
}
