package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IExprUn extends IExpr {

	private final ExprInterface b;
	private final IOpUn op;

    public IExprUn(IOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

	@Override
	public Expr toZ3Int(Event e, Context ctx) {
		return op.encode(b.toZ3Int(e, ctx), ctx);
	}

	@Override
	public Expr getLastValueExpr(Context ctx) {
        return op.encode(b.getLastValueExpr(ctx), ctx);
	}

	@Override
	public int getIntValue(Event e, Model model, Context ctx) {
        return -(b.getIntValue(e, model, ctx));
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b.getRegs()).build();
	}

    @Override
    public String toString() {
        return "(" + op + b + ")";
    }

    @Override
	public IConst reduce() {
        switch(op){
			case MINUS:
				return new IConst(-b.reduce().getValue(), b.getPrecision());
			case BV2UINT:
			case INT2BV1: case INT2BV8: case INT2BV16: case INT2BV32: case INT2BV64: 
			case TRUNC6432: case TRUNC6416: case TRUNC648: case TRUNC641: case TRUNC3216: case TRUNC328: case TRUNC321: case TRUNC168: case TRUNC161: case TRUNC81:
			case ZEXT18: case ZEXT116: case ZEXT132: case ZEXT164: case ZEXT816: case ZEXT832: case ZEXT864: case ZEXT1632: case ZEXT1664: case ZEXT3264: 
			case SEXT18: case SEXT116: case SEXT132: case SEXT164: case SEXT816: case SEXT832: case SEXT864: case SEXT1632: case SEXT1664: case SEXT3264:
				return b.reduce();
			default:
		        throw new UnsupportedOperationException("Reduce not supported for " + this);				
        }
	}

	@Override
	public int getPrecision() {
		return b.getPrecision();
	}
	
	@Override
	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase not supported for " + this);
	}
}
