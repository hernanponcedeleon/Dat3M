package com.dat3m.dartagnan.program.metadata;

import com.dat3m.dartagnan.utils.metadata.Metadata;

import java.nio.file.Path;
import java.util.Objects;

public record Source(Path path) implements Metadata {

    public Source {
        Objects.requireNonNull(path, "Source path cannot be null");
    }
}
