package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public enum IOpBin {
    PLUS, MINUS, MULT, DIV, UDIV, MOD, AND, OR, XOR, LSHIFT, RSHIFT, ARSHIFT, SREM, UREM;
	
	public static List<IOpBin> BWOps = Arrays.asList(UDIV, AND, OR, XOR, LSHIFT, RSHIFT, ARSHIFT, SREM, UREM); 
	
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
            case LSHIFT:
                return "<<";
            case RSHIFT:
                return ">>>";
            case ARSHIFT:
                return ">>";
            default:
            	return super.toString();        	
        }
    }

    public String getName(){
        return this.name().toLowerCase();
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
            case LSHIFT:
                return a.shiftLeft(b.intValue());
            case RSHIFT:
                if (a.signum() < 0) {
                    // BigInteger does not support logical shift on negative values
                    throw new UnsupportedOperationException("No support for " + this + " on negative values.");
                }
                // For non-negative values, a logical shift is identical to a regular shift
            case ARSHIFT:
                return a.shiftRight(b.intValue());
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IOpBin");
    }
}
