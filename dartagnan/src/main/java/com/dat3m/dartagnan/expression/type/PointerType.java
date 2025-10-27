package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class PointerType implements Type {

    public int size = 64;

    PointerType() {}

    PointerType(int size) {
        this.size = size;
    }


    @Override
    public String toString() {
        return "ptr_"+ size;
    }

    @Override
    public boolean equals(Object obj) {
        return obj != null && obj.getClass() == this.getClass();
    }

}
