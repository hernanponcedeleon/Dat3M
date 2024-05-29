package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.analysis.UseDefAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import java.util.*;

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

    // Checks if "g <= f": For every (open/partial) execution of g with input I, there is a (open/partial) execution of f
    // on the same input I that (i) produces the same return values and (ii) is at least as consistent as g's execution.
    public void canSimulate(Function f, Function g) {

    }

    private Program convertFunctionToProgram(Function f) {
        final Thread thread = new Thread(f.getName(), f.getFunctionType(),
                Lists.transform(f.getParameterRegisters(), Register::getName),
                0, EventFactory.newThreadStart(null));

        // Copy registers
        final Map<Register, Register> registerMap = new HashMap<>();
        for (Register reg : f.getRegisters()) {
            Register regCopy = thread.getOrNewRegister(reg.getName(), reg.getType());
            registerMap.put(reg, regCopy);
        }
        final ExprTransformer regSubstitutor = new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                return registerMap.get(reg);
            }
        };

        // Copy body
        final Map<Event, Event> copyContext = new HashMap<>();
        final List<Event> bodyCopy = IRHelper.copyPath(f.getEntry(), f.getExit(), copyContext, registerMap);
        thread.getEntry().insertAfter(bodyCopy);

        // Create program
        final Program origProg = f.getProgram();
        final Program program = new Program(origProg.getMemory(), origProg.getFormat());
        program.addThread(thread);

        return program;
    }

    private Function makeOpenFunction(Function f, Event start, Event end) {
        final Set<Event> body = new HashSet<>(IRHelper.getEventsFromTo(start, end));
        final UseDefAnalysis useDefAnalysis = UseDefAnalysis.forFunction(f);

        Set<Register> inputs = new HashSet<>();
        Set<MemoryObject> referencedObjects = new HashSet<>();
        Set<Register> possibleOutputs = new HashSet<>();
        Set<Label> exitLabels = new HashSet<>();
        for (Event e : body) {
            if (e instanceof RegReader reader) {
                for (Register.Read read : reader.getRegisterReads()) {
                    final Set<RegWriter> possibleWriters = useDefAnalysis.getDefs(reader, read.register());
                    if (possibleWriters.isEmpty() || !body.containsAll(possibleWriters)) {
                        inputs.add(read.register());
                    }
                }
                reader.transformExpressions(new ExpressionInspector() {
                    @Override
                    public Expression visitMemoryObject(MemoryObject memObj) {
                        referencedObjects.add(memObj);
                        return memObj;
                    }
                });
            }

            if (e instanceof RegWriter writer) {
                possibleOutputs.add(writer.getResultRegister());
            }

            if (e instanceof CondJump jump && !body.contains(jump.getLabel())) {
                exitLabels.add(jump.getLabel());
            }
        }


        final List<Register> sortedInputs = inputs.stream().sorted().toList();
        final List<Register> sortedOutputs = possibleOutputs.stream().sorted().toList();

        final TypeFactory types = TypeFactory.getInstance();
        final Type inputType = types.getAggregateType(Lists.transform(sortedInputs, Register::getType));
        final Type outputType = types.getAggregateType(Lists.transform(sortedOutputs, Register::getType));

        final String snippetName = String.format("__%s@[%s, %s]", f.getName(), start.getGlobalId(), end.getGlobalId());
        final FunctionType funcType = types.getFunctionType(outputType, List.of(inputType));
        final Function openFunction = new Function("__" + f.getName(), funcType, List.of("input"), 0,
                EventFactory.newLabel("__BEGIN"));

        // TODO: Copy over event body, generate end marker, and return
        return null;
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

    private static class FunctionSnippet {
        private final Function function;
        private final Event start;
        private final Event end;

        private final Set<Register> inputRegisters = new HashSet<>();
        // The keys are either jumps or the unique <end> event.
        private final Map<Event, Set<Register>> liveRegsAtExit = new HashMap<>();

        private FunctionSnippet(Function function, Event start, Event end) {
            this.function = function;
            this.start = start;
            this.end = end;
        }

        public static FunctionSnippet computeSnippet(Event start, Event end) {
            Preconditions.checkArgument(start.getFunction() == end.getFunction() && start.getFunction() != null);

            final Function func = start.getFunction();
            final Set<Event> body = new HashSet<>(IRHelper.getEventsFromTo(start, end));
            final UseDefAnalysis useDefAnalysis = UseDefAnalysis.forFunction(func);

            Set<Register> inputs = new HashSet<>();
            //Set<MemoryObject> referencedObjects = new HashSet<>();
            Set<Register> possibleOutputs = new HashSet<>();
            Set<Event> exits = new HashSet<>();

            // ------- Analyse body of snippet -------
            for (Event e : body) {

                if (e instanceof RegReader reader) {
                    for (Register.Read read : reader.getRegisterReads()) {
                        final Set<RegWriter> possibleWriters = useDefAnalysis.getDefs(reader, read.register());
                        if (possibleWriters.isEmpty() || !body.containsAll(possibleWriters)) {
                            inputs.add(read.register());
                        }
                    }
                }

                if (e instanceof RegWriter writer) {
                    possibleOutputs.add(writer.getResultRegister());
                }

                if (e instanceof CondJump jump && !body.contains(jump.getLabel())) {
                    exits.add(jump);
                }
            }
            exits.add(end);

            // ------- Find live outputs -------
            final Map<Event, Set<Register>> liveRegsAtEntry = new HashMap<>();

            return new FunctionSnippet(func, start, end); // TODO
        }

    }

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
    private static class OpenProgram {

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



    }
}
