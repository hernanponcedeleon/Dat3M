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
import com.dat3m.dartagnan.program.processing.Intrinsics;
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
public class UbsanLibrary extends AbstractLibrary<UbsanLibrary> {

    public enum SupportedFunctions {
        UBSAN_OVERFLOW(List.of("__ubsan_handle_add_overflow", "__ubsan_handle_sub_overflow",
                "__ubsan_handle_divrem_overflow", "__ubsan_handle_mul_overflow",
                "__ubsan_handle_negate_overflow", "__ubsan_handle_shift_out_of_bounds"),
                UbsanLibrary::inlineIntegerOverflow),
        UBSAN_TYPE_MISSMATCH("__ubsan_handle_type_mismatch_v1", UbsanLibrary::inlineInvalidDereference),
        ;

        private final List<String> variants;
        private final Handler<UbsanLibrary> handler;

        SupportedFunctions(List<String> variants, CallResolver<UbsanLibrary> handler) {
            this.variants = variants;
            this.handler = handler;
        }

        SupportedFunctions(String name, CallResolver<UbsanLibrary> handler) {
            this(List.of(name), handler);
        }

        private boolean matches(String funcName) {
            return variants.contains(funcName);
        }
    }


    public UbsanLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
    }

    @Override
    protected UbsanLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<Handler<UbsanLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }

    // ========================================================================================

    private List<Event> inlineIntegerOverflow(FunctionCall call) {
        return inlineAssert(AssertionType.OVERFLOW, "integer overflow");
    }

    private List<Event> inlineInvalidDereference(FunctionCall call) {
        return inlineAssert(AssertionType.INVALIDDEREF, "invalid dereference");
    }


}

