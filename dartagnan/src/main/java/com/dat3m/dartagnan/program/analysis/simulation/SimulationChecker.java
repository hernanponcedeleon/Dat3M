package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.base.Preconditions;

import java.util.List;

/*
    Checks if function f can simulate function g.
    Assumptions about the shape of f and g:
    - Both functions have the same arguments (modulo renaming)
    - Both functions have the same return type and use a single return statement.

          OutT f/g(InT1 in1, InT2 in2, ..., InTk ink) {
            // ... body ...
            return outputExpr; // Single return
          }

    - Program constants and memory objects referenced in f/g are implicitly treated as additional inputs.
    - Memory loads can also implicitly be understood as special inputs (with some special conditions).
    - Functions may use non-deterministic choice. Unlike inputs, when simulating, the functions may do

 */

public class SimulationChecker {

    public void test(Function f) {
        List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(f).getLoopsOfFunction(f);

        for (LoopAnalysis.LoopInfo loop : loops) {
            assert !loop.isUnrolled();
            final LoopAnalysis.LoopIterationInfo loopBody = loop.iterations().get(0);
            List<Event> body = IRHelper.getEventsFromTo(loopBody.getIterationStart(), loopBody.getIterationEnd());
            FunctionSnippet snippet = FunctionSnippet.computeSnippet(loopBody.getIterationStart(), loopBody.getIterationEnd());
            int i = 5;
        }
    }

    // Checks if "g <= f": For every (open/partial) execution of g with input I, there is a (open/partial) execution of f
    // on the same input I that (i) produces the same return values and (ii) is at least as consistent as g's execution.
    public void canSimulate(FunctionSnippet f, FunctionSnippet g) {

    }


    /*
        Represents the check "p1 <= p2" where "<=" means that <p2> can simulate all behaviour of <p1>.
        Here <p1>/<p2> are open programs that have the same number of inputs and outputs.
     */
    private static class SimulationCheck {

        final OpenProgram prog1;
        final OpenProgram prog2;

        SimulationCheck(OpenProgram program1, OpenProgram program2) {
            this.prog1 = program1;
            this.prog2 = program2;

            Preconditions.checkArgument(program1.inputs.size() == program2.inputs.size());
            Preconditions.checkArgument(program1.outputs.size() == program2.outputs.size());

        }

    }

}
