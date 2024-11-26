package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.relation.RelationModel;
import com.dat3m.dartagnan.wmm.Relation;

import java.math.BigInteger;
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

    private final Map<BigInteger, Set<LoadModel>> addressReadsMap;
    private final Map<BigInteger, Set<StoreModel>> addressWritesMap;
    private final Map<BigInteger, Set<MemoryEventModel>> addressAccessesMap;
    private final Map<Thread, List<List<EventModel>>> atomicBlocksMap;

    ExecutionModelNext() {
        threadList = new ArrayList<>();
        eventList = new ArrayList<>();
        eventMap = new HashMap<>();
        relationMap = new HashMap<>();
        memoryLayoutMap= new HashMap<>();

        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
        addressAccessesMap = new HashMap<>();
        atomicBlocksMap = new HashMap<>();
    }

    public void addThreadEvents(Thread thread, List<EventModel> events) {
        threadList.add(new ThreadModel(thread, events));
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

    public void addAccessedAddress(BigInteger address) {
        if (!addressAccessesMap.containsKey(address)) {
            addressAccessesMap.put(address, new HashSet<>());
        }
        if (!addressReadsMap.containsKey(address)) {
            addressReadsMap.put(address, new HashSet<>());
        }
        if (!addressWritesMap.containsKey(address)) {
            addressWritesMap.put(address, new HashSet<>());
        }
    }

    public void addAddressRead(BigInteger address, LoadModel read) {
        addressReadsMap.get(address).add(read);
        addressAccessesMap.get(address).add((MemoryEventModel) read);
    }

    public void addAddressWrite(BigInteger address, StoreModel write) {
        addressWritesMap.get(address).add(write);
        addressAccessesMap.get(address).add((MemoryEventModel) write);
    }

    public void addAtomicBlocks(Thread thread, List<List<EventModel>> atomics) {
        atomicBlocksMap.put(thread, atomics);
    }

    public List<ThreadModel> getThreadList() {
        return Collections.unmodifiableList(threadList);
    }

    public List<EventModel> getEventList() {
        return Collections.unmodifiableList(eventList);
    }

    public List<EventModel> getVisibleEventList() {
        return eventList.stream().filter(e -> e.hasTag(Tag.VISIBLE)).toList();
    }

    public List<EventModel> getEventsByFilter(Filter filter) {
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

    public Map<BigInteger, Set<LoadModel>> getAddressReadsMap() {
        return Collections.unmodifiableMap(addressReadsMap);
    }

    public Map<BigInteger, Set<StoreModel>> getAddressWritesMap() {
        return Collections.unmodifiableMap(addressWritesMap);
    }

    public Map<BigInteger, Set<MemoryEventModel>> getAddressAccessesMap() {
        return Collections.unmodifiableMap(addressAccessesMap);
    }

    public Map<Thread, List<List<EventModel>>> getAtomicBlocksMap() {
        return Collections.unmodifiableMap(atomicBlocksMap);
    }
}