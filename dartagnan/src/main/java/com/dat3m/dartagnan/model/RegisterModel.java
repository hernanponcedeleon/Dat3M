package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.expression.Type;

public record RegisterModel(Type type, String name, ThreadModel thread) {

    @Override
    public String toString() {
        return name;
    }

}
