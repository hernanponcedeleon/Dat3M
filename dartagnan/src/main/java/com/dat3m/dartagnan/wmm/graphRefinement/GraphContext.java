package com.dat3m.dartagnan.wmm.graphRefinement;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclic;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Irreflexive;
import com.dat3m.dartagnan.wmm.graphRefinement.analysis.BranchEquivalence;
import com.dat3m.dartagnan.wmm.graphRefinement.analysis.DependencyAnalysis;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.EventLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.Literals;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventMap;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.*;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;

import java.util.*;

// This class is the binding element of all the components needed to perform
// graph refinement
public class GraphContext {

    // General
    private Wmm memoryModel;
    private RelationMap relationMap;
    private List<RelationData> relationDataList; // A topologically sorted list

    private Program program;
    private BranchEquivalence branchEq;
    private EventMap eventMap;

    // ============= Refinement specific  =============
    private Model model;
    private Context context;
    private Literals literals; // Not used right now
    private ReasonGraph reasonGraph;

    // The event list is sorted lexicographically by (threadID, cID)
    private ArrayList<EventData> eventList;
    private Map<Thread, List<EventData>> threadEventsMap;
    private Map<EventData, EventData> readWriteMap;
    private Map<EventData, Set<EventData>> writeReadsMap;
    private Map<String, Set<EventData>> fenceMap;
    private Map<Integer, Set<EventData>> addressReadsMap;
    private Map<Integer, Set<EventData>> addressWritesMap; // This ALSO contains the init writes
    private Map<Integer, EventData> addressInitMap;
    //TODO: Note, we could merge the
    // three above maps into a single one that holds writes, reads and init writes.

    // Read-only views of collections
    private List<RelationData> relationDataListView;

    private List<EventData> eventListView;
    private Map<Thread, List<EventData>> threadEventsMapView;
    private Map<EventData, EventData> readWriteMapView;
    private Map<EventData, Set<EventData>> writeReadsMapView;
    private Map<String, Set<EventData>> fenceMapView;
    private Map<Integer, Set<EventData>> addressReadsMapView;
    private Map<Integer, Set<EventData>> addressWritesMapView;
    private Map<Integer, EventData> addressInitMapView;


    public GraphContext(Program program, Wmm memoryModel) {
        this.program = program;
        this.memoryModel = memoryModel;
        literals = new Literals(this);

        eventList = new ArrayList<>(100);
        threadEventsMap = new HashMap<>(program.getThreads().size());
        readWriteMap = new HashMap<>();
        writeReadsMap = new HashMap<>();
        fenceMap = new HashMap<>();
        addressReadsMap = new HashMap<>();
        addressWritesMap = new HashMap<>();
        addressInitMap = new HashMap<>();

        // Compute branch equivalence
        branchEq = new BranchEquivalence(program);

        // Compute/create all necessary relations and then perform dependency analysis
        computeRelations();
        performDependencyAnalysis();

        createViews();
    }


    private void createViews() {
        relationDataListView = Collections.unmodifiableList(relationDataList);

        eventListView = Collections.unmodifiableList(eventList);
        threadEventsMapView = Collections.unmodifiableMap(threadEventsMap);
        readWriteMapView = Collections.unmodifiableMap(readWriteMap);
        writeReadsMapView = Collections.unmodifiableMap(writeReadsMap);
        fenceMapView = Collections.unmodifiableMap(fenceMap);
        addressReadsMapView = Collections.unmodifiableMap(addressReadsMap);
        addressWritesMapView = Collections.unmodifiableMap(addressWritesMap);
        addressInitMapView = Collections.unmodifiableMap(addressInitMap);
    }

    public Wmm getMemoryModel() {
        return memoryModel;
    }

    public Program getProgram() {
        return program;
    }

    public BranchEquivalence getBranchEquivalence() {
        return branchEq;
    }

    public Model getZ3Model() {
        return model;
    }

    public Context getZ3Context() {
        return context;
    }

    public Literals getLiterals() {
        return literals;
    }

    public ReasonGraph getReasonGraph() {
        return reasonGraph;
    }

    public List<EventData> getEventList() {
        return eventListView;
    }

    public Map<Thread, List<EventData>> getThreadEventsMap() { return threadEventsMapView; }

    public Map<EventData, EventData> getReadWriteMap() {
        return readWriteMapView;
    }

    public Map<EventData, Set<EventData>> getWriteReadsMap() { return writeReadsMapView; }

    public Map<String, Set<EventData>> getFenceMap() {
        return fenceMapView;
    }

    public Map<Integer, Set<EventData>> getAddressReadsMap() {
        return addressReadsMapView;
    }

    public Map<Integer, Set<EventData>> getAddressWritesMap() {
        return addressWritesMapView;
    }

    public Map<Integer, EventData> getAddressInitMap() {
        return addressInitMapView;
    }

    public List<RelationData> getRelationDataList() {
        return relationDataListView;
    }

    public boolean eventExists(EventData e) {
        return Collections.binarySearch(eventList, e) >= 0;
    }

    public CoreLiteral getEventLiteral(Event e) {
        return new EventLiteral(getData(branchEq.getRepresentative(e)));
    }

    public RelationData getData(Relation rel) {
        return relationMap.get(rel);
    }

    public RelationData getData(Axiom axiom) {
        return relationMap.get(axiom);
    }

    public EventData getData(Event e) {
        return eventMap.get(e);
    }

    public Edge getEdge(Tuple tuple) {
        return new Edge(getData(tuple.getFirst()), getData(tuple.getSecond()));
    }


    public void init(Model model, Context ctx) {
        this.model = model;
        this.context = ctx;
        reasonGraph = new ReasonGraph();
        extractEventsFromModel();
        extractReadsFrom();
        initLiterals();
    }

    public void initLiterals() {
        literals.init();
    }

    private void extractEventsFromModel() {
        //TODO: We might be able to look at each branch from the last computation
        // and check if they are part of the current model
        // If so, we might be able to skip some recomputations and only update
        // the reads and writes (i.e. their value/address and rf-connections)
        // We could even skip updating constant writes (i.e. init writes)
        int id = 0;
        int threadStart = 0;
        eventList.clear();
        threadEventsMap.clear();
        addressInitMap.clear(); // This one can probably be constant and need not be rebuilt!
        addressWritesMap.clear();
        addressReadsMap.clear();
        fenceMap.clear();
        eventMap = new EventMap();

        for (Thread thread : program.getThreads()) {
            Event e = thread.getEntry();
            int localId = 0;
            do {
                EventData data = eventMap.get(e);
                data.setId(id++);
                if (data.isMemoryEvent()) {
                    eventList.add(data);
                    data.setLocalId(localId++);

                    data.setWasExecuted(e.wasExecuted(model));
                    // A memory event in the control flow need NOT be executed (e.g. AARCH's StoreExclusive)
                    if (data.wasExecuted()) {
                        Integer address = ((MemEvent) e).getAddress().getIntValue(e, model, context);
                        data.setAccessedAddress(address);
                        if (!addressReadsMap.containsKey(address)) {
                            addressReadsMap.put(address, new HashSet<>());
                            addressWritesMap.put(address, new HashSet<>());
                        }

                        if (data.isRead()) {
                            addressReadsMap.get(address).add(data);
                        } else if (data.isWrite()) {
                            addressWritesMap.get(address).add(data);
                            writeReadsMap.put(data, new HashSet<>());
                            if (data.isInit())
                                addressInitMap.put(address, data);
                        } else {
                            throw new RuntimeException("Unexpected memory event");
                        }
                    }
                }  else if (data.isFence()) {
                    eventList.add(data);
                    data.setLocalId(localId++);

                    String name = data.toString();
                    if (!fenceMap.containsKey(name))
                        fenceMap.put(name, new HashSet<>());
                    fenceMap.get(name).add(data);
                } else if (data.isJump()) {
                    CondJump jump = (CondJump)e;
                    if (jump.didJump(model, context))
                        e = jump.getLabel(); // A jump target is always a label, so we can safely take the successor of it
                }//TODO: If's and maybe other events?
                e = e.getSuccessor();
            } while (e != null);


            // Update thread view
            threadEventsMap.put(thread, Collections.unmodifiableList(eventList.subList(threadStart, eventList.size())));
            threadStart = eventList.size();
        }
    }

    private void extractReadsFrom() {
        readWriteMap.clear();

        for (Map.Entry<Integer, Set<EventData>> addressedReads : addressReadsMap.entrySet()) {
            Integer address = addressedReads.getKey();
            for (EventData read : addressedReads.getValue()) {
                for (EventData write : addressWritesMap.get(address)) {
                    BoolExpr rf = Utils.edge("rf", write.getEvent(), read.getEvent(), context);
                    if (model.getConstInterp(rf).isTrue()) {
                        readWriteMap.put(read, write);
                        read.setReadFrom(write);
                        writeReadsMap.get(write).add(read);
                        continue;
                    }
                }
            }
        }
    }

    private void computeRelations() {
        this.relationMap = RelationMap.fromMemoryModel(memoryModel);

        // Add new non-transitive coherence relation "_co"
        RelationData writeOrder = relationMap.get(new RelCo(false));
        relationMap.get(memoryModel.getRelationRepository().getRelation("co")).addDependency(writeOrder);

        // Replace acyclicity axioms by irreflexivity axioms
        RelationData[] axioms = relationMap.getAxiomValues().toArray(new RelationData[0]);
        for (RelationData axiom : axioms) {
            if (axiom.getAxiom() instanceof Acyclic) {
                relationMap.remove(axiom.getAxiom());
                axiom.removeDependency(axiom.getInner());

                RelationData transClosure =  relationMap.get(new RelTrans(axiom.getRelation()));
                transClosure.addDependency(transClosure.getInner());

                RelationData irrAxiom = relationMap.get(new Irreflexive(transClosure.getRelation()));
                irrAxiom.addDependency(irrAxiom.getInner());
            }
        }
    }

    private void performDependencyAnalysis() {
        relationDataList = new DependencyAnalysis(relationMap).getRelationDataList();
    }


}
