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

    record Generic(Path sourcePath, int lineNumber) implements SourceLocation {

        public Generic(String sourcePath, int lineNumber) {
            this(Path.of(sourcePath), lineNumber);
        }

        @Override
        public String toString() {
            return sourcePath.getFileName() + "#" + lineNumber;
        }
    }
}