package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;

import java.util.List;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public class VoidDirectFunctionCall extends DirectFunctionCall {

    public VoidDirectFunctionCall(Function func, List<Expression> arguments) {
        super(func, arguments);
        // TODO: Check for no return type
    }

    protected VoidDirectFunctionCall(VoidDirectFunctionCall other) {
        super(other);
    }

    @Override
    protected String defaultString() {
        return String.format("call %s(%s)", function.getName(), super.argumentsToString());
    }

    @Override
    public VoidDirectFunctionCall getCopy() {
        return new VoidDirectFunctionCall(this);
    }
}
