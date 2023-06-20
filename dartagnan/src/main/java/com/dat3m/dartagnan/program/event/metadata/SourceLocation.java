package com.dat3m.dartagnan.program.event.metadata;


public record SourceLocation(String sourceCodeFilePath, int lineNumber) implements Metadata {

    public String getSourceCodeFileName() {
        return sourceCodeFilePath.contains("/")
                ? sourceCodeFilePath.substring(sourceCodeFilePath.lastIndexOf("/") + 1)
                : sourceCodeFilePath;
    }

    @Override
    public String toString() {
        return String.format("@%s#%s", getSourceCodeFileName(), lineNumber());
    }

}
