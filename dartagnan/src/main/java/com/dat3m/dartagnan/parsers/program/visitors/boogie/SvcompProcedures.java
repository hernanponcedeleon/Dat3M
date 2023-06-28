package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public class SvcompProcedures {

    public static List<String> SVCOMPPROCEDURES = Arrays.asList(
            "reach_error", // Only used in SVCOMP
            "__VERIFIER_assert",
            // "__VERIFIER_assume",
            "__VERIFIER_loop_bound",
            "__VERIFIER_loop_begin",
            "__VERIFIER_spin_start",
            "__VERIFIER_spin_end",
            "__VERIFIER_atomic_begin",
            "__VERIFIER_atomic_end",
            "__VERIFIER_nondet_bool",
            "__VERIFIER_nondet_int",
            "__VERIFIER_nondet_uint",
            "__VERIFIER_nondet_unsigned_int",
            "__VERIFIER_nondet_short",
            "__VERIFIER_nondet_ushort",
            "__VERIFIER_nondet_unsigned_short",
            "__VERIFIER_nondet_long",
            "__VERIFIER_nondet_ulong",
            "__VERIFIER_nondet_char",
            "__VERIFIER_nondet_uchar");

    public static void handleSvcompFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        switch (funcName) {
            case "reach_error" -> visitor.addAssertion(visitor.expressions.makeZero(visitor.types.getArchType()));
            case "__VERIFIER_loop_bound" -> __VERIFIER_loop_bound(visitor, ctx);
            case "__VERIFIER_loop_begin" -> visitor.addEvent(EventFactory.Svcomp.newLoopBegin());
            case "__VERIFIER_spin_start" -> visitor.addEvent(EventFactory.Svcomp.newSpinStart());
            case "__VERIFIER_spin_end" -> visitor.addEvent(EventFactory.Svcomp.newSpinEnd());
            case "__VERIFIER_assert" -> visitor.addAssertion((IExpr) ctx.call_params().exprs().accept(visitor));
            case "__VERIFIER_assume" -> __VERIFIER_assume(visitor, ctx);
            case "__VERIFIER_atomic_begin" -> __VERIFIER_atomic_begin(visitor);
            case "__VERIFIER_atomic_end" -> __VERIFIER_atomic_end(visitor);
            case "__VERIFIER_nondet_bool" -> __VERIFIER_nondet_bool(visitor, ctx);
            case "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint",
                    "__VERIFIER_nondet_unsigned_int", "__VERIFIER_nondet_short",
                    "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                    "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                    "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar" -> __VERIFIER_nondet(visitor, ctx, funcName);
            default -> throw new UnsupportedOperationException(funcName + " procedure is not part of SVCOMPPROCEDURES");
        }
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

    private static void __VERIFIER_nondet(VisitorBoogie visitor, Call_cmdContext ctx, String name) {
        final String suffix = name.substring("__VERIFIER_nondet_".length());
        boolean signed = switch (suffix) {
            case "int", "short", "long", "char" -> true;
            default -> false;
        };
        final BigInteger min = switch (suffix) {
            case "long" -> BigInteger.valueOf(Long.MIN_VALUE);
            case "int" -> BigInteger.valueOf(Integer.MIN_VALUE);
            case "short" -> BigInteger.valueOf(Short.MIN_VALUE);
            case "char" -> BigInteger.valueOf(Byte.MIN_VALUE);
            default -> BigInteger.ZERO;
        };
        final BigInteger max = switch (suffix) {
            case "int" -> BigInteger.valueOf(Integer.MAX_VALUE);
            case "uint", "unsigned_int" -> UnsignedInteger.MAX_VALUE.bigIntegerValue();
            case "short" -> BigInteger.valueOf(Short.MAX_VALUE);
            case "ushort", "unsigned_short" -> BigInteger.valueOf(65535);
            case "long" -> BigInteger.valueOf(Long.MAX_VALUE);
            case "ulong" -> UnsignedLong.MAX_VALUE.bigIntegerValue();
            case "char" -> BigInteger.valueOf(Byte.MAX_VALUE);
            case "uchar" -> BigInteger.valueOf(255);
            default -> throw new ParsingException(name + " is not supported");
        };
        final String registerName = ctx.call_params().Ident(0).getText();
        final Register register = visitor.getScopedRegister(registerName);
        if (register != null) {
            if (!(register.getType() instanceof IntegerType type)) {
                throw new ParsingException(String.format("Non-integer result register %s.", register));
            }
            final INonDet expression = visitor.programBuilder.newConstant(type, signed);
            expression.setMin(min);
            expression.setMax(max);
            visitor.addEvent(EventFactory.newLocal(register, expression));
        }
    }

    private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
        final String registerName = ctx.call_params().Ident(0).getText();
        final Register register = visitor.getScopedRegister(registerName);
        if (register != null) {
            visitor.addEvent(EventFactory.newLocal(register, new BNonDet(visitor.types.getBooleanType())));
        }
    }

    private static void __VERIFIER_loop_bound(VisitorBoogie visitor, Call_cmdContext ctx) {
        final int bound = ((IExpr) ctx.call_params().exprs().expr(0).accept(visitor)).reduce().getValueAsInt();
        visitor.addEvent(EventFactory.Svcomp.newLoopBound(bound));
    }
}
