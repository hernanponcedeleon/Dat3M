package com.dat3m.dartagnan.program.event.lang;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

/*
    This is for non-value-returning RMWs/AMOs, i.e., every operation of shape
        __temp = load(addr);
        store(addr, op(__temp));
 */
public class GenericRMWNoReturn extends SingleAccessMemoryEvent {

    protected Expression storeTransformer;

    protected GenericRMWNoReturn(Expression address, Expression storeTransformer, String mo) {
        super(address, storeTransformer.getType(), mo);
        this.storeTransformer = storeTransformer;
        addTags(READ, WRITE, RMW);
    }

    protected GenericRMWNoReturn(GenericRMWNoReturn other) {
        super(other);
        this.storeTransformer = other.storeTransformer;
    }

    public Expression getStoreTransformer() { return storeTransformer; }
    public void setStoreTransformer(Expression storeTransformer) { this.storeTransformer = storeTransformer; }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.storeTransformer = storeTransformer.accept(exprTransformer);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitGenericRMWNoReturn(this);
    }

    @Override
    public GenericRMWNoReturn getCopy() {
        return new GenericRMWNoReturn(this);
    }

    @Override
    protected String defaultString() {
        return String.format("rmw (%s, %s)", address, storeTransformer);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(storeTransformer, Register.UsageType.DATA, super.getRegisterReads());
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

}