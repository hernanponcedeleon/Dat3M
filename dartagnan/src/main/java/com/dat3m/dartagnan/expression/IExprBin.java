package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IExprBin extends IExpr implements ExprInterface {

    private final ExprInterface lhs;
    private final ExprInterface rhs;
    private final IOpBin op;

    public IExprBin(ExprInterface lhs, IOpBin op, ExprInterface rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public Expr toZ3NumExpr(Event e, Context ctx, boolean bp) {
        return op.encode(lhs.toZ3NumExpr(e, ctx, bp), rhs.toZ3NumExpr(e, ctx, bp), ctx, bp);
    }

    @Override
    public Expr getLastValueExpr(Context ctx, boolean bp){
        return op.encode(lhs.getLastValueExpr(ctx, bp), rhs.getLastValueExpr(ctx, bp), ctx, bp);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }

    @Override
    public int getIntValue(Event e, Context ctx, Model model, boolean bp){
        return op.combine(lhs.getIntValue(e, ctx, model, bp), rhs.getIntValue(e, ctx, model, bp));
    }
    
    @Override
	public IConst reduce() {
		int v1 = lhs.reduce().getValue();
		int v2 = rhs.reduce().getValue();
        switch(op){
        case PLUS:
            return new IConst(v1 + v2);
        case MINUS:
        	return new IConst(v1 - v2);
        case MULT:
        	return new IConst(v1 * v2);
        case DIV:
        	return new IConst(v1 / v2);
        case MOD:
        	return new IConst(v1 % v2);
        case AND:
        	return new IConst(v1 == 1 ? v2 : 0);
        case OR:
        	return new IConst(v1 == 1 ? 1 : v2);
        case XOR:
        	return new IConst(v1 + v2 == 1 ? 1 : 0);
		default:
			throw new UnsupportedOperationException("Reduce not supported for " + this);
        }
	}
}
