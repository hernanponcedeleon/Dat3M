package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BoolBinaryOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public class BoolBinaryExpr extends BoolExpr {

    private final Expression b1;
    private final Expression b2;
    private final BoolBinaryOp op;

    BoolBinaryExpr(BooleanType type, Expression b1, BoolBinaryOp op, Expression b2) {
        super(type);
        this.b1 = b1;
        this.b2 = b2;
        this.op = op;
    }

    public Expression getLHS() {
    	return b1;
    }
    
    public Expression getRHS() {
    	return b2;
    }
    
    public BoolBinaryOp getOp() {
    	return op;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b1.getRegs()).addAll(b2.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return b1.hashCode() + b2.hashCode() + op.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        BoolBinaryExpr expr = (BoolBinaryExpr) obj;
        return expr.op == op && expr.b1.equals(b1) && expr.b2.equals(b2);
    }
}
