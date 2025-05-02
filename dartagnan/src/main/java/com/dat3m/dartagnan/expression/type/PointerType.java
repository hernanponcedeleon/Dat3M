package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class PointerType implements Type {

    PointerType() {
    }

    @Override
    public String toString() {
        return "ptr";
    }

    @Override
    public boolean equals(Object obj) {
        return obj != null && obj.getClass() == this.getClass();
    }

}
