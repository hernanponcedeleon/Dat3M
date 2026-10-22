package com.dat3m.dartagnan.witness.svcomp;

import java.util.Objects;

public record SvcompCorrectnessWitness(Metadata metadata) implements SvcompWitness {

    public SvcompCorrectnessWitness {
        Objects.requireNonNull(metadata);
    }
}
