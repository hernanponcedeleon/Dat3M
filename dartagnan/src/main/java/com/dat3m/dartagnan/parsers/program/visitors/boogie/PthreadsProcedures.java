package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprsContext;
import com.dat3m.dartagnan.program.event.EventFactory;

public class PthreadsProcedures {

    public static boolean handlePthreadsFunctions(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        switch (funcName) {
            case "pthread_cond_init":
            case "pthread_cond_wait":
            case "pthread_cond_signal":
            case "pthread_cond_broadcast":
            case "pthread_mutex_destroy":
                // TODO: These are skipped for now
                VisitorBoogie.logger.warn(
                        "Skipped call to {} because the function is not supported right now.", funcName);
                return true;
            case "pthread_exit":
                final Expression retVal = (Expression) ctx.call_params().exprs().expr(0).accept(visitor);
                visitor.addEvent(EventFactory.newFunctionReturn(retVal));
                return true;
            case "pthread_mutex_init":
                mutexInit(visitor, ctx);
                return true;
            case "pthread_mutex_lock":
                mutexLock(visitor, ctx);
                return true;
            case "pthread_mutex_unlock":
                mutexUnlock(visitor, ctx);
                return true;
            default:
                // pthread_create and pthread_join are handled by a dedicated pass, so we skip them here.
                return false;
        }
    }

    private static void mutexInit(VisitorBoogie visitor, Call_cmdContext ctx) {
        final ExprContext lock = ctx.call_params().exprs().expr(0);
        final Expression lockAddress = (Expression) lock.accept(visitor);
        final Expression value = (Expression) ctx.call_params().exprs().expr(1).accept(visitor);
        if (lockAddress != null) {
            visitor.addEvent(EventFactory.Pthread.newInitLock(lock.getText(), lockAddress, value));
        }
    }

    private static void mutexLock(VisitorBoogie visitor, Call_cmdContext ctx) {
        final ExprsContext lock = ctx.call_params().exprs();
        final Expression lockAddress = (Expression) lock.accept(visitor);
        if (lockAddress != null) {
            visitor.addEvent(EventFactory.Pthread.newLock(lock.getText(), lockAddress));
        }
    }

    private static void mutexUnlock(VisitorBoogie visitor, Call_cmdContext ctx) {
        final ExprsContext lock = ctx.call_params().exprs();
        final Expression lockAddress = (Expression) lock.accept(visitor);
        if (lockAddress != null) {
            visitor.addEvent(EventFactory.Pthread.newUnlock(lock.getText(), lockAddress));
        }
    }
}