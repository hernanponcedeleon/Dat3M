package com.dat3m.dartagnan.analysis.saturation.reasoning;

//TODO: Add some context field (implement some sort of refinement context?)
public abstract class AbstractLiteral implements CoreLiteral {

    public AbstractLiteral() {}

    @Override
    public boolean hasOpposite() {
        return false;
    }

    @Override
    public CoreLiteral getOpposite() {
        throw new UnsupportedOperationException(this + " has no opposing literals.");
    }
}
