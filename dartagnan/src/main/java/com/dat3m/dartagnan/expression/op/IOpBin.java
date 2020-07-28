package com.dat3m.dartagnan.expression.op;

import com.dat3m.dartagnan.utils.EncodingConf;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;

public enum IOpBin {
    PLUS, MINUS, MULT, DIV, UDIV, MOD, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT, SREM, UREM;
	
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

    public Expr encode(Expr e1, Expr e2, EncodingConf conf){
    	Context ctx = conf.getCtx();
    	boolean bp = conf.getBP();
		switch(this){
            case PLUS:
            	return bp ? ctx.mkBVAdd((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkAdd((IntExpr)e1, (IntExpr)e2);            		
            case MINUS:
            	return bp ? ctx.mkBVSub((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkSub((IntExpr)e1, (IntExpr)e2);
            case MULT:
            	return bp ? ctx.mkBVMul((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkMul((IntExpr)e1, (IntExpr)e2);
            case DIV:
            	return bp ? ctx.mkBVSDiv((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkDiv((IntExpr)e1, (IntExpr)e2);
            case UDIV:
            	return bp ? ctx.mkBVUDiv((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVUDiv(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case MOD:
            	return bp ? ctx.mkBVSMod((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkMod((IntExpr)e1, (IntExpr)e2);
            case AND:
            	return bp ? ctx.mkBVAND((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVAND(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);	
            case OR:
            	return bp ? ctx.mkBVOR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVOR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);	
            case XOR:
            	return bp ? ctx.mkBVXOR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVXOR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case L_SHIFT:
            	return bp ? ctx.mkBVSHL((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVSHL(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case R_SHIFT:
            	return bp ? ctx.mkBVLSHR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVLSHR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case AR_SHIFT:
            	return bp ? ctx.mkBVASHR((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVASHR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case SREM:
            	return bp ? ctx.mkBVSRem((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVSRem(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case UREM:
            	return bp ? ctx.mkBVURem((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkBV2Int(ctx.mkBVURem(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
        }
        throw new UnsupportedOperationException("Encoding of not supported for IOpBin " + this);
    }

    public int combine(int a, int b){
        switch(this){
            case PLUS:
                return a + b;
            case MINUS:
                return a - b;
            case MULT:
                return a * b;
            case DIV:
            case UDIV:
                return a / b;
            case MOD:
            case SREM:
            case UREM:
                return a % b;
            case AND:
                return a & b;
            case OR:
                return a | b;
            case XOR:
                return a ^ b;
            case L_SHIFT:
                return a << b;
            case R_SHIFT:
                return a >>> b;
            case AR_SHIFT:
                return a >> b;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
    }
}
