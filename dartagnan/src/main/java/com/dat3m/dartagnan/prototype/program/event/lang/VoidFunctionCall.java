package com.dat3m.dartagnan.prototype.program.event.lang;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.types.FunctionType;
import com.dat3m.dartagnan.prototype.expr.types.VoidType;
import com.dat3m.dartagnan.prototype.program.Register;
import com.google.common.base.Preconditions;

import java.util.List;

// TODO: "abstract" is only here to avoid providing a complete implementation for now
public abstract class VoidFunctionCall extends FunctionCall implements Register.Reader {

    protected VoidFunctionCall(FunctionType funcType, Expression funcAddress, List<Expression> arguments) {
        super(funcType, funcAddress, arguments);
        Preconditions.checkArgument(funcType.getReturnType().equals(VoidType.get()));
    }

}
