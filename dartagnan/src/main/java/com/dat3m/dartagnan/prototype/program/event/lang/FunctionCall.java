package com.dat3m.dartagnan.prototype.program.event.lang;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.types.FunctionType;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public abstract class FunctionCall extends AbstractEvent implements Register.Reader {

    protected FunctionType funcType;
    protected Expression functionAddress;
    protected List<Expression> arguments;

    protected FunctionCall(FunctionType funcType, Expression funcAddress, List<Expression> arguments) {
        Preconditions.checkArgument(arguments.size() == funcType.getParameterTypes().size());
        this.funcType = funcType;
        this.functionAddress = funcAddress;
        this.arguments = arguments;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        Register.collectRegisterReads(functionAddress, Register.UsageType.DATA, regReads);
        for (Expression argument : arguments) {
            Register.collectRegisterReads(argument, Register.UsageType.DATA, regReads);
        }
        return regReads;
    }
}
