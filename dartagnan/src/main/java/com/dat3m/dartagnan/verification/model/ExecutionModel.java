package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.google.common.base.Preconditions.checkNotNull;

/*
The ExecutionModel wraps a Model and extracts data from it in a more workable manner.
 */

//TODO: Add the capability to remove unnecessary init events from a model
// i.e. those that init some address which no read nor write accesses.
public class ExecutionModel {

    private static final Logger logger = LogManager.getLogger(ExecutionModel.class);

    private final EncodingContext encodingContext;

    // ============= Model specific  =============
    private Model model;
    private Filter eventFilter;
    private boolean extractCoherences;

    private final EventMap eventMap;
    // The event list is sorted lexicographically by (threadID, cID)
    private final ArrayList<EventData> eventList;
    private final ArrayList<Thread> threadList;
    private final Map<MemoryObject, MemoryObjectModel> memoryLayoutMap;
    private final Map<Thread, List<EventData>> threadEventsMap;
    private final Map<Thread, List<List<EventData>>> atomicBlocksMap;
    private final Map<EventData, EventData> readWriteMap;
    private final Map<EventData, Set<EventData>> writeReadsMap;
    private final Map<String, Set<EventData>> fenceMap;
    private final Map<BigInteger, Set<EventData>> addressReadsMap;
    private final Map<BigInteger, Set<EventData>> addressWritesMap; // This ALSO contains the init writes
    private final Map<BigInteger, EventData> addressInitMap;
    //Note, we could merge the three above maps into a single one that holds writes, reads and init writes.

    private final Map<EventData, Set<EventData>> dataDepMap;
    private final Map<EventData, Set<EventData>> addrDepMap;
    private final Map<EventData, Set<EventData>> ctrlDepMap;

    private final Map<BigInteger, List<EventData>> coherenceMap;

    // The following are a read-only views which get passed to the outside
    private List<EventData> eventListView;
    private List<Thread> threadListView;
    private Map<MemoryObject, MemoryObjectModel> memoryLayoutMapView;
    private Map<Thread, List<EventData>> threadEventsMapView;
    private Map<Thread, List<List<EventData>>> atomicBlocksMapView;
    private Map<EventData, EventData> readWriteMapView;
    private Map<EventData, Set<EventData>> writeReadsMapView;
    private Map<String, Set<EventData>> fenceMapView;
    private Map<BigInteger, Set<EventData>> addressReadsMapView;
    private Map<BigInteger, Set<EventData>> addressWritesMapView;
    private Map<BigInteger, EventData> addressInitMapView;

    private Map<EventData, Set<EventData>> dataDepMapView;
    private Map<EventData, Set<EventData>> addrDepMapView;
    private Map<EventData, Set<EventData>> ctrlDepMapView;

    private Map<BigInteger, List<EventData>> coherenceMapView;

    private ExecutionModel(EncodingContext c) {
        this.encodingContext = checkNotNull(c);

        eventList = new ArrayList<>(100);
        threadList = new ArrayList<>(getProgram().getThreads().size());
        threadEventsMap = new HashMap<>(getProgram().getThreads().size() * 4/3, 0.75f);
        memoryLayoutMap = new HashMap<>();
        atomicBlocksMap = new HashMap<>();
        readWriteMap = new HashMap<>();
        writeReadsMap = new HashMap<>();
        fenceMap = new HashMap<>();
        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
        addressInitMap = new HashMap<>();
        eventMap = new EventMap();
        dataDepMap = new HashMap<>();
        addrDepMap = new HashMap<>();
        ctrlDepMap = new HashMap<>();
        coherenceMap = new HashMap<>();

        createViews();
    }

    public static ExecutionModel withContext(EncodingContext context) throws InvalidConfigurationException {
        return new ExecutionModel(context);
    }

    private void createViews() {
        eventListView = Collections.unmodifiableList(eventList);
        threadListView = Collections.unmodifiableList(threadList);
        memoryLayoutMapView = Collections.unmodifiableMap(memoryLayoutMap);
        threadEventsMapView = Collections.unmodifiableMap(threadEventsMap);
        atomicBlocksMapView = Collections.unmodifiableMap(atomicBlocksMap);
        readWriteMapView = Collections.unmodifiableMap(readWriteMap);
        writeReadsMapView = Collections.unmodifiableMap(writeReadsMap);
        fenceMapView = Collections.unmodifiableMap(fenceMap);
        addressReadsMapView = Collections.unmodifiableMap(addressReadsMap);
        addressWritesMapView = Collections.unmodifiableMap(addressWritesMap);
        addressInitMapView = Collections.unmodifiableMap(addressInitMap);
        dataDepMapView = Collections.unmodifiableMap(dataDepMap);
        addrDepMapView = Collections.unmodifiableMap(addrDepMap);
        ctrlDepMapView = Collections.unmodifiableMap(ctrlDepMap);
        coherenceMapView = Collections.unmodifiableMap(coherenceMap);
    }

    //======================== Public data ===========================‚

    // General data
    public VerificationTask getTask() {
        return encodingContext.getTask();
    }
    
    public Wmm getMemoryModel() {
        return encodingContext.getTask().getMemoryModel();
    }

    public Program getProgram() {
        return encodingContext.getTask().getProgram();
    }

    // Model specific data
    public Model getModel() {
        return model;
    }
    public EncodingContext getContext() {
        return encodingContext;
    }
    public Filter getEventFilter() {
        return eventFilter;
    }
    public boolean hasCoherences() {
        return extractCoherences;
    }

    public List<EventData> getEventList() {
        return eventListView;
    }

    public List<Thread> getThreads() {
        return threadListView;
    }

    public Map<MemoryObject, MemoryObjectModel> getMemoryLayoutMap() { return memoryLayoutMapView; }
    public Map<Thread, List<EventData>> getThreadEventsMap() {
        return threadEventsMapView;
    }
    public Map<Thread, List<List<EventData>>> getAtomicBlocksMap() { return atomicBlocksMapView; }
    public Map<EventData, EventData> getReadWriteMap() {
        return readWriteMapView;
    }
    public Map<EventData, Set<EventData>> getWriteReadsMap() {
        return writeReadsMapView;
    }
    public Map<String, Set<EventData>> getFenceMap() {
        return fenceMapView;
    }
    public Map<BigInteger, Set<EventData>> getAddressReadsMap() {
        return addressReadsMapView;
    }
    public Map<BigInteger, Set<EventData>> getAddressWritesMap() {
        return addressWritesMapView;
    }
    public Map<BigInteger, EventData> getAddressInitMap() {
        return addressInitMapView;
    }
    public Map<EventData, Set<EventData>> getAddrDepMap() { return addrDepMapView; }
    public Map<EventData, Set<EventData>> getDataDepMap() { return dataDepMapView; }
    public Map<EventData, Set<EventData>> getCtrlDepMap() { return ctrlDepMapView; }
    public Map<BigInteger, List<EventData>> getCoherenceMap() { return coherenceMapView; }



    public boolean eventExists(Event e) {
        return eventMap.contains(e);
    }

    public Optional<EventData> getData(Event e) {
        return Optional.ofNullable(eventMap.get(e));
    }

    //========================== Initialization =========================


    public void initialize(Model model) {
        initialize(model, true);
    }

    public void initialize(Model model, boolean extractCoherences) {
        initialize(model, Filter.byTag(Tag.VISIBLE), extractCoherences);
    }

    public void initialize(Model model, Filter eventFilter, boolean extractCoherences) {
        // We populate here, instead of on construction,
        // to reuse allocated data structures (since these data structures already adapted
        // their capacity in previous iterations, and thus we should have less overhead in future populations)
        // However, for all intents and purposes, this serves as a constructor.
        this.model = model;
        this.eventFilter = eventFilter;
        this.extractCoherences = extractCoherences;
        extractEventsFromModel();
        extractMemoryLayout();
        extractReadsFrom();
        coherenceMap.clear();
        if (extractCoherences) {
            extractCoherences();
        }
    }

    //========================== Internal methods  =========================

    private void extractEventsFromModel() {
        //TODO(TH): We might also want to extract events such as inline assertions
        // and whether they were violated or not.
        int id = 0;
        eventList.clear();
        threadList.clear();
        threadEventsMap.clear();
        atomicBlocksMap.clear();
        addressInitMap.clear(); // This one can probably be constant and need not be rebuilt!
        addressWritesMap.clear();
        addressReadsMap.clear();
        writeReadsMap.clear();
        fenceMap.clear();
        eventMap.clear();
        addrDepMap.clear();
        dataDepMap.clear();
        ctrlDepMap.clear();

        List<Thread> threadList = new ArrayList<>(getProgram().getThreads());
        List<Integer> threadEndIndexList = new ArrayList<>(threadList.size());
        Map<Thread, List<List<Integer>>> atomicBlockRangesMap = new HashMap<>();

        for (Thread thread : threadList) {
            initDepTracking();
            List<List<Integer>> atomicBlockRanges = atomicBlockRangesMap.computeIfAbsent(thread, key -> new ArrayList<>());
            Event e = thread.getEntry();
            int atomicBegin = -1;
            int localId = 0;
            do {
                if (!isTrue(encodingContext.execution(e))) {
                    e = e.getSuccessor();
                    continue;
                }
                if (eventFilter.apply(e)) {
                    addEvent(e, id++, localId++);
                }
                trackDependencies(e);

                // ===== Atomic blocks =====
                if (e instanceof BeginAtomic) {
                    atomicBegin = id;
                } else if (e instanceof EndAtomic) {
                    Preconditions.checkState(atomicBegin != -1, "EndAtomic without matching BeginAtomic in model");
                    atomicBlockRanges.add(ImmutableList.of(atomicBegin, id));
                    atomicBegin = -1;
                }
                // =========================

                if (e instanceof CondJump jump && isTrue(encodingContext.jumpCondition(jump))) {
                    e = jump.getLabel();
                } else {
                    e = e.getSuccessor();
                }

            } while (e != null);
            // We have a BeginAtomic without EndAtomic since the program terminated within the block
            if (atomicBegin != -1) {
                atomicBlockRanges.add(ImmutableList.of(atomicBegin, id));
            }
            // -----------
            threadEndIndexList.add(id);
        }

        // Get sublists for all threads
        int start = 0;
        for (int i = 0; i < threadList.size(); i++) {
            Thread thread = threadList.get(i);
            int end = threadEndIndexList.get(i);
            if (start != end) {
                this.threadList.add(thread);
                threadEventsMap.put(thread, Collections.unmodifiableList(eventList.subList(start, end)));

                atomicBlocksMap.put(thread, new ArrayList<>());
                for (List<Integer> aRange : atomicBlockRangesMap.get(thread)) {
                    atomicBlocksMap.get(thread).add(eventList.subList(aRange.get(0), aRange.get(1)));
                }
            }
            start = end;
        }
    }


    private void addEvent(Event e, int globalId, int localId) {
        EventData data = eventMap.getOrCreate(e);
        data.setId(globalId);
        data.setLocalId(localId);
        eventList.add(data);

        data.setWasExecuted(true);
        if (data.isMemoryEvent()) {
            // ===== Memory Events =====
            Object addressObject = checkNotNull(model.evaluate(encodingContext.address((MemoryEvent) e)));
            BigInteger address = new BigInteger(addressObject.toString());
            data.setAccessedAddress(address);
            if (!addressReadsMap.containsKey(address)) {
                addressReadsMap.put(address, new HashSet<>());
                addressWritesMap.put(address, new HashSet<>());
            }

            if (data.isRead() || data.isWrite()) {
                Formula valueFormula = encodingContext.value((MemoryCoreEvent)e);
                assert valueFormula != null;
                String valueString = String.valueOf(model.evaluate(valueFormula));
                BigInteger value = switch(valueString) {
                    // NULL case can happen if the solver optimized away a variable.
                    // This should only happen if the value is irrelevant, so we will just pick 0.
                    case "false", "null" -> BigInteger.ZERO;
                    case "true" -> BigInteger.ONE;
                    default -> new BigInteger(valueString);
                };
                data.setValue(value);
            }

            if (data.isRead()) {
                addressReadsMap.get(address).add(data);
            } else if (data.isWrite()) {
                addressWritesMap.get(address).add(data);
                writeReadsMap.put(data, new HashSet<>());
                if (data.isInit()) {
                    addressInitMap.put(address, data);
                }
            } else {
                //FIXME: Handle other kinds of memory events such as SRCU_SYNC.
                throw new UnsupportedOperationException("Unexpected memory event " + data.getEvent());
            }

        } else if (data.isFence()) {
            // ===== Fences =====
            // FIXME this assumes not only that the event has a fence tag but also that it
            // is a GenericVisibleEvent. This is dangerous and should be fixed.
            String name = ((GenericVisibleEvent)data.getEvent()).getName();
            fenceMap.computeIfAbsent(name, key -> new HashSet<>()).add(data);
        } else if (data.isJump()) {
            // ===== Jumps =====
            // We override the meaning of execution here. A jump is executed IFF its condition was true.
            data.setWasExecuted(isTrue(encodingContext.jumpCondition((CondJump) e)));
        } else {
            //TODO: Maybe add some other events (e.g. assertions)
            // But for now all non-visible events are simply registered without
            // having any data extracted
        }
    }

    // =============== Dependency tracking ===============
    //TODO: The following code is refinement specific and assumes that only visible events get extracted!

    // Due to intra thread communication using registers, we do not
    // reset this map for every thread, but keep it global
    private Map<Register, Set<EventData>> lastRegWrites = new HashMap<>();
    private Set<EventData> curCtrlDeps;
    // The following is used for Linux
    private Stack<Set<EventData>> ifCtrlDeps;
    private Stack<Label> endIfs;
    //------------------------
    private void initDepTracking() {
        curCtrlDeps = new HashSet<>();
        ifCtrlDeps = new Stack<>();
        endIfs = new Stack<>();
    }

    private void trackDependencies(Event e) {

        while (!endIfs.isEmpty() && e.getGlobalId() >= endIfs.peek().getGlobalId()) {
            // We exited an If-then-else block and remove the dependencies associated with it.
            // We do this inside a loop just in case multiple Ifs are left simultaneously
            endIfs.pop();
            curCtrlDeps.removeAll(ifCtrlDeps.pop());
        }

        if (e.hasTag(Tag.VISIBLE)) {
            // ---- Track ctrl dependency ----
            // TODO: This may be done more efficiently, as many events share the same set of ctrldeps.
            ctrlDepMap.put(eventMap.get(e), new HashSet<>(curCtrlDeps));
        }

        if (e instanceof RegReader regReader) {
            final Set<EventData> dataDeps = new HashSet<>();
            final Set<EventData> addrDeps = new HashSet<>();
            final Set<EventData> ctrlDeps = new HashSet<>();
            for (Register.Read regRead : regReader.getRegisterReads()) {
                final Register reg = regRead.register();
                final Set<EventData> visibleRootDependencies = lastRegWrites.get(reg);
                if (visibleRootDependencies == null) {
                    // FIXME: This should never happen, but our parser is buggy and produces ill-formed code.
                    logger.warn("Encountered uninitialized register {} read by {} in an execution.", reg, e);
                    continue;
                }
                switch (regRead.usageType()) {
                    case DATA -> dataDeps.addAll(visibleRootDependencies);
                    case ADDR -> addrDeps.addAll(visibleRootDependencies);
                    case CTRL -> ctrlDeps.addAll(visibleRootDependencies);
                }
            }

            final EventData eData = eventMap.get(e);
            if (e.hasTag(Tag.VISIBLE)) {
                // For visible events we store the dependencies.
                dataDepMap.put(eData, dataDeps);
                addrDepMap.put(eData, addrDeps);
            }
            if (e instanceof IfAsJump ifJmp) {
                // Remember what dependencies were added when entering the If so we can remove them when exiting
                HashSet<EventData> addedDeps = new HashSet<>(Sets.difference(ctrlDeps, curCtrlDeps));
                ifCtrlDeps.push(addedDeps);
                endIfs.push(ifJmp.getEndIf());
            }
            curCtrlDeps.addAll(ctrlDeps);
        }

        if (e instanceof RegWriter regWriter) {
            if (regWriter instanceof Load load) {
                final EventData eData = eventMap.get(e);
                lastRegWrites.put(load.getResultRegister(), new HashSet<>(Set.of(eData)));
            } else if (regWriter instanceof ExecutionStatus status) {
                // ---- Track data dependency due to execution tracking ----
                final Event tracked = status.getStatusEvent();
                HashSet<EventData> deps = new HashSet<>();
                if (eventExists(tracked) && status.doesTrackDep()) {
                    deps.add(eventMap.get(tracked));
                    //TODO: If the tracked event is a RMWStoreExclusive, don't we need to
                    // put a dependency to the paired exclusive load if the store failed to execute?
                }
                lastRegWrites.put(status.getResultRegister(), deps);
            } else if (regWriter instanceof RegReader regReader) {
                // Note: This code might work for more cases than we check for here,
                // but we want to throw an exception if an unexpected event appears.
                assert regWriter instanceof Local || regWriter instanceof Alloc;
                // ---- internal data dependency ----
                final Set<EventData> dataDeps = new HashSet<>();
                for (Register.Read regRead : regReader.getRegisterReads()) {
                    final Register reg = regRead.register();
                    final Set<EventData> visibleRootDependencies = lastRegWrites.get(reg);
                    if (visibleRootDependencies == null) {
                        // FIXME: This should never happen, but our parser is buggy and produces ill-formed code.
                        logger.warn("Encountered uninitialized register {} read by {} in an execution.", reg, e);
                        continue;
                    }
                    assert regRead.usageType() == Register.UsageType.DATA;
                    dataDeps.addAll(visibleRootDependencies);
                }
                lastRegWrites.put(regWriter.getResultRegister(), dataDeps);
            } else {
                assert e instanceof ThreadArgument;
                // We have a RegWriter that doesn't read registers, so there are no dependencies.
                lastRegWrites.put(regWriter.getResultRegister(), new HashSet<>());
            }
        }
    }

    // ===================================================

    private void extractMemoryLayout() {
        memoryLayoutMap.clear();
        for (MemoryObject obj : getProgram().getMemory().getObjects()) {
            final boolean isAllocated = obj.isStaticallyAllocated() || isTrue(encodingContext.execution(obj.getAllocationSite()));
            if (isAllocated) {
                final ValueModel address = new ValueModel(model.evaluate(encodingContext.address(obj)));
                final BigInteger size = (BigInteger) model.evaluate(encodingContext.size(obj));
                memoryLayoutMap.put(obj, new MemoryObjectModel(obj, address, size));
            }
        }
    }

    private void extractReadsFrom() {
        final EncodingContext.EdgeEncoder rf = encodingContext.edge(encodingContext.getTask().getMemoryModel().getRelation(RF));
        readWriteMap.clear();

        for (Map.Entry<BigInteger, Set<EventData>> addressedReads : addressReadsMap.entrySet()) {
            BigInteger address = addressedReads.getKey();
            for (EventData read : addressedReads.getValue()) {
                for (EventData write : addressWritesMap.get(address)) {
                    BooleanFormula rfExpr = rf.encode(write.getEvent(), read.getEvent());
                    if (isTrue(rfExpr)) {
                        readWriteMap.put(read, write);
                        read.setReadFrom(write);
                        writeReadsMap.get(write).add(read);
                        break;
                    }
                }
            }
        }
    }

    private void extractCoherences() {
        final EncodingContext.EdgeEncoder co = encodingContext.edge(encodingContext.getTask().getMemoryModel().getRelation(CO));

        for (Map.Entry<BigInteger, Set<EventData>> addrWrites : addressWritesMap.entrySet()) {
            final BigInteger addr = addrWrites.getKey();
            final Set<EventData> writes = addrWrites.getValue();

            List<EventData> coSortedWrites;
            if (encodingContext.usesSATEncoding()) {
                // --- Extracting co from SAT-based encoding ---
                Map<EventData, List<EventData>> coEdges = new HashMap<>();
                for (EventData w1 : writes) {
                    coEdges.put(w1, new ArrayList<>());
                    for (EventData w2 : writes) {
                        if (isTrue(co.encode(w1.getEvent(), w2.getEvent()))) {
                            coEdges.get(w1).add(w2);
                        }
                    }
                }
                DependencyGraph<EventData> depGraph = DependencyGraph.from(writes, coEdges);
                coSortedWrites = new ArrayList<>(Lists.reverse(depGraph.getNodeContents()));
            } else {
                // --- Extracting co from IDL-based encoding using clock variables ---
                Map<EventData, BigInteger> writeClockMap = new HashMap<>(writes.size() * 4 / 3, 0.75f);
                for (EventData w : writes) {
                    writeClockMap.put(w, model.evaluate(encodingContext.memoryOrderClock(w.getEvent())));
                }
                coSortedWrites = writes.stream().sorted(Comparator.comparing(writeClockMap::get)).collect(Collectors.toList());
            }

            // --- Apply internal clock orders (we always start from 0) --
            int i = 0;
            for (EventData w : coSortedWrites) {
                w.setCoherenceIndex(i++);
            }
            coherenceMap.put(addr, Collections.unmodifiableList(coSortedWrites));
        }

    }

    private boolean isTrue(BooleanFormula formula) {
        return Boolean.TRUE.equals(model.evaluate(formula));
    }
}