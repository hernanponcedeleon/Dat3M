package com.dat3m.dartagnan.program.event.lang;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.*;

public abstract class RMWAbstract extends SingleAccessMemoryEvent implements RegWriter {

    protected final Register resultRegister;
    protected Expression value;

    protected RMWAbstract(Expression address, Register register, Expression value, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value = value;
        addTags(READ, WRITE, RMW);
    }

    protected RMWAbstract(RMWAbstract other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
    }

    public Expression getMemValue(){
        return value;
    }

    public void setMemValue(Expression value){
        this.value = value;
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.value = value.visit(exprTransformer);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMWAbstract(this);
    }
}