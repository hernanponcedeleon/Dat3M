package com.dat3m.dartagnan.witness.svcomp;

import java.util.List;
import java.util.Objects;

public record ViolationWitness(Metadata metadata, List<Segment> segments) implements Witness {

    public ViolationWitness {
        Objects.requireNonNull(metadata);
        segments = List.copyOf(segments);
    }
}
