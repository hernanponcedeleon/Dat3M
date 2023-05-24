package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprsContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.parsers.program.boogie.SmackTypes.refType;

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
            "pthread_setspecific");

    public static void handlePthreadsFunctions(VisitorBoogie visitor, Call_cmdContext ctx) {
        String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
        switch (name) {
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
                throw new ParsingException(name + " cannot be handled");
        }
    }

    private static void pthread_create(VisitorBoogie visitor, Call_cmdContext ctx) {
        visitor.currentThread++;

        visitor.threadCallingValues.put(visitor.currentThread, new ArrayList<>());
        Expression callingValue = (Expression) ctx.call_params().exprs().expr().get(3).accept(visitor);
        visitor.threadCallingValues.get(visitor.currentThread).add(callingValue);

        Expression pointer = (Expression) ctx.call_params().exprs().expr(0).accept(visitor);
        String threadName = ctx.call_params().exprs().expr().get(2).getText();
        visitor.pool.add(pointer, threadName, visitor.thread.getId());

        Event matcher = EventFactory.newStringAnnotation("// Spawning thread associated to " + pointer);
        visitor.thread.append(matcher);
        visitor.pool.addMatcher(pointer, matcher);

        visitor.allocations.add(pointer);
        visitor.append(EventFactory.Pthread.newCreate(pointer, threadName));
        String registerName = visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText();
        Register reg = visitor.thread.getOrNewRegister(registerName, refType);
        visitor.thread.append(EventFactory.newLocal(reg, visitor.expressions.makeZero(refType)));
    }

    private static void mutexInit(VisitorBoogie visitor, Call_cmdContext ctx) {
        ExprContext lock = ctx.call_params().exprs().expr(0);
        Expression lockAddress = (Expression) lock.accept(visitor);
        Expression value = (Expression) ctx.call_params().exprs().expr(1).accept(visitor);
        if (lockAddress != null) {
            visitor.append(EventFactory.Pthread.newInitLock(lock.getText(), lockAddress, value));
        }
    }

    private static void mutexLock(VisitorBoogie visitor, Call_cmdContext ctx) {
        ExprsContext lock = ctx.call_params().exprs();
        Register register = visitor.thread.newRegister(refType);
        Expression lockAddress = (Expression) lock.accept(visitor);
        if (lockAddress != null) {
            visitor.append(EventFactory.Pthread.newLock(lock.getText(), lockAddress, register));
        }
    }

    private static void mutexUnlock(VisitorBoogie visitor, Call_cmdContext ctx) {
        ExprsContext lock = ctx.call_params().exprs();
        Register register = visitor.thread.newRegister(refType);
        Expression lockAddress = (Expression) lock.accept(visitor);
        if (lockAddress != null) {
            visitor.append(EventFactory.Pthread.newUnlock(lock.getText(), lockAddress, register));
        }
    }
}