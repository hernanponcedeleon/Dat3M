package com.dat3m.dartagnan.analysis.graphRefinement;

public class RefinementStats {
    long modelConstructionTime;
    long searchTime;
    long resolutionTime;
    long violationComputationTime;
    int modelSize;
    int numGuessedCoherences;
    int numComputedViolations;
    int saturationDepth;

    RefinementStats() {
        modelConstructionTime = 0;
        searchTime = 0;
        resolutionTime = 0;
        violationComputationTime = 0;
        modelSize = 0;
        numGuessedCoherences = 0;
        numComputedViolations = 0;
        saturationDepth = 0;
    }

    public long getModelConstructionTime() { return modelConstructionTime; }
    public long getSearchTime() { return searchTime; }
    public long getResolutionTime() { return resolutionTime; }
    public long getViolationComputationTime() { return violationComputationTime; }
    public int getModelSize() { return modelSize; }
    public int getNumGuessedCoherences() { return numGuessedCoherences; }
    public int getNumComputedViolations() { return numComputedViolations; }
    public int getSaturationDepth() { return saturationDepth; }

    public String toString() {
        StringBuilder str = new StringBuilder();
        str.append("Model construction time(ms): ").append(getModelConstructionTime()).append("\n");
        str.append("Model size (#events): ").append(modelSize).append("\n");
        str.append("Violation computation time(ms): ").append(getViolationComputationTime()).append("\n");
        str.append("Resolution time(ms): ").append(getResolutionTime()).append("\n");
        str.append("Total search time(ms): ").append(getSearchTime()).append("\n");
        str.append("Guessings: ").append(numGuessedCoherences).append("\n");
        str.append("Computed violations: ").append(numComputedViolations).append("\n");
        str.append("Saturation depth: ").append(saturationDepth).append("\n");

        return str.toString();
    }
}
