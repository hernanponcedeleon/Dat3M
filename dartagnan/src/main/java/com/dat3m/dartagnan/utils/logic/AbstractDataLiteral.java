package com.dat3m.dartagnan.utils.logic;

public abstract class AbstractDataLiteral<T extends Literal<T>, D> extends AbstractLiteral<T> {

    protected final D data;

    public D getData() { return data; }

    protected AbstractDataLiteral(String name, D data, boolean isNegative) {
        super(name, isNegative);
        this.data = data;
    }

    @Override
    public int hashCode() {
        return baseHashCode() + data.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }

        AbstractDataLiteral<T, D> lit = (AbstractDataLiteral<T, D>) obj;
        return baseEquals(lit) && lit.data.equals(this.data);
    }

    @Override
    public String toString() {
        return toStringBase() + "(" + data + ")";
    }
}
