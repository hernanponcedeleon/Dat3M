package com.dat3m.dartagnan.witness.svcomp;

/**
 * Names of the relations and axioms of {@code cat/svcomp.cat}
 * that witness extraction and validation rely on.
 */
public final class CatNames {

    /** Name of the relation that orders the events of an SV-COMP execution. */
    public static final String HB_RELATION = "hb-consistency";
    public static final String RF_RELATION = "rf";
    public static final String CO_RELATION = "co";
    public static final String FR_RELATION = "fr";
    /** Name of the flagged axiom that reports data races. */
    public static final String DATA_RACE_AXIOM = "data-race";

    private CatNames() { }
}
