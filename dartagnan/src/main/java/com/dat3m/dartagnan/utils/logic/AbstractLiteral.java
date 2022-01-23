package com.dat3m.dartagnan.utils.logic;


public abstract class AbstractLiteral<T extends Literal<T>> implements Literal<T> {

    protected final String name;
    protected final boolean isNegative;

    protected AbstractLiteral(String name, boolean isNegative) {
        this.name = name;
        this.isNegative = isNegative;
    }

    @Override
    public String getName() { return name; }

    @Override
    public boolean isPositive() { return !isNegative; }

    @Override
    public boolean isNegative() { return isNegative; }

    // The following methods are made abstract to force subclasses to overwrite them.

    @Override
    public abstract int hashCode();

    @Override
    public abstract boolean equals(Object obj);

    @Override
    public abstract String toString();


    protected final int baseHashCode() {
        return 31*name.hashCode() + 3*Boolean.hashCode(isNegative);
    }

    protected final boolean baseEquals(AbstractLiteral<T> lit) {
        return this.isNegative == lit.isNegative && this.name.equals(lit.name);
    }

    protected final String toStringBase() {
        return (isNegative ? "~" : "") + name;
    }
}
