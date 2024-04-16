package com.dat3m.dartagnan.solver.onlineCaat.caat.predicates;

public abstract class AbstractDerivable implements Derivable {

    protected final int time;
    protected final int derivLength;

    protected AbstractDerivable(int time, int derivLength) {
        this.time = time;
        this.derivLength = derivLength;
    }

    @Override
    public int getTime() { return time; }

    @Override
    public int getDerivationLength() { return derivLength; }
}
