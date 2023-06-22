package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.base.Preconditions;

import java.util.List;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public class ValueDirectFunctionCall extends DirectFunctionCall implements RegWriter {

    protected Register resultRegister;

    public ValueDirectFunctionCall(Register resultRegister, Function func, List<Expression> arguments) {
        super(func, arguments);
        Preconditions.checkArgument(resultRegister.getType().equals(func.getFunctionType().getReturnType()));
        this.resultRegister = resultRegister;
    }

    protected ValueDirectFunctionCall(ValueDirectFunctionCall other) {
        super(other);
        this.resultRegister = other.getResultRegister();
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    protected String defaultString() {
        return String.format("%s <- call %s(%s)", resultRegister, function.getName(), super.argumentsToString());
    }

    @Override
    public ValueDirectFunctionCall getCopy() {
        return new ValueDirectFunctionCall(this);
    }
}
