package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

import java.util.Objects;

public class PointerType extends IntegerType {

    private static final int ARCH_SIZE = TypeFactory.getInstance().getArchType().getBitWidth();

    protected Type pointedType;

    PointerType(Type pointedType) {
        super(ARCH_SIZE);
        this.pointedType = pointedType;
    }

    void setPointedType(Type type) {
        if (pointedType != null) {
            throw new IllegalArgumentException("Attempt to redefine ..");
        }
        pointedType = type;
    }

    public Type getPointedType() {
        return pointedType;
    }

    @Override
    public String toString() {
        if (pointedType == null) {
            return "tmp ptr";
        }
        if (!recursion) {
            recursion = true;
            String result = pointedType + "*";
            recursion = false;
            return result;
        }
        return "ptr";
    }

    private boolean recursion = false;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        if (!super.equals(o)) {
            return false;
        }
        if (!recursion) {
            if (!((PointerType) o).recursion) {
                recursion = true;
                boolean result = Objects.equals(pointedType, ((PointerType) o).pointedType);
                recursion = false;
                return result;
            }
            return false;
        }
        return ((PointerType) o).recursion;
    }

    @Override
    public int hashCode() {
        if (!recursion) {
            recursion = true;
            int hash = Objects.hash(super.hashCode(), pointedType);
            recursion = false;
            return hash;
        }
        return 0;
    }
}
