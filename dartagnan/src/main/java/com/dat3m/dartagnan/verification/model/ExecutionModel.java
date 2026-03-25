package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Dealloc;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;

import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;

/*
The ExecutionModel wraps a Model and extracts data from it in a more workable manner.
 */

//TODO: Add the capability to remove unnecessary init events from a model
// i.e. those that init some address which no read nor write accesses.
public class ExecutionModel {

    private final EncodingContext ctx;

    // ============= Model specific  =============
    private IREvaluator irModel;

    private final EventMap eventMap;
    // The event list is sorted lexicographically by (threadID, cID)
    private final ArrayList<EventData> eventList;
    private final ArrayList<Thread> threadList;
    private final Map<Thread, List<EventData>> threadEventsMap;
    private final Map<Thread, List<List<EventData>>> atomicBlocksMap;
    private final Map<Object, Set<EventData>> addressReadsMap;
    private final Map<Object, Set<EventData>> addressWritesMap;

    // The following are a read-only views which get passed to the outside
    private List<EventData> eventListView;
    private List<Thread> threadListView;
    private Map<Thread, List<EventData>> threadEventsMapView;
    private Map<Thread, List<List<EventData>>> atomicBlocksMapView;
    private Map<Object, Set<EventData>> addressReadsMapView;
    private Map<Object, Set<EventData>> addressWritesMapView;

    private ExecutionModel(EncodingContext c) {
        this.ctx = checkNotNull(c);

        eventList = new ArrayList<>(100);
        threadList = new ArrayList<>(getProgram().getThreads().size());
        threadEventsMap = new HashMap<>(getProgram().getThreads().size() * 4/3, 0.75f);
        atomicBlocksMap = new HashMap<>();
        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
        eventMap = new EventMap();

        createViews();
    }

    public static ExecutionModel withContext(EncodingContext context) {
        return new ExecutionModel(context);
    }

    private void createViews() {
        eventListView = Collections.unmodifiableList(eventList);
        threadListView = Collections.unmodifiableList(threadList);
        threadEventsMapView = Collections.unmodifiableMap(threadEventsMap);
        atomicBlocksMapView = Collections.unmodifiableMap(atomicBlocksMap);
        addressReadsMapView = Collections.unmodifiableMap(addressReadsMap);
        addressWritesMapView = Collections.unmodifiableMap(addressWritesMap);
    }

    //======================== Public data ===========================‚

    // General data
    public VerificationTask getTask() {
        return ctx.getTask();
    }
    
    public Wmm getMemoryModel() {
        return ctx.getTask().getMemoryModel();
    }

    public Program getProgram() {
        return ctx.getTask().getProgram();
    }

    // Model specific data
    public IREvaluator getEvaluator() {
        return irModel;
    }
    public EncodingContext getContext() {
        return ctx;
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

    public Map<Object, Set<EventData>> getAddressReadsMap() {
        return addressReadsMapView;
    }
    public Map<Object, Set<EventData>> getAddressWritesMap() {
        return addressWritesMapView;
    }

    public Optional<EventData> getData(Event e) {
        return Optional.ofNullable(eventMap.get(e));
    }

    //========================== Initialization =========================

    public void initialize(IREvaluator model) {
        // We populate here, instead of on construction,
        // to reuse allocated data structures (since these data structures already adapted
        // their capacity in previous iterations, and thus we should have less overhead in future populations)
        // However, for all intents and purposes, this serves as a constructor.
        irModel = model;
        extractEventsFromModel();
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
        addressWritesMap.clear();
        addressReadsMap.clear();
        eventMap.clear();
        uninitRegReads.clear();
        initializedRegisters.clear();

        List<Thread> threadList = new ArrayList<>(getProgram().getThreads());
        List<Integer> threadEndIndexList = new ArrayList<>(threadList.size());
        Map<Thread, List<List<Integer>>> atomicBlockRangesMap = new HashMap<>();

        for (Thread thread : threadList) {
            List<List<Integer>> atomicBlockRanges = atomicBlockRangesMap.computeIfAbsent(thread, key -> new ArrayList<>());
            Event e = thread.getEntry();
            int atomicBegin = -1;
            int localId = 0;
            do {
                if (!irModel.isExecuted(e)) {
                    e = e.getSuccessor();
                    continue;
                }
                trackRegisterAccesses(e);
                if (e.hasTag(Tag.VISIBLE)) {
                    addEvent(e, id++, localId++);
                }

                // ===== Atomic blocks =====
                if (e instanceof BeginAtomic) {
                    atomicBegin = id;
                } else if (e instanceof EndAtomic) {
                    Preconditions.checkState(atomicBegin != -1, "EndAtomic without matching BeginAtomic in model");
                    atomicBlockRanges.add(ImmutableList.of(atomicBegin, id));
                    atomicBegin = -1;
                }
                // =========================

                if (e instanceof CondJump jump && irModel.jumpTaken(jump)) {
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

        if (data.isMemoryEvent()) {
            // ===== Memory Events =====
            Object address = checkNotNull(irModel.address((MemoryCoreEvent) e).value());
            data.setAccessedAddress(address);
            if (!addressReadsMap.containsKey(address)) {
                addressReadsMap.put(address, new HashSet<>());
                addressWritesMap.put(address, new HashSet<>());
            }

            if (data.isRead()) {
                addressReadsMap.get(address).add(data);
            } else if (data.isWrite()) {
                addressWritesMap.get(address).add(data);
            } else if (!(data.getEvent() instanceof Dealloc)) {
                //FIXME: Handle other kinds of memory events such as SRCU_SYNC.
                throw new UnsupportedOperationException("Unexpected memory event " + data.getEvent());
            }
        } else {
            //TODO: Maybe add some other events (e.g. assertions)
            // But for now all non-visible events are simply registered without
            // having any data extracted
        }
    }

    // =============== Register tracking ===============
    //NOTE: The following code is only used to check for reads from uninitialized registers
    public record UninitRegRead(Register register, Event at) {}

    private final List<UninitRegRead> uninitRegReads = new ArrayList<>();
    private final Set<Register> initializedRegisters = new HashSet<>();

    public List<UninitRegRead> getUninitRegReads() { return uninitRegReads; }

    //------------------------
    private void trackRegisterAccesses(Event e) {
        if (e instanceof RegReader regReader) {
            for (Register.Read regRead : regReader.getRegisterReads()) {
                final Register reg = regRead.register();
                if (!initializedRegisters.contains(reg)) {
                    uninitRegReads.add(new UninitRegRead(reg, e));
                }
            }
        }
        if (e instanceof RegWriter writer) {
            initializedRegisters.add(writer.getResultRegister());
        }
    }

}