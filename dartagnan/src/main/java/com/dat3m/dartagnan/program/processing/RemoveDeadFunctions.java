package com.dat3m.dartagnan.program.processing;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.MemoryObject;


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

    private static final Logger logger = LoggerFactory.getLogger(RemoveDeadFunctions.class);

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
            for (Integer field : memoryObject.getInitializedFields()) {
                memoryObject.getInitialValue(field).accept(functionCollector);
            }
        }

        // (2) Collect all functions that are initially reachable
        final Set<Function> reachableFunctions = new HashSet<>();
        reachableFunctions.addAll(functionCollector.collectedFunctions);
        reachableFunctions.addAll(program.getThreads()); // threads are reachable
        reachableFunctions.addAll(program.getEntrypoint().getEntryFunctions()); // entry points are reachable
        program.getFunctions().stream().filter(Function::isIntrinsic).forEach(reachableFunctions::add); // intrinsics

        // (3) For all reachable functions, find which other functions it can reach.
        final Queue<Function> workqueue = new ArrayDeque<>(program.getThreads());
        workqueue.addAll(reachableFunctions);
        while (!workqueue.isEmpty()) {
            final Function func = workqueue.remove();
            functionCollector.reset();
            liveFunctions(func, functionCollector);
            for (Function f : functionCollector.collectedFunctions) {
                if (reachableFunctions.add(f)) {
                    workqueue.add(f);
                }
            }
        }

        return reachableFunctions;
    }

    private void liveFunctions(Function function, FunctionCollector liveFunctions) {
        final var liveRegisters = new HashSet<Register>();
        final List<Event> events = function.getEvents();
        final List<HashSet<Register>> jumps = events.stream().map(e -> new HashSet<Register>()).toList();
        for (int i = events.size() - 1; i >= 0; i--) {
            Event event = events.get(i);
            if (IRHelper.isAlwaysBranching(event)) { liveRegisters.clear(); }
            liveRegisters.addAll(jumps.get(i));
            if (event instanceof Label label) {
                for (CondJump jump : label.getJumpSet()) {
                    final int j = events.indexOf(jump);
                    if (!jump.isDead() && jumps.get(j).addAll(liveRegisters)) {
                        // Redo, if there is a backjump.
                        i = Integer.max(i, j + 1);
                    }
                }
            }
            final Collection<Expression> expressions = liveFunctionExpressions(event, liveRegisters);
            expressions.forEach(x -> x.accept(liveFunctions));
            expressions.forEach(x -> liveRegisters.addAll(x.getRegs()));
        }
    }

    // Expressions that may contain pointers to functions that should not be removed.
    private Collection<Expression> liveFunctionExpressions(Event event, Set<Register> liveRegisters) {
        final var expressions = new ArrayList<Expression>();
        if (!(event instanceof RegReader reader)) {
            return expressions;
        }
        final Expression exception = event instanceof CondJump j ? j.getGuard()
                : event instanceof Local e && !liveRegisters.contains(e.getResultRegister()) ? e.getExpr() : null;
        final var collector = new ExpressionVisitor<Expression>() {
            @Override
            public Expression visitExpression(Expression x) {
                if (!x.equals(exception)) {
                    expressions.add(x);
                }
                return x;
            }
        };
        reader.transformExpressions(collector);
        return expressions;
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
