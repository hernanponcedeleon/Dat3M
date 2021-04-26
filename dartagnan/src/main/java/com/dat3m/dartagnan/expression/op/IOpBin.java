package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;

public enum IOpBin {
    PLUS, MINUS, MULT, DIV, UDIV, MOD, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT, SREM, UREM;
	
	public static List<IOpBin> BWOps = Arrays.asList(UDIV, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT, SREM, UREM); 
	
    @Override
    public String toString() {
        switch(this){
            case PLUS:
                return "+";
            case MINUS:
                return "-";
            case MULT:
                return "*";
            case DIV:
                return "/";
            case MOD:
                return "%";
            case AND:
                return "&";
            case OR:
                return "|";
            case XOR:
                return "^";
            case L_SHIFT:
                return "<<";
            case R_SHIFT:
                return ">>>";
            case AR_SHIFT:
                return ">>";
            default:
            	return super.toString();        	
        }
    }

    public String toLinuxName(){
        switch(this){
            case PLUS:
                return "add";
            case MINUS:
                return "sub";
            case AND:
                return "and";
            case OR:
                return "or";
            case XOR:
                return "xor";
            default:
            	throw new UnsupportedOperationException("Linux op name is not defined for " + this);
        }
    }

    public Expr encode(Expr e1, Expr e2, Context ctx){
		switch(this){
            case PLUS:
            	return e1.isBV() ? ctx.mkBVAdd((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkAdd((IntExpr)e1, (IntExpr)e2);            		
            case MINUS:
            	return e1.isBV() ? ctx.mkBVSub((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkSub((IntExpr)e1, (IntExpr)e2);
            case MULT:
            	return e1.isBV() ? ctx.mkBVMul((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkMul((IntExpr)e1, (IntExpr)e2);
            case DIV:
            	return e1.isBV() ? ctx.mkBVSDiv((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkDiv((IntExpr)e1, (IntExpr)e2);
            case UDIV:
            	return e1.isBV() ? ctx.mkBVUDiv((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVUDiv(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case MOD:
            	return e1.isBV() ? ctx.mkBVSMod((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkMod((IntExpr)e1, (IntExpr)e2);
            case AND:
            	return e1.isBV() ? ctx.mkBVAND((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVAND(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);	
            case OR:
            	return e1.isBV() ? ctx.mkBVOR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVOR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case XOR:
            	return e1.isBV() ? ctx.mkBVXOR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVXOR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case L_SHIFT:
            	return e1.isBV() ? ctx.mkBVSHL((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVSHL(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case R_SHIFT:
            	return e1.isBV() ? ctx.mkBVLSHR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVLSHR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case AR_SHIFT:
            	return e1.isBV() ? ctx.mkBVASHR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVASHR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case SREM:
            	return e1.isBV() ? ctx.mkBVSRem((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVSRem(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case UREM:
            	return e1.isBV() ? ctx.mkBVURem((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVURem(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
        }
        throw new UnsupportedOperationException("Encoding of not supported for IOpBin " + this);
    }

    public BigInteger combine(BigInteger a, BigInteger b){
        switch(this){
            case PLUS:
                return a.add(b);
            case MINUS:
                return a.subtract(b);
            case MULT:
                return a.multiply(b);
            case DIV:
            case UDIV:
                return a.divide(b);
            case MOD:
            case SREM:
            case UREM:
                return a.mod(b);
            case AND:
                return a.and(b);
            case OR:
                return a.or(b);
            case XOR:
                return a.xor(b);
            case L_SHIFT:
                return a.shiftLeft(b.intValue());
            case R_SHIFT:
            	// BigInteger do not support logical shift
                throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
            case AR_SHIFT:
                return a.shiftRight(b.intValue());
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
    }
}
