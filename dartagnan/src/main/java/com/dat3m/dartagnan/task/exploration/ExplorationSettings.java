package com.dat3m.dartagnan.task.exploration;

/*
    Settings of an exploration (see ExplorationTaskSolver for their description).
    A bound of 0 means unbounded.
 */
record ExplorationSettings(
        ExplorationOrder order,
        int maxEventsPerThread,
        boolean awaits,
        boolean spinLast,
        boolean printExecutions,
        int threads
) {}
