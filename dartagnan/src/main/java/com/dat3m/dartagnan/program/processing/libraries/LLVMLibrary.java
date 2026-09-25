package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static com.google.common.base.Preconditions.checkArgument;

@Options
public class LLVMLibrary extends AbstractLibrary<LLVMLibrary> {

    public enum SupportedFunctions {
        LLVM(List.of("llvm.smax", "llvm.umax", "llvm.smin", "llvm.umin", "llvm.fmax", "llvm.fmin","llvm.maxnum.", "llvm.minnum.",
                "llvm.ssub.sat", "llvm.usub.sat", "llvm.sadd.sat", "llvm.uadd.sat", // TODO: saturated shifts
                "llvm.sadd.with.overflow", "llvm.ssub.with.overflow", "llvm.smul.with.overflow",
                "llvm.ctlz", "llvm.cttz", "llvm.ctpop",
                "llvm.fabs"),
                LLVMLibrary::handleLLVMIntrinsic),
        LLVM_ASSUME("llvm.assume", LLVMLibrary::inlineLLVMAssume),
        LLVM_META(List.of("llvm.stacksave", "llvm.stackrestore", "llvm.lifetime"),  AbstractLibrary::inlineAsZero),
        // LLVM_OBJECTSIZE("llvm.objectsize", false, false, true, false, null),
        LLVM_EXPECT("llvm.expect", LLVMLibrary::inlineLLVMExpect),
        // LLVM_MEMCPY("llvm.memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        // LLVM_MEMSET("llvm.memset", true, false, true, false, Intrinsics::inlineMemSet),
        LLVM_THREADLOCAL("llvm.threadlocal.address.p0", LLVMLibrary::inlineLLVMThreadLocal),
        ;

        private final List<String> variants;
        private final Handler<LLVMLibrary> handler;

        SupportedFunctions(List<String> variants, CallResolver<LLVMLibrary> handler) {
            this.variants = variants;
            this.handler = handler;
        }

        SupportedFunctions(String name, CallResolver<LLVMLibrary> handler) {
            this(List.of(name), handler);
        }

        private boolean matches(String funcName) {
            return variants.stream().anyMatch(funcName::startsWith);
        }
    }


    public LLVMLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
    }

    @Override
    protected LLVMLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<Handler<LLVMLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }


    // ========================================================================================

    private List<Event> handleLLVMIntrinsic(FunctionCall call) {
        assert call instanceof ValueFunctionCall && call.isDirectCall();
        final ValueFunctionCall valueCall = (ValueFunctionCall) call;
        final String name = call.getCalledFunction().getName();

        if (name.startsWith("llvm.ctlz")) {
            return inlineLLVMCtlz(valueCall);
        } else if (name.startsWith("llvm.cttz")) {
            return inlineLLVMCttz(valueCall);
        } else if (name.startsWith("llvm.ctpop")) {
            return inlineLLVMCtpop(valueCall);
        } else if (name.contains("add.sat")) {
            return inlineLLVMSaturatedAdd(valueCall);
        } else if (name.contains("sadd.with.overflow")) {
            return inlineLLVMSAddWithOverflow(valueCall);
        } else if (name.contains("ssub.with.overflow")) {
            return inlineLLVMSSubWithOverflow(valueCall);
        } else if (name.contains("smul.with.overflow")) {
            return inlineLLVMSMulWithOverflow(valueCall);
        } else if (name.contains("sub.sat")) {
            return inlineLLVMSaturatedSub(valueCall);
        } else if (name.startsWith("llvm.smax") || name.startsWith("llvm.smin")
                || name.startsWith("llvm.umax") || name.startsWith("llvm.umin")
                || name.startsWith("llvm.fmax") || name.startsWith("llvm.fmin")
                || name.startsWith("llvm.maxnum") || name.startsWith("llvm.minnum")) {
            return inlineLLVMMinMax(valueCall);
        } else if (name.contains("llvm.fabs")) {
            return inlineLLVMFAbs(valueCall);
        } else {
            final String error = String.format(
                    "Call %s to LLVM intrinsic %s cannot be handled.", call, call.getCalledFunction());
            throw new UnsupportedOperationException(error);
        }
    }

    private List<Event> inlineLLVMCtlz(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-ctlz-intrinsic
        checkArgument(call.getArguments().size() == 2,
                "Expected 2 parameters for \"llvm.ctlz\", got %s.", call.getArguments().size());
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final Type type = resultReg.getType();
        checkArgument(resultReg.getType() instanceof IntegerType,
                "Non-integer %s type for \"llvm.ctlz\".", type);
        checkArgument(input.getType().equals(type),
                "Return type %s of \"llvm.ctlz\" must match argument type %s.", type, input.getType());
        final Expression resultExpression = expressions.makeCTLZ(input);
        final Event assignment = EventFactory.newLocal(resultReg, resultExpression);
        return List.of(assignment);
    }

    private List<Event> inlineLLVMCttz(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-cttz-intrinsic
        checkArgument(call.getArguments().size() == 2,
                "Expected 2 parameters for \"llvm.cttz\", got %s.", call.getArguments().size());
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final Type type = resultReg.getType();
        checkArgument(resultReg.getType() instanceof IntegerType,
                "Non-integer %s type for \"llvm.cttz\".", type);
        checkArgument(input.getType().equals(type),
                "Return type %s of \"llvm.cttz\" must match argument type %s.", type, input.getType());
        final Expression resultExpression = expressions.makeCTTZ(input);
        final Event assignment = EventFactory.newLocal(resultReg, resultExpression);
        return List.of(assignment);
    }

    private List<Event> inlineLLVMCtpop(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-ctpop-intrinsic
        final Expression input = call.getArguments().get(0);
        // TODO: Handle the second parameter as well
        final Register resultReg = call.getResultRegister();
        final IntegerType type = (IntegerType) resultReg.getType();
        final Expression increment = expressions.makeAdd(resultReg, expressions.makeOne(type));

        final List<Event> replacement = new ArrayList<>();
        replacement.add(EventFactory.newLocal(resultReg, expressions.makeZero(type)));
        //TODO: There might be more efficient ways to count bits set, though it is not clear
        // if they are also more friendly for the SMT backend.
        for (int i = type.getBitWidth() - 1; i >= 0; i--) {
            final Expression testMask = expressions.makeValue(BigInteger.ONE.shiftLeft(i), type);
            //TODO: dedicated test-bit expressions might yield better results, and they are supported by the SMT backend
            // in the form of extract operations.
            final Expression testBit = expressions.makeEQ(expressions.makeIntAnd(input, testMask), testMask);

            replacement.add(
                    EventFactory.newLocal(resultReg, expressions.makeITE(testBit, increment, resultReg))
            );
        }

        return replacement;
    }

    private List<Event> inlineLLVMMinMax(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
        final List<Expression> arguments = call.getArguments();
        final Expression left = arguments.get(0);
        final Expression right = arguments.get(1);
        final String name = call.getCalledFunction().getName();
        final boolean signed = name.startsWith("llvm.smax.") || name.startsWith("llvm.smin.");
        final boolean isMax = name.startsWith("llvm.smax.") || name.startsWith("llvm.umax.") || name.startsWith("llvm.fmax.") || name.startsWith("llvm.maxnum.");
        final boolean isFloat = name.startsWith("llvm.fmax.") || name.startsWith("llvm.fmin.") || name.startsWith("llvm.maxnum.") || name.startsWith("llvm.minnum.");
        if (isFloat) {
            final Expression result = isMax ? expressions.makeFMax(left, right) : expressions.makeFMin(left, right);
            return List.of(EventFactory.newLocal(call.getResultRegister(), result));
        }
        final Expression isLess = expressions.makeLT(left, right, signed);
        final Expression result = expressions.makeITE(isLess, isMax ? right : left, isMax ? left : right);
        return List.of(EventFactory.newLocal(call.getResultRegister(), result));
    }

    private List<Event> inlineLLVMFAbs(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
        final List<Expression> arguments = call.getArguments();
        final Expression operand = arguments.get(0);

        return List.of(EventFactory.newLocal(call.getResultRegister(), expressions.makeFAbs(operand)));
    }

    private List<Event> inlineLLVMSaturatedSub(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#saturation-arithmetic-intrinsics
        /*
            signedSatSub(x, y):
                ret = (x < 0) ? MIN : MAX;
                if ((x < 0) == (y < (x-ret))
                    ret = x - y;
                return ret;

            unsignedSatSub(x, y)
                return x > y ? x - y : 0;
         */
        final Register resultReg = call.getResultRegister();
        final List<Expression> arguments = call.getArguments();
        final Expression x = arguments.get(0);
        final Expression y = arguments.get(1);
        final String name = call.getCalledFunction().getName();
        final boolean isSigned = name.startsWith("llvm.s");
        final IntegerType type = (IntegerType) x.getType();

        assert x.getType() == y.getType();

        if (isSigned) {
            final Expression min = expressions.makeValue(type.getMinimumValue(true), type);
            final Expression max = expressions.makeValue(type.getMaximumValue(true), type);

            final Expression leftIsNegative = expressions.makeLT(x, expressions.makeZero(type), true);
            final Expression noOverflow = expressions.makeEQ(
                    leftIsNegative,
                    expressions.makeLT(y, expressions.makeSub(x, resultReg), true)
            );

            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeITE(leftIsNegative, min, max)),
                    EventFactory.newLocal(resultReg, expressions.makeITE(noOverflow, expressions.makeSub(x, y), resultReg))
            );
        } else {
            final Expression noUnderflow = expressions.makeGT(x, y, false);
            final Expression zero = expressions.makeZero(type);
            return List.of(
                    EventFactory.newLocal(resultReg, expressions.makeITE(noUnderflow, expressions.makeSub(x, y), zero))
            );
        }
    }

    private List<Event> inlineLLVMSaturatedAdd(ValueFunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#saturation-arithmetic-intrinsics
        /*
            (un)signedSatAdd(x, y):
                ret = (x < 0) ? MIN : MAX; // MIN/MAX depends on signedness
                if ((x < 0) == (y > (ret-x))
                    ret = x + y;
                return ret;
         */
        final Register resultReg = call.getResultRegister();
        final List<Expression> arguments = call.getArguments();
        final Expression x = arguments.get(0);
        final Expression y = arguments.get(1);
        final String name = call.getCalledFunction().getName();
        final boolean isSigned = name.startsWith("llvm.s");
        final IntegerType type = (IntegerType) x.getType();

        assert x.getType() == y.getType();

        final Expression min = expressions.makeValue(type.getMinimumValue(isSigned), type);
        final Expression max = expressions.makeValue(type.getMaximumValue(isSigned), type);

        final Expression leftIsNegative = isSigned ?
                expressions.makeLT(x, expressions.makeZero(type), true) :
                expressions.makeFalse();
        final Expression noOverflow = expressions.makeEQ(
                leftIsNegative,
                expressions.makeGT(y, expressions.makeSub(resultReg, x), isSigned)
        );

        return List.of(
                EventFactory.newLocal(resultReg, expressions.makeITE(leftIsNegative, min, max)),
                EventFactory.newLocal(resultReg, expressions.makeITE(noOverflow, expressions.makeAdd(x, y), resultReg))
        );
    }

    private List<Event> inlineLLVMSAddWithOverflow(ValueFunctionCall call) {
        return inlineLLVMSOpWithOverflow(call, IntBinaryOp.ADD);
    }

    private List<Event> inlineLLVMSSubWithOverflow(ValueFunctionCall call) {
        return inlineLLVMSOpWithOverflow(call, IntBinaryOp.SUB);
    }

    private List<Event> inlineLLVMSMulWithOverflow(ValueFunctionCall call) {
        return inlineLLVMSOpWithOverflow(call, IntBinaryOp.MUL);
    }

    private List<Event> inlineLLVMSOpWithOverflow(ValueFunctionCall call, IntBinaryOp op) {
        final Register resultReg = call.getResultRegister();
        final List<Expression> arguments = call.getArguments();
        final Expression x = arguments.get(0);
        final Expression y = arguments.get(1);
        assert x.getType() == y.getType();

        // The flag expression defined below has the form A & B.
        // A is only relevant for integer encoding, B is only relevant for BV encoding.
        // Here we do not yet know yet which encoding will be used and thus use both A & B.
        // This probably has no noticeable impact on performance.

        // Check for integer encoding
        final IntegerType iType = (IntegerType) x.getType();
        final Expression result = expressions.makeIntBinary(x, op, y);
        final Expression rangeCheck = checkIfValueInRangeOfType(result, iType, true);

        // Check for BV encoding. From LLVM's language manual:
        // "An operation overflows if, for any values of its operands A and B and for any N larger than
        // the operands’ width, ext(A op B) to iN is not equal to (ext(A) to iN) op (ext(B) to iN) where
        // ext is sext for signed overflow and zext for unsigned overflow, and op is the
        // underlying arithmetic operation.""
        final int width = iType.getBitWidth();
        final Expression xExt = expressions.makeCast(x, types.getIntegerType(width + 1), true);
        final Expression yExt = expressions.makeCast(y, types.getIntegerType(width + 1), true);
        final Expression resultExt = expressions.makeCast(result, types.getIntegerType(width + 1), true);
        final Expression bvCheck = expressions.makeEQ(expressions.makeIntBinary(xExt, op, yExt), resultExt);
        final Expression flag = expressions.makeCast(
                expressions.makeNot(expressions.makeAnd(bvCheck, rangeCheck)),
                types.getIntegerType(1)
        );
        final Type type = types.getAggregateType(List.of(result.getType(), flag.getType()));
        return List.of(
                EventFactory.newLocal(resultReg, expressions.makeConstruct(type, List.of(result, flag)))
        );
    }

    private Expression checkIfValueInRangeOfType(Expression value, IntegerType integerType, boolean signed) {
        final Expression minValue = expressions.makeValue(integerType.getMinimumValue(signed), integerType);
        final Expression maxValue = expressions.makeValue(integerType.getMaximumValue(signed), integerType);
        return expressions.makeAnd(
                expressions.makeLTE(minValue, value, true),
                expressions.makeLTE(value, maxValue, true)
        );
    }

    private List<Event> inlineLLVMAssume(FunctionCall call) {
        //see https://llvm.org/docs/LangRef.html#llvm-assume-intrinsic
        return List.of(EventFactory.newAssume(expressions.makeBooleanCast(call.getArguments().get(0))));
    }

    private List<Event> inlineLLVMExpect(FunctionCall call) {
        assert call instanceof ValueFunctionCall;
        final Register retReg = ((ValueFunctionCall) call).getResultRegister();
        final Expression value = call.getArguments().get(0);
        return List.of(EventFactory.newLocal(retReg, value));
    }

    private List<Event> inlineLLVMThreadLocal(FunctionCall call) {
        final Register resultReg = getResultRegisterAndCheckArguments(1, call);
        final Expression exp = call.getArguments().get(0);
        checkArgument(exp instanceof MemoryObject object && object.isThreadLocal(), "Calling thread-local intrinsic on a non-thread-local object \"%s\"", call);
        return List.of(
                EventFactory.newLocal(resultReg, exp)
        );
    }

    // ====================================================================
    
}
