package com.dat3m.dartagnan.witness.svcomp;

import java.util.List;
import java.util.Objects;

public record SvcompViolationWitness(Metadata metadata, List<Segment> segments) implements SvcompWitness {

    public SvcompViolationWitness {
        Objects.requireNonNull(metadata);
        segments = List.copyOf(segments);
    }
}
