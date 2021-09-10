package com.dat3m.dartagnan.analysis.saturation;

public class SolverStatistics {
    long modelConstructionTime;
    long searchTime;
    long resolutionTime;
    long reasonComputationTime;
    int modelSize;
    int numGuessedCoherences;
    int numComputedReasons;
    int saturationDepth;

    SolverStatistics() {
        modelConstructionTime = 0;
        searchTime = 0;
        resolutionTime = 0;
        reasonComputationTime = 0;
        modelSize = 0;
        numGuessedCoherences = 0;
        numComputedReasons = 0;
        saturationDepth = 0;
    }

    public long getModelConstructionTime() { return modelConstructionTime; }
    public long getSearchTime() { return searchTime; }
    public long getResolutionTime() { return resolutionTime; }
    public long getReasonComputationTime() { return reasonComputationTime; }
    public int getModelSize() { return modelSize; }
    public int getNumGuessedCoherences() { return numGuessedCoherences; }
    public int getNumComputedReasons() { return numComputedReasons; }
    public int getSaturationDepth() { return saturationDepth; }

    public String toString() {
        StringBuilder str = new StringBuilder();
        str.append("Model construction time(ms): ").append(getModelConstructionTime()).append("\n");
        str.append("Model size (#events): ").append(modelSize).append("\n");
        str.append("Reason computation time(ms): ").append(getReasonComputationTime()).append("\n");
        str.append("Resolution time(ms): ").append(getResolutionTime()).append("\n");
        str.append("Total search time(ms): ").append(getSearchTime()).append("\n");
        str.append("#Guessings: ").append(numGuessedCoherences).append("\n");
        str.append("#Computed reasons: ").append(numComputedReasons).append("\n");
        str.append("Saturation depth: ").append(saturationDepth);

        return str.toString();
    }
}
