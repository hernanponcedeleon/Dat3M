package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.program.event.EventFactory.newDealloc;
import static com.google.common.base.Preconditions.checkArgument;

@Options
public class StdLibrary extends AbstractLibrary<StdLibrary> {

    public enum SupportedFunctions {
        // --------------------------- Misc ---------------------------
        //STD_MEMCPY("memcpy", true, true, true, false, Intrinsics::inlineMemCpy),
        //STD_MEMCPYS("memcpy_s", true, true, true, false, Intrinsics::inlineMemCpyS),
        //STD_MEMSET(List.of("memset", "__memset_chk"), true, false, true, false, Intrinsics::inlineMemSet),
        //STD_MEMCMP("memcmp", false, true, true, false, Intrinsics::inlineMemCmp),
        STD_MALLOC("malloc", StdLibrary::inlineMalloc),
        STD_CALLOC("calloc", StdLibrary::inlineCalloc),
        STD_ALIGNED_ALLOC("aligned_alloc", StdLibrary::inlineAlignedAlloc),
        STD_FREE("free", StdLibrary::inlineFree),
        STD_ASSERT(List.of("__assert_fail", "__assert_rtn"), StdLibrary::inlineUserAssert),
        STD_EXIT("exit", StdLibrary::inlineExit),
        STD_ABORT("abort", StdLibrary::inlineExit),
        STD_IO(List.of("puts", "putchar", "printf", "fflush"), StdLibrary::inlineAsZero),
        STD_IO_NONDET("fprintf", StdLibrary::inlineCallAsNonDet),
        STD_SLEEP("sleep", StdLibrary::inlineAsZero),
        STD_FFS(List.of("ffs", "ffsl", "ffsll"), StdLibrary::inlineFfs),
        ;

        private final List<String> variants;
        private final Handler<StdLibrary> handler;

        SupportedFunctions(List<String> variants, CallResolver<StdLibrary> handler) {
            this.variants = variants;
            this.handler = handler;
        }

        SupportedFunctions(String name, CallResolver<StdLibrary> handler) {
            this(List.of(name), handler);
        }

        private boolean matches(String funcName) {
            return variants.contains(funcName);
        }
    }


    public StdLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
    }

    @Override
    protected StdLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<Handler<StdLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }


    // ========================================================================================


    private List<Event> inlineMalloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(1, call);
        final Type allocType = types.getByteType();
        final Expression totalSize = call.getArguments().get(0);
        return List.of(
                EventFactory.newAlloc(resultRegister, allocType, totalSize, true, false)
        );
    }

    private List<Event> inlineCalloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Type allocType = types.getByteType();
        final Expression elementCount = call.getArguments().get(0);
        final Expression elementSize = call.getArguments().get(1);
        final Expression totalSize = expressions.makeMul(elementCount, elementSize);
        return List.of(
                EventFactory.newAlloc(resultRegister, allocType, totalSize, true, true)
        );
    }

    private List<Event> inlineAlignedAlloc(FunctionCall call) {
        final Register resultRegister = getResultRegisterAndCheckArguments(2, call);
        final Type allocType = types.getByteType();
        final Expression alignment = call.getArguments().get(0);
        final Expression totalSize = call.getArguments().get(1);
        return List.of(
                EventFactory.newAlignedAlloc(resultRegister, allocType, totalSize, alignment, true, false)
        );
    }

    private List<Event> inlineFree(FunctionCall call) {
        final Expression address = call.getArguments().get(0);
        return List.of(newDealloc(address));
    }

    private List<Event> inlineUserAssert(FunctionCall call) {
        return inlineAssert(AssertionType.USER, "user assertion");
    }

    private List<Event> inlineExit(FunctionCall ignored) {
        final Event exit = EventFactory.newAbortIf(expressions.makeTrue());
        exit.addTags(Tag.EXCEPTIONAL_TERMINATION);
        return List.of(exit);
    }

    private List<Event> inlineFfs(FunctionCall call) {
        //see https://linux.die.net/man/3/ffs
        final String name = call.getCalledFunction().getName();
        checkArgument(call.getArguments().size() == 1,
                "Expected 1 parameter for \"%s\", got %s.", name, call.getArguments().size());
        final Expression input = call.getArguments().get(0);
        final Register resultReg = getResultRegister(call);
        final Type outputType = resultReg.getType();
        checkArgument(outputType instanceof IntegerType,
                "Non-integer %s type for \"%s\".", name, outputType);
        final IntegerType inputType  = (IntegerType)input.getType();
        final Expression cttz = expressions.makeCTTZ(input);
        final Expression widthExpr = expressions.makeValue(BigInteger.valueOf(inputType.getBitWidth()), inputType);
        final Expression count = expressions.makeAdd(cttz, expressions.makeOne(inputType));
        final Expression ite = expressions.makeITE(expressions.makeEQ(cttz, widthExpr), expressions.makeZero(inputType), count);
        final Expression cast = expressions.makeCast(ite, outputType, false);
        final Event assignment = EventFactory.newLocal(resultReg, cast);
        return List.of(assignment);
    }


}

