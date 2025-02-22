package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.program.Register;

@NoInterface
public class RMWExtremumBase extends RMWXchgBase {

    protected final IntCmpOp operator;

    public RMWExtremumBase(Register register, Expression address, IntCmpOp op, Expression value, String mo) {
        super(register, address, value, mo);
        this.operator = op;
    }

    protected RMWExtremumBase(RMWExtremumBase other) {
        super(other);
        this.operator = other.operator;
    }

    public IntCmpOp getOperator() {
        return operator;
    }

    @Override
    public String defaultString() {
        return String.format("%s := rmw ext_%s(%s, %s, %s)", resultRegister, mo, storeValue, address, operator.getName());
    }

    @Override
    public RMWExtremumBase getCopy() {
        return new RMWExtremumBase(this);
    }
}