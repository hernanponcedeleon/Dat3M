package com.dat3m.dartagnan.programNew.event.lang;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.types.FunctionType;
import com.dat3m.dartagnan.programNew.Register;
import com.google.common.base.Preconditions;

import java.util.List;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class ValueFunctionCall extends FunctionCall implements Register.Reader, Register.Writer {

    protected Register resultRegister;

    protected ValueFunctionCall(Register resultRegister, FunctionType funcType, Expression funcAddress, List<Expression> arguments) {
        super(funcType, funcAddress, arguments);
        Preconditions.checkArgument(resultRegister.getType().equals(funcType.getReturnType()));

        this.resultRegister = resultRegister;
    }


    @Override
    public Register getResultRegister() {
        return resultRegister;
    }


}
