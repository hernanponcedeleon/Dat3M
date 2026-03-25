package com.dat3m.dartagnan.program.event.metadata;

public sealed interface SourceLocation extends Metadata {

    int getLineNumber();

    record Litmus(String threadName, int lineNumber) implements SourceLocation {
        @Override
        public int getLineNumber() { return lineNumber; }

        @Override
        public String toString() {
            return threadName + "#" + lineNumber;
        }
    }

    record Generic(String sourceCodeFilePath, int lineNumber) implements SourceLocation {
        @Override
        public int getLineNumber() { return lineNumber; }

        public String getSourceCodeFileName() {
            final String path = sourceCodeFilePath;
            return path.contains("/") ? path.substring(path.lastIndexOf("/") + 1) : path;
        }

        @Override
        public String toString() {
            return getSourceCodeFileName() + "#" + lineNumber;
        }
    }
}