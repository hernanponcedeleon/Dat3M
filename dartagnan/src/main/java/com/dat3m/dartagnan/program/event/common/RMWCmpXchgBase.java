package com.dat3m.dartagnan.program.event.common;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.RegWriter;

import java.util.Set;

import static com.dat3m.dartagnan.program.Register.UsageType.DATA;
import static com.dat3m.dartagnan.program.event.Tag.*;

@NoInterface
public abstract class RMWCmpXchgBase extends SingleAccessMemoryEvent implements RegWriter {

    protected Register resultRegister;
    protected Expression expectedValue;
    protected Expression storeValue;
    protected boolean isStrong;

    protected RMWCmpXchgBase(Register register, Expression address, Expression expectedValue, Expression storeValue,
                             boolean isStrong, String mo) {
        super(address, register.getType(), mo);
        this.resultRegister = register;
        this.expectedValue = expectedValue;
        this.storeValue = storeValue;
        this.isStrong = isStrong;
        addTags(READ, WRITE, RMW);
    }

    protected RMWCmpXchgBase(RMWCmpXchgBase other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.expectedValue = other.expectedValue;
        this.storeValue = other.storeValue;
        this.isStrong = other.isStrong;
    }

    public Expression getExpectedValue() { return expectedValue; }
    public void setExpectedValue(Expression expected) { this.expectedValue = expected; }

    public Expression getStoreValue() { return storeValue; }
    public void setStoreValue(Expression storeValue) { this.storeValue = storeValue; }

    public boolean isStrong() { return this.isStrong; }
    public boolean isWeak() { return !isStrong(); }
    public void setIsStrong(boolean isStrong) { this.isStrong = isStrong; }

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
        this.expectedValue = expectedValue.accept(exprTransformer);
        this.storeValue = storeValue.accept(exprTransformer);
    }

    @Override
    protected String defaultString() {
        final String strongSuffix = isStrong ?  "strong" : "weak";
        return String.format("%s := rmw compare_exchange_%s(%s, %s, %s)",
                resultRegister, strongSuffix, address, expectedValue, storeValue);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(storeValue, DATA,
                Register.collectRegisterReads(expectedValue, DATA,
                        super.getRegisterReads()));
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }


}