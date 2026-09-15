package com.dat3m.dartagnan.metadata;

import java.nio.file.Path;

public sealed interface SourceLocation extends Metadata {

    record SourcePath(Path sourcePath) implements SourceLocation {
        @Override
        public String toString() {
            return sourcePath.toString();
        }
    }

    record Litmus(String threadName, int lineNumber) implements SourceLocation {
        @Override
        public String toString() {
            return threadName + "#" + lineNumber;
        }
    }

    record Generic(String source, int lineNumber) implements SourceLocation {
        @Override
        public String toString() {
            // If source is a path, we take the last path element
            // if source is not a path, the function will return it as is
            final String name = Path.of(source).getFileName().toString();
            return name + "#" + lineNumber;
        }
    }
}