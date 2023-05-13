package com.dat3m.dartagnan.program.event.metadata;


public class SourceLocation implements Metadata {

    private final String sourceCodeFilePath;
    private final int lineNumber;

    public SourceLocation(String sourceCodeFilePath, int lineNumber) {
        this.sourceCodeFilePath = sourceCodeFilePath;
        this.lineNumber = lineNumber;
    }

    public String getSourceCodeFilePath() {
        return sourceCodeFilePath ;
    }
    public int getLineNumber() { return lineNumber; }

    public String getSourceCodeFileName() {
        return sourceCodeFilePath.contains("/")
                ? sourceCodeFilePath.substring(sourceCodeFilePath.lastIndexOf("/") + 1)
                : sourceCodeFilePath;
    }

    @Override
    public String toString() {
        return String.format("@%s#%s", getSourceCodeFileName(), getLineNumber());
    }

    @Override
    public int hashCode() {
        return 31 * sourceCodeFilePath.hashCode() + lineNumber;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || obj.getClass() != this.getClass()) {
            return false;
        }

        final SourceLocation loc = (SourceLocation) obj;
        return this.sourceCodeFilePath.equals(loc.sourceCodeFilePath) && this.lineNumber == loc.lineNumber;
    }
}
