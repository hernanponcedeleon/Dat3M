package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
    Shape of (normalized) open program:
    (1) List of input variables (in_1, ... in_k) given by NonDetValue expressions.
    (2) List of output expressions (outExpr_1, ..., outExpr_m)
    (3) Single main thread:
        void main() {
        // Init:
        r1 <- in_1
        ...
        rk <- in_k
        // Constraints (if any constraints over inputs are given):
        assume (constraint_1)
        ...
        assume (constraint_l)
        // Actual program logic
        L_BEGIN:
        ...
        ... (All jumps stay within this body or go to L_END)
        ...
        L_END:
        // Output expressions are evaluated at L_END.
    }

    Typically, we have the following special shape:
        - There is a special "r_exit" register that represents over which jump we exited
          the body (i.e., reached L_END). Typically, we also have "outExpr_i = r_exit" for some output.
        - outExpr_i may be of shape "ITE(r_exit != k, ..., 0)" so that one can emulate that different exits
          may have different sets of outputs (here: exit k does not have output i emulated by always setting out_i = 0)

   TODO: Think about MemoryObject and Allocs
    - (Static and dynamic) MemoryObjects could also be modelled as NonDetValue inputs
      (this would inhibit alias analysis, but might not be too bad)
    - Allocs are tricky for simulation checking: all allocs of a program must get simulated by another
      (assuming all allocs escape) but this can be done in arbitrary order.
 */
class OpenProgram {

    final Thread mainThread; // We assume a single-threaded program with a unique entry point.
    final List<NonDetValue> inputs;
    final List<Expression> outputs;

    private OpenProgram(Program program, List<NonDetValue> inputs, List<Expression> outputs) {
        Preconditions.checkArgument(program.getFunctions().isEmpty());
        Preconditions.checkArgument(program.getThreads().size() == 1);
        this.mainThread = program.getThreads().get(0);
        this.inputs = inputs;
        this.outputs = outputs;
    }


    public static OpenProgram fromFunctionSnippet(FunctionSnippet snippet) {
        final Function func = snippet.function;
        final Program origProgram = func.getProgram();
        final Program openProgram = new Program(new Memory(), origProgram.getFormat());

        final Function f = snippet.function;
        final TypeFactory types = TypeFactory.getInstance();
        final Thread thread = new Thread(f.getName(), types.getFunctionType(types.getVoidType(), List.of()),
                List.of(), 0, EventFactory.newThreadStart(null));
        thread.append(EventFactory.newLabel("__BEGIN"));

        // Copy registers
        final Map<Register, Register> registerMap = new HashMap<>();
        for (Register reg : f.getRegisters()) {
            final Register regCopy = thread.getOrNewRegister(reg.getName(), reg.getType());
            registerMap.put(reg, regCopy);
        }

        // Init input
        final List<NonDetValue> inputs = new ArrayList<>();
        for (Register reg : snippet.inputRegisters) {
            final Register copy = registerMap.get(reg);
            //final NonDetValue inputVar = new NonDetValue(copy.getType(),)
        }

        // Copy body
        final Map<Event, Event> copyContext = new HashMap<>();
        final List<Event> bodyCopy = IRHelper.copyPath(snippet.start, snippet.end, copyContext, registerMap);
        thread.getEntry().insertAfter(bodyCopy);
        thread.append(EventFactory.newLabel("__END"));

        // Create program
        final Program origProg = f.getProgram();
        final Program program = new Program(origProg.getMemory(), origProg.getFormat());
        program.addThread(thread);

        //return program;
        return null; // TODO
    }

}
