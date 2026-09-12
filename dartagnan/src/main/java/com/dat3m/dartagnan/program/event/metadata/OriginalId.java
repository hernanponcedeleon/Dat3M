package com.dat3m.dartagnan.program.event.metadata;

import com.dat3m.dartagnan.utils.metadata.Metadata;

// Used as a snapshot of the global ID after the program has been constructed (either programmatically or via a parser).
public record OriginalId(int value) implements Metadata { }
