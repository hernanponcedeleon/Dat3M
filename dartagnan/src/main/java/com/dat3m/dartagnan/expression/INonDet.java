package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;

public class INonDet extends IExpr implements ExprInterface {
	
	private INonDetTypes type;
	private final int precision;
	
	public INonDet(INonDetTypes type, int precision) {
		this.type = type;
		this.precision = precision;
	}

	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public Expr toZ3Int(Event e, Context ctx) {
		String name = Integer.toString(hashCode());
		return precision > 0 ? ctx.mkBVConst(name, precision) : ctx.mkIntConst(name);
	}

	@Override
	public Expr getLastValueExpr(Context ctx) {
		String name = Integer.toString(hashCode());
		return precision > 0 ? ctx.mkBVConst(name, precision) : ctx.mkIntConst(name);
	}

	@Override
	public int getIntValue(Event e, Model model, Context ctx) {
		return Integer.parseInt(model.getConstInterp(toZ3Int(e, ctx)).toString());
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}
	
	@Override
	public String toString() {
        switch(type){
        case INT:
            return "nondet_int()";
        case UINT:
            return "nondet_uint()";
		case LONG:
			return "nondet_long()";
		case ULONG:
			return "nondet_ulong()";
		case SHORT:
			return "nondet_short()";
		case USHORT:
			return "nondet_ushort()";
		case CHAR:
			return "nondet_char()";
		case UCHAR:
			return "nondet_uchar()";
        }
        throw new UnsupportedOperationException("toString() not supported for " + this);
	}

	@Override
	public int getPrecision() {
		return precision;
	}
}
