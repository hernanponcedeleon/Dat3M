package com.dat3m.dartagnan.expression.op;

public enum BOpUn {
    NOT;

    @Override
    public String toString() {
       	return "!";
    }

    public boolean combine(boolean a){
       	return !a;
    }
}
