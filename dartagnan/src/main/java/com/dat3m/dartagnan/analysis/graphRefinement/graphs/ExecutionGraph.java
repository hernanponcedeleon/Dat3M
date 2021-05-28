package com.dat3m.dartagnan.analysis.graphRefinement.graphs;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat.*;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary.*;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.DifferenceGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.AcyclicityAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.EmptinessAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.GraphAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.IrreflexivityAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.basic.CoherenceGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.CompositionGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.IntersectionGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary.UnionGraph;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.RelRMW;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelCo;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelLoc;
import com.dat3m.dartagnan.wmm.relation.base.memory.RelRf;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelExt;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelPo;
import com.dat3m.dartagnan.wmm.relation.binary.RelComposition;
import com.dat3m.dartagnan.wmm.relation.binary.RelIntersection;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.relation.binary.RelUnion;
import com.dat3m.dartagnan.wmm.relation.unary.RelInverse;
import com.dat3m.dartagnan.wmm.relation.unary.RelRangeIdentity;
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;
import com.dat3m.dartagnan.wmm.relation.unary.RelTransRef;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;

import java.util.*;

public class ExecutionGraph {

    private static final Set<String> EXCLUDED_RELS = ImmutableSet.of("idd", "idd^+", "ctrlDirect", "addrDirect");
    private static final Set<String> SPECIAL_RELS = ImmutableSet.of("addr", "data", "ctrl");


    private final VerificationTask verificationTask;
    private final Map<Relation, EventGraph> relationGraphMap;
    private final Map<Axiom, GraphAxiom> axiomMap;
    private final GraphHierarchy graphHierarchy;

    private EventGraph poGraph;
    private EventGraph rfGraph;
    private EventGraph coGraph;
    private EventGraph locGraph;
    private EventGraph woGraph;

    public ExecutionGraph(VerificationTask verificationTask) {
        this.verificationTask = verificationTask;
        relationGraphMap = new HashMap<>();
        axiomMap = new HashMap<>();
        graphHierarchy = new GraphHierarchy();
        constructMappings();
    }

    private void constructMappings() {
        // We make sure to compute graphs along the dependency order
        for (Relation rel : verificationTask.getRelationDependencyGraph().getNodeContents()) {
            if (!EXCLUDED_RELS.contains(rel.getName())) {
                getGraphFromRelation(rel);
            }
        }

        for (Axiom axiom : verificationTask.getAxioms()) {
            getGraphAxiomFromAxiom(axiom);
        }
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

    // For now we only allow refinement on co-edges.
    // We might want to add similar features for rf
    // We also assume, that the non-transitive write order is defined.
    public boolean addCoherenceEdge(Edge coEdge) {
        graphHierarchy.addEdgesToGraph(woGraph, ImmutableList.of(coEdge));
        return true;
    }

    public void initializeFromModel(ExecutionModel executionModel) {
        graphHierarchy.constructFromModel(executionModel);
        axiomMap.values().forEach(x -> x.initialize(executionModel));
    }

    public void backtrack() {
        graphHierarchy.backtrack();
    }


    //===================== Reading the WMM ========================

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
        graphHierarchy.addGraphListener(innerGraph, graphAxiom);
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
            }
        } else if (relClass == RelRf.class) {
            graph = rfGraph = new ReadFromGraph();
        } else if (relClass == RelLoc.class) {
            graph = locGraph = new LocationGraph();
        } else if (relClass == RelPo.class) {
            graph = poGraph = new ProgramOrderGraph();
        } else if (relClass == RelCo.class) {
            graphHierarchy.addEventGraph(woGraph = new CoherenceGraph());
            graph = coGraph = new TransitiveGraph(woGraph);
        } else if (rel.isUnaryRelation() || rel.isRecursiveRelation()) {
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
                EventGraph transGraph = getGraphFromRelation(new RelTrans(rel.getInner()));
                graph = new ReflexiveClosureGraph(transGraph);
            }
        } else if (rel.isBinaryRelation()) {
            EventGraph first = getGraphFromRelation(rel.getFirst());
            EventGraph second = getGraphFromRelation(rel.getSecond());

            // Might be the case when recursion is in play
            if (relationGraphMap.containsKey(rel))
                return relationGraphMap.get(rel);

            if (relClass == RelUnion.class) {
                graph = new UnionGraph(first, second);
            } else if (relClass == RelIntersection.class) {
                graph = new IntersectionGraph(first, second);
            } else if (relClass == RelComposition.class) {
                graph = new CompositionGraph(first, second);
            } else if (relClass == RelMinus.class) {
                graph = new DifferenceGraph(first, second);
            }
        } else if (rel.isRecursiveRelation()) {
            RecursiveGraph recGraph = new RecursiveGraph();
            relationGraphMap.put(rel, recGraph);
            recGraph.setConcreteGraph(getGraphFromRelation(rel.getInner()));
            return recGraph;
        } else if (rel.isStaticRelation()) {
            if (relClass == RelCartesian.class) {
                graph = new CartesianGraph((RelCartesian) rel);
            } else if (relClass == RelRMW.class) {
                graph = new RMWGraph();
            } else if (relClass == RelExt.class) {
                graph = new ExternalGraph();
            } else if (relClass == RelFencerel.class) {
                graph = new FenceGraph((RelFencerel) rel);
            } else {
                //TODO: Add all predefined static graphs (CartesianGraph, ExtGraph, ... etc.)
                graph = new StaticDefaultEventGraph(rel);
            }
        } else {
            throw new RuntimeException(new ClassNotFoundException(relClass.toString() + " is no supported relation class"));
        }

        graphHierarchy.addEventGraph(graph);
        relationGraphMap.put(rel, graph);
        return graph;
    }


}
