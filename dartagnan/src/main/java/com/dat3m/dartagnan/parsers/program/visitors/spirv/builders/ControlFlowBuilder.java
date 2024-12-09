package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.google.common.collect.Sets;

import java.util.*;

public class ControlFlowBuilder {

    protected final Map<String, Label> blockLabels = new HashMap<>();
    protected final Map<String, Event> lastBlockEvents = new HashMap<>();
    protected final Deque<String> blockStack = new ArrayDeque<>();
    protected final Map<String, Map<Register, String>> phiDefinitions = new HashMap<>();
    protected final Map<String, SourceLocation> phiDefinitionLocations = new HashMap<>();
    protected final Map<String, Map<Register, String>> phiDefinitionIds = new HashMap<>();
    protected final Map<String, Expression> expressions;
    protected SourceLocation currentLocation;

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
                    SourceLocation loc = getPhiLocation(blockId, k);
                    if (loc != null) { event.setMetadata(loc); }
                    lastBlockEvents.get(blockId).getPredecessor().insertAfter(event);
                }));
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
        removeCurrentLocation();
        return event;
    }

    public Label getOrCreateLabel(String id) {
        return blockLabels.computeIfAbsent(id, EventFactory::newLabel);
    }

    public void addPhiDefinition(String blockId, Register register, String expressionId) {
        phiDefinitions.computeIfAbsent(blockId, k -> new HashMap<>()).put(register, expressionId);
    }

    public SourceLocation getCurrentLocation() {
        if (currentLocation == null) {
            throw new ParsingException("No source location for the instruction");
        }
        return currentLocation;
    }

    public void setCurrentLocation(SourceLocation loc) { currentLocation = loc; }

    public void removeCurrentLocation() { currentLocation = null; }

    public boolean hasCurrentLocation() {
        return currentLocation != null;
    }

    public void setPhiLocation(String id) {
        if (phiDefinitionLocations.containsKey(id)) {
            throw new ParsingException("Already set source location for Phi definition %s", id);
        }
        if (hasCurrentLocation()) {
            phiDefinitionLocations.put(id, currentLocation);
        }
    }

    public void setPhiId(String blockId, Register register, String id) {
        String phiId = phiDefinitionIds.computeIfAbsent(blockId, k -> new HashMap<>()).get(register);
        if (phiId != null) {
            throw new ParsingException(
                "Already set id %s for the Phi definition in the block %s", phiId, blockId);
        } else {
            phiDefinitionIds.get(blockId).put(register, id);
        }
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
        Map<Event, String> reverse = new HashMap<>();
        lastBlockEvents.forEach((k, v) -> {
            if (reverse.containsKey(v)) {
                throw new ParsingException("Multiple blocks end in the same event '%s'", v);
            }
            reverse.put(v, k);
        });
    }

    private SourceLocation getPhiLocation(String blockId, Register register) {
        String id = phiDefinitionIds.get(blockId).get(register);
        if (id != null) {
            return phiDefinitionLocations.get(id);
        }
        return null;
    }
}
