package com.dat3m.dartagnan.witness.svcomp;

import java.util.Objects;

public record CorrectnessWitness(Metadata metadata) implements Witness {

    public CorrectnessWitness {
        Objects.requireNonNull(metadata);
    }
}
