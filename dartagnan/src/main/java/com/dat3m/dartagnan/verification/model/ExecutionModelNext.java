package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.*;


// This is a new implementation of ExecutionModel which serves as the data structure
// representing an execution in Dartagnan. It contains instances of EventModel for events
// and RelationModel for relations. It is used only by ExecutionGraphVisualizer so far.
public class ExecutionModelNext {
    private final List<ThreadModel> threadList;
    private final List<EventModel> eventList;
    private final Map<Event, EventModel> eventMap;
    private final Map<Relation, RelationModel> relationMap;
    private final Map<MemoryObject, MemoryObjectModel> memoryLayoutMap;

    private final Map<ValueModel, Set<LoadModel>> addressReadsMap;
    private final Map<ValueModel, Set<StoreModel>> addressWritesMap;

    ExecutionModelNext() {
        threadList = new ArrayList<>();
        eventList = new ArrayList<>();
        eventMap = new HashMap<>();
        relationMap = new HashMap<>();
        memoryLayoutMap= new HashMap<>();

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

    public List<EventModel> getEventModelsByFilter(Filter filter) {
        return eventList.stream().filter(e -> filter.apply(e.getEvent())).toList();
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

    public Map<ValueModel, Set<LoadModel>> getAddressReadsMap() {
        return Collections.unmodifiableMap(addressReadsMap);
    }

    public Map<ValueModel, Set<StoreModel>> getAddressWritesMap() {
        return Collections.unmodifiableMap(addressWritesMap);
    }
}