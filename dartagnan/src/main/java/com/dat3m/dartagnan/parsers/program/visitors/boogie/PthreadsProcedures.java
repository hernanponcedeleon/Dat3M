package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprsContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class PthreadsProcedures {

    public static List<String> PTHREADPROCEDURES = Arrays.asList(
            "pthread_create",
            "pthread_cond_init",
            "pthread_cond_wait",
            "pthread_cond_signal",
            "pthread_cond_broadcast",
            "pthread_exit",
            "pthread_getspecific",
            "pthread_join",
            "__pthread_join", // generated by Clang on MacOS
            "pthread_key_create",
            "pthread_mutex_init",
            "pthread_mutex_destroy",
            "pthread_mutex_lock",
            "pthread_mutex_unlock",
            "pthread_setspecific"
    );

    public static void handlePthreadsFunctions(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        switch (funcName) {
            case "pthread_create":
                pthread_create(visitor, ctx);
                break;
            case "__pthread_join":
            case "pthread_join":
                // VisitorBoogie already took care of creating the join event
                // when it parsed the previous load.
                break;
            case "pthread_cond_init":
            case "pthread_cond_wait":
            case "pthread_cond_signal":
            case "pthread_cond_broadcast":
            case "pthread_exit":
            case "pthread_mutex_destroy":
                break;
            case "pthread_mutex_init":
                mutexInit(visitor, ctx);
                break;
            case "pthread_mutex_lock":
                mutexLock(visitor, ctx);
                break;
            case "pthread_mutex_unlock":
                mutexUnlock(visitor, ctx);
                break;
            default:
                throw new ParsingException(funcName + " cannot be handled");
        }
    }

    private static void pthread_create(VisitorBoogie visitor, Call_cmdContext ctx) {
        // ----- TODO: Test code -----
        if (!visitor.inlineMode) {
            visitor.addEvent(EventFactory.newFunctionCall("dummy pthread_create()"));
            // TODO: Create a proper function call, not just an annotation
            return;
        }
        // ----- TODO: Test code end -----
        visitor.currentThread++;

        visitor.threadCallingValues.put(visitor.currentThread, new ArrayList<>());
        final Expression callingValue = (Expression) ctx.call_params().exprs().expr().get(3).accept(visitor);
        visitor.threadCallingValues.get(visitor.currentThread).add(callingValue);

        final Expression pointer = (Expression) ctx.call_params().exprs().expr(0).accept(visitor);
        final String threadName = ctx.call_params().exprs().expr().get(2).getText();
        visitor.pool.add(pointer, threadName, visitor.threadCount);

        final Event matcher = EventFactory.newStringAnnotation("// Spawning thread associated to " + pointer);
        visitor.addEvent(matcher);
        visitor.pool.addMatcher(pointer, matcher);

        visitor.allocations.add(pointer);
        visitor.addEvent(EventFactory.Pthread.newCreate(pointer, threadName));

        final String regName = ctx.call_params().Ident(0).getText();
        final Register reg = visitor.getOrNewScopedRegister(regName);
        final Expression zero = visitor.expressions.makeZero(reg.getType());
        visitor.addEvent(EventFactory.newLocal(reg, zero));
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
        final Register register = visitor.getOrNewScopedRegister(null);
        final Expression lockAddress = (Expression) lock.accept(visitor);
        if (lockAddress != null) {
            visitor.addEvent(EventFactory.Pthread.newLock(lock.getText(), lockAddress, register));
        }
    }

    private static void mutexUnlock(VisitorBoogie visitor, Call_cmdContext ctx) {
        final ExprsContext lock = ctx.call_params().exprs();
        final Register register = visitor.getOrNewScopedRegister(null);
        final Expression lockAddress = (Expression) lock.accept(visitor);
        if (lockAddress != null) {
            visitor.addEvent(EventFactory.Pthread.newUnlock(lock.getText(), lockAddress, register));
        }
    }
}