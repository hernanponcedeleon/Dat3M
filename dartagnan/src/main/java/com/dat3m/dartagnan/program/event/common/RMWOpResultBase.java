package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegWriter;

/*
    This class can be used as base for many value-returning operator-based RMWs, such as
    fetch_op, op_return, and op_and_test.
 */
@NoInterface
public abstract class RMWOpResultBase extends RMWOpBase implements RegWriter {

    protected Register resultRegister;

    protected RMWOpResultBase(Register register, Expression address, IntBinaryOp operator, Expression operand, String mo) {
        super(address, operator, operand, mo);
        this.resultRegister = register;
    }

    protected RMWOpResultBase(RMWOpResultBase other) {
        super(other);
        this.resultRegister = other.resultRegister;
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
        return String.format("%s := rmw %s_result(%s, %s)", resultRegister, operator.getName(), address, operand);
    }

}