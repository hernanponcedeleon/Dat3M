package com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ControlFlowBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MockControlFlowBuilder extends ControlFlowBuilder {
    public MockControlFlowBuilder(Map<String, Expression> expressions) {
        super(expressions);
    }

    public List<String> getBlockStack() {
        return blockStack.stream().toList();
    }

    public Map<String, Event> getLastBlockEvents() {
        return Map.copyOf(lastBlockEvents);
    }

    public Map<Register, String> getPhiDefinitions(String blockId) {
        return Map.copyOf(phiDefinitions.computeIfAbsent(blockId, k -> new HashMap<>()));
    }
}
