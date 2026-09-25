package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.event.functions.ValueFunctionCall;
import com.google.common.base.Verify;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.EnumSet;
import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.configuration.OptionNames.REMOVE_ASSERTION_OF_TYPE;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.google.common.base.Preconditions.checkArgument;

@Options
public abstract class AbstractLibrary<T extends Library> implements Library {

    private static final Logger logger = LoggerFactory.getLogger(AbstractLibrary.class);

    protected enum AssertionType { USER, OVERFLOW, INVALIDDEREF, UNKNOWN_FUNCTION }

    // TODO: It would be cleaner to have a dedicated pass that removes assertions
    //  rather than avoiding them during construction.
    @Option(name = REMOVE_ASSERTION_OF_TYPE,
            description = "Remove assertions of type [user, overflow, invalidderef, unknown_function].",
            toUppercase=true,
            secure = true)
    protected EnumSet<AssertionType> notToInline = EnumSet.noneOf(AssertionType.class);

    protected static final TypeFactory types = TypeFactory.getInstance();
    protected static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    protected AbstractLibrary(Configuration config) throws InvalidConfigurationException {
        config.inject(this, AbstractLibrary.class);
    }

    @Override
    public void link(Program program) {

        // 1. Provide implementations of undefined functions if possible
        for (Function function : program.getFunctions()) {
            if (function.hasBody()) {
                continue;
            }

            final Handler<T> handler = getHandler(function).orElse(null);
            if (handler instanceof ImplementationProvider<T> implementor) {
                final List<Event> implementation = implementor.implement(getThis(), function);
                Verify.verify(!implementation.isEmpty());
                function.append(implementation);
                // TODO: Shall we put any metadata in the implemented body?
            }
        }

        // 2. Resolve calls to functions that are still undefined after point 1.
        for (Function function : program.getFunctions()) {
            for (FunctionCall call : function.getEvents(FunctionCall.class)) {
                if (!call.isDirectCall() || call.getCalledFunction().hasBody()) {
                    continue;
                }

                final Handler<T> handler = getHandler(call.getCalledFunction()).orElse(null);
                if (handler instanceof CallResolver<T> resolver) {
                    final List<Event> replacement = resolver.resolve(getThis(), call);

                    if (replacement.isEmpty()) {
                        call.tryDelete();
                    } else {
                        // NOTE: We deliberately do not use the call markers, because (1) we want to distinguish between
                        // intrinsics and normal calls, and (2) we do not want to have intrinsics in the call stack.
                        // We may want to change this behaviour though.
                        call.insertBefore(EventFactory.newStringAnnotation(
                                String.format("=== Calling library function %s ===", call.getCalledFunction().getName())
                        ));
                        call.insertAfter(EventFactory.newStringAnnotation(
                                String.format("=== Returning from library function %s ===", call.getCalledFunction().getName())
                        ));
                        IRHelper.replaceWithMetadata(call, replacement);
                    }
                }
            }
        }
    }

    // ====================================================================================================

    protected abstract T getThis();

    protected abstract Optional<Handler<T>> getHandler(Function function);

    protected sealed interface Handler<T> {}

    @FunctionalInterface
    protected non-sealed interface ImplementationProvider<T> extends Handler<T> {
        List<Event> implement(T self, Function function);
    }

    @FunctionalInterface
    protected non-sealed interface CallResolver<T> extends Handler<T> {
        List<Event> resolve(T self, FunctionCall call);
    }

    // ====================================================================================================

    protected List<Event> inlineAsZero(FunctionCall call) {
        if (call instanceof ValueFunctionCall valueCall) {
            final Register reg = valueCall.getResultRegister();
            final Expression zero = expressions.makeGeneralZero(reg.getType());
            logger.debug("Replaced (unsupported) call to \"{}\" by zero.", call.getCalledFunction().getName());
            return List.of(EventFactory.newLocal(reg, zero));
        } else {
            return List.of();
        }
    }

    protected List<Event> inlineCallAsNonDet(FunctionCall call) {
        return List.of(
                EventFactory.newSignedNonDetChoice(getResultRegister(call), true)
        );
    }

    protected List<Event> inlineAssert(Expression condition, boolean abortOnFailure, AssertionType type, String errorMsg) {
        final Event assertion = notToInline.contains(type) ? null : EventFactory.newAssert(condition, errorMsg);
        Event abort = null;
        if (abortOnFailure) {
            abort = EventFactory.newAbortIf(expressions.makeNot(condition));
            abort.addTags(Tag.EXCEPTIONAL_TERMINATION);
        }
        return eventSequence(assertion, abort);
    }

    protected List<Event> inlineAssert(AssertionType type, String errorMsg) {
        return  inlineAssert(expressions.makeFalse(), true, type, errorMsg);
    }

    protected void checkArguments(int expectedArgumentCount, FunctionCall call) {
        checkArgument(call.getArguments().size() == expectedArgumentCount, "Wrong function type at %s", call);
    }

    protected Register getResultRegister(FunctionCall call) {
        checkArgument(call instanceof ValueFunctionCall, "Unexpected value discard at intrinsic \"%s\"", call);
        return ((ValueFunctionCall) call).getResultRegister();
    }

    protected Register getResultRegisterAndCheckArguments(int expectedArgumentCount, FunctionCall call) {
        checkArguments(expectedArgumentCount, call);
        return getResultRegister(call);
    }

}
