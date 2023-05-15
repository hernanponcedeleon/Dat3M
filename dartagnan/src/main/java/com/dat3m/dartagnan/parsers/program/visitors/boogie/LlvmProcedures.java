package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventFactory.Llvm;
import com.dat3m.dartagnan.program.event.Tag.C11;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.Type;

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

        String regName = visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText();
        Register reg = visitor.thread.getOrNewRegister(regName, visitor.types.getNumberType());

        Object p0 = params.get(0).accept(visitor);
        Object p1 = params.size() > 1 ? params.get(1).accept(visitor) : null;
        Object p2 = params.size() > 2 ? params.get(2).accept(visitor) : null;
        Object p3 = params.size() > 3 ? params.get(3).accept(visitor) : null;

        ExpressionFactory factory = visitor.expressions;

        String mo;

        // For intrinsics
        Expression i1;
        Expression i2;
        Expression cond;

        switch (name) {
            case "__llvm_atomic32_load":
            case "__llvm_atomic64_load":
                mo = C11.intToMo(((IConst) p1).getValueAsInt());
                visitor.append(Llvm.newLoad(reg, (Expression) p0, mo));
                return;
            case "__llvm_atomic32_store":
            case "__llvm_atomic64_store":
                mo = C11.intToMo(((IConst) p2).getValueAsInt());
                visitor.append(Llvm.newStore((Expression) p0, (Expression) p1, mo));
                return;
            case "__llvm_atomic_fence":
                mo = C11.intToMo(((IConst) p0).getValueAsInt());
                visitor.append(Llvm.newFence(mo));
                return;
            case "__llvm_atomic32_cmpxchg":
            case "__llvm_atomic64_cmpxchg":
                // Since we don't support struct types, we instead model each member as a
                // register.
                // It is the responsibility of each LLVM istruction creating a structure to
                // create such registers,
                // then when calling "extractvalue" we can check if the member was properly
                // initialized
                Type type = visitor.types.getNumberType();
                Register oldValueRegister = visitor.thread.getOrNewRegister(regName + "(0)", type);
                Register cmpRegister = visitor.thread.getOrNewRegister(regName + "(1)", type);
                // The compilation of Llvm.newCompareExchange will
                // assign the correct values to the registers above
                mo = C11.intToMo(((IConst) p3).getValueAsInt());
                visitor.append(Llvm.newCompareExchange(oldValueRegister, cmpRegister, (Expression) p0, (Expression) p1, (Expression) p2, mo, true));
                return;
            case "__llvm_atomic32_rmw":
            case "__llvm_atomic64_rmw":
                mo = C11.intToMo(((IConst) p2).getValueAsInt());
                IOpBin op;
                switch (((IConst) p3).getValueAsInt()) {
                    case 0:
                        visitor.append(Llvm.newExchange(reg, (Expression) p0, (Expression) p1, mo));
                        return;
                    case 1:
                        op = IOpBin.PLUS;
                        break;
                    case 2:
                        op = IOpBin.MINUS;
                        break;
                    case 3:
                        op = IOpBin.AND;
                        break;
                    case 4:
                        op = IOpBin.OR;
                        break;
                    case 5:
                        op = IOpBin.XOR;
                        break;
                    default:
                        throw new UnsupportedOperationException("Operation " + params.get(3).getText() + " is not recognized.");
                }
                visitor.append(Llvm.newRMW(reg, (Expression) p0, (Expression) p1, op, mo));
                return;
            case "llvm.smax.i32":
            case "llvm.smax.i64":
            case "llvm.umax.i32":
            case "llvm.umax.i64":
                i1 = (Expression) p0;
                i2 = (Expression) p1;
                cond = name.contains("smax") ? factory.makeBinary(i1, COpBin.GTE, i2) : factory.makeBinary(i1, COpBin.UGTE, i2);
                visitor.append(EventFactory.newLocal(reg, factory.makeConditional(cond, i1, i2)));
                return;
            case "llvm.smin.i32":
            case "llvm.smin.i64":
            case "llvm.umin.i32":
            case "llvm.umin.i64":
                i1 = (Expression) p0;
                i2 = (Expression) p1;
                cond = name.contains("smin") ? factory.makeBinary(i1, COpBin.LTE, i2) : factory.makeBinary(i1, COpBin.ULTE, i2);
                visitor.append(EventFactory.newLocal(reg, factory.makeConditional(cond, i1, i2)));
                return;
            case "llvm.ctlz.i32":
            case "llvm.ctlz.i64":
                i1 = (Expression) p0;
                i2 = (Expression) p1;
                visitor.append(EventFactory.newLocal(reg, factory.makeUnary(IOpUn.CTLZ, i1)));
                return;
            default:
                throw new UnsupportedOperationException(name + " procedure is not part of LLVMPROCEDURES");
        }
    }
}
