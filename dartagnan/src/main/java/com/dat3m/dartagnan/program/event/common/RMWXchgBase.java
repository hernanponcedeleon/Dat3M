package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.RegWriter;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

@NoInterface
public abstract class RMWXchgBase extends SingleAccessMemoryEvent implements RegWriter {

    protected Register resultRegister;
    protected Expression storeValue;

    protected RMWXchgBase(Register register, Expression address, Expression value, String mo) {
        super(address, register.getType(), mo);
        this.resultRegister = register;
        this.storeValue = value;
        addTags(READ, WRITE, RMW);
    }

    protected RMWXchgBase(RMWXchgBase other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.storeValue = other.storeValue;
    }

    public Expression getValue() { return storeValue; }
    public void setValue(Expression value) { this.storeValue = value; }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.storeValue = storeValue.accept(exprTransformer);
    }

    @Override
    protected String defaultString() {
        return String.format("%s := rmw exchange(%s, %s)", resultRegister, address, storeValue);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(storeValue, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }


}