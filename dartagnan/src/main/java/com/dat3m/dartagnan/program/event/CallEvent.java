package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.Function;
import com.google.common.base.Preconditions;

import java.util.List;

/*
    A CallEvent is an event that abstractly calls a "callable" (i.e., function) with arguments.
    Currently,
        - The only callables are functions
        - The only call events are function calls and (dynamic) thread creation.
 */
public interface CallEvent extends RegReader {

    FunctionType getCallType();
    Expression getCallTarget();
    List<Expression> getArguments();

    void setArgument(int index, Expression argument);
    void setCallTarget(Expression callTarget);

    default boolean isDirectCall() { return getCallTarget() instanceof Function; }
    default Function getDirectCallTarget() {
        Preconditions.checkState(isDirectCall());
        return (Function) getCallTarget();
    }

    @Override
    CallEvent getCopy();
}
