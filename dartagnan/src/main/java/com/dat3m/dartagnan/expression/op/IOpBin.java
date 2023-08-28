package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

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

    public static IOpBin intToOp(int i) {
        switch(i) {
            case 0: return PLUS;
            case 1: return MINUS;
            case 2: return AND;
            case 3: return OR;
            default:
                throw new UnsupportedOperationException("The binary operator is not recognized");
        }
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
                return a.mod(b);
            case SREM:
            case UREM:
                return a.remainder(b);
            case AND:
                return a.and(b);
            case OR:
                return a.or(b);
            case XOR:
                return a.xor(b);
            case L_SHIFT:
                return a.shiftLeft(b.intValue());
            case R_SHIFT:
                if (a.signum() < 0) {
                    // BigInteger does not support logical shift on negative values
                    throw new UnsupportedOperationException("No support for " + this + " on negative values.");
                }
                // For non-negative values, a logical shift is identical to a regular shift
            case AR_SHIFT:
                return a.shiftRight(b.intValue());
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
    }
}
