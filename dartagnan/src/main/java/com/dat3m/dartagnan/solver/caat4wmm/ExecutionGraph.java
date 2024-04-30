package com.dat3m.dartagnan.solver.caat4wmm;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.solver.caat.CAATModel;
import com.dat3m.dartagnan.solver.caat.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.Constraint;
import com.dat3m.dartagnan.solver.caat.constraints.EmptinessConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.IrreflexivityConstraint;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.EmptyGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.*;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.base.Preconditions;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.Maps;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class ExecutionGraph {

    // ================== Fields =====================

    // All following variables can be considered "final".
    // Some are not declared final for purely technical reasons but all of them get
    // assigned during construction.

    private final RefinementModel refinementModel;
    private final RelationAnalysis ra;
    private final BiMap<Relation, RelationGraph> relationGraphMap;
    private final BiMap<Filter, SetPredicate> filterSetMap;
    private final BiMap<Axiom, Constraint> constraintMap;
    private final Set<Relation> cutRelations;

    private CAATModel caatModel;
    private EventDomain domain;

    // =================================================

    // ============= Construction & Init ===============

    public ExecutionGraph(RefinementModel refinementModel, RelationAnalysis ra) {
        this.refinementModel = refinementModel;
        this.ra = ra;
        relationGraphMap = HashBiMap.create();
        filterSetMap = HashBiMap.create();
        constraintMap = HashBiMap.create();
        cutRelations = refinementModel.computeBoundaryRelations().stream()
                .filter(r -> r.getName().map(n -> !Wmm.ANARCHIC_CORE_RELATIONS.contains(n)).orElse(true))
                .map(refinementModel::translateToOriginal)
                .collect(Collectors.toSet());

        checkNoUnsupportedRelations(refinementModel);
        constructMappings();
    }

    public void initializeFromModel(ExecutionModel executionModel) {
        domain = new EventDomain(executionModel);
        caatModel.initializeToDomain(domain);
    }

    // --------------------------------------------------

    private void constructMappings() {
        final Wmm memoryModel = refinementModel.getOriginalModel();

        Set<RelationGraph> graphs = new HashSet<>();
        Set<Constraint> constraints = new HashSet<>();
        DependencyGraph<Relation> dependencyGraph = DependencyGraph.from(memoryModel.getRelations());
        Set<Relation> upperRelations = refinementModel.getUpperRelations();

        // Special treatment for recursive relations.
        for (Set<DependencyGraph<Relation>.Node> component : dependencyGraph.getSCCs()) {
            if (!upperRelations.contains(component.stream().findAny().get().getContent())) {
                // We skip all relations that are below or on the cut, because we do not handle recursion on those
                continue;
            }

            if (component.size() > 1) {
                for (DependencyGraph<Relation>.Node node : component) {
                    Relation relation = node.getContent();
                    if (relation.isRecursive()) {
                        RecursiveGraph graph = new RecursiveGraph();
                        graph.setName(relation.getNameOrTerm() + "_rec");
                        graphs.add(graph);
                        relationGraphMap.put(relation, graph);
                    }
                }
                for (DependencyGraph<Relation>.Node node : component) {
                    Relation relation = node.getContent();
                    if (relation.isRecursive()) {
                        // side effect leads to calculation of children
                        RecursiveGraph graph = (RecursiveGraph) relationGraphMap.get(relation);
                        graph.setConcreteGraph(createGraphFromRelation(relation));
                    }
                }
            }
        }

        for (Axiom axiom : memoryModel.getAxioms()) {
            if (axiom instanceof ForceEncodeAxiom || axiom.isFlagged()) {
                continue;
            }
            Constraint constraint = getOrCreateConstraintFromAxiom(axiom);
            constraints.add(constraint);
        }

        caatModel = CAATModel.from(graphs, constraints);
    }

    // =================================================

    // ================ Accessors =======================

    public CAATModel getCAATModel() { return caatModel; }

    public EventDomain getDomain() { return domain; }

    public BiMap<Relation, RelationGraph> getRelationGraphMap() {
        return Maps.unmodifiableBiMap(relationGraphMap);
    }

    public BiMap<Axiom, Constraint> getAxiomConstraintMap() {
        return Maps.unmodifiableBiMap(constraintMap);
    }

    public Set<Relation> getCutRelations() { return cutRelations; }

    public RelationGraph getRelationGraph(Relation rel) {
        return relationGraphMap.get(rel);
    }

    public RelationGraph getRelationGraphByName(String name) {
        return getRelationGraph(refinementModel.getOriginalModel().getRelation(name));
    }

    public Constraint getConstraint(Axiom axiom) {
        return constraintMap.get(axiom);
    }

    public Collection<Constraint> getConstraints() {
        return constraintMap.values();
    }

    // ====================================================

    // ==================== Mutation ======================

    public void backtrackTo(int time) {
        caatModel.getHierarchy().backtrackTo(time);
    }

    // =======================================================

    // ==================== Analysis ======================

    public boolean checkInconsistency() {
        return caatModel.checkInconsistency();
    }

    // =======================================================

    //=================== Reading the WMM ====================

    private void checkNoUnsupportedRelations(RefinementModel refinementModel) {
        // Check that unsupported relations are all below the cut.
        for (Relation rel : refinementModel.getOriginalModel().getRelations()) {
            if (rel.isInternal() || rel.getDefinition() instanceof LinuxCriticalSections) {
                Preconditions.checkArgument(refinementModel.translateToBase(rel) != null,
                        "Relation '%s' is not supported. Missing cut?", rel.getNameOrTerm());
            }
        }
    }

    private Constraint getOrCreateConstraintFromAxiom(Axiom axiom) {
        if (constraintMap.containsKey(axiom)) {
            return constraintMap.get(axiom);
        }

        Constraint constraint;
        RelationGraph innerGraph = getOrCreateGraphFromRelation(axiom.getRelation());
        if (axiom.isAcyclicity()) {
            constraint = new AcyclicityConstraint(innerGraph);
        } else if (axiom.isEmptiness()) {
            constraint = new EmptinessConstraint(innerGraph);
        } else if (axiom.isIrreflexivity()) {
            constraint = new IrreflexivityConstraint(innerGraph);
        } else {
            throw new UnsupportedOperationException("The axiom " + axiom + " is not recognized.");
        }

        constraintMap.put(axiom, constraint);
        return constraint;
    }

    private RelationGraph getOrCreateGraphFromRelation(Relation rel) {
        if (relationGraphMap.containsKey(rel)) {
            return relationGraphMap.get(rel);
        }
        RelationGraph graph = createGraphFromRelation(rel);
        relationGraphMap.put(rel, graph);
        return graph;
    }

    private RelationGraph createGraphFromRelation(Relation rel) {
        final RelationGraph graph;
        final Class<?> relClass = rel.getDefinition().getClass();
        final List<Relation> dependencies = rel.getDependencies();

        if (cutRelations.contains(rel)) {
            graph = new DynamicDefaultWMMGraph(refinementModel.translateToBase(rel));
        } else if (relClass == ReadFrom.class) {
            graph = new ReadFromGraph();
        } else if (relClass == SameLocation.class) {
            graph = new LocationGraph();
        } else if (relClass == ProgramOrder.class) {
            graph = new ProgramOrderGraph();
        } else if (relClass == Coherence.class) {
            graph = new CoherenceGraph();
        } else if (relClass == Inverse.class || relClass == TransitiveClosure.class || relClass == RangeIdentity.class) {
            RelationGraph g = getOrCreateGraphFromRelation(dependencies.get(0));
            graph = relClass == Inverse.class ? new InverseGraph(g) :
                    relClass == TransitiveClosure.class ? new TransitiveGraph(g) :
                            new RangeIdentityGraph(g);
        } else if (relClass == Union.class || relClass == Intersection.class) {
            RelationGraph[] graphs = new RelationGraph[dependencies.size()];
            for (int i = 0; i < graphs.length; i++) {
                graphs[i] = getOrCreateGraphFromRelation(dependencies.get(i));
            }
            graph = relClass == Union.class ? new UnionGraph(graphs) :
                    new IntersectionGraph(graphs);
        } else if (relClass == Composition.class || relClass == Difference.class) {
            RelationGraph g1 = getOrCreateGraphFromRelation(dependencies.get(0));
            RelationGraph g2 = getOrCreateGraphFromRelation(dependencies.get(1));
            graph = relClass == Composition.class ? new CompositionGraph(g1, g2) :
                    new DifferenceGraph(g1, g2);
        } else if (relClass == CartesianProduct.class) {
            CartesianProduct cartRel = (CartesianProduct)rel.getDefinition();
            SetPredicate lhs = getOrCreateSetFromFilter(cartRel.getFirstFilter());
            SetPredicate rhs = getOrCreateSetFromFilter(cartRel.getSecondFilter());
            graph = new CartesianGraph(lhs, rhs);
        } else if (relClass == ReadModifyWrites.class) {
            graph = new RMWGraph();
        } else if (relClass == External.class) {
            graph = new ExternalGraph();
        } else if (relClass == Internal.class) {
            graph = new InternalGraph();
        } else if (relClass == Fences.class) {
            throw new UnsupportedOperationException("fencerel is not supported in CAAT.");
        } else if (relClass == SetIdentity.class) {
            SetPredicate set = getOrCreateSetFromFilter(((SetIdentity) rel.getDefinition()).getFilter());
            graph = new SetIdentityGraph(set);
        } else if (relClass == Empty.class) {
            graph = new EmptyGraph();
        } else {
            // This is a fallback for all unimplemented static graphs
            graph = new StaticDefaultWMMGraph(rel, ra);
        }

        graph.setName(rel.getNameOrTerm());
        return graph;
    }

    private SetPredicate getOrCreateSetFromFilter(Filter filter) {
        if (filterSetMap.containsKey(filter)) {
            return filterSetMap.get(filter);
        }

        SetPredicate set = new StaticWMMSet(filter);
        set.setName(filter.toString());
        filterSetMap.put(filter, set);
        return set;

    }

    // =======================================================


}
