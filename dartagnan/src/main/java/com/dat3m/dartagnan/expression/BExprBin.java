package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;

import java.math.BigInteger;

import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class BExprBin extends BExpr {

    private final ExprInterface b1;
    private final ExprInterface b2;
    private final BOpBin op;

    public BExprBin(ExprInterface b1, BOpBin op, ExprInterface b2) {
        this.b1 = b1;
        this.b2 = b2;
        this.op = op;
    }

    public ExprInterface getLHS() {
    	return b1;
    }
    
    public ExprInterface getRHS() {
    	return b2;
    }
    
    public BOpBin getOp() {
    	return op;
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx) {
        return op.encode(b1.toZ3Bool(e, ctx), b2.toZ3Bool(e, ctx), ctx);
    }

    @Override
    public Expr getLastValueExpr(Context ctx){
        BoolExpr expr1 = ctx.mkGt((IntExpr)b1.getLastValueExpr(ctx), ctx.mkInt(1));
        BoolExpr expr2 = ctx.mkGt((IntExpr)b2.getLastValueExpr(ctx), ctx.mkInt(1));
        return ctx.mkITE(op.encode(expr1, expr2, ctx), ctx.mkInt(1), ctx.mkInt(0));
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b1.getRegs()).addAll(b2.getRegs()).build();
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return new ImmutableSet.Builder<Location>().addAll(b1.getLocs()).addAll(b2.getLocs()).build();
    }

    @Override
    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Model model, Context ctx){
        return op.combine(b1.getBoolValue(e, model, ctx), b2.getBoolValue(e, model, ctx));
    }

    @Override
	public IConst reduce() {
    	BigInteger v1 = b1.reduce().getIntValue();
    	BigInteger v2 = b2.reduce().getIntValue();
		switch(op) {
        case AND:
        	return new IConst(v1.compareTo(BigInteger.ONE) == 0 ? v2 : BigInteger.ZERO, -1);
        case OR:
        	return new IConst(v1.compareTo(BigInteger.ONE) == 0 ? BigInteger.ONE : v2, -1);
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
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
        }
        if (obj == null || obj.getClass() != getClass())
            return false;
        BExprBin expr = (BExprBin) obj;
        return expr.op == op && expr.b1.equals(b1) && expr.b2.equals(b2);
    }
}
