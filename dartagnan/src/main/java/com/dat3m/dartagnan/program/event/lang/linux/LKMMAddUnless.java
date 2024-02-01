package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;

import java.util.Set;

import static com.dat3m.dartagnan.program.Register.UsageType.DATA;

public class LKMMAddUnless extends SingleAccessMemoryEvent implements RegWriter {

    private Register resultRegister;
    private Expression operand;
    private Expression cmp;

    public LKMMAddUnless(Register register, Expression address, Expression operand, Expression cmp) {
        super(address, register.getType(), Tag.Linux.MO_MB);
        this.resultRegister = register;
        this.operand = operand;
        this.cmp = cmp;
        addTags(Tag.WRITE, Tag.READ, Tag.RMW);
    }

    private LKMMAddUnless(LKMMAddUnless other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.operand = other.operand;
        this.cmp = other.cmp;
    }

    @Override
    public String defaultString() {
        return String.format("%s := atomic_add_unless(%s, %s, %s)\t### LKMM",
                resultRegister, address, operand, cmp);
    }

    @Override
    public Register getResultRegister() {
        return resultRegister;
    }

    @Override
    public void setResultRegister(Register reg) {
        this.resultRegister = reg;
    }

    public Expression getOperand() {
        return operand;
    }

    public Expression getCmp() {
        return cmp;
    }
    
    @Override
    public Set<Register.Read> getRegisterReads(){
        return Register.collectRegisterReads(cmp, DATA,
                Register.collectRegisterReads(operand, DATA,
                super.getRegisterReads()));
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.operand = operand.accept(exprTransformer);
        this.cmp = cmp.accept(exprTransformer);
    }

    @Override
    public LKMMAddUnless getCopy(){
        return new LKMMAddUnless(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitLKMMAddUnless(this);
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
    }
}