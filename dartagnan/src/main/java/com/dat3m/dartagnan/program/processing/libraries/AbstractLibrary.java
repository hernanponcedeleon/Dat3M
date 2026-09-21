package com.dat3m.dartagnan.program.processing.libraries;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.ExecutionStatus;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.google.common.collect.ImmutableList;

import java.util.List;
import java.util.Map;

public abstract class AbstractLibrary<T extends LibraryImplementation> implements LibraryImplementation {

    protected static final TypeFactory types = TypeFactory.getInstance();
    protected static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    protected abstract T getThis();

    protected abstract Handler<T> getHandler(Function function);

    @Override
    public void link(Program program) {

        // 1. Provide implementations of undefined functions if possible
        for (Function function : program.getFunctions()) {
            if (function.hasBody()) {
                continue;
            }

            final Handler<T> handler = getHandler(function);
            if (handler instanceof ImplementationProvider<T> implementor) {
                implementor.implement(getThis(), function);
                assert function.hasBody();
            }
        }

        // 2. Resolve calls to function that are still undefined after point 1.
        for (Function function : program.getFunctions()) {
            for (FunctionCall call : function.getEvents(FunctionCall.class)) {
                if (!call.isDirectCall() || call.getCalledFunction().hasBody()) {
                    continue;
                }

                final Handler<T> handler = getHandler(call.getCalledFunction());
                if (handler instanceof CallResolver<T> resolver) {
                    final List<Event> replacement = resolver.resolve(getThis(), call);

                    if (replacement.isEmpty()) {
                        call.tryDelete();
                    } else if (replacement.get(0) != call) {
                        if (!call.getUsers().isEmpty() && call.getUsers().stream().allMatch(ExecutionStatus.class::isInstance)) {
                            final Map<Event, Event> updateMapping = Map.of(call, replacement.get(0));
                            ImmutableList.copyOf(call.getUsers()).forEach(user -> user.updateReferences(updateMapping));
                        }
                        // NOTE: We deliberately do not use the call markers, because (1) we want to distinguish between
                        // intrinsics and normal calls, and (2) we do not want to have intrinsics in the call stack.
                        // We may want to change this behaviour though.
                        call.insertBefore(EventFactory.newStringAnnotation(
                                String.format("=== Calling intrinsic %s ===", call.getCalledFunction().getName())
                        ));
                        call.insertAfter(EventFactory.newStringAnnotation(
                                String.format("=== Returning from intrinsic %s ===", call.getCalledFunction().getName())
                        ));
                        IRHelper.replaceWithMetadata(call, replacement);
                    }
                }
            }
        }
    }


    @FunctionalInterface
    protected interface ImplementationProvider<T> extends Handler<T> {
        void implement(T self, Function function);
    }

    @FunctionalInterface
    protected interface CallResolver<T> extends Handler<T> {
        List<Event> resolve(T self, FunctionCall call);
    }

    protected interface Handler<T> {}

}
