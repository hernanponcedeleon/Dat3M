package com.dat3m.dartagnan.analysis.saturation;

public class SolverStatistics {
    long modelConstructionTime;
    long reasonComputationTime;
    long consistencyCheckTime;
    int modelSize;
    int numComputedReasons;
    int numComputedReducedReasons;

    SolverStatistics() {
        modelConstructionTime = 0;
        reasonComputationTime = 0;
        modelSize = 0;
        numComputedReasons = 0;
        numComputedReducedReasons = 0;
    }

    public long getModelConstructionTime() { return modelConstructionTime; }
    public long getReasonComputationTime() { return reasonComputationTime; }
    public long getConsistencyCheckTime() { return consistencyCheckTime; }
    public int getModelSize() { return modelSize; }
    public int getNumComputedReasons() { return numComputedReasons; }
    public int getNumComputedReducedReasons() { return numComputedReducedReasons; }

    public String toString() {
        StringBuilder str = new StringBuilder();
        str.append("Model construction time(ms): ").append(getModelConstructionTime()).append("\n");
        str.append("Consistency check time(ms): ").append(getConsistencyCheckTime()).append("\n");
        str.append("Reason computation time(ms): ").append(getReasonComputationTime()).append("\n");
        str.append("Model size (#events): ").append(modelSize).append("\n");
        str.append("#Computed reasons: ").append(numComputedReasons).append("\n");
        str.append("#Computed reduced reasons: ").append(numComputedReducedReasons).append("\n");

        return str.toString();
    }
}
