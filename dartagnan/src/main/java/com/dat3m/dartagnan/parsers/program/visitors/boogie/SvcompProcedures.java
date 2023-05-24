package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.Literal;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class SvcompProcedures {

    public static List<String> SVCOMPPROCEDURES = Arrays.asList(
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
        String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
        switch (name) {
            case "__VERIFIER_loop_bound" -> __VERIFIER_loop_bound(visitor, ctx);
            case "__VERIFIER_loop_begin" -> visitor.thread.append(EventFactory.Svcomp.newLoopBegin());
            case "__VERIFIER_spin_start" -> visitor.thread.append(EventFactory.Svcomp.newSpinStart());
            case "__VERIFIER_spin_end" -> visitor.thread.append(EventFactory.Svcomp.newSpinEnd());
            case "__VERIFIER_assert" -> visitor.addAssertion((Expression) ctx.call_params().exprs().accept(visitor));
            case "__VERIFIER_assume" -> __VERIFIER_assume(visitor, ctx);
            case "__VERIFIER_atomic_begin" -> __VERIFIER_atomic_begin(visitor);
            case "__VERIFIER_atomic_end" -> __VERIFIER_atomic_end(visitor);
            case "__VERIFIER_nondet_bool" -> __VERIFIER_nondet_bool(visitor, ctx);
            case "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int", "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short", "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong", "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar" ->
                    __VERIFIER_nondet(visitor, ctx, name);
            default -> throw new UnsupportedOperationException(name + " procedure is not part of SVCOMPPROCEDURES");
        }
    }

    private static void __VERIFIER_assume(VisitorBoogie visitor, Call_cmdContext ctx) {
        Expression expr = (Expression) ctx.call_params().exprs().accept(visitor);
        visitor.thread.append(EventFactory.newAssume(expr));
    }

    public static void __VERIFIER_atomic_begin(VisitorBoogie visitor) {
        visitor.currentBeginAtomic = EventFactory.Svcomp.newBeginAtomic();
        visitor.thread.append(visitor.currentBeginAtomic);
    }

    public static void __VERIFIER_atomic_end(VisitorBoogie visitor) {
        if (visitor.currentBeginAtomic == null) {
            throw new MalformedProgramException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
        }
        visitor.thread.append(EventFactory.Svcomp.newEndAtomic(visitor.currentBeginAtomic));
        visitor.currentBeginAtomic = null;
    }

    private static void __VERIFIER_nondet(VisitorBoogie visitor, Call_cmdContext ctx, String name) {
        boolean signed;
        BigInteger min;
        BigInteger max;
        switch (name) {
            case "__VERIFIER_nondet_int" -> {
                signed = true;
                min = BigInteger.valueOf(Integer.MIN_VALUE);
                max = BigInteger.valueOf(Integer.MAX_VALUE);
            }
            case "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int" -> {
                signed = false;
                min = BigInteger.ZERO;
                max = UnsignedInteger.MAX_VALUE.bigIntegerValue();
            }
            case "__VERIFIER_nondet_short" -> {
                signed = true;
                min = BigInteger.valueOf(Short.MIN_VALUE);
                max = BigInteger.valueOf(Short.MAX_VALUE);
            }
            case "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short" -> {
                signed = false;
                min = BigInteger.ZERO;
                max = BigInteger.valueOf(65535);
            }
            case "__VERIFIER_nondet_long" -> {
                signed = true;
                min = BigInteger.valueOf(Long.MIN_VALUE);
                max = BigInteger.valueOf(Long.MAX_VALUE);
            }
            case "__VERIFIER_nondet_ulong" -> {
                signed = false;
                min = BigInteger.ZERO;
                max = UnsignedLong.MAX_VALUE.bigIntegerValue();
            }
            case "__VERIFIER_nondet_char" -> {
                signed = true;
                min = BigInteger.valueOf(-128);
                max = BigInteger.valueOf(127);
            }
            case "__VERIFIER_nondet_uchar" -> {
                signed = false;
                min = BigInteger.ZERO;
                max = BigInteger.valueOf(255);
            }
            default -> throw new ParsingException(name + " is not supported");
        }
        String registerName = ctx.call_params().Ident(0).getText();
        Optional<Register> register = visitor.thread.getRegister(visitor.currentScope.getID() + ":" + registerName);
        if (register.isEmpty()) {
            return;
        }
        visitor.append(EventFactory.newLocal(register.get(),
                visitor.program.newConstant(
                        register.get().getType(),
                        signed,
                        min,
                        max)));
    }

    private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
        String registerName = ctx.call_params().Ident(0).getText();
        Optional<Register> register = visitor.thread.getRegister(visitor.currentScope.getID() + ":" + registerName);
        Expression expression = visitor.program.newConstant(visitor.types.getIntegerType(1), false, BigInteger.ZERO, BigInteger.ONE);
        register.ifPresent(value -> visitor.append(EventFactory.newLocal(value, expression)));

    }

    private static void __VERIFIER_loop_bound(VisitorBoogie visitor, Call_cmdContext ctx) {
        Object boundObject = ctx.call_params().exprs().expr(0).accept(visitor);
        if (!(boundObject instanceof Literal)) {
            throw new ParsingException("Expected constant bound in " + ctx.getText() + ".");
        }
        int bound = ((Literal) boundObject).getValueAsInt();
        visitor.append(EventFactory.Svcomp.newLoopBound(bound));

    }
}
