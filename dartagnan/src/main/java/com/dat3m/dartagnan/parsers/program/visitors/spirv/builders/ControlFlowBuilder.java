package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.collect.Sets;

import java.util.*;

public class ControlFlowBuilder {

    protected final Map<String, Label> blockLabels = new HashMap<>();
    protected final Map<String, Event> lastBlockEvents = new HashMap<>();
    protected final Map<String, String> mergeLabelIds = new HashMap<>();
    protected final Deque<String> blockStack = new ArrayDeque<>();
    protected final Map<String, Map<Register, String>> phiDefinitions = new HashMap<>();
    protected final Map<String, Expression> expressions;

    public ControlFlowBuilder(Map<String, Expression> expressions) {
        this.expressions = expressions;
    }

    public boolean isInsideBlock() {
        return !blockStack.isEmpty();
    }

    public boolean isBlockStarted(String id) {
        return lastBlockEvents.containsKey(id) || blockStack.contains(id);
    }

    public void build() {
        validateBeforeBuild();
        phiDefinitions.forEach((blockId, def) ->
                def.forEach((k, v) -> {
                    Event event = EventFactory.newLocal(k, expressions.get(v));
                    lastBlockEvents.get(blockId).getPredecessor().insertAfter(event);
                }));
        mergeLabelIds.forEach((jumpLabelId, endLabelId) ->
                lastBlockEvents.get(jumpLabelId).getPredecessor().insertAfter(blockLabels.get(endLabelId)));
    }

    public void startBlock(String id) {
        if (lastBlockEvents.containsKey(id)) {
            throw new ParsingException("Attempt to redefine label '%s'", id);
        }
        blockStack.push(id);
    }

    public Event endBlock(Event event) {
        if (blockStack.isEmpty()) {
            throw new ParsingException("Attempt to exit block while not in a block definition");
        }
        lastBlockEvents.put(blockStack.pop(), event);
        return event;
    }

    public Label getOrCreateLabel(String id) {
        return blockLabels.computeIfAbsent(id, EventFactory::newLabel);
    }

    public Label createMergeLabel(String id) {
        String mergeId = id + "_end";
        mergeLabelIds.put(id, mergeId);
        return createLabel(mergeId);
    }

    public void addPhiDefinition(String blockId, Register register, String expressionId) {
        phiDefinitions.computeIfAbsent(blockId, k -> new HashMap<>()).put(register, expressionId);
    }

    private void validateBeforeBuild() {
        if (!blockStack.isEmpty()) {
            throw new ParsingException("Unclosed blocks %s", String.join(",", blockStack));
        }
        Set<String> missingPhiBlocks = Sets.difference(phiDefinitions.keySet(), blockLabels.keySet());
        if (!missingPhiBlocks.isEmpty()) {
            throw new ParsingException("Phi operation(s) refer to undefined block(s) %s",
                    String.join(", ", missingPhiBlocks));
        }
        Set<String> missingMergeBlocks = Sets.difference(mergeLabelIds.keySet(), blockLabels.keySet());
        if (!missingMergeBlocks.isEmpty()) {
            throw new ParsingException("Branch merge label(s) refer to undefined block(s) %s",
                    String.join(", ", missingMergeBlocks));
        }
        Map<Event, String> reverse = new HashMap<>();
        lastBlockEvents.forEach((k, v) -> {
            if (reverse.containsKey(v)) {
                throw new ParsingException("Multiple blocks end in the same event '%s'", v);
            }
            reverse.put(v, k);
        });
    }

    private Label createLabel(String id) {
        if (blockLabels.containsKey(id)) {
            throw new ParsingException("Attempt to redefine label '%s'", id);
        }
        return getOrCreateLabel(id);
    }
}
