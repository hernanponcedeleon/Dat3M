package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.google.common.base.Preconditions;

import java.util.List;

public class ValueFunctionCall extends FunctionCall implements RegWriter {

    protected Register resultRegister;

    public ValueFunctionCall(Register resultRegister, FunctionType funcType, Expression funcPtr, List<Expression> arguments) {
        super(funcType, funcPtr, arguments);
        Preconditions.checkArgument(resultRegister.getType().equals(funcType.getReturnType()));
        this.resultRegister = resultRegister;
    }

    protected ValueFunctionCall(ValueFunctionCall other) {
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
        final Object target = isDirectCall() ? ((Function)callTarget).getName() : callTarget;
        return String.format("%s <- call %s(%s)", resultRegister, target, super.argumentsToString());
    }

    @Override
    public ValueFunctionCall getCopy() {
        return new ValueFunctionCall(this);
    }
}
