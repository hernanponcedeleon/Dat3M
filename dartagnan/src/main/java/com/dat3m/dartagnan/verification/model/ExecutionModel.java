package com.dat3m.dartagnan.verification.model;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import java.math.BigInteger;
import java.util.*;

/*
The ExecutionModel wraps a Z3Model and extracts data from it in a more workable manner.
 */

public class ExecutionModel {

    private final VerificationTask verificationTask;

    // ============= Refinement specific  =============
    private Model model;
    private Context context;
    private FilterAbstract eventFilter;
    private boolean extractCoherences;

    private final EventMap eventMap;
    // The event list is sorted lexicographically by (threadID, cID)
    private final ArrayList<EventData> eventList;
    private final ArrayList<Thread> threadList;
    private final Map<Thread, List<EventData>> threadEventsMap;
    private final Map<EventData, EventData> readWriteMap;
    private final Map<EventData, Set<EventData>> coherenceMap;
    private final Map<EventData, Set<EventData>> writeReadsMap;
    private final Map<String, Set<EventData>> fenceMap;
    private final Map<BigInteger, Set<EventData>> addressReadsMap;
    private final Map<BigInteger, Set<EventData>> addressWritesMap; // This ALSO contains the init writes
    private final Map<BigInteger, EventData> addressInitMap;
    //TODO: Note, we could merge the
    // three above maps into a single one that holds writes, reads and init writes.

    // The following are a read-only views which get passed to the outside
    private List<EventData> eventListView;
    private List<Thread> threadListView;
    private Map<Thread, List<EventData>> threadEventsMapView;
    private Map<EventData, EventData> readWriteMapView;
    private Map<EventData, Set<EventData>> coherenceMapView;
    private Map<EventData, Set<EventData>> writeReadsMapView;
    private Map<String, Set<EventData>> fenceMapView;
    private Map<BigInteger, Set<EventData>> addressReadsMapView;
    private Map<BigInteger, Set<EventData>> addressWritesMapView;
    private Map<BigInteger, EventData> addressInitMapView;

    //========================== Construction =========================

    public ExecutionModel(VerificationTask verificationTask) {
        this.verificationTask = verificationTask;
        eventList = new ArrayList<>(100);
        threadList = new ArrayList<>(getProgram().getThreads().size());
        threadEventsMap = new HashMap<>(getProgram().getThreads().size());
        readWriteMap = new HashMap<>();
        coherenceMap = new HashMap<>();
        writeReadsMap = new HashMap<>();
        fenceMap = new HashMap<>();
        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
        addressInitMap = new HashMap<>();
        eventMap = new EventMap();
        createViews();
    }

    private void createViews() {
        eventListView = Collections.unmodifiableList(eventList);
        threadListView = Collections.unmodifiableList(threadList);
        threadEventsMapView = Collections.unmodifiableMap(threadEventsMap);
        readWriteMapView = Collections.unmodifiableMap(readWriteMap);
        coherenceMapView = Collections.unmodifiableMap(coherenceMap);
        writeReadsMapView = Collections.unmodifiableMap(writeReadsMap);
        fenceMapView = Collections.unmodifiableMap(fenceMap);
        addressReadsMapView = Collections.unmodifiableMap(addressReadsMap);
        addressWritesMapView = Collections.unmodifiableMap(addressWritesMap);
        addressInitMapView = Collections.unmodifiableMap(addressInitMap);
    }

    //========================== Public data =========================

    // General data
    public VerificationTask getVerificationTask() {
    	return verificationTask;
    }
    
    public Wmm getMemoryModel() {
        return verificationTask.getMemoryModel();
    }

    public Program getProgram() {
        return verificationTask.getProgram();
    }

    // Model specific data
    public Model getZ3Model() {
        return model;
    }
    public Context getZ3Context() {
        return context;
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

    public Map<EventData, EventData> getReadWriteMap() {
        return readWriteMapView;
    }
    
    public Map<EventData, Set<EventData>> getCoherenceMap() {
    	return coherenceMapView;
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

    public boolean eventExists(Event e) {
        return eventMap.contains(e);
    }

    public EventData getData(Event e) {
        return eventExists(e) ? eventMap.get(e) : null;
    }

    public Edge getEdge(Tuple tuple) {
        return (eventExists(tuple.getFirst()) && eventExists(tuple.getSecond())) ?
                new Edge(getData(tuple.getFirst()), getData(tuple.getSecond())) : null;
    }

    //========================== Initialization =========================


    public void initialize(Model model, Context ctx) {
        initialize(model, ctx, true);
    }

    public void initialize(Model model, Context ctx, boolean extractCoherences) {
        initialize(model, ctx, FilterBasic.get(EType.VISIBLE), extractCoherences);
    }

    public void initialize(Model model, Context ctx, FilterAbstract eventFilter, boolean extractCoherences) {
        // We populate here, instead of on construction,
        // to reuse allocated data structures (since these data structures already adapted
        // their capacity in previous iterations and thus we should have less overhead in future populations)
        // However, for all intents and purposes, this serves as a constructor.
        this.model = model;
        this.context = ctx;
        this.eventFilter = eventFilter;
        this.extractCoherences = extractCoherences;
        extractEventsFromModel();
        extractReadsFrom();
        extractCoherences();
    }

    //========================== Internal methods  =========================

    private void extractEventsFromModel() {
        //TODO(TH): We might also want to extract events such as inline assertions
        // and whether they were violated or not.
        int id = 0;
        eventList.clear();
        threadList.clear();
        threadEventsMap.clear();
        addressInitMap.clear(); // This one can probably be constant and need not be rebuilt!
        addressWritesMap.clear();
        addressReadsMap.clear();
        fenceMap.clear();
        eventMap.clear();

        List<Thread> threadList = new ArrayList<>(getProgram().getThreads());
        List<Integer> threadEndIndexList = new ArrayList<>(threadList.size());

        for (Thread thread : threadList) {
            Event e = thread.getEntry();
            int localId = 0;
            do {
                if (e.wasExecuted(model) && eventFilter.filter(e)) {
                    addEvent(e, id++, localId++);
                }
                //TODO: Add support for ifs
                if (e instanceof CondJump) {
                    CondJump jump = (CondJump) e;
                    if (jump.didJump(model, context)) {
                        e = jump.getLabel();
                        continue;
                    }
                }
                e = e.getSuccessor();

            } while (e != null);
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
            }
            start = end;
        }
    }

    private void addEvent(Event e, int globalId, int localId) {
        EventData data = eventMap.get(e);
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
                data.setValue(new BigInteger(model.getConstInterp(((RegWriter)e).getResultRegisterExpr()).toString()));
                addressReadsMap.get(address).add(data);
            } else if (data.isWrite()) {
                data.setValue(((MemEvent)e).getMemValue().getIntValue(e, model, context));
                addressWritesMap.get(address).add(data);
                writeReadsMap.put(data, new HashSet<>());
                if (data.isInit())
                    addressInitMap.put(address, data);
            } else {
                throw new RuntimeException("Unexpected memory event");
            }

        } else if (data.isFence()) {
            // ===== Fences =====
            String name = data.getEvent().toString();
            if (!fenceMap.containsKey(name))
                fenceMap.put(name, new HashSet<>());
            fenceMap.get(name).add(data);
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

    private Relation rf;
    private void extractReadsFrom() {
        readWriteMap.clear();

        if (rf == null) {
            rf = getMemoryModel().getRelationRepository().getRelation("rf");
        }

        for (Map.Entry<BigInteger, Set<EventData>> addressedReads : addressReadsMap.entrySet()) {
        	BigInteger address = addressedReads.getKey();
            for (EventData read : addressedReads.getValue()) {
                for (EventData write : addressWritesMap.get(address)) {
                    BoolExpr rfExpr = rf.getSMTVar(write.getEvent(), read.getEvent(), context);
                    Expr rfInterp = model.getConstInterp(rfExpr);
                    // The null check is important: Currently there are cases where no rf-edge between
                    // init writes and loads get encoded (in case of arrays/structs). This is usually no problem,
                    // since in a well-initialized program, the init write should not be readable anyway.
                    if (rfInterp != null && rfInterp.isTrue()) {
                        readWriteMap.put(read, write);
                        read.setReadFrom(write);
                        writeReadsMap.get(write).add(read);
                        write.setImportance(write.getImportance() + 1);
                        break;
                    }
                }
            }
        }
    }

    private Relation co;
    private void extractCoherences() {
        coherenceMap.clear();
        if (!extractCoherences)
            return;

        if (co == null) {
            co = getMemoryModel().getRelationRepository().getRelation("co");
        }

        for (Map.Entry<BigInteger, Set<EventData>> addressedWrites : addressWritesMap.entrySet()) {
        	BigInteger address = addressedWrites.getKey();
            for (EventData w1 : addressedWrites.getValue()) {
                coherenceMap.put(w1, new HashSet<>());
                for (EventData w2 : addressWritesMap.get(address)) {
                    BoolExpr coExpr = co.getSMTVar(w1.getEvent(), w2.getEvent(), context);
                    Expr coInterp = model.getConstInterp(coExpr);
                    if (coInterp != null && coInterp.isTrue()) {
                        coherenceMap.get(w1).add(w2);
                        break;
                    }
                }
            }
        }
    }
}