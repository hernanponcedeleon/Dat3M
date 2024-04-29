package com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates;

public interface Derivable {

    int getTime();
    int getDerivationLength();

    Derivable with(int time, int derivationLength);


    // ================== Defaults ====================
    default Derivable withTime(int time) { return with(time, getDerivationLength()); }
    default Derivable withDerivationLength(int derivationLength) { return with(getTime(), getDerivationLength()); }
}
