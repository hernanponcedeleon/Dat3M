package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.google.common.base.Preconditions;

import java.util.List;

public class DirectVoidFunctionCall extends DirectFunctionCall {

    public DirectVoidFunctionCall(Function func, List<Expression> arguments) {
        super(func, arguments);
        Preconditions.checkArgument(func.getFunctionType().getReturnType()
                .equals(TypeFactory.getInstance().getVoidType()));
    }

    protected DirectVoidFunctionCall(DirectVoidFunctionCall other) {
        super(other);
    }

    @Override
    protected String defaultString() {
        return String.format("call %s(%s)", callTarget.getName(), super.argumentsToString());
    }

    @Override
    public DirectVoidFunctionCall getCopy() {
        return new DirectVoidFunctionCall(this);
    }
}
