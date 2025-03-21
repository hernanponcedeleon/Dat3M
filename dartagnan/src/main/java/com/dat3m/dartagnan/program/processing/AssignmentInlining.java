package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.DominatorAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.utils.DominatorTree;

import java.util.HashMap;
import java.util.Map;

/*
    This pass performs the following inlining of assignments:

          r = someExpr;      =====>       r = someExpr;
          RegReader(r);      =====>       RegReader(someExpr); // uses "someExpr" directly

    The inlined assignments are dead and can be eliminated by dead assignment eliminations.
    To avoid duplication of "someExpr", the pass only inlines assignments if the assigned register is used only once.
    To achieve this, the pass scans the code twice: once to collect usage statistics and once to perform the inlining.
 */
public class AssignmentInlining implements FunctionProcessor {

    private AssignmentInlining() { }

    public static AssignmentInlining newInstance() {
        return new AssignmentInlining();
    }

    @Override
    public void run(Function function) {
        if (!function.hasBody()) {
            return;
        }

        final Processor processor = new Processor(function);

        // Scan for usages of locally assigned registers.
        processor.setMode(Processor.Mode.SCAN);
        function.getEvents().forEach(e -> e.accept(processor));

        // Perform inlining using the information gathered above.
        processor.setMode(Processor.Mode.REPLACE);
        function.getEvents().forEach(e -> e.accept(processor));
    }

    private static class Processor implements EventVisitor<Void> {

        private final DominatorTree<Event> preDominatorTree;
        private final Map<Register, Local> lastAssignments = new HashMap<>();
        private final Map<Local, Integer> usageCounter = new HashMap<>();

        private enum Mode { SCAN, REPLACE }

        private Mode mode = Mode.SCAN;
        private Event curEvent;

        private final ExprTransformer substitutor = new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                final Local lastAssignment = lastAssignments.get(reg);
                if (lastAssignment == null) {
                    return reg;
                }

                if (mode == Mode.SCAN) {
                    usageCounter.compute(lastAssignment, (k, v) -> v == null ? 1 : v + 1);
                    return reg;
                } else if (
                        // The default case is awkward, but it can happen for locals of the form "r = f(r)"
                        // which do not allow for substituting r for f(r) in later usages.
                        usageCounter.getOrDefault(lastAssignment, 0) == 1
                        && preDominatorTree.isDominatedBy(curEvent, lastAssignment)
                        && !curEvent.hasTag(Tag.NOOPT)
                ) {
                    assert mode == Mode.REPLACE;
                    return lastAssignment.getExpr();
                }

                return reg;
            }
        };

        private Processor(Function function) {
            preDominatorTree = DominatorAnalysis.computePreDominatorTree(function.getEntry(), function.getExit());
        }

        private void setMode(Mode mode) {
            lastAssignments.clear();
            this.mode = mode;
        }

        @Override
        public Void visitEvent(Event e) {
            curEvent = e;
            if (e instanceof RegReader reader) {
                reader.transformExpressions(substitutor);
            }

            if (e instanceof RegWriter writer) {
                lastAssignments.remove(writer.getResultRegister());
                lastAssignments.values().removeIf(l -> l.getExpr().getRegs().contains(writer.getResultRegister()));
            }

            if (e instanceof Local local && !local.getExpr().getRegs().contains(local.getResultRegister())) {
                lastAssignments.put(local.getResultRegister(), local);
            }
            return null;
        }
    }


}