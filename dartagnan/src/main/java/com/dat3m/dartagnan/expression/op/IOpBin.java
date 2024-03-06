package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.List;

public enum IOpBin {
    ADD, SUB, MUL, DIV, UDIV, MOD, AND, OR, XOR, LSHIFT, RSHIFT, ARSHIFT, SREM, UREM;
	
	public static List<IOpBin> BWOps = Arrays.asList(UDIV, AND, OR, XOR, LSHIFT, RSHIFT, ARSHIFT, SREM, UREM); 
	
    @Override
    public String toString() {
        switch(this){
            case ADD:
                return "+";
            case SUB:
                return "-";
            case MUL:
                return "*";
            case DIV, UDIV:
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
            case 0: return ADD;
            case 1: return SUB;
            case 2: return AND;
            case 3: return OR;
            default:
                throw new UnsupportedOperationException("The binary operator is not recognized");
        }
    }

    public BigInteger combine(BigInteger a, BigInteger b){
        switch(this){
            case ADD:
                return a.add(b);
            case SUB:
                return a.subtract(b);
            case MUL:
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
