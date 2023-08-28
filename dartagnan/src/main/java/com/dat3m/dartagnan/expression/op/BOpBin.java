package com.dat3m.dartagnan.expression.op;

public enum BOpBin {
    AND, OR;

    @Override
    public String toString() {
        switch(this){
            case AND:
                return "&&";
            case OR:
                return "||";
        }
        return super.toString();
    }

    public boolean combine(boolean a, boolean b){
        switch(this){
            case AND:
                return a && b;
            case OR:
                return a || b;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in BOpBin");
    }
}
