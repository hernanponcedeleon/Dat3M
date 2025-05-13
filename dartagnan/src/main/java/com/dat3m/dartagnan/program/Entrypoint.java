package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.processing.transformers.MemoryTransformer;

public sealed interface Entrypoint {

    Function getEntryFunction();

    // In case the parser already spawns the threads, e.g., like we do in Litmus code.
    final class Resolved implements Entrypoint {
        @Override
        public Function getEntryFunction() {
            return null;
        }

        @Override
        public String toString() {
            return "Resolved";
        }
    }

    // Standard entry point
    final class Simple implements Entrypoint {
        private final Function function;
        public Simple(Function function) {
            this.function = function;
        }
        @Override
        public Function getEntryFunction() { return function; }

        @Override
        public String toString() {
            return "Entry@" + function.getName();
        }
    }

    // GPU entry point
    final class Grid implements Entrypoint {
        private final Function function;
        private final ThreadGrid threadGrid;
        private final MemoryTransformer memoryTransformer;

        public Grid(Function function, ThreadGrid grid, MemoryTransformer transformer) {
            this.function = function;
            this.threadGrid = grid;
            this.memoryTransformer = transformer;
        }

        @Override
        public String toString() {
            return String.format("Entry@%s with %s", function.getName(), threadGrid);
        }

        @Override
        public Function getEntryFunction() { return function; }
        public ThreadGrid getThreadGrid() { return threadGrid; }
        public MemoryTransformer getMemoryTransformer() { return memoryTransformer; }
    }


}
