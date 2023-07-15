package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.google.common.base.Preconditions;

import java.util.List;

public class DirectValueFunctionCall extends DirectFunctionCall implements RegWriter {

    protected Register resultRegister;

    public DirectValueFunctionCall(Register resultRegister, Function func, List<Expression> arguments) {
        super(func, arguments);
        Preconditions.checkArgument(resultRegister.getType().equals(func.getFunctionType().getReturnType()));
        this.resultRegister = resultRegister;
    }

    protected DirectValueFunctionCall(DirectValueFunctionCall other) {
        super(other);
        this.resultRegister = other.getResultRegister();
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    @Override
    protected String defaultString() {
        return String.format("%s <- call %s(%s)", resultRegister, callTarget.getName(), super.argumentsToString());
    }

    @Override
    public DirectValueFunctionCall getCopy() {
        return new DirectValueFunctionCall(this);
    }
}
