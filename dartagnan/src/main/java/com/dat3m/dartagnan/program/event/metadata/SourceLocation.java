package com.dat3m.dartagnan.program.event.metadata;

import java.util.*;

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

    public static List<String> toStringList(Collection<SourceLocation> locations) {
        final List<String> stringList = new ArrayList<>();
        final Map<String, Set<Integer>> byPath = new TreeMap<>();
        for (SourceLocation location : locations) {
            byPath.computeIfAbsent(location.sourceCodeFilePath, k -> new TreeSet<>()).add(location.lineNumber);
        }
        for (Map.Entry<String, Set<Integer>> entry : byPath.entrySet()) {
            stringList.add(toString(entry.getKey(), entry.getValue()));
        }
        return stringList;
    }

    @Override
    public String toString() {
        return toString(sourceCodeFilePath, List.of(lineNumber));
    }
}
