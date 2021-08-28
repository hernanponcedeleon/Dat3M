package com.dat3m.dartagnan.analysis.graphRefinement.graphs;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.AcyclicityAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.EmptinessAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.GraphAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.IrreflexivityAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.basic.CoherenceGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.CompositionGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.DifferenceGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.MatIntersectionGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.MatUnionGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat.*;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary.*;
import com.dat3m.dartagnan.analysis.graphRefinement.util.ShortestDerivationComplexity;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.RelRMW;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelLoc;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.relation.base.stat.*;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelRangeIdentity;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.relation.unary.RelTransRef;
import com.google.common.collect.*;

import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class ExecutionGraph {

    // These graphs are only relevant for data, ctrl and addr, all of which have a special event graph (see below)
    private static final Set<String> EXCLUDED_RELS = ImmutableSet.of(
            "idd", "idd^+", "ctrlDirect", "addrDirect", "(idd^+;addrDirect)", "(addrDirect+(idd^+;addrDirect))",
            "(idd^+;ctrlDirect)"
    );

    // These relations have special event graphs associated with them
    private static final Set<String> SPECIAL_RELS = ImmutableSet.of("addr", "data", "ctrl", "crit");


    // ================== Fields =====================

    // All following variables can be considered "final".
    // Some are not declared final for purely technical reasons but all of them get
    // assigned during construction.

    private final VerificationTask verificationTask;
    private final BiMap<Relation, EventGraph> relationGraphMap;
    private final BiMap<Axiom, GraphAxiom> axiomMap;
    private GraphHierarchy graphHierarchy;
    private Map<EventGraph, Integer> derivationComplexityMap;

    private EventGraph poGraph;
    private EventGraph rfGraph;
    private EventGraph coGraph;
    private EventGraph locGraph;
    private EventGraph woGraph;

    // =================================================

    // ============= Construction & Init ===============

    public ExecutionGraph(VerificationTask verificationTask) {
        this.verificationTask = verificationTask;
        relationGraphMap = HashBiMap.create();
        axiomMap = HashBiMap.create();
        constructMappings();
    }

    public void initializeFromModel(ExecutionModel executionModel) {
        graphHierarchy.constructFromModel(executionModel);
        axiomMap.values().forEach(x -> x.initialize(executionModel));
    }

    // --------------------------------------------------

    private void constructMappings() {
        // We make sure to compute graphs along the dependency order
        // TODO: Is the order really important?
        Set<EventGraph> graphs = new HashSet<>();
        for (Relation rel : verificationTask.getRelationDependencyGraph().getNodeContents()) {
            if (!EXCLUDED_RELS.contains(rel.getName())) {
                EventGraph graph = getGraphFromRelation(rel);
                graphs.add(graph);
            }
        }
        graphHierarchy = new GraphHierarchy(graphs);
        derivationComplexityMap = ImmutableMap.copyOf(new ShortestDerivationComplexity(graphHierarchy).getComplexityMap());

        for (Axiom axiom : verificationTask.getAxioms()) {
            GraphAxiom ax = getGraphAxiomFromAxiom(axiom);
            EventGraph graph = getGraphFromRelation(axiom.getRelation());
            graphHierarchy.addGraphListener(graph, ax);
        }
    }

    // =================================================

    // ================ Accessors =======================

    public VerificationTask getVerificationTask() { return verificationTask; }

    public BiMap<Relation, EventGraph> getRelationGraphMap() {
        return Maps.unmodifiableBiMap(relationGraphMap);
    }

    public BiMap<Axiom, GraphAxiom> getAxiomMap() {
        return Maps.unmodifiableBiMap(axiomMap);
    }

    public EventGraph getPoGraph() { return poGraph; }
    public EventGraph getRfGraph() { return rfGraph; }
    public EventGraph getLocGraph() { return locGraph; }
    public EventGraph getCoGraph() { return coGraph; }
    public EventGraph getWoGraph() { return woGraph; }

    public EventGraph getEventGraph(Relation rel) {
        return relationGraphMap.get(rel);
    }

    public Collection<EventGraph> getEventGraphs() {
        return graphHierarchy.getGraphList();
    }

    public GraphAxiom getGraphAxiom(Axiom axiom) {
        return axiomMap.get(axiom);
    }

    public Collection<GraphAxiom> getGraphAxioms() {
        return axiomMap.values();
    }

    // The length of a shortest path from <graph> to some base graph
    // along the dependency graph
    // TODO: This is not really used anymore. We can probably remove it
    public int getShortestDerivationComplexity(EventGraph graph) {
        return derivationComplexityMap.getOrDefault(graph, -1);
    }

    // ====================================================

    // ==================== Mutation ======================

    // For now we only allow refinement on co-edges.
    // We might want to add similar features for other linear orders (i.e. user defined orders)
    // We also assume, that the non-transitive write order is defined.
    public boolean addCoherenceEdges(Edge coEdge) {
        return addCoherenceEdges(ImmutableList.of(coEdge));
    }

    public boolean addCoherenceEdges(Collection<Edge> coEdges) {
        if ( woGraph == null) {
            return false;
        }
        graphHierarchy.addEdgesAndPropagate(woGraph, coEdges);
        return true;
    }

    public void backtrack() {
        graphHierarchy.backtrack();
    }

    // =======================================================


    //=================== Reading the WMM ====================

    private GraphAxiom getGraphAxiomFromAxiom(Axiom axiom) {
        if (axiomMap.containsKey(axiom))
            return axiomMap.get(axiom);

        GraphAxiom graphAxiom = null;
        EventGraph innerGraph = getGraphFromRelation(axiom.getRelation());
        if (axiom.isAcyclicity()) {
            graphAxiom = new AcyclicityAxiom(innerGraph);
        } else if (axiom.isEmptiness()) {
            graphAxiom = new EmptinessAxiom(innerGraph);
        } else if (axiom.isIrreflexivity()) {
            graphAxiom = new IrreflexivityAxiom(innerGraph);
        }

        axiomMap.put(axiom, graphAxiom);
        return graphAxiom;
    }

    private EventGraph getGraphFromRelation(Relation rel) {
        if (relationGraphMap.containsKey(rel))
            return relationGraphMap.get(rel);

        EventGraph graph = null;
        Class<?> relClass = rel.getClass();

        // ===== Filter special relations ======
        if (SPECIAL_RELS.contains(rel.getName())) {
            switch (rel.getName()) {
                case "ctrl":
                    graph = new CtrlDepGraph();
                    break;
                case "data":
                    graph = new DataDepGraph();
                    break;
                case "addr":
                    graph = new AddrDepGraph();
                    break;
                case "crit":
                    graph = new RcuGraph();
                    break;
            }
        } else if (relClass == RelRf.class) {
            graph = rfGraph = new ReadFromGraph();
        } else if (relClass == RelLoc.class) {
            graph = locGraph = new LocationGraph();
        } else if (relClass == RelPo.class) {
            graph = poGraph = new ProgramOrderGraph();
        } else if (relClass == RelCo.class) {
            graph = coGraph = new TransitiveGraph(woGraph = new CoherenceGraph());
            woGraph.setName("_wo");
        } else if (rel.isRecursiveRelation()) {
            RecursiveGraph recGraph = new RecursiveGraph();
            recGraph.setName(rel.getName() + "_rec");
            relationGraphMap.put(rel, recGraph);
            recGraph.setConcreteGraph(getGraphFromRelation(rel.getInner()));
            return recGraph;
        } else if (rel.isUnaryRelation()) {
            EventGraph inner = getGraphFromRelation(rel.getInner());
            // A safety check because recursion might compute this edge set
            if (relationGraphMap.containsKey(rel))
                return relationGraphMap.get(rel);

            if (relClass == RelInverse.class) {
                graph = new InverseGraph(inner);
            } else if (relClass == RelTrans.class) {
                graph = new TransitiveGraph(inner);
            } else if (relClass == RelRangeIdentity.class) {
                graph = new RangeIdentityGraph(inner);
            } else if (relClass == RelTransRef.class) {
                RelTrans relTrans = new RelTrans(rel.getInner());
                relTrans.initialise(verificationTask, null); // A little sketchy
                EventGraph transGraph = getGraphFromRelation(relTrans);
                graph = new ReflexiveClosureGraph(transGraph);
            }
        } else if (rel.isBinaryRelation()) {
            EventGraph first = getGraphFromRelation(rel.getFirst());
            EventGraph second = getGraphFromRelation(rel.getSecond());

            // Might be the case when recursion is in play
            if (relationGraphMap.containsKey(rel))
                return relationGraphMap.get(rel);

            if (relClass == RelUnion.class) {
                //graph = new UnionGraph(first, second);
                graph = new MatUnionGraph(first, second);
            } else if (relClass == RelIntersection.class) {
                //graph = new IntersectionGraph(first, second);
                graph = new MatIntersectionGraph(first, second);
            } else if (relClass == RelComposition.class) {
                graph = new CompositionGraph(first, second);
            } else if (relClass == RelMinus.class) {
                graph = new DifferenceGraph(first, second);
            }
        } else if (rel.isStaticRelation()) {
            if (relClass == RelCartesian.class) {
                graph = new CartesianGraph((RelCartesian) rel);
            } else if (relClass == RelRMW.class) {
                graph = new RMWGraph();
            } else if (relClass == RelExt.class) {
                graph = new ExternalGraph();
            } else if (relClass == RelInt.class) {
                graph = new InternalGraph();
            } else if (relClass == RelFencerel.class) {
                graph = new FenceGraph((RelFencerel) rel);
            } else if (relClass == RelSetIdentity.class) {
                RelSetIdentity relSet = (RelSetIdentity) rel;
                graph = new SetIdentityGraph(relSet.getFilter());
            } else if (relClass == RelId.class) {
                graph = new IdentityGraph();
            } else if (relClass == RelEmpty.class) {
                graph = new EmptyGraph();
            } else {
                // This is a fallback for all unimplemented static graphs
                graph = new StaticDefaultEventGraph(rel);
            }
        } else {
            throw new RuntimeException(new ClassNotFoundException(relClass.toString() + " is no supported relation class"));
        }

        graph.setName(rel.getName());
        relationGraphMap.put(rel, graph);
        return graph;
    }

    // =======================================================


}
