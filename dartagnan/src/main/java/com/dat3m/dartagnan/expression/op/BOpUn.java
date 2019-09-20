package com.dat3m.dartagnan.expression.op;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public enum BOpUn {
    ID, NOT;

    @Override
    public String toString() {
    	switch(this) {
    	case NOT:
        	return "!";
		default:
			return "";    	
    	}
    }

    public BoolExpr encode(BoolExpr e, Context ctx) {
    	switch(this) {
    	case NOT:
        	return ctx.mkNot(e);
		default:
			return e;    	
    	}
    }

    public boolean combine(boolean a){
    	switch(this) {
    	case NOT:
        	return !a;
		default:
			return a;    	
    	}
    }
}
