package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

@Options
public class VerifierLibrary extends AbstractLibrary<VerifierLibrary> {

    public enum SupportedFunctions {
        // --------------------------- SVCOMP ---------------------------
        VERIFIER_ATOMIC_BEGIN("__VERIFIER_atomic_begin", VerifierLibrary::inlineAtomicBegin),
        VERIFIER_ATOMIC_END("__VERIFIER_atomic_end", VerifierLibrary::inlineAtomicEnd),
        // --------------------------- __VERIFIER ---------------------------
        VERIFIER_LOOP_BEGIN("__VERIFIER_loop_begin",  AbstractLibrary::inlineAsZero),
        VERIFIER_SPIN_START("__VERIFIER_spin_start", AbstractLibrary::inlineAsZero),
        VERIFIER_SPIN_END("__VERIFIER_spin_end",  AbstractLibrary::inlineAsZero),
        VERIFIER_LOOP_BOUND("__VERIFIER_loop_bound",  VerifierLibrary::inlineLoopBound),
        VERIFIER_ASSUME("__VERIFIER_assume", VerifierLibrary::inlineAssume),
        VERIFIER_ASSERT("__VERIFIER_assert", VerifierLibrary::inlineVerifierAssert),
        VERIFIER_NONDET(List.of("__VERIFIER_nondet_bool",
                "__VERIFIER_nondet_int", "__VERIFIER_nondet_uint", "__VERIFIER_nondet_unsigned_int",
                "__VERIFIER_nondet_short", "__VERIFIER_nondet_ushort", "__VERIFIER_nondet_unsigned_short",
                "__VERIFIER_nondet_long", "__VERIFIER_nondet_ulong",
                "__VERIFIER_nondet_longlong", "__VERIFIER_nondet_ulonglong",
                "__VERIFIER_nondet_char", "__VERIFIER_nondet_uchar",
                "__VERIFIER_nondet_float", "__VERIFIER_nondet_double"),
                VerifierLibrary::inlineNonDet),
        ;

        private final List<String> variants;
        private final Handler<VerifierLibrary> handler;

        SupportedFunctions(List<String> variants, CallResolver<VerifierLibrary> handler) {
            this.variants = variants;
            this.handler = handler;
        }

        SupportedFunctions(String name, CallResolver<VerifierLibrary> handler) {
            this(List.of(name), handler);
        }

        private boolean matches(String funcName) {
            return variants.contains(funcName);
        }
    }


    public VerifierLibrary(Configuration config) throws InvalidConfigurationException {
        super(config);
    }

    @Override
    protected VerifierLibrary getThis() {
        return this;
    }

    @Override
    protected Optional<Handler<VerifierLibrary>> getHandler(Function func) {
        final String funcName = func.getName();
        return Arrays.stream(SupportedFunctions.values())
                .filter(f -> f.matches(funcName))
                .map(f -> f.handler)
                .findFirst();
    }


    // ========================================================================================

    //FIXME This might have concurrency issues if processing multiple programs at the same time.
    // It also relies on the fact that we handle calls in program order.
    private BeginAtomic currentAtomicBegin;

    private List<Event> inlineLoopBound(FunctionCall call) {
        final Expression boundExpression = call.getArguments().get(0);
        return List.of(EventFactory.newLoopBound(boundExpression));
    }

    private List<Event> inlineAssume(FunctionCall call) {
        final Expression assumption = call.getArguments().get(0);
        return List.of(EventFactory.newAssume(expressions.makeBooleanCast(assumption)));
    }

    private List<Event> inlineAtomicBegin(FunctionCall ignored) {
        return List.of(currentAtomicBegin = EventFactory.Svcomp.newBeginAtomic());
    }

    private List<Event> inlineAtomicEnd(FunctionCall ignored) {
        return List.of(EventFactory.Svcomp.newEndAtomic(checkNotNull(currentAtomicBegin)));
    }

    private List<Event> inlineVerifierAssert(FunctionCall call) {
        assert call.getArguments().size() == 1;
        final Expression condition = call.getArguments().get(0);
        return inlineAssert(expressions.makeBooleanCast(condition), false,
                AssertionType.USER, "user assertion");
    }

    private List<Event> inlineNonDet(FunctionCall call) {
        assert call.isDirectCall() && call instanceof ValueFunctionCall;
        final Register result = getResultRegister(call);
        final String name = call.getCalledFunction().getName();
        final String separator = "nondet_";
        final int index = name.indexOf(separator);
        assert index > -1;
        final String suffix = name.substring(index + separator.length());

        final Type nonDetType;
        final boolean signed;
        switch (suffix) {
            case "bool" -> {
                // Nondeterministic booleans
                signed = false;
                nonDetType = types.getBooleanType();
            }
            case "float" -> {
                // Nondeterministic floats (32 bits)
                signed = true;
                nonDetType = types.getIEEESingleType();
            }
            case "double" -> {
                // Nondeterministic floats (64 bits)
                signed = true;
                nonDetType = types.getIEEEDoubleType();
            }
            default -> {
                // Nondeterministic integers
                final int bits = switch (suffix) {
                    case "longlong", "ulonglong" -> 64;
                    case "long", "ulong" -> 64;
                    case "int", "uint", "unsigned_int" -> 32;
                    case "short", "ushort", "unsigned_short" -> 16;
                    case "char", "uchar" -> 8;
                    default -> throw new UnsupportedOperationException(String.format("%s is not supported", call));
                };

                signed = switch (suffix) {
                    case "int", "short", "long", "longlong", "char" -> true;
                    default -> false;
                };
                nonDetType = types.getIntegerType(bits);
            }
        }

        final Register nonDetReg = call.getFunction().getOrNewRegister("__r_nondet_" + suffix, nonDetType);
        return List.of(
                EventFactory.newSignedNonDetChoice(nonDetReg, signed),
                EventFactory.newLocal(result, expressions.makeCast(nonDetReg, result.getType(), signed))
        );
    }

    // ====================================================================
    
}
