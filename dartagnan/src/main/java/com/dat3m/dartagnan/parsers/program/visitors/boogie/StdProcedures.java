package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;

public class StdProcedures {

    public static boolean handleStdFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        if (funcName.equals("$alloc") || funcName.equals("$malloc") || funcName.equals("calloc")
                || funcName.equals("malloc") || funcName.equals("external_alloc")) {
            alloc(visitor, ctx);
            return true;
        }
        if (funcName.equals("abort")) {
            visitor.addEvent(EventFactory.newAbortIf(visitor.expressions.makeTrue()));
            return true;
        }
        if (funcName.equals("__assert_fail") || funcName.equals("__assert_rtn")) {
            __assert_fail(visitor);
            return true;
        }
        if (funcName.equals("assert_.i32")) {
            __assert(visitor, ctx);
            return true;
        }
        if (funcName.startsWith("fopen")) {
            // TODO: Implement this
            return true;
        }
        if (funcName.startsWith("free")) {
            // TODO: Implement this
            return true;
        }
        if (funcName.startsWith("memcpy") | funcName.startsWith("$memcpy")) {
            // TODO: Implement this
            return true;
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
            return true;
        }
        if (funcName.startsWith("strncpy")) {
            throw new ParsingException(funcName + " cannot be handled");
        }
        if (funcName.startsWith("llvm.stackrestore")) {
            // TODO: Implement this
            return true;
        }
        if (funcName.startsWith("llvm.stacksave")) {
            // TODO: Implement this
            return true;
        }
        if (funcName.startsWith("llvm.lifetime.start")) {
            // TODO: Implement this
            return true;
        }
        if (funcName.startsWith("llvm.lifetime.end")) {
            // TODO: Implement this
            return true;
        }
        return false;
    }

    private static void alloc(VisitorBoogie visitor, Call_cmdContext ctx) {
        //Uniquely identify the allocated storage in the entire program
        final Expression sizeExpr = (Expression) ctx.call_params().exprs().expr(0).accept(visitor);
        final String ptrName = ctx.call_params().Ident(0).getText();
        final Register reg = visitor.getRegister(ptrName);
        final Type byteType = TypeFactory.getInstance().getByteType();

        visitor.addEvent(EventFactory.newAlloc(reg, byteType, sizeExpr, true));
    }

    private static void __assert(VisitorBoogie visitor, Call_cmdContext ctx) {
        final Expression expr = (Expression) ctx.call_params().exprs().accept(visitor);
        visitor.addAssertion(expr);
    }

    private static void __assert_fail(VisitorBoogie visitor) {
        visitor.addAssertion(visitor.expressions.makeFalse());
    }

}
