package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.functions.DirectFunctionCall;
import com.dat3m.dartagnan.program.event.functions.DirectValueFunctionCall;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.math.BigInteger;
import java.util.List;

public class IntrinsicsInlining implements ProgramProcessor {

    private int constantId;

    private IntrinsicsInlining() {
    }

    public static IntrinsicsInlining fromConfig(Configuration ignored) throws InvalidConfigurationException {
        return new IntrinsicsInlining();
    }

    @Override
    public void run(Program program) {
        constantId = 0;
        for (Thread thread : program.getThreads()) {
            run(thread);
        }
    }

    private void run(Thread thread) {
        for (Event event : List.copyOf(thread.getEvents())) {
            if (!(event instanceof DirectFunctionCall call)) {
                continue;
            }
            assert !call.getCallTarget().hasBody();

            List<Event> replacement = switch (call.getCallTarget().getName()) {
                case "__VERIFIER_nondet_bool",
                        "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                        "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                        "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                        "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar" -> inlineNonDet(call);
                default -> throw new UnsupportedOperationException(
                        String.format("Undefined function %s", call.getCallTarget().getName()));
            };

            call.insertAfter(replacement);
            call.forceDelete();
        }
    }

    private List<Event> inlineNonDet(DirectFunctionCall call) {
        TypeFactory types = TypeFactory.getInstance();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        assert call instanceof DirectValueFunctionCall;
        Register register = ((DirectValueFunctionCall) call).getResultRegister();
        String name = call.getCallTarget().getName();
        String prefix = name.startsWith("__V") ? "__VERIFIER_nondet_" : "__SMACK_nondet_";
        assert name.startsWith(prefix);
        String suffix = call.getCallTarget().getName().substring(prefix.length());

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
        call.getFunction().getProgram().addConstant(expression);
        expression.setMin(min);
        expression.setMax(max);
        return List.of(EventFactory.newLocal(register, expression));
    }
}
