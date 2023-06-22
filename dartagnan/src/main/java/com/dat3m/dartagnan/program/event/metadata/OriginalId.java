package com.dat3m.dartagnan.program.event.metadata;

// Used as a snapshot of the global ID after the program has been constructed (either programmatically or via a parser).
public record OriginalId(int value) implements Metadata { }
