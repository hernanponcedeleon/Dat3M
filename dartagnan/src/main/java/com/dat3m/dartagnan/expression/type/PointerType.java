package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class PointerType implements Type {
    private int stride;
    private Type referredType;

    PointerType() {}


    public int getStride(){ return stride; };
    public void setStride(int s){ stride = s;};

    public Type getReferredType(){ return referredType; }
    public void setReferredType(Type t){ referredType = t;};

    @Override
    public String toString() {
        return "ptr";
    }

    @Override
    public boolean equals(Object obj) {
        return obj != null && obj.getClass() == this.getClass();
    }

}
