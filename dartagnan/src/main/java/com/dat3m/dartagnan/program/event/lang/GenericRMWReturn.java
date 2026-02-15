package com.dat3m.dartagnan.program.event.lang;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.MemoryAccess;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;

import java.util.Set;

/*
    This class can be used for many value-returning RMWs/AMOs of shape
        __temp = load(addr);
        if (cmp(__temp))                // (_ == expected) for CAS
           store(addr, op(__temp));     // ID(_) for CAS
        result = returnOp(__temp);      // ID(_) for fetch_op, OP(_) for op_return, or some
                                        // cond(_) for op_and_test

 */
public class GenericRMWReturn extends SingleAccessMemoryEvent implements RegWriter {

    protected Register resultRegister;
    protected Expression storeTransformer;
    protected Expression conditionalExpr;
    protected Expression returnTransformer;

    public GenericRMWReturn(Register register, Expression address,
                            Expression storeTransformer,
                            Expression conditionalExpr,
                            Expression returnTransformer,
                            String mo) {
        super(address, storeTransformer.getType(), mo);
        this.resultRegister = register;
        this.storeTransformer = storeTransformer;
        this.conditionalExpr =  conditionalExpr;
        this.returnTransformer = returnTransformer;
    }

    protected GenericRMWReturn(GenericRMWReturn other) {
        super(other);
        this.resultRegister = other.resultRegister;
        this.storeTransformer = other.storeTransformer;
        this.conditionalExpr = other.conditionalExpr;
        this.returnTransformer = other.returnTransformer;
    }

    public Expression getStoreTransformer() { return storeTransformer; }
    public Expression getConditionalExpr() { return conditionalExpr; }
    public Expression getReturnTransformer() { return returnTransformer; }

    public boolean hasConditional() { return conditionalExpr != null; }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        super.transformExpressions(exprTransformer);
        this.storeTransformer = storeTransformer.accept(exprTransformer);
        this.conditionalExpr = conditionalExpr == null ? null : conditionalExpr.accept(exprTransformer);
        this.returnTransformer = returnTransformer.accept(exprTransformer);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        Set<Register.Read> reads = super.getRegisterReads();
        reads = Register.collectRegisterReads(storeTransformer, Register.UsageType.DATA, reads);
        if (conditionalExpr != null) {
            reads = Register.collectRegisterReads(conditionalExpr, Register.UsageType.CTRL, reads);
        }
        reads = Register.collectRegisterReads(returnTransformer, Register.UsageType.DATA, reads);
        return reads;
    }

    @Override
    public Event getCopy() {
        return new GenericRMWReturn(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitGenericRMWReturn(this);
    }

    @Override
    public MemoryAccess getMemoryAccess() {
        return new MemoryAccess(address, accessType, MemoryAccess.Mode.RMW);
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
        if (hasConditional()) {
            return String.format("%s = rmw_return(%s, val='%s', cond='%s', ret='%s')", resultRegister, address, storeTransformer, conditionalExpr, returnTransformer);
        }
        return String.format("%s = rmw_return(%s, val='%s', ret='%s')", resultRegister, address, storeTransformer, returnTransformer);
    }

}