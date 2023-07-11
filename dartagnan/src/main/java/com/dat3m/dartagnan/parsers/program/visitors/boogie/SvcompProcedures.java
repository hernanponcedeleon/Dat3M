package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;

import java.math.BigInteger;

public class SvcompProcedures {

    public static boolean handleSvcompFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        switch (funcName) {
            case "reach_error" -> visitor.addAssertion(visitor.expressions.makeZero(visitor.types.getArchType()));
            case "__VERIFIER_loop_bound" -> __VERIFIER_loop_bound(visitor, ctx);
            case "__VERIFIER_loop_begin" -> visitor.addEvent(EventFactory.Svcomp.newLoopBegin());
            case "__VERIFIER_spin_start" -> visitor.addEvent(EventFactory.Svcomp.newSpinStart());
            case "__VERIFIER_spin_end" -> visitor.addEvent(EventFactory.Svcomp.newSpinEnd());
            case "__VERIFIER_assert" -> visitor.addAssertion((Expression) ctx.call_params().exprs().accept(visitor));
            case "__VERIFIER_assume" -> __VERIFIER_assume(visitor, ctx);
            case "__VERIFIER_atomic_begin" -> __VERIFIER_atomic_begin(visitor);
            case "__VERIFIER_atomic_end" -> __VERIFIER_atomic_end(visitor);
            default -> {
                return false;
            }
        }
        return true;
    }

    private static void __VERIFIER_assume(VisitorBoogie visitor, Call_cmdContext ctx) {
        Expression expr = (Expression) ctx.call_params().exprs().accept(visitor);
        visitor.addEvent(EventFactory.newAssume(expr));
    }

    public static void __VERIFIER_atomic_begin(VisitorBoogie visitor) {
        visitor.currentBeginAtomic = (BeginAtomic) visitor.addEvent(EventFactory.Svcomp.newBeginAtomic());
    }

    public static void __VERIFIER_atomic_end(VisitorBoogie visitor) {
        if (visitor.currentBeginAtomic == null) {
            throw new MalformedProgramException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
        }
        visitor.addEvent(EventFactory.Svcomp.newEndAtomic(visitor.currentBeginAtomic));
        visitor.currentBeginAtomic = null;
    }

    private static void __VERIFIER_loop_bound(VisitorBoogie visitor, Call_cmdContext ctx) {
        final int bound = ((IExpr) ctx.call_params().exprs().expr(0).accept(visitor)).reduce().getValueAsInt();
        visitor.addEvent(EventFactory.Svcomp.newLoopBound(bound));
    }
}
