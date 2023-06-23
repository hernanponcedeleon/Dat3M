package com.dat3m.dartagnan.program.event.arch.lisa;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.Tag.RMW;
import static com.dat3m.dartagnan.program.event.Tag.*;

public class RMW extends SingleAccessMemoryEvent implements RegWriter {

    private Register resultRegister;
    private Expression value;
    

    public RMW(Expression address, Register register, Expression value, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value = value;
        addTags(READ, WRITE, RMW);
    }

    private RMW(RMW other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
    }

    @Override
    public String defaultString() {
        return resultRegister + " := rmw[" + mo + "](" + value + ", " + address + ")";
    }

    public Expression getMemValue(){
        return value;
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(value, Register.UsageType.DATA, super.getRegisterReads());
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
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.value = value.visit(exprTransformer);
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public RMW getCopy() {
        return new RMW(this);
    }

    // Visitor
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitRMW(this);
    }
}