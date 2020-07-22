package com.dat3m.dartagnan.expression.op;

import static com.dat3m.dartagnan.utils.Settings.USEBV;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;

public enum IOpBin {
    PLUS, MINUS, MULT, DIV, MOD, AND, OR, XOR, L_SHIFT, R_SHIFT, AR_SHIFT;
	
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
        }
        return super.toString();
    }

    public String toLinuxName(){
        switch(this){
            case PLUS:
                return "add";
            case MINUS:
                return "sub";
            case MULT:
                return "mult";
            case DIV:
                return "div";
            case MOD:
                return "mod";
            case AND:
                return "and";
            case OR:
                return "or";
            case XOR:
                return "xor";
            case L_SHIFT:
                return "shl";
            case R_SHIFT:
                return "lshr";
            case AR_SHIFT:
                return "ashr";
            default:
            	throw new UnsupportedOperationException("Linux op name is not defined for " + this);
        }
    }

    public Expr encode(Expr e1, Expr e2, Context ctx){
        switch(this){
            case PLUS:
            	return USEBV ? ctx.mkBVAdd((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkAdd((IntExpr)e1, (IntExpr)e2);            		
            case MINUS:
            	return USEBV ? ctx.mkBVSub((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkSub((IntExpr)e1, (IntExpr)e2);
            case MULT:
            	return USEBV ? ctx.mkBVMul((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkMul((IntExpr)e1, (IntExpr)e2);
            case DIV:
            	return USEBV ? ctx.mkBVSDiv((BitVecExpr)e1, (BitVecExpr)e2) :  ctx.mkDiv((IntExpr)e1, (IntExpr)e2);
            case MOD:
            	return USEBV ? ctx.mkBVSMod((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkMod((IntExpr)e1, (IntExpr)e2);
            case AND:
            	return USEBV ? 
            			ctx.mkBVAND((BitVecExpr)e1, (BitVecExpr)e2) : 
            			ctx.mkBV2Int(ctx.mkBVAND(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);	
            case OR:
            	return USEBV ? 
            			ctx.mkBVOR((BitVecExpr)e1, (BitVecExpr)e2) : 
            			ctx.mkBV2Int(ctx.mkBVOR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);	
            case XOR:
            	return USEBV ? 
            			ctx.mkBVXOR((BitVecExpr)e1, (BitVecExpr)e2) : 
            			ctx.mkBV2Int(ctx.mkBVXOR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case L_SHIFT:
            	return USEBV ? 
            			ctx.mkBVSHL((BitVecExpr)e1, (BitVecExpr)e2) : 
            			ctx.mkBV2Int(ctx.mkBVSHL(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case R_SHIFT:
            	return USEBV ? 
            			ctx.mkBVLSHR((BitVecExpr)e1, (BitVecExpr)e2) : 
            			ctx.mkBV2Int(ctx.mkBVLSHR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            case AR_SHIFT:
            	return USEBV ? 
            			ctx.mkBVASHR((BitVecExpr)e1, (BitVecExpr)e2) : 
            			ctx.mkBV2Int(ctx.mkBVASHR(ctx.mkInt2BV(32, (IntExpr)e1), ctx.mkInt2BV(32, (IntExpr)e2)), false);
            default:
                throw new UnsupportedOperationException("Encoding of not supported for IOpBin " + this);
        }
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
                return a / b;
            case MOD:
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
