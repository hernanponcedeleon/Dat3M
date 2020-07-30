package com.dat3m.dartagnan.expression.op;

import com.dat3m.dartagnan.utils.EncodingConf;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;

public enum IOpUn {
    MINUS, INT2BV;

    @Override
    public String toString() {
        switch(this){
        	case MINUS:
        		return "-";
        	default:
        		return "";
        }
    }

    public Expr encode(Expr e, EncodingConf conf) {
    	Context ctx = conf.getCtx();
    	switch(this){
    		case MINUS:
    			return e instanceof BitVecExpr ? ctx.mkBVSub(ctx.mkBV(0, 32), (BitVecExpr)e) : ctx.mkSub(ctx.mkInt(0), (IntExpr)e);
    		case INT2BV:
    			return e instanceof BitVecExpr ? e : ctx.mkInt2BV(32, (IntExpr) e);
    	}
        throw new UnsupportedOperationException("Encoding of not supported for IOpUn " + this);
    }
}
