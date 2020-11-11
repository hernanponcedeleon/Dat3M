package com.dat3m.dartagnan.expression.op;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;

public enum IOpUn {
    MINUS, 
    BV2UINT, 
    INT2BV1, INT2BV8, INT2BV16, INT2BV32, INT2BV64, 
    TRUNC6432, TRUNC6416,TRUNC648, TRUNC641, TRUNC3216, TRUNC328, TRUNC321, TRUNC168, TRUNC161, TRUNC81,    
    ZEXT18, ZEXT116, ZEXT132, ZEXT164, ZEXT816, ZEXT832, ZEXT864, ZEXT1632, ZEXT1664, ZEXT3264, 
    SEXT18, SEXT116, SEXT132, SEXT164, SEXT816, SEXT832, SEXT864, SEXT1632, SEXT1664, SEXT3264;
	
    @Override
    public String toString() {
        switch(this){
    	case MINUS:
    		return "-";
        default:
        	return "";
        }
    }

    public Expr encode(Expr e, Context ctx) {
    	switch(this){
    		case MINUS:
    			return e.isBV() ? ctx.mkBVSub(ctx.mkBV(0, 32), (BitVecExpr)e) : ctx.mkSub(ctx.mkInt(0), (IntExpr)e);
    		case BV2UINT:
    			return e.isBV() ? ctx.mkBV2Int((BitVecExpr)e, false) : e;
    		// ============ INT2BV ============
    		case INT2BV1:
    			return e.isBV() ? e : ctx.mkInt2BV(1, (IntExpr)e);
    		case INT2BV8:
    			return e.isBV() ? e : ctx.mkInt2BV(8, (IntExpr)e);
    		case INT2BV16:
    			return e.isBV() ? e : ctx.mkInt2BV(16, (IntExpr)e);
    		case INT2BV32:
    			return e.isBV() ? e : ctx.mkInt2BV(32, (IntExpr)e);
    		case INT2BV64:
    			return e.isBV() ? e : ctx.mkInt2BV(64, (IntExpr)e);
        	// ============ TRUNC ============    		
    		case TRUNC6432:
    			return e.isBV() ? ctx.mkExtract(31, 0, (BitVecExpr)e) : e;
    		case TRUNC6416:
    		case TRUNC3216:
    			return e.isBV() ? ctx.mkExtract(15, 0, (BitVecExpr)e) : e;
    		case TRUNC648:
    		case TRUNC328:
    		case TRUNC168:
    			return e.isBV() ? ctx.mkExtract(7, 0, (BitVecExpr)e) : e;
    		case TRUNC641:
    		case TRUNC321:
    		case TRUNC161:
    		case TRUNC81:
    			return e.isBV() ? ctx.mkExtract(0, 0, (BitVecExpr)e) : e;    		
        	// ============ ZEXT ============    		
    		case ZEXT18:
    			return e.isBV() ? ctx.mkZeroExt(7, (BitVecExpr)e) : e;
    		case ZEXT116:
    			return e.isBV() ? ctx.mkZeroExt(15, (BitVecExpr)e) : e;
    		case ZEXT132:
    			return e.isBV() ? ctx.mkZeroExt(31, (BitVecExpr)e) : e;
    		case ZEXT164:
    			return e.isBV() ? ctx.mkZeroExt(63, (BitVecExpr)e) : e;
    		case ZEXT816:
    			return e.isBV() ? ctx.mkZeroExt(8, (BitVecExpr)e) : e;
    		case ZEXT832:
    			return e.isBV() ? ctx.mkZeroExt(24, (BitVecExpr)e) : e;
    		case ZEXT864:
    			return e.isBV() ? ctx.mkZeroExt(56, (BitVecExpr)e) : e;
    		case ZEXT1632:
    			return e.isBV() ? ctx.mkZeroExt(16, (BitVecExpr)e) : e;
    		case ZEXT1664:
    			return e.isBV() ? ctx.mkZeroExt(484, (BitVecExpr)e) : e;
    		case ZEXT3264:
    			return e.isBV() ? ctx.mkZeroExt(32, (BitVecExpr)e) : e;
        	// ============ SEXT ============
    		case SEXT18:
    			return e.isBV() ? ctx.mkSignExt(7, (BitVecExpr)e) : e;
    		case SEXT116:
    			return e.isBV() ? ctx.mkSignExt(15, (BitVecExpr)e) : e;
    		case SEXT132:
    			return e.isBV() ? ctx.mkSignExt(31, (BitVecExpr)e) : e;
    		case SEXT164:
    			return e.isBV() ? ctx.mkSignExt(63, (BitVecExpr)e) : e;
    		case SEXT816:
    			return e.isBV() ? ctx.mkSignExt(8, (BitVecExpr)e) : e;
    		case SEXT832:
    			return e.isBV() ? ctx.mkSignExt(24, (BitVecExpr)e) : e;
    		case SEXT864:
    			return e.isBV() ? ctx.mkSignExt(56, (BitVecExpr)e) : e;
    		case SEXT1632:
    			return e.isBV() ? ctx.mkSignExt(16, (BitVecExpr)e) : e;
    		case SEXT1664:
    			return e.isBV() ? ctx.mkSignExt(48, (BitVecExpr)e) : e;
    		case SEXT3264:
    			return e.isBV() ? ctx.mkSignExt(32, (BitVecExpr)e) : e;
    	}
        throw new UnsupportedOperationException("Encoding of not supported for IOpUn " + this);
    }
}
