package com.dat3m.dartagnan.program.event.metadata;

import java.util.Collection;
import java.util.List;

public record SourceLocation(String sourceCodeFilePath, int lineNumber) implements Metadata {

    public String getSourceCodeFileName() {
        return getSourceCodeFileName(sourceCodeFilePath);
    }

    public static String getSourceCodeFileName(String path) {
        return path.contains("/") ? path.substring(path.lastIndexOf("/") + 1) : path;
    }

    public static String toString(String sourceCodeFilePath, Collection<Integer> lineNumbers) {
        final Object numbers = lineNumbers.size() != 1 ? lineNumbers : lineNumbers.iterator().next();
        return "@" + getSourceCodeFileName(sourceCodeFilePath) + "#" + numbers;
    }

    @Override
    public String toString() {
        return toString(sourceCodeFilePath, List.of(lineNumber));
    }
}
