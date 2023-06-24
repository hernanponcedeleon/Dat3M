package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

@NoInterface
public abstract class RMWFetchOpBase extends RMWOpBase implements RegWriter {

    protected Register resultRegister;

    protected RMWFetchOpBase(Register register, Expression address, IOpBin operator, Expression operand, String mo) {
        super(address, operator, operand, mo);
        this.resultRegister = register;
    }

    protected RMWFetchOpBase(RMWFetchOpBase other) {
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    protected String defaultString() {
        return String.format("%s := rmw fetch_%s(%s, %s)", resultRegister, operator, address, operand);
    }

}