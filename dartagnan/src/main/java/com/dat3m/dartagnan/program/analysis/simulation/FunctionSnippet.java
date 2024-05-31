package com.dat3m.dartagnan.program.analysis.simulation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.LiveRegistersAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;
import com.google.common.collect.Sets;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/*
    A FunctionSnippet describes a contiguous part of a function and its connection with the surrounding function/program.
    A snippet has the following contextual information:
       (1) Input registers are registers that are live at the entry point of the snippet, i.e.,
           those registers that are (potentially) used before getting overwritten/reassigned.
           These are "inputs" from the surrounding context.
       (2) Memory references: the memory objects referenced within the snippet (e.g. for loading/storing).
       (3) Program constants: the program constants referenced within the snippet.
       (4) Output registers (for each exit point) are the registers that are (potentially) live in the context after
           taking that exit.
 */
public class FunctionSnippet {
    final Function function;
    final Event start;
    final Event end;

    final Set<Register> inputRegisters = new HashSet<>();
    final Set<MemoryObject> memoryReferences = new HashSet<>();
    final Set<NonDetValue> programConstants = new HashSet<>();
    // The keys are either jumps or the unique <end> event.
    final Map<CondJump, Set<Register>> liveRegsAtJumpExit = new HashMap<>();
    final Set<Register> liveRegsAtRegularExit = new HashSet<>();

    private FunctionSnippet(Function function, Event start, Event end) {
        this.function = function;
        this.start = start;
        this.end = end;
    }

    public static FunctionSnippet computeSnippet(Event start, Event end) {
        Preconditions.checkArgument(start.getFunction() == end.getFunction() && start.getFunction() != null);

        final Function func = start.getFunction();
        final Set<Event> body = new HashSet<>(IRHelper.getEventsFromTo(start, end));
        final LiveRegistersAnalysis liveRegsAnalysis = LiveRegistersAnalysis.forFunction(func);

        // ------- Analyse body of snippet -------
        final Set<CondJump> exitJumps = new HashSet<>();
        final Set<Register> readRegisters = new HashSet<>();
        final Set<Register> writtenRegisters = new HashSet<>();
        final Set<MemoryObject> memoryReferences = new HashSet<>();
        final Set<NonDetValue> programConstants = new HashSet<>();
        final ExpressionInspector exprInspector = new ExpressionInspector() {
            @Override
            public Expression visitRegister(Register reg) {
                readRegisters.add(reg);
                return reg;
            }

            @Override
            public Expression visitMemoryObject(MemoryObject memObj) {
                memoryReferences.add(memObj);
                return memObj;
            }

            @Override
            public Expression visitNonDetValue(NonDetValue nonDet) {
                programConstants.add(nonDet);
                return nonDet;
            }
        };

        for (Event e : body) {
            if (e instanceof RegReader reader) {
                reader.transformExpressions(exprInspector);
                for (Register.Read read : reader.getRegisterReads()) {
                    readRegisters.add(read.register());
                }
            }

            if (e instanceof RegWriter writer) {
                writtenRegisters.add(writer.getResultRegister());
            }

            if (e instanceof CondJump jump && !body.contains(jump.getLabel())) {
                exitJumps.add(jump);
            }
        }

        // ------- Create snippet and populate -------
        final FunctionSnippet snippet = new FunctionSnippet(func, start, end);
        snippet.inputRegisters.addAll(Sets.intersection(readRegisters, liveRegsAnalysis.getLiveRegistersAt(start)));
        for (CondJump exitJump : exitJumps) {
            // TODO: This set may contain registers that are never written to on any path to that exit
            //  as long as they are written to somewhere in the snippet.
            final Set<Register> liveOnExit = Sets.intersection(writtenRegisters, liveRegsAnalysis.getLiveRegistersAt(exitJump.getLabel()));
            snippet.liveRegsAtJumpExit.put(exitJump, liveOnExit);
        }
        if (!IRHelper.isAlwaysBranching(end) && end.getSuccessor() != null) {
            snippet.liveRegsAtRegularExit.addAll(liveRegsAnalysis.getLiveRegistersAt(end.getSuccessor()));
        }
        snippet.memoryReferences.addAll(memoryReferences);
        snippet.programConstants.addAll(programConstants);

        return snippet;
    }

}
