package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.google.common.base.Preconditions;

import java.util.List;

public class VoidFunctionCall extends FunctionCall {

    public VoidFunctionCall(FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        super(funcType, funcPtr, arguments);
        Preconditions.checkArgument(funcType.getReturnType().equals(TypeFactory.getInstance().getVoidType()));
    }

    protected VoidFunctionCall(VoidFunctionCall other) {
        super(other);
    }

    @Override
    protected String defaultString() {
        if (isDirectCall()) {
            return String.format("call %s(%s)", ((Function)callTarget).getName(), super.argumentsToString());
        } else {
            return String.format("call %s(%s)", callTarget, super.argumentsToString());
        }
    }

    @Override
    public VoidFunctionCall getCopy() {
        return new VoidFunctionCall(this);
    }
}
