package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.List;

/*
    This pass runs late in the processing chain, in particular after regular inlining, unrolling, SCCP, and thread creation.
    Thus, the following conditions should be met:
    - The intrinsics are live (reachable) and have constant input if possible.
    - All code duplications ran: The replacement of the intrinsic will not get copied again.
      This allows this pass to set up global state per replaced intrinsic without getting invalidated later.
 */
public class LateIntrinsicsInlining implements ProgramProcessor {

    // TODO: This id should be part of Program
    private int constantId;
    private int assertionId;

    private LateIntrinsicsInlining() {
    }

    public static LateIntrinsicsInlining fromConfig(Configuration ignored) throws InvalidConfigurationException {
        return new LateIntrinsicsInlining();
    }

    @Override
    public void run(Program program) {
        constantId = 0;
        program.getThreads().forEach(this::run);
    }

    private void run(Function function) {
        for (DirectFunctionCall call : function.getEvents(DirectFunctionCall.class)) {
            assert !call.getCallTarget().hasBody();

            final List<Event> replacement = switch (call.getCallTarget().getName()) {
                case "__VERIFIER_nondet_bool",
                        "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                        "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                        "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                        "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar" -> inlineNonDet(call);
                case "__assert_fail", "__assert_rtn" -> inlineAssert(call);
                default -> throw new UnsupportedOperationException(
                        String.format("Undefined function %s", call.getCallTarget().getName()));
            };

            replacement.forEach(e -> e.copyAllMetadataFrom(call));
            call.replaceBy(replacement);
        }
    }

    private List<Event> inlineNonDet(DirectFunctionCall call) {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        assert call instanceof DirectValueFunctionCall;
        Register register = ((DirectValueFunctionCall) call).getResultRegister();
        String name = call.getCallTarget().getName();
        final String separator = "nondet_";
        int index = name.indexOf(separator);
        assert index > -1;
        String suffix = name.substring(index + separator.length());

        // Nondeterministic booleans
        if (suffix.equals("bool")) {
            BooleanType booleanType = types.getBooleanType();
            var nondeterministicExpression = new BNonDet(booleanType);
            Expression cast = expressions.makeCast(nondeterministicExpression, register.getType());
            return List.of(EventFactory.newLocal(register, cast));
        }

        // Nondeterministic integers
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
            default -> throw new UnsupportedOperationException(String.format("%s is not supported", call));
        };
        if (!(register.getType() instanceof IntegerType type)) {
            throw new ParsingException(String.format("Non-integer result register %s.", register));
        }
        var expression = new INonDet(constantId++, type, signed);
        expression.setMin(min);
        expression.setMax(max);
        call.getFunction().getProgram().addConstant(expression);
        return List.of(EventFactory.newLocal(register, expression));
    }

    private List<Event> inlineAssert(DirectFunctionCall call) {
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        final Expression condition = expressions.makeFalse();
        final Register register = call.getFunction().getOrNewRegister("assert_" + assertionId++, condition.getType());
        final Event endOfThread = call.getFunction().getExit();
        assert endOfThread instanceof Label;
        final Event flag = EventFactory.newLocal(register, condition);
        flag.addTags(Tag.ASSERTION);
        final Event jump = EventFactory.newGoto((Label) endOfThread);
        jump.addTags(Tag.EARLYTERMINATION);
        return List.of(flag, jump);
    }
}