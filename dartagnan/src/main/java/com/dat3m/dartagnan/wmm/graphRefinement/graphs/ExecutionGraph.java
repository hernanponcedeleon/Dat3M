package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.VerificationContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.AxiomData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom.AcyclicityAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom.EmptinessAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom.GraphAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.axiom.IrreflexivityAxiom;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.basic.CoherenceGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.binary.CompositionGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.binary.DifferenceGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.binary.IntersectionGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.binary.UnionGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.stat.*;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.unary.InverseGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.unary.RecursiveGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.unary.TransitiveGraph;
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
import com.dat3m.dartagnan.wmm.relation.unary.RelTrans;

import java.util.*;

public class ExecutionGraph {

    private final VerificationContext verificationContext;
    private final Map<RelationData, EventGraph> relationGraphMap;
    private final Map<AxiomData, GraphAxiom> axiomMap;
    private final GraphHierarchy graphHierarchy;

    private EventGraph poGraph;
    private EventGraph rfGraph;
    private EventGraph coGraph;
    private EventGraph locGraph;
    private EventGraph woGraph;

    public ExecutionGraph(VerificationContext verificationContext) {
        this.verificationContext = verificationContext;
        relationGraphMap = new HashMap<>();
        axiomMap = new HashMap<>();
        graphHierarchy = new GraphHierarchy();
        constructMappings();
    }

    private void constructMappings() {
        // We make sure to compute graphs along the dependency order
        for (RelationData rel : verificationContext.computeRelationDependencyGraph().getNodeContents()) {
            getGraphFromRelation(rel);
        }

        for (AxiomData axiom : verificationContext.getAxioms()) {
            getGraphAxiomFromAxiom(axiom);
        }
    }

    public EventGraph getPoGraph() { return poGraph; }
    public EventGraph getRfGraph() { return rfGraph; }
    public EventGraph getLocGraph() { return locGraph; }
    public EventGraph getCoGraph() { return coGraph; }
    public EventGraph getWoGraph() { return woGraph; }

    public EventGraph getEventGraph(RelationData rel) {
        return relationGraphMap.get(rel);
    }

    public Collection<EventGraph> getEventGraphs() {
        return relationGraphMap.values();
    }

    public GraphAxiom getGraphAxiom(AxiomData axiom) {
        return axiomMap.get(axiom);
    }

    public Collection<GraphAxiom> getGraphAxioms() {
        return axiomMap.values();
    }

    // For now we only allow refinement on co-edges.
    // We might want to add similar features for rf
    // We also assume, that the non-transitive write order is defined.
    public boolean addCoherenceEdge(Edge coEdge) {
        graphHierarchy.addEdgesToGraph(woGraph, Collections.singleton(coEdge));
        return true;
    }

    public void initializeFromModel(ModelContext modelContext) {
        graphHierarchy.initializeFromModel(modelContext);
        axiomMap.values().forEach(x -> x.initialize(modelContext));
    }

    public void backtrack() {
        graphHierarchy.backtrack();
    }


    //===================== Reading the WMM ========================

    private GraphAxiom getGraphAxiomFromAxiom(AxiomData axiom) {
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

    private EventGraph getGraphFromRelation(RelationData relData) {
        if (relationGraphMap.containsKey(relData))
            return relationGraphMap.get(relData);

        EventGraph graph = null;
        Class relClass = relData.getWrappedRelation().getClass();
        if (relClass == RelRf.class) {
            graph = rfGraph = new ReadFromGraph();
        } else if (relClass == RelLoc.class) {
            graph = locGraph = new LocationGraph();
        } else if (relClass == RelPo.class) {
            graph = poGraph = new ProgramOrderGraph();
        } else if (relClass == RelCo.class) {
            // A little ugly
            if (relData.getWrappedRelation().getName().equals("_co"))
                graph = woGraph = new CoherenceGraph();
            else {
                graph = coGraph = new TransitiveGraph(woGraph);
            }
        } else if (relData.isUnaryRelation()) {
            EventGraph inner = getGraphFromRelation(relData.getInner());
            // A safety check because recursion might compute this edge set
            if (relationGraphMap.containsKey(relData))
                return relationGraphMap.get(relData);

            if (relClass == RelInverse.class) {
                graph = new InverseGraph(inner);
            } else if (relClass == RelTrans.class) {
                graph = new TransitiveGraph(inner);
            } //TODO: RelTransRef.class is missing
        } else if (relData.isBinaryRelation()) {
            EventGraph first = getGraphFromRelation(relData.getFirst());
            EventGraph second = getGraphFromRelation(relData.getSecond());

            // Might be the case when recursion is in play
            if (relationGraphMap.containsKey(relData))
                return relationGraphMap.get(relData);

            if (relClass == RelUnion.class) {
                graph = new UnionGraph(first, second);
            } else if (relClass == RelIntersection.class) {
                graph = new IntersectionGraph(first, second);
            } else if (relClass == RelComposition.class) {
                graph = new CompositionGraph(first, second);
            } else if (relClass == RelMinus.class) {
                graph = new DifferenceGraph(first, second);
            }
        } else if (relData.isRecursiveRelation()) {
            RecursiveGraph recGraph = new RecursiveGraph();
            relationGraphMap.put(relData, recGraph);
            recGraph.setConcreteGraph(getGraphFromRelation(relData.getInner()));
            return recGraph;
        } else if (relData.isStaticRelation()) {
            if (relClass == RelCartesian.class) {
                graph = new CartesianGraph(relData);
            } else if (relClass == RelRMW.class) {
                graph = new RMWGraph();
            } else if (relClass == RelExt.class) {
                graph = new ExternalGraph();
            } else if (relClass == RelFencerel.class) {
                graph = new FenceGraph((RelFencerel) relData.getWrappedRelation());
            } else {
                //TODO: Add all predefined static graphs (CartesianGraph, ExtGraph, ... etc.)
                graph = new StaticDefaultEventGraph(relData);
            }
        } else {
            throw new RuntimeException(new ClassNotFoundException(relClass.toString() + " is no supported relation class"));
        }

        graphHierarchy.addEventGraph(graph);
        relationGraphMap.put(relData, graph);
        return graph;
    }


}
