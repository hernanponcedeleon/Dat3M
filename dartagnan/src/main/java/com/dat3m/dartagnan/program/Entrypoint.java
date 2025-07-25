package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.program.processing.transformers.MemoryTransformer;

import java.util.List;

public sealed interface Entrypoint {

    List<Function> getEntryFunctions();

    // Default value: usually designates an error
    final class None implements Entrypoint {
        @Override
        public List<Function> getEntryFunctions() {
            return List.of();
        }

        @Override
        public String toString() {
            return "No Entrypoint";
        }
    }

    // In case the parser already spawns the threads, e.g., like we do in Litmus code.
    final class Resolved implements Entrypoint {
        @Override
        public List<Function> getEntryFunctions() {
            return List.of();
        }

        @Override
        public String toString() {
            return "Resolved";
        }
    }

    // Standard entry point
    record Simple(Function function) implements Entrypoint {
    @Override
        public List<Function> getEntryFunctions() {
            return List.of(function);
        }

        @Override
        public String toString() {
            return "Entry@" + function.getName();
        }
    }

    record Grid(Function function, ThreadGrid threadGrid, MemoryTransformer memoryTransformer)
            implements Entrypoint {

        @Override
        public String toString() {
            return String.format("Entry@%s with %s", function.getName(), threadGrid);
        }

        @Override
        public List<Function> getEntryFunctions() {
            return List.of(function);
        }
    }


}
