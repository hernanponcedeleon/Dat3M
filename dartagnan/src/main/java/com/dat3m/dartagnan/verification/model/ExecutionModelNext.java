package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.relation.RelationModel;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.Relation;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;
import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkNotNull;


public class ExecutionModelNext {
    private final EncodingContext encodingContext;
    private Model model;
    private EncodingContext contextWithFullWmm; // This context is needed for extraction of relations when RefinementSolver being used.
    private ExecutionModelManager manager;

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

    ExecutionModelNext(EncodingContext encodingContext) {
        this.encodingContext = checkNotNull(encodingContext);

        threadList = new ArrayList<>(getProgram().getThreads().size());
        eventList = new ArrayList<>();
        threadEventsMap = new HashMap<>(getProgram().getThreads().size() * 4 / 3, 0.75f);
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

    void clear() {
        threadList.clear();
        eventList.clear();
        threadEventsMap.clear();
        eventMap.clear();
        relationMap.clear();
        relationNameMap.clear();
        memoryLayoutMap.clear();
        addressReadsMap.clear();
        addressWritesMap.clear();
        addressAccessesMap.clear();
        addressInitMap.clear();
        fenceMap.clear();
        atomicBlocksMap.clear();
        readWriteMap.clear();
        writeReadsMap.clear();
        coherenceMap.clear();
    }

    void setModel(Model model) {
        this.model = model;
    }

    void setContextWithFullWmm(EncodingContext context) {
        contextWithFullWmm = context;
    }

    void setManager(ExecutionModelManager manager) {
        this.manager = manager;
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
        relationNameMap.put(rModel.getName(), rModel);
    }

    public void addMemoryObject(MemoryObject m, MemoryObjectModel mModel) {
        memoryLayoutMap.put(m, mModel);
    }

    public void addAddressRead(BigInteger address, LoadModel read) {
        addressReadsMap.computeIfAbsent(address, key -> new HashSet<>()).add(read);
        addressAccessesMap.computeIfAbsent(address, key -> new HashSet<>()).add((MemoryEventModel) read);
    }

    public void addAddressWrite(BigInteger address, StoreModel write) {
        addressWritesMap.computeIfAbsent(address, key -> new HashSet<>()).add(write);
        addressAccessesMap.computeIfAbsent(address, key -> new HashSet<>()).add((MemoryEventModel) write);
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

    public EncodingContext getEncodingContext() {
        return encodingContext;
    }

    public ExecutionModelManager getManager() {
        return manager;
    }

    public EncodingContext getContextWithFullWmm() {
        if (contextWithFullWmm != null) {
            return contextWithFullWmm;
        }
        return encodingContext;
    }

    public Program getProgram() {
        return encodingContext.getTask().getProgram();
    }

    public Wmm getFullMemoryModel() {
        return getContextWithFullWmm().getTask().getMemoryModel();
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

    public boolean isTrue(BooleanFormula formula) {
        return Boolean.TRUE.equals(model.evaluate(formula));
    }

    public Object evaluateByModel(Formula formula) {
        return model.evaluate(formula);
    }
}