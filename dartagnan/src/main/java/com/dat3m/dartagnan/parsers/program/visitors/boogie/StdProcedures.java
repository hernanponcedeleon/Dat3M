package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.expression.Literal;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.expression.Expression;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public class StdProcedures {

    public static List<String> STDPROCEDURES = Arrays.asList(
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
        String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
        if (name.equals("$alloc") || name.equals("$malloc") || name.equals("calloc") || name.equals("malloc") || name.equals("external_alloc")) {
            alloc(visitor, ctx);
            return;
        }
        if (name.equals("get_my_tid")) {
            String registerName = ctx.call_params().Ident(0).getText();
            Register register = visitor.thread.getRegister(visitor.currentScope.getID() + ":" + registerName).orElseThrow();
            Literal tid = visitor.expressions.makeValue(BigInteger.valueOf(visitor.threadCount), visitor.types.getIntegerType());
            visitor.thread.append(EventFactory.newLocal(register, tid));
            return;
        }
        if (name.equals("__assert_fail") || name.equals("__assert_rtn")) {
            __assert_fail(visitor);
            return;
        }
        if (name.equals("assert_.i32")) {
            __assert(visitor, ctx);
            return;
        }
        if (name.startsWith("fopen")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("free")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("memcpy") | name.startsWith("$memcpy")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("memset") || name.startsWith("$memset")) {
            throw new ParsingException(name + " cannot be handled");
        }
        if (name.startsWith("nvram_read_byte")) {
            throw new ParsingException(name + " cannot be handled");
        }
        if (name.startsWith("strcpy")) {
            throw new ParsingException(name + " cannot be handled");
        }
        if (name.startsWith("strcmp")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("strncpy")) {
            throw new ParsingException(name + " cannot be handled");
        }
        if (name.startsWith("llvm.stackrestore")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("llvm.stacksave")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("llvm.lifetime.start")) {
            // TODO: Implement this
            return;
        }
        if (name.startsWith("llvm.lifetime.end")) {
            // TODO: Implement this
            return;
        }
        throw new UnsupportedOperationException(name + " procedure is not part of STDPROCEDURES");
    }

    private static void alloc(VisitorBoogie visitor, Call_cmdContext ctx) {
        //Uniquely identify the allocated storage in the entire program
        final Expression sizeExpr = ((Expression) ctx.call_params().exprs().expr(0).accept(visitor));
        final String ptrName = visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText();
        //FIXME Perhaps this should require existence
        final Register reg = visitor.thread.getRegister(ptrName).orElse(null);

        visitor.thread.append(EventFactory.Std.newMalloc(reg, sizeExpr));
    }

    private static void __assert(VisitorBoogie visitor, Call_cmdContext ctx) {
        Expression expr = (Expression) ctx.call_params().exprs().accept(visitor);
        visitor.addAssertion(expr);
    }

    private static void __assert_fail(VisitorBoogie visitor) {
        visitor.addAssertion(visitor.expressions.makeZero(visitor.types.getIntegerType()));
    }

}
