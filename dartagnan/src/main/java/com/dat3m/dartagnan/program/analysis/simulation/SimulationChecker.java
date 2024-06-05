package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.dat3m.dartagnan.program.processing.IdReassignment;
import com.dat3m.dartagnan.program.processing.ProcessingManager;
import com.google.common.collect.Lists;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

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

    public void test(Function f) {
        List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(f).getLoopsOfFunction(f);

        for (LoopAnalysis.LoopInfo loop : loops) {
            assert !loop.isUnrolled();
            final LoopAnalysis.LoopIterationInfo loopBody = loop.iterations().get(0);
            List<Event> body = IRHelper.getEventsFromTo(loopBody.getIterationStart(), loopBody.getIterationEnd());
            FunctionSnippet snippet = FunctionSnippet.computeSnippet(loopBody.getIterationStart(), loopBody.getIterationEnd());
            final OpenFunction func = OpenFunction.fromSnippet(snippet);
            f.getProgram().addFunction(func.getFunction());
            IdReassignment.newInstance().run(f.getProgram());

            final OpenFunction f1 = func.constructLoopBoundedCopy(2);
            final OpenFunction f2 = func.constructLoopBoundedCopy(3);

            canSimulate(f1.getFunction(), f2.getFunction());
        }
    }

    // Checks if "g <= f": For every (open/partial) execution of g with input I, there is a (open/partial) execution of f
    // on the same input I that (i) produces the same return values and (ii) is at least as consistent as g's execution.
    public boolean canSimulate(Function f, Function g) {
        if (!f.getFunctionType().equals(g.getFunctionType())) {
            return false;
        }

        final Program commonProg = constructCommonProgram(f, g, Program.SourceLanguage.LLVM);
        final SimulationCheck check = generateThreads(commonProg);
        process(check);


        final List<Event> fBody = check.source.getEvents();
        final List<Event> gBody = check.simulator.getEvents();

        int i = 5;
        /*
            Plan:
            (1) We construct a program that contains f and g:
                - We make a copy of all the program constants and memory objects referenced by both functions
            (2) We generate two threads, one for f and one for g of the shape:
                    void thread_f/g() {
                        in_reg_1 = in_1 // in_i are free variables
                        ...
                        in_reg_k = in_k
                        result = call f/g(in_reg_1, ..., in_reg_k)
                        out_reg_1 = extract(result, 0)
                        ...
                        out_reg_m = extract(result, m-1)
                    }
             (3) We generate the encodings phi_f and phi_g for thread_f and thread_g without a memory model encoding
                 (also no rf-edges; loads can take arbitrary values). We only require tracking of po, idd, data/addr/ctrl.
             (4) We encode "forall vars(phi_f): (phi_f => exists unique_vars(phi_g): phi_g /\ matching)"
                 - We universally quantify over all variables of phi_f (some of which may be shared with phi_g)
                   and existentially quantify over those variables in phi_g that are not shared with phi_f.
                 - "matching" is an encoding that makes sure that the execution encoded by phi_g matches with the one
                    encoded by phi_f:
                    -- Whenever g performs a visible event then it must match with one performed by f.
                    -- Whenever two g-events are related by po/dep, then so must the matching events in f.
                    -- Whenever input/output regs in g are related by idd, then so must the input/output regs in f must be matched
         */

        return false;
    }

    /*
        Construct a program that contains both f and g.
     */
    private Program constructCommonProgram(Function f, Function g, Program.SourceLanguage sourceLang) {
        final Set<MemoryObject> memObjs = new HashSet<>();
        final Set<NonDetValue> progConstants = new HashSet<>();

        final ExpressionInspector collector = new ExpressionInspector() {
            @Override
            public Expression visitMemoryObject(MemoryObject memObj) {
                memObjs.add(memObj);
                return memObj;
            }

            @Override
            public Expression visitNonDetValue(NonDetValue nonDet) {
                progConstants.add(nonDet);
                return nonDet;
            }
        };
        f.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(collector));
        g.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(collector));

        final Program program = new Program(new Memory(), sourceLang);

        final Map<MemoryObject, MemoryObject> memTranslator = new HashMap<>();
        for (MemoryObject memObj : memObjs) {
            assert memObj.isStaticallyAllocated();
            final MemoryObject copy = program.getMemory().allocate(memObj.size());
            copy.setName(memObj.getName());
            memTranslator.put(memObj, copy);
        }

        final Map<NonDetValue, NonDetValue> progConstTranslator = new HashMap<>();
        for (NonDetValue progConst : progConstants) {
            final NonDetValue copy = (NonDetValue) program.newConstant(progConst.getType());
            copy.setIsSigned(progConst.isSigned());
            progConstTranslator.put(progConst, copy);
        }

        program.addFunction(IRHelper.translateFunction(f, program, memTranslator, progConstTranslator));
        program.addFunction(IRHelper.translateFunction(g, program, memTranslator, progConstTranslator));

        IdReassignment.newInstance().run(program);

        return program;
    }

    private SimulationCheck generateThreads(Program program) {
        final Function f = program.getFunctions().get(0);
        final Function g = program.getFunctions().get(1);

        final TypeFactory types = TypeFactory.getInstance();
        final ExpressionFactory exprs = ExpressionFactory.getInstance();
        final FunctionType threadType = types.getFunctionType(types.getVoidType(), List.of());

        final Thread fThread = new Thread(f.getName() + "_source", threadType, List.of(),
                0, EventFactory.newThreadStart(null)
        );
        final Thread gThread = new Thread(g.getName() + "_simulator", threadType, List.of(),
                1, EventFactory.newThreadStart(null)
        );

        final List<NonDetValue> inputConstants = new ArrayList<>();
        final List<Register> fInputRegs = new ArrayList<>();
        final List<Register> gInputRegs = new ArrayList<>();
        for (Type inputType : f.getFunctionType().getParameterTypes()) {
            final int id =  inputConstants.size();
            final Register fInputReg = fThread.newRegister("__input" + id, inputType);
            final Register gInputReg = gThread.newRegister("__input" + id, inputType);
            final NonDetValue inputConstant = (NonDetValue) program.newConstant(inputType);

            fInputRegs.add(fInputReg);
            final Event fAssign = EventFactory.newLocal(fInputReg, inputConstant);
            fAssign.addTags(Tag.NOOPT);
            fThread.append(fAssign);

            gInputRegs.add(gInputReg);
            final Event gAssign = EventFactory.newLocal(gInputReg, inputConstant);
            gAssign.addTags(Tag.NOOPT);
            gThread.append(gAssign);

            inputConstants.add(inputConstant);
        }

        final Register fCallResultReg = fThread.newRegister("__callResult", f.getFunctionType().getReturnType());
        final Register gCallResultReg = gThread.newRegister("__callResult", g.getFunctionType().getReturnType());
        fThread.append(EventFactory.newValueFunctionCall(fCallResultReg, f, Lists.transform(fInputRegs, reg -> reg)));
        gThread.append(EventFactory.newValueFunctionCall(gCallResultReg, g, Lists.transform(gInputRegs, reg -> reg)));

        //TODO: Extend to non-aggregate types
        final AggregateType resultType = (AggregateType) f.getFunctionType().getReturnType();
        int nextId = 0;
        for (Type outputType : resultType.getDirectFields()) {
            final int id = nextId++;
            final Register fOutputReg = fThread.newRegister("__output" + id, outputType);
            final Register gOutputReg = gThread.newRegister("__output" + id, outputType);

            final Event fAssign = EventFactory.newLocal(fOutputReg, exprs.makeExtract(id, fCallResultReg));
            fAssign.addTags(Tag.NOOPT);
            fThread.append(fAssign);

            final Event gAssign = EventFactory.newLocal(gOutputReg, exprs.makeExtract(id, gCallResultReg));
            gAssign.addTags(Tag.NOOPT);
            gThread.append(gAssign);
        }
        // TODO: Maybe add a dummy event that uses all output registers, so we do not have to mark them as NOOPT?

        // TODO: Check if really necessary
        fThread.append(EventFactory.newLabel("END_OF_T"));
        gThread.append(EventFactory.newLabel("END_OF_T"));

        program.addThread(fThread);
        program.addThread(gThread);

        final SimulationCheck check = new SimulationCheck(program, fThread, gThread, inputConstants);
        return check;

    }

    private void process(SimulationCheck check) {
        // TODO: TEST CODE
        final Program program = check.program;
        try {
            IdReassignment.newInstance().run(program);
            ProcessingManager.fromConfig(Configuration.defaultConfiguration()).run(program);
        } catch (InvalidConfigurationException e) {
            throw new RuntimeException(e);
        }

        assert program.getThreads().size() == 2;
        for (Thread thread : program.getThreads()) {
            final Map<Expression, Expression> replacementMap = new HashMap<>();
            final Set<Event> inputLocals = new HashSet<>();
            for (Local local : thread.getEvents(Local.class)) {
                if (local.getResultRegister().getName().startsWith("__input") && check.inputConstants.contains(local.getExpr())) {
                    replacementMap.put(local.getExpr(), local.getResultRegister());
                    inputLocals.add(local);
                }
            }

            final ExprTransformer replacer = new ExprTransformer() {
                @Override
                public Expression visitNonDetValue(NonDetValue nonDet) {
                    return replacementMap.getOrDefault(nonDet, nonDet);
                }
            };

            thread.getEvents(RegReader.class)
                    .stream().filter(reader -> !inputLocals.contains(reader))
                    .forEach(reader -> reader.transformExpressions(replacer));
        }
    }



    private class SimulationCheck {

        private final Program program;
        private final Thread source;
        private final Thread simulator;

        private final List<NonDetValue> inputConstants;

        private SimulationCheck(Program program, Thread source, Thread simulator, List<NonDetValue> inputConstants) {
            this.program = program;
            this.source = source;
            this.simulator = simulator;
            this.inputConstants = inputConstants;
        }
        //private final List<String> outputRegNames;

    }

}
