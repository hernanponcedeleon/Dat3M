package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;
import com.google.common.collect.ImmutableSet;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;

public class INonDet extends IExpr implements ExprInterface {
	
	private INonDetTypes type;
	
	public INonDet(INonDetTypes type) {
		this.type = type;
	}

	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public Expr toZ3NumExpr(Event e, EncodingConf conf) {
		String name = Integer.toString(hashCode());
		Context ctx = conf.getCtx();
		return conf.getBP() ? ctx.mkBVConst(name, 32) : ctx.mkIntConst(name);
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf) {
		String name = Integer.toString(hashCode());
		Context ctx = conf.getCtx();
		return conf.getBP() ? ctx.mkBVConst(name, 32) : ctx.mkIntConst(name);
	}

	@Override
	public int getIntValue(Event e, Model model, EncodingConf conf) {
		return Integer.parseInt(model.getConstInterp(toZ3NumExpr(e, conf)).toString());
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

	public long getMin(boolean bp) {
        switch(type){
        case INT:
            return Integer.MIN_VALUE;
        case UINT:
            return UnsignedInteger.ZERO.longValue();
		case LONG:
            return bp ? Integer.MIN_VALUE : Long.MIN_VALUE;
		case ULONG:
            return UnsignedLong.ZERO.longValue();
		case SHORT:
            return Short.MIN_VALUE;
		case USHORT:
            return 0;
		case CHAR:
            return -128;
		case UCHAR:
            return 0;
        }
        throw new UnsupportedOperationException("getMin() not supported for " + this);
	}

	public long getMax(boolean bp) {
        switch(type){
        case INT:
            return Integer.MAX_VALUE;
        case UINT:
            return bp ? Integer.MAX_VALUE : UnsignedInteger.MAX_VALUE.longValue();
		case LONG:
            return bp ? Integer.MAX_VALUE : Long.MAX_VALUE;
		case ULONG:
            return bp ? Integer.MAX_VALUE : UnsignedLong.MAX_VALUE.longValue();
		case SHORT:
            return bp ? Integer.MAX_VALUE : Short.MAX_VALUE;
		case USHORT:
            return 65535;
		case CHAR:
            return 127;
		case UCHAR:
            return 255;
        }
        throw new UnsupportedOperationException("getMax() not supported for " + this);
	}
}
