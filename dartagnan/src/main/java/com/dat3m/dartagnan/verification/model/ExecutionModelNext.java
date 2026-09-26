package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.base.Preconditions;

import java.util.*;


// Represents a concrete execution, including its events, relations, memory layout, and violations.
public class ExecutionModelNext {
    private final List<ThreadModel> threadList;
    private final List<EventModel> eventList;
    private final Map<Event, EventModel> eventMap;
    private final Map<Relation, RelationModel> relationMap;
    private final Map<MemoryObject, MemoryObjectModel> memoryLayoutMap;
    private final Set<Property> violatedProperties;
    private final Set<Axiom> flaggedAxioms;

    private final Map<ValueModel, Set<LoadModel>> addressReadsMap;
    private final Map<ValueModel, Set<StoreModel>> addressWritesMap;

    ExecutionModelNext() {
        threadList = new ArrayList<>();
        eventList = new ArrayList<>();
        eventMap = new HashMap<>();
        relationMap = new HashMap<>();
        memoryLayoutMap = new HashMap<>();
        violatedProperties = EnumSet.noneOf(Property.class);
        flaggedAxioms = new HashSet<>();

        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
    }

    public void addThread(ThreadModel tModel) {
        threadList.add(tModel);
    }

    public void addEvent(Event e, EventModel eModel) {
        eventList.add(eModel);
        eventMap.put(e, eModel);
    }

    public void addRelation(Relation r, RelationModel rModel) {
        relationMap.put(r, rModel);
    }

    public void addMemoryObject(MemoryObject m, MemoryObjectModel mModel) {
        memoryLayoutMap.put(m, mModel);
    }

    void addViolatedProperty(Property property) {
        violatedProperties.add(property);
    }

    void addFlaggedAxiom(Axiom axiom) {
        Preconditions.checkArgument(axiom.isFlagged(), "Axiom is not flagged: %s", axiom);
        flaggedAxioms.add(axiom);
    }

    public void addAddressRead(ValueModel address, LoadModel read) {
        addressReadsMap.computeIfAbsent(address, k -> new HashSet<>()).add(read);
    }

    public void addAddressWrite(ValueModel address, StoreModel write) {
        addressWritesMap.computeIfAbsent(address, k -> new HashSet<>()).add(write);
    }

    public List<ThreadModel> getThreadModels() {
        return Collections.unmodifiableList(threadList);
    }

    public List<EventModel> getEventModels() {
        return Collections.unmodifiableList(eventList);
    }

    public List<EventModel> getVisibleEventModels() {
        return eventList.stream()
                        .filter(e -> e instanceof MemoryEventModel || e instanceof GenericVisibleEventModel)
                        .toList();
    }

    public List<EventModel> getEventModelsByTag(String tag) {
        return eventList.stream().filter(e -> e.getEvent().hasTag(tag)).toList();
    }

    public EventModel getEventModelById(int id) {
        return eventList.get(id);
    }

    public EventModel getEventModelByEvent(Event event) {
        return eventMap.get(event);
    }

    public Set<RelationModel> getRelationModels() {
        return new HashSet<>(relationMap.values());
    }

    public Map<MemoryObject, MemoryObjectModel> getMemoryLayoutMap() {
        return Collections.unmodifiableMap(memoryLayoutMap);
    }

    public boolean isViolated(Property property) {
        return violatedProperties.contains(property);
    }

    public boolean isFlagged(Axiom axiom) {
        return flaggedAxioms.contains(axiom);
    }

    public Map<ValueModel, Set<LoadModel>> getAddressReadsMap() {
        return Collections.unmodifiableMap(addressReadsMap);
    }

    public Map<ValueModel, Set<StoreModel>> getAddressWritesMap() {
        return Collections.unmodifiableMap(addressWritesMap);
    }
}
