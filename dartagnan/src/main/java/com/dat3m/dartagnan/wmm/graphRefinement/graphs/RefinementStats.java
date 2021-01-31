package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

public class RefinementStats {
    long modelConstructionTime;
    long searchTime;
    long resolutionTime;
    long violationComputationTime;
    int numGuessedCoherences;
    int numComputedViolations;

    RefinementStats() {
        modelConstructionTime = 0;
        searchTime = 0;
        resolutionTime = 0;
        violationComputationTime = 0;
        numGuessedCoherences = 0;
        numComputedViolations = 0;
    }

    public long getModelConstructionTime() { return modelConstructionTime; }
    public long getSearchTime() { return searchTime; }
    public long getResolutionTime() { return resolutionTime; }
    public long getViolationComputationTime() { return violationComputationTime; }
    public int getNumGuessedCoherences() { return numGuessedCoherences; }
    public int getNumComputedViolations() { return numComputedViolations; }

    public String toString() {
        StringBuilder str = new StringBuilder();
        str.append("Model construction time(ms): ").append(getModelConstructionTime()).append("\n");
        str.append("Violation computation time(ms): ").append(getViolationComputationTime()).append("\n");
        str.append("Resolution time(ms): ").append(getResolutionTime()).append("\n");
        str.append("Search time(ms): ").append(getSearchTime()).append("\n");
        str.append("Guessings: ").append(numGuessedCoherences).append("\n");
        str.append("Computed violations: ").append(numComputedViolations).append("\n");

        return str.toString();
    }
}
