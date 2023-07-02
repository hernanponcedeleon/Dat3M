package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public class StdProcedures {

    public static List<String> STDPROCEDURES = Arrays.asList(
            "abort",
            "get_my_tid",
            "devirtbounce",
            "external_alloc",
            "$alloc",
            "__assert_rtn", // generated on MacOS
            "assert_.i32",
            "__assert_fail",
            "$malloc",
            "calloc",
            "malloc",
            "fopen",
            "free",
            "memcpy",
            "$memcpy",
            "memset",
            "$memset",
            "nvram_read_byte",
            "strcpy",
            "strcmp",
            "strncpy",
            "llvm.stackrestore",
            "llvm.stacksave",
            "llvm.lifetime.start",
            "llvm.lifetime.end");

    public static void handleStdFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        if (funcName.equals("$alloc") || funcName.equals("$malloc") || funcName.equals("calloc")
                || funcName.equals("malloc") || funcName.equals("external_alloc")) {
            alloc(visitor, ctx);
            return;
        }
        if (funcName.equals("abort")) {
            if (visitor.inlineMode) {
                visitor.addEvent(EventFactory.newGoto(visitor.getEndOfThreadLabel()));
            } else {
                visitor.addEvent(EventFactory.newAbortIf(visitor.expressions.makeTrue()));
            }
            return;
        }
        if (funcName.equals("get_my_tid")) {
            // FIXME: In noinline mode, we cannot resolve the tId yet.
            final String registerName = ctx.call_params().Ident(0).getText();
            final Register register = visitor.getScopedRegister(registerName);
            final IValue tid = visitor.expressions.makeValue(BigInteger.valueOf(visitor.currentThread), register.getType());
            visitor.addEvent(EventFactory.newLocal(register, tid));
            return;
        }
        if (funcName.equals("__assert_fail") || funcName.equals("__assert_rtn")) {
            __assert_fail(visitor);
            return;
        }
        if (funcName.equals("assert_.i32")) {
            __assert(visitor, ctx);
            return;
        }
        if (funcName.startsWith("fopen")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("free")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("memcpy") | funcName.startsWith("$memcpy")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("memset") || funcName.startsWith("$memset")) {
            throw new ParsingException(funcName + " cannot be handled");
        }
        if (funcName.startsWith("nvram_read_byte")) {
            throw new ParsingException(funcName + " cannot be handled");
        }
        if (funcName.startsWith("strcpy")) {
            throw new ParsingException(funcName + " cannot be handled");
        }
        if (funcName.startsWith("strcmp")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("strncpy")) {
            throw new ParsingException(funcName + " cannot be handled");
        }
        if (funcName.startsWith("llvm.stackrestore")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("llvm.stacksave")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("llvm.lifetime.start")) {
            // TODO: Implement this
            return;
        }
        if (funcName.startsWith("llvm.lifetime.end")) {
            // TODO: Implement this
            return;
        }
        throw new UnsupportedOperationException(funcName + " procedure is not part of STDPROCEDURES");
    }

    private static void alloc(VisitorBoogie visitor, Call_cmdContext ctx) {
        //Uniquely identify the allocated storage in the entire program
        final Expression sizeExpr = (Expression) ctx.call_params().exprs().expr(0).accept(visitor);
        final String ptrName = ctx.call_params().Ident(0).getText();
        final Register reg = visitor.getScopedRegister(ptrName);

        visitor.addEvent(EventFactory.Std.newMalloc(reg, sizeExpr));
    }

    private static void __assert(VisitorBoogie visitor, Call_cmdContext ctx) {
        final Expression expr = (Expression) ctx.call_params().exprs().accept(visitor);
        visitor.addAssertion(expr);
    }

    private static void __assert_fail(VisitorBoogie visitor) {
        visitor.addAssertion(visitor.expressions.makeZero(visitor.types.getArchType()));
    }

}
