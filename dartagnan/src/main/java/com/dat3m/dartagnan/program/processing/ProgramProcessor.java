package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.google.common.collect.Iterables;

/*
    A ProgramProcessor is an algorithm that runs on a program and somehow
    transforms it.
 */
public interface ProgramProcessor {

    void run(Program program);

    // =========================== Static utility ===========================

    enum Target {
        THREADS,
        FUNCTIONS,
        ALL
    }

    static ProgramProcessor fromFunctionProcessor(FunctionProcessor processor, Target type, boolean reassignIds) {
        return program -> {
            final Iterable<? extends Function> targets = switch (type) {
                case THREADS -> program.getThreads();
                case FUNCTIONS -> program.getFunctions();
                case ALL -> Iterables.concat(program.getThreads(), program.getFunctions());
            };
            targets.forEach(processor::run);
            if (reassignIds) {
                EventIdReassignment.newInstance().run(program);
            }
        };
    }
}