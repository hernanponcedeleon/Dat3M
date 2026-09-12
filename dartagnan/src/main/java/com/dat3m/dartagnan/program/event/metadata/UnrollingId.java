package com.dat3m.dartagnan.program.event.metadata;

import com.dat3m.dartagnan.utils.metadata.Metadata;

// Used as a snapshot of the global ID right before unrolling.
public record UnrollingId(int value) implements Metadata { }
