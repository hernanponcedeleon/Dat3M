package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;

public class INonDet extends IExpr implements ExprInterface {
	
	INonDetTypes type;;
	
	public INonDet(INonDetTypes type) {
		this.type = type;
	}

	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		return ctx.mkIntConst(Integer.toString(hashCode()));
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx) {
		return ctx.mkIntConst(Integer.toString(hashCode()));
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model) {
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
    }
        throw new UnsupportedOperationException("toString() not supported for " + this);
	}

	public long getMin() {
        switch(type){
        case INT:
            return Integer.MIN_VALUE;
        case UINT:
            return 0;
		case LONG:
            return Long.MIN_VALUE;
		case ULONG:
            return 0;
		case SHORT:
            return Short.MIN_VALUE;
		case USHORT:
            return 0;
    }
        throw new UnsupportedOperationException("getMin() not supported for " + this);
	}

	// TODO check how Z3 handles max values
	public long getMax() {
        return Integer.MAX_VALUE;
	}
}
