package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;

/*
The ExecutionModel wraps a Model and extracts data from it in a more workable manner.
 */

//TODO: Add the capability to remove unnecessary init events from a model
// i.e. those that init some address which no read nor write accesses.
@Options
public class ExecutionModel {

    private final EncodingContext encodingContext;

    // ============= Model specific  =============
    private Model model;
    private SolverContext context;
    private FilterAbstract eventFilter;
    private boolean extractCoherences;

    private final EventMap eventMap;
    // The event list is sorted lexicographically by (threadID, cID)
    private final ArrayList<EventData> eventList;
    private final ArrayList<Thread> threadList;
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
        this.encodingContext = Preconditions.checkNotNull(c);

        eventList = new ArrayList<>(100);
        threadList = new ArrayList<>(getProgram().getThreads().size());
        threadEventsMap = new HashMap<>(getProgram().getThreads().size() * 4/3, 0.75f);
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
        ExecutionModel m = new ExecutionModel(context);
        context.getTask().getConfig().inject(m);
        return m;
    }

    private void createViews() {
        eventListView = Collections.unmodifiableList(eventList);
        threadListView = Collections.unmodifiableList(threadList);
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
    public FilterAbstract getEventFilter() {
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
        initialize(model, FilterBasic.get(Tag.VISIBLE), extractCoherences);
    }

    public void initialize(Model model, FilterAbstract eventFilter, boolean extractCoherences) {
        // We populate here, instead of on construction,
        // to reuse allocated data structures (since these data structures already adapted
        // their capacity in previous iterations and thus we should have less overhead in future populations)
        // However, for all intents and purposes, this serves as a constructor.
        this.model = model;
        this.context = encodingContext.getSolverContext();
        this.eventFilter = eventFilter;
        this.extractCoherences = extractCoherences;
        extractEventsFromModel();
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
                if (!Boolean.TRUE.equals(model.evaluate(encodingContext.execution(e)))) {
                    e = e.getSuccessor();
                    continue;
                }
                if (eventFilter.filter(e)) {
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

                if (e instanceof CondJump) {
                    CondJump jump = (CondJump) e;
                    if (jump.didJump(model, context)) {
                        e = jump.getLabel();
                        continue;
                    }
                }
                e = e.getSuccessor();

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
        	BigInteger address = ((MemEvent) e).getAddress().getIntValue(e, model, context);
            data.setAccessedAddress(address);
            if (!addressReadsMap.containsKey(address)) {
                addressReadsMap.put(address, new HashSet<>());
                addressWritesMap.put(address, new HashSet<>());
            }

            if (data.isRead()) {
                data.setValue(new BigInteger(model.evaluate(encodingContext.result((RegWriter) e)).toString()));
                addressReadsMap.get(address).add(data);
            } else if (data.isWrite()) {
                data.setValue(((MemEvent)e).getMemValue().getIntValue(e, model, context));
                addressWritesMap.get(address).add(data);
                writeReadsMap.put(data, new HashSet<>());
                if (data.isInit()) {
                    addressInitMap.put(address, data);
                }
            } else {
                throw new UnsupportedOperationException("Unexpected memory event " + data.getEvent());
            }

        } else if (data.isFence()) {
            // ===== Fences =====
            String name = ((Fence)data.getEvent()).getName();
            fenceMap.computeIfAbsent(name, key -> new HashSet<>()).add(data);
        } else if (data.isJump()) {
            // ===== Jumps =====
            // We override the meaning of execution here. A jump is executed IFF its condition was true.
            data.setWasExecuted(((CondJump)e).didJump(model, context));
        } else {
            //TODO: Maybe add some other events (e.g. assertions)
            // But for now all non-visible events are simply registered without
            // having any data extracted
        }
    }

    // =============== Dependency tracking ===============
    //TODO: The following code is refinement specific and assumes that only visible events get extracted!

    private Map<Register, Set<EventData>> lastRegWrites;
    private Set<EventData> curCtrlDeps;
    // The following is used for Linux
    private Stack<Set<EventData>> ifCtrlDeps;
    private Stack<Label> endIfs;
    //------------------------
    private void initDepTracking() {
        lastRegWrites = new HashMap<>();
        curCtrlDeps = new HashSet<>();
        ifCtrlDeps = new Stack<>();
        endIfs = new Stack<>();
    }

    private void trackDependencies(Event e) {

        while (!endIfs.isEmpty() && e.getCId() >= endIfs.peek().getCId()) {
            // We exited an If and remove the dependencies associated with it
            // We do this inside a loop just in case multiple Ifs are left simultaneously
            endIfs.pop();
            curCtrlDeps.removeAll(ifCtrlDeps.pop());
        }


        if (e instanceof MemEvent) {
            // ---- Track address dependency ----
            MemEvent memEvent = (MemEvent) e;
            HashSet<EventData> deps = new HashSet<>();

            for (Register reg : memEvent.getAddress().getRegs()) {
                deps.addAll(lastRegWrites.get(reg));
            }
            addrDepMap.put(eventMap.get(e), deps);
        }

        if (e.is(Tag.VISIBLE)) {
            // ---- Track ctrl dependency ----
            // TODO: This may be done more efficiently, as many events share the same set of ctrldeps.
            ctrlDepMap.put(eventMap.get(e), new HashSet<>(curCtrlDeps));
        }

        if (e instanceof ExecutionStatus) {
            // ---- Track data dependency due to execution tracking ----
            ExecutionStatus status = (ExecutionStatus) e;
            Event tracked = status.getStatusEvent();
            HashSet<EventData> deps = new HashSet<>();
            if (eventExists(tracked) && status.doesTrackDep()) {
                deps.add(eventMap.get(tracked));
            }
            lastRegWrites.put(status.getResultRegister(), deps);
        }

        if (e instanceof RegReaderData) {
            // ---- Track data dependency ----
            RegReaderData reader = (RegReaderData)e;
            HashSet<EventData> deps = new HashSet<>();
            for (Register r : reader.getDataRegs()) {
                deps.addAll(lastRegWrites.getOrDefault(r, Collections.emptySet()));
            }

            if (e instanceof Store) {
                // ---- visible data dependency ----
                dataDepMap.put(eventMap.get(e), deps);
            }
            if (e instanceof RegWriter) {
                // ---- internal data dependency ----
                RegWriter writer = (RegWriter) e;
                lastRegWrites.put(writer.getResultRegister(), deps);
            }
            if (e instanceof CondJump) {
                if (e instanceof IfAsJump) {
                    // Remember what dependencies were added when entering the If so we can remove them when exiting
                    HashSet<EventData> addedDeps = new HashSet<>(Sets.difference(deps, curCtrlDeps));
                    ifCtrlDeps.push(addedDeps);
                    endIfs.push(((IfAsJump)e).getEndIf());
                }
                // Jumps add all dependencies
                curCtrlDeps.addAll(deps);
            }
        }

        if (e instanceof Load) {
            // ---- Update lastRegWrites ----
            Load load = (Load)e;
            lastRegWrites.compute(load.getResultRegister(), (k, v) -> new HashSet<>()).add(eventMap.get(e));
        }
    }

    // ===================================================

    private void extractReadsFrom() {
        final Relation rf = getMemoryModel().getRelation(RF);
        readWriteMap.clear();

        for (Map.Entry<BigInteger, Set<EventData>> addressedReads : addressReadsMap.entrySet()) {
        	BigInteger address = addressedReads.getKey();
            for (EventData read : addressedReads.getValue()) {
                for (EventData write : addressWritesMap.get(address)) {
                    BooleanFormula rfExpr = encodingContext.edge(rf, write.getEvent(), read.getEvent());
                    // The null check is important: Currently there are cases where no rf-edge between
                    // init writes and loads get encoded (in case of arrays/structs). This is usually no problem,
                    // since in a well-initialized program, the init write should not be readable anyway.
					Boolean rfVal = model.evaluate(rfExpr);
					if (rfVal != null && rfVal) {
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
        final Relation co = encodingContext.getTask().getMemoryModel().getRelation(CO);

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
                        if (Boolean.TRUE.equals(model.evaluate(encodingContext.edge(co, w1.getEvent(), w2.getEvent())))) {
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
}