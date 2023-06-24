package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventFactory.Llvm;
import com.dat3m.dartagnan.program.event.Tag.C11;

import java.util.Arrays;
import java.util.List;

public class LlvmProcedures {

    public static List<String> LLVMPROCEDURES = Arrays.asList(
            // Atomic operations
            "__llvm_atomic32_load",
            "__llvm_atomic64_load",
            "__llvm_atomic32_store",
            "__llvm_atomic64_store",
            "__llvm_atomic32_cmpxchg",
            "__llvm_atomic64_cmpxchg",
            "__llvm_atomic32_rmw",
            "__llvm_atomic64_rmw",
            "__llvm_atomic_fence",
            // Intrinsics
            "llvm.smax.i32",
            "llvm.smax.i64",
            "llvm.umax.i32",
            "llvm.umax.i64",
            "llvm.smin.i32",
            "llvm.smin.i64",
            "llvm.umin.i32",
            "llvm.umin.i64",
            "llvm.ctlz.i32",
            "llvm.ctlz.i64");

    public static void handleLlvmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
        String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
        List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();

        String regName = visitor.getScopedName(ctx.call_params().Ident(0).getText());
        Register reg = visitor.programBuilder.getOrNewRegister(visitor.threadCount, regName);

        Expression p0 = (Expression) params.get(0).accept(visitor);
        Expression p1 = params.size() > 1 ? (Expression) params.get(1).accept(visitor) : null;
        Expression p2 = params.size() > 2 ? (Expression) params.get(2).accept(visitor) : null;
        Expression p3 = params.size() > 3 ? (Expression) params.get(3).accept(visitor) : null;

        String mo;

        // For intrinsics
        Expression cond;

        switch (name) {
            case "__llvm_atomic32_load", "__llvm_atomic64_load" -> {
                mo = C11.intToMo(((IConst) p1).getValueAsInt());
                visitor.addEvent(Llvm.newLoad(reg, p0, mo));
            }
            case "__llvm_atomic32_store", "__llvm_atomic64_store" -> {
                mo = C11.intToMo(((IConst) p2).getValueAsInt());
                visitor.addEvent(Llvm.newStore(p0, p1, mo));
            }
            case "__llvm_atomic_fence" -> {
                mo = C11.intToMo(((IConst) p0).getValueAsInt());
                visitor.addEvent(Llvm.newFence(mo));
            }
            case "__llvm_atomic32_cmpxchg", "__llvm_atomic64_cmpxchg" -> {
                // Since we don't support struct types, we instead model each member as a
                // register.
                // It is the responsibility of each LLVM instruction creating a structure to
                // create such registers,
                // then when calling "extractvalue" we can check if the member was properly
                // initialized
                Register oldValueRegister = visitor.programBuilder.getOrNewRegister(visitor.threadCount, regName + "(0)");
                Register cmpRegister = visitor.programBuilder.getOrNewRegister(visitor.threadCount, regName + "(1)");
                // The compilation of Llvm.newCompareExchange will
                // assign the correct values to the registers above
                mo = C11.intToMo(((IConst) p3).getValueAsInt());
                visitor.addEvent(Llvm.newCompareExchange(oldValueRegister, cmpRegister, p0, p1, p2, mo, true));
            }
            case "__llvm_atomic32_rmw", "__llvm_atomic64_rmw" -> {
                mo = C11.intToMo(((IConst) p2).getValueAsInt());
                IOpBin op;
                switch (((IConst) p3).getValueAsInt()) {
                    case 0 -> {
                        visitor.addEvent(Llvm.newExchange(reg, p0, p1, mo));
                        return;
                    }
                    case 1 -> op = IOpBin.PLUS;
                    case 2 -> op = IOpBin.MINUS;
                    case 3 -> op = IOpBin.AND;
                    case 4 -> op = IOpBin.OR;
                    case 5 -> op = IOpBin.XOR;
                    default ->
                            throw new UnsupportedOperationException("Operation " + params.get(3).getText() + " is not recognized.");
                }
                visitor.addEvent(Llvm.newRMW(reg, p0, p1, op, mo));
            }
            case "llvm.smax.i32", "llvm.smax.i64", "llvm.umax.i32", "llvm.umax.i64" -> {
                cond = visitor.expressions.makeGT(p0, p1, name.contains("smax"));
                visitor.addEvent(EventFactory.newLocal(reg, visitor.expressions.makeConditional(cond, p0, p1)));
            }
            case "llvm.smin.i32", "llvm.smin.i64", "llvm.umin.i32", "llvm.umin.i64" -> {
                cond = visitor.expressions.makeLT(p0, p1, name.contains("smin"));
                visitor.addEvent(EventFactory.newLocal(reg, visitor.expressions.makeConditional(cond, p0, p1)));
            }
            case "llvm.ctlz.i32", "llvm.ctlz.i64" -> {
                visitor.addEvent(EventFactory.newLocal(reg, visitor.expressions.makeCTLZ(p0, (IntegerType) p0.getType())));
            }
            default -> throw new UnsupportedOperationException(name + " procedure is not part of LLVMPROCEDURES");
        }
    }
}
