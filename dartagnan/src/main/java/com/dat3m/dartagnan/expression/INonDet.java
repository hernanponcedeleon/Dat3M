package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;

import static com.dat3m.dartagnan.expression.INonDetTypes.UCHAR;
import static com.dat3m.dartagnan.expression.INonDetTypes.UINT;
import static com.dat3m.dartagnan.expression.INonDetTypes.ULONG;
import static com.dat3m.dartagnan.expression.INonDetTypes.USHORT;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;

public class INonDet extends IExpr implements ExprInterface {
	
	private INonDetTypes type;
	private final int precision;
	
	public INonDet(INonDetTypes type, int precision) {
		this.type = type;
		this.precision = precision;
	}

	public INonDetTypes getType() {
		return type;
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

	public long getMin() {
        switch(type){
        case INT:
            return Integer.MIN_VALUE;
        case UINT:
            return UnsignedInteger.ZERO.longValue();
		case LONG:
            return Long.MIN_VALUE;
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

	public long getMax() {
        switch(type){
        case INT:
            return Integer.MAX_VALUE;
        case UINT:
            return UnsignedInteger.MAX_VALUE.longValue();
		case LONG:
            return Long.MAX_VALUE;
		case ULONG:
            return UnsignedLong.MAX_VALUE.longValue();
		case SHORT:
            return Short.MAX_VALUE;
		case USHORT:
            return 65535;
		case CHAR:
            return 127;
		case UCHAR:
            return 255;
        }
        throw new UnsupportedOperationException("getMax() not supported for " + this);
	}

	@Override
	public int getPrecision() {
		return precision;
	}
	
	public BoolExpr encodeBounds(boolean bp, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		long min = getMin();
		long max = getMax();
		if(bp) {
			if(type.equals(UINT) || type.equals(ULONG) || type.equals(USHORT) || type.equals(UCHAR)) {
	        	enc = ctx.mkAnd(enc, ctx.mkBVUGE((BitVecExpr)toZ3Int(null,ctx), ctx.mkBV(min, precision)));
	        	enc = ctx.mkAnd(enc, ctx.mkBVULE((BitVecExpr)toZ3Int(null,ctx), ctx.mkBV(max, precision)));					
			} else {
	        	enc = ctx.mkAnd(enc, ctx.mkBVSGE((BitVecExpr)toZ3Int(null,ctx), ctx.mkBV(min, precision)));
	        	enc = ctx.mkAnd(enc, ctx.mkBVSLE((BitVecExpr)toZ3Int(null,ctx), ctx.mkBV(max, precision)));					
			}
		} else {
        	enc = ctx.mkAnd(enc, ctx.mkGe((IntExpr)toZ3Int(null,ctx), ctx.mkInt(min)));
        	enc = ctx.mkAnd(enc, ctx.mkLe((IntExpr)toZ3Int(null,ctx), ctx.mkInt(max)));
		}
		return enc;
	}
}
