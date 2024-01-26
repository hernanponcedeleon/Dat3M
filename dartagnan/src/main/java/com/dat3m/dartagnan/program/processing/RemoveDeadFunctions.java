package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;

/*
    This pass removes functions which are "dead".
    A function is dead if:
    - it is not the entry point, i.e., it is not main
    - it is not a thread
    - it is not referenced in the code (e.g., by a function call) nor memory.
    - it is not an intrinsic.
 */
public class RemoveDeadFunctions implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(RemoveDeadFunctions.class);

    private RemoveDeadFunctions() { }

    public static RemoveDeadFunctions newInstance() {
        return new RemoveDeadFunctions();
    }

    @Override
    public void run(Program program) {
        final Set<Function> reachableFunctions = findReachableFunctions(program);

        for (Function func : List.copyOf(program.getFunctions())) {
            if (!reachableFunctions.contains(func)) {
                program.removeFunction(func);
                logger.debug("Removed dead function: {}", func.getName());
            }
        }
    }

    private Set<Function> findReachableFunctions(Program program) {
        final FunctionCollector functionCollector = new FunctionCollector();

        // (1) Find functions referenced by memory
        for (MemoryObject memoryObject : program.getMemory().getObjects()) {
            for (Integer field : memoryObject.getStaticallyInitializedFields()) {
                memoryObject.getInitialValue(field).accept(functionCollector);
            }
        }

        // (2) Collect all functions that are initially reachable
        final Set<Function> reachableFunctions = new HashSet<>();
        reachableFunctions.addAll(functionCollector.collectedFunctions);
        reachableFunctions.addAll(program.getThreads()); // threads are reachable
        program.getFunctionByName("main").ifPresent(reachableFunctions::add); // "main" is reachable
        program.getFunctions().stream().filter(Function::isIntrinsic).forEach(reachableFunctions::add); // intrinsics

        // (3) For all reachable functions, find which other functions it can reach.
        final Queue<Function> workqueue = new ArrayDeque<>(reachableFunctions);
        while (!workqueue.isEmpty()) {
            final Function func = workqueue.remove();
            if (!func.hasBody()) {
                continue;
            }
            functionCollector.reset();
            for (RegReader reader : func.getEvents(RegReader.class)) {
                reader.transformExpressions(functionCollector);
            }
            functionCollector.collectedFunctions.stream().filter(reachableFunctions::add).forEach(workqueue::add);
        }

        return reachableFunctions;
    }

    private static class FunctionCollector implements ExpressionInspector {

        private final Set<Function> collectedFunctions = new HashSet<>();

        public void reset() { collectedFunctions.clear(); }

        @Override
        public Expression visitFunction(Function function) {
            collectedFunctions.add(function);
            return function;
        }
    }
}
