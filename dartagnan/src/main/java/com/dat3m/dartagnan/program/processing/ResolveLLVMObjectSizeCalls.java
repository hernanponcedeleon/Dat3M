package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import org.sosy_lab.common.configuration.Configuration;

import java.math.BigInteger;

/*
    https://llvm.org/docs/LangRef.html#llvm-objectsize-intrinsic
    A call to llvm.objectsize(ptr, ...) returns the size of the (accessible) object pointed to by <ptr>.
    For example, if ptr_base is returned by alloc(100), then llvm.objectsize(ptr_base) == 100,
    but llvm.objectsize(ptr_base + 80) == 20 (~ there are only 20 accessible bytes at that offset).
    If the size cannot be determined statically, the call is replaced by either 0 or -1.
    The intrinsic is typically used together with bound-checked memset/memcpy calls (e.g. __memset_chk) where the bound
    check may get statically eliminated.

    NOTE: For simplicity, we will always assume the object size to be statically unknown and return -1/0.

    FIXME: A correct implementation needs to traverse the use-def chain from a llvm.objectsize call back to
     the allocation site while tracking offset computations.
     Unfortunately, this is quite hard to do in the presence of array indexing which can result in dynamic offsets.
     A way around this is to rely on unrolling + CP to resolve dynamic offsets, then run this pass, and finally
     run a second CP to propagate the resolved object sizes.
 */
public class ResolveLLVMObjectSizeCalls implements FunctionProcessor {

    private ResolveLLVMObjectSizeCalls() {}

    public static ResolveLLVMObjectSizeCalls fromConfig(Configuration config) {
        return new ResolveLLVMObjectSizeCalls();
    }

    @Override
    public void run(Function function) {
        function.getEvents(ValueFunctionCall.class)
                .stream().filter(call -> call.isDirectCall() && call.getCalledFunction().getIntrinsicInfo() == Intrinsics.Info.LLVM_OBJECTSIZE)
                .forEach(this::resolveObjectSizeCall);
    }

    private void resolveObjectSizeCall(ValueFunctionCall call) {
        //final Expression ptr = call.getArguments().get(0);
        final IntLiteral zeroIfUnknown = (IntLiteral)call.getArguments().get(1); // else -1 if unknown
        //final IntLiteral nullIsUnknown = (IntLiteral)call.getArguments().get(2);
        //final IntLiteral isDynamic = (IntLiteral) call.getArguments().get(3); // Meaning of this is unclear

        // TODO: We treat all pointers as unknown for now.
        final ExpressionFactory exprs = ExpressionFactory.getInstance();
        final BigInteger value = zeroIfUnknown.isOne() ? BigInteger.ZERO : BigInteger.ONE.negate();
        final Event constAssignment = EventFactory.newLocal(
                call.getResultRegister(), exprs.makeValue(value, (IntegerType) call.getResultRegister().getType())
        );
        constAssignment.copyAllMetadataFrom(call);
        call.replaceBy(constAssignment);
    }
}
