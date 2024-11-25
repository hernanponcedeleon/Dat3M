package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.relation.RelationModel;
import com.dat3m.dartagnan.wmm.Relation;

import java.math.BigInteger;
import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;


// This is a new implementation of ExecutionModel which serves as the data structure
// representing an execution in Dartagnan. It contains instances of EventModel for events
// and RelationModel for relations. It is used only by ExecutionGraphVisualizer so far.
public class ExecutionModelNext {
    private final ExecutionModelManager manager;

    private final List<Thread> threadList;
    private final List<EventModel> eventList;
    private final Map<Thread, List<EventModel>> threadEventsMap;
    private final Map<Event, EventModel> eventMap;
    private final Map<Relation, RelationModel> relationMap;
    private final Map<String, RelationModel> relationNameMap;
    private final Map<MemoryObject, MemoryObjectModel> memoryLayoutMap;

    private final Map<BigInteger, Set<LoadModel>> addressReadsMap;
    private final Map<BigInteger, Set<StoreModel>> addressWritesMap;
    private final Map<BigInteger, Set<MemoryEventModel>> addressAccessesMap;
    private final Map<BigInteger, StoreModel> addressInitMap;
    private final Map<String, Set<FenceModel>> fenceMap;
    private final Map<Thread, List<List<EventModel>>> atomicBlocksMap;

    private final Map<LoadModel, StoreModel> readWriteMap;
    private final Map<StoreModel, Set<LoadModel>> writeReadsMap;

    private final Map<BigInteger, List<StoreModel>> coherenceMap;

    // Views
    private List<Thread> threadListView;
    private List<EventModel> eventListView;
    private Map<Thread, List<EventModel>> threadEventsMapView;
    private Map<Event, EventModel> eventMapView;
    private Map<Relation, RelationModel> relationMapView;
    private Map<String, RelationModel> relationNameMapView;
    private Map<MemoryObject, MemoryObjectModel> memoryLayoutMapView;
    private Map<BigInteger, Set<LoadModel>> addressReadsMapView;
    private Map<BigInteger, Set<StoreModel>> addressWritesMapView;
    private Map<BigInteger, Set<MemoryEventModel>> addressAccessesMapView;
    private Map<BigInteger, StoreModel> addressInitMapView;
    private Map<String, Set<FenceModel>> fenceMapView;
    private Map<Thread, List<List<EventModel>>> atomicBlocksMapView;
    private Map<LoadModel, StoreModel> readWriteMapView;
    private Map<StoreModel, Set<LoadModel>> writeReadsMapView;
    private Map<BigInteger, List<StoreModel>> coherenceMapView;

    ExecutionModelNext(ExecutionModelManager manager) {
        this.manager = manager;

        threadList = new ArrayList<>();
        eventList = new ArrayList<>();
        threadEventsMap = new HashMap<>();
        eventMap = new HashMap<>();
        relationMap = new HashMap<>();
        relationNameMap = new HashMap<>();
        memoryLayoutMap= new HashMap<>();

        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
        addressAccessesMap = new HashMap<>();
        addressInitMap = new HashMap<>();
        fenceMap = new HashMap<>();
        atomicBlocksMap = new HashMap<>();

        readWriteMap = new HashMap<>();
        writeReadsMap = new HashMap<>();

        coherenceMap = new HashMap<>();

        createViews();
    }

    private void createViews() {
        threadListView = Collections.unmodifiableList(threadList);
        eventListView = Collections.unmodifiableList(eventList);
        threadEventsMapView = Collections.unmodifiableMap(threadEventsMap);
        eventMapView = Collections.unmodifiableMap(eventMap);
        relationMapView = Collections.unmodifiableMap(relationMap);
        relationNameMapView = Collections.unmodifiableMap(relationNameMap);
        memoryLayoutMapView = Collections.unmodifiableMap(memoryLayoutMap);
        addressReadsMapView = Collections.unmodifiableMap(addressReadsMap);
        addressWritesMapView = Collections.unmodifiableMap(addressWritesMap);
        addressAccessesMapView = Collections.unmodifiableMap(addressAccessesMap);
        addressInitMapView = Collections.unmodifiableMap(addressInitMap);
        fenceMapView = Collections.unmodifiableMap(fenceMap);
        atomicBlocksMapView = Collections.unmodifiableMap(atomicBlocksMap);
        readWriteMapView = Collections.unmodifiableMap(readWriteMap);
        writeReadsMapView = Collections.unmodifiableMap(writeReadsMap);
        coherenceMapView = Collections.unmodifiableMap(coherenceMap);
    }

    public void addThreadEvents(Thread thread, List<EventModel> events) {
        threadList.add(thread);
        threadEventsMap.put(thread, events);
    }

    public void addEvent(Event e, EventModel eModel) {
        eventList.add(eModel);
        eventMap.put(e, eModel);
    }

    public void addRelation(Relation r, RelationModel rModel) {
        relationMap.put(r, rModel);
        // We add an entry for each name of the relation.
        for (String name : rModel.getNames()) {
            relationNameMap.put(name, rModel);
        }
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

    public void addAddressInit(BigInteger address, StoreModel init) {
        addressInitMap.put(address, init);
    }

    public void addFence(FenceModel fence) {
        fenceMap.computeIfAbsent(fence.getName(), key -> new HashSet<>()).add(fence);
    }
    
    public void addAtomicBlocks(Thread thread, List<List<EventModel>> atomics) {
        atomicBlocksMap.put(thread, atomics);
    }

    public void addReadWrite(LoadModel read, StoreModel write) {
        readWriteMap.put(read, write);
    }

    public void addWriteRead(StoreModel write, LoadModel read) {
        writeReadsMap.computeIfAbsent(write, key -> new HashSet<>()).add(read);
    }

    public void addCoherenceWrites(BigInteger address, List<StoreModel> writes) {
        coherenceMap.put(address, writes);
    }

    public ExecutionModelManager getManager() {
        return manager;
    }

    public List<Thread> getThreads() {
        return threadList;
    }

    public List<EventModel> getEventList() {
        return eventListView;
    }

    public EventModel getEventModelById(int id) {
        return eventList.get(id);
    }

    public EventModel getEventModelByEvent(Event event) {
        return eventMap.get(event);
    }

    public List<EventModel> getEventModelsToShow(Thread t) {
        return threadEventsMap.get(t).stream()
                              .filter(e -> e.hasTag(Tag.VISIBLE) || e.isLocal() || e.isAssert())
                              .toList();
    }

    public RelationModel getRelationModel(String name) {
        return relationNameMap.get(name);
    }

    public Map<Thread, List<EventModel>> getThreadEventsMap() {
        return threadEventsMapView;
    }

    public Map<MemoryObject, MemoryObjectModel> getMemoryLayoutMap() {
        return memoryLayoutMapView;
    }

    public Map<BigInteger, Set<LoadModel>> getAddressReadsMap() {
        return addressReadsMapView;
    }

    public Map<BigInteger, Set<StoreModel>> getAddressWritesMap() {
        return addressWritesMapView;
    }

    public Map<BigInteger, Set<MemoryEventModel>> getAddressAccessesMap() {
        return addressAccessesMapView;
    }

    public Map<BigInteger, StoreModel> getAddressInitMap() {
        return addressInitMapView;
    }

    public Map<Thread, List<List<EventModel>>> getAtomicBlocksMap() {
        return atomicBlocksMapView;
    }
}