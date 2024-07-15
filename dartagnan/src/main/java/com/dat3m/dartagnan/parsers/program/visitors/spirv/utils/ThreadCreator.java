package com.dat3m.dartagnan.parsers.program.visitors.spirv.utils;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.google.common.collect.Lists;

import java.util.*;

public class ThreadCreator {

    private final ThreadGrid grid;
    private final Function function;
    private final Set<ScopedPointerVariable> variables;
    private final MemoryTransformer transformer;

    public ThreadCreator(ThreadGrid grid, Function function, Set<ScopedPointerVariable> variables, BuiltIn builtIn) {
        this.grid = grid;
        this.function = function;
        this.variables = variables;
        this.transformer = new MemoryTransformer(grid, function, builtIn, variables);
    }

    public void create() {
        Program program = function.getProgram();
        for (int i = 0; i < grid.dvSize(); i++) {
            program.addThread(createThreadFromFunction(i));
        }
        deleteLocalFunctionVariables();
    }

    private Thread createThreadFromFunction(int tid) {
        String name = function.getName();
        FunctionType type = function.getFunctionType();
        List<String> args = Lists.transform(function.getParameterRegisters(), Register::getName);
        ThreadStart start = EventFactory.newThreadStart(null);
        ScopeHierarchy scope = grid.getScoreHierarchy(tid);
        Thread thread = new Thread(name, type, args, tid, start, scope, Set.of());
        thread.copyDummyCountFrom(function);
        copyThreadEvents(thread);
        transformReturnEvents(thread);
        return thread;
    }

    private void copyThreadEvents(Thread thread) {
        List<Event> body = new ArrayList<>();
        Map<Event, Event> eventCopyMap = new HashMap<>();
        function.getEvents().forEach(e -> body.add(eventCopyMap.computeIfAbsent(e, Event::getCopy)));
        transformer.setThread(thread);
        for (Event copy : body) {
            if (copy instanceof EventUser user) {
                user.updateReferences(eventCopyMap);
            }
            if (copy instanceof RegReader reader) {
                reader.transformExpressions(transformer);
            }
            if (copy instanceof RegWriter regWriter) {
                regWriter.setResultRegister(transformer.getRegisterMapping(regWriter.getResultRegister()));
            }
        }
        thread.getEntry().insertAfter(body);
    }

    private void transformReturnEvents(Thread thread) {
        Label returnLabel = EventFactory.newLabel("RETURN_OF_T" + thread.getId());
        Label endLabel = EventFactory.newLabel("END_OF_T" + thread.getId());
        for (Return event : thread.getEvents(Return.class)) {
            event.replaceBy(EventFactory.newGoto(returnLabel));
        }
        thread.append(returnLabel);
        thread.append(endLabel);
    }

    private void deleteLocalFunctionVariables() {
        Memory memory = function.getProgram().getMemory();
        variables.forEach(v -> {
            if (v.getAddress().isThreadLocal()) {
                memory.deleteMemoryObject(v.getAddress());
            }
        });
    }
}
