package com.dat3m.dartagnan.solver.caat4wmm;

import com.dat3m.dartagnan.solver.caat.CAATModel;
import com.dat3m.dartagnan.solver.caat.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.Constraint;
import com.dat3m.dartagnan.solver.caat.constraints.EmptinessConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.IrreflexivityConstraint;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.EmptyGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.*;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.sets.derived.*;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.*;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
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

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

public class ExecutionGraph {

    // ================== Fields =====================

    // All following variables can be considered "final".
    // Some are not declared final for purely technical reasons but all of them get
    // assigned during construction.

    private final RefinementModel refinementModel;
    private final BiMap<Relation, CAATPredicate> predicateToRelationMap;
    private final BiMap<Axiom, Constraint> constraintMap;
    private final Set<Relation> cutRelations;

    private CAATModel caatModel;
    private EventDomain domain;

    // =================================================

    // ============= Construction & Init ===============

    public ExecutionGraph(RefinementModel refinementModel) {
        this.refinementModel = refinementModel;
        predicateToRelationMap = HashBiMap.create();
        constraintMap = HashBiMap.create();
        cutRelations = refinementModel.computeBoundaryRelations().stream()
                .filter(r -> r.getName().map(n -> !(n.equals(CO) || n.equals(RF))).orElse(true))
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
                        predicateToRelationMap.put(relation, graph);
                    }
                }
                for (DependencyGraph<Relation>.Node node : component) {
                    Relation relation = node.getContent();
                    if (relation.isRecursive()) {
                        // side effect leads to calculation of children
                        RecursiveGraph graph = (RecursiveGraph) predicateToRelationMap.get(relation);
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

    public Relation getRelation(CAATPredicate predicate) {
        return predicateToRelationMap.inverse().get(predicate);
    }

    public BiMap<Axiom, Constraint> getAxiomConstraintMap() {
        return Maps.unmodifiableBiMap(constraintMap);
    }

    public Set<Relation> getCutRelations() { return cutRelations; }

    public CAATPredicate getPredicate(Relation rel) {
        return predicateToRelationMap.get(rel);
    }

    public CAATPredicate getPredicateByName(String name) {
        return getPredicate(refinementModel.getOriginalModel().getRelation(name));
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
        Relation.checkIsRelation(rel);
        if (predicateToRelationMap.containsKey(rel)) {
            return (RelationGraph) predicateToRelationMap.get(rel);
        }
        RelationGraph graph = createGraphFromRelation(rel);
        predicateToRelationMap.put(rel, graph);
        return graph;
    }

    private RelationGraph createGraphFromRelation(Relation rel) {
        Relation.checkIsRelation(rel);
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
        } else if (relClass == Inverse.class || relClass == TransitiveClosure.class) {
            RelationGraph g = getOrCreateGraphFromRelation(dependencies.get(0));
            graph = relClass == Inverse.class ? new InverseGraph(g) : new TransitiveGraph(g);
        } else if (relClass == Union.class || relClass == Intersection.class) {
            RelationGraph[] graphs = new RelationGraph[dependencies.size()];
            for (int i = 0; i < graphs.length; i++) {
                graphs[i] = getOrCreateGraphFromRelation(dependencies.get(i));
            }
            graph = relClass == Union.class ? new UnionGraph(graphs) : new IntersectionGraph(graphs);
        } else if (relClass == Composition.class || relClass == Difference.class) {
            RelationGraph g1 = getOrCreateGraphFromRelation(dependencies.get(0));
            RelationGraph g2 = getOrCreateGraphFromRelation(dependencies.get(1));
            graph = relClass == Composition.class ? new CompositionGraph(g1, g2) : new DifferenceGraph(g1, g2);
        } else if (relClass == CartesianProduct.class) {
            CartesianProduct cartRel = (CartesianProduct)rel.getDefinition();
            SetPredicate lhs = getOrCreateSetFromRelation(cartRel.getDomain());
            SetPredicate rhs = getOrCreateSetFromRelation(cartRel.getRange());
            graph = new CartesianGraph(lhs, rhs);
        } else if (relClass == External.class) {
            graph = new ExternalGraph();
        } else if (relClass == Internal.class) {
            graph = new InternalGraph();
        } else if (relClass == SetIdentity.class) {
            SetPredicate set = getOrCreateSetFromRelation(((SetIdentity) rel.getDefinition()).getDomain());
            graph = new SetIdentityGraph(set);
        } else if (relClass == Empty.class) {
            graph = new EmptyGraph();
        } else {
            final String error = String.format("Cannot handle relation %s with definition of type %s.",
                    rel, relClass.getSimpleName());
            throw new UnsupportedOperationException(error);
        }

        graph.setName(rel.getNameOrTerm());
        return graph;
    }

    private SetPredicate getOrCreateSetFromRelation(Relation relation) {
        Relation.checkIsSet(relation);
        final CAATPredicate existing = predicateToRelationMap.get(relation);
        if (existing != null) {
            return (SetPredicate) existing;
        }
        final Class<?> relClass = relation.getDefinition().getClass();
        final List<Relation> dependencies = relation.getDependencies();
        final SetPredicate set;
        if (cutRelations.contains(relation)) {
            set = new DynamicDefaultWMMSet(refinementModel.translateToBase(relation));
        } else if (relClass == TagSet.class) {
            set = new StaticWMMSet(((TagSet) relation.getDefinition()).getTag());
        } else if (relClass == Range.class || relClass == Domain.class) {
            RelationGraph g = getOrCreateGraphFromRelation(dependencies.get(0));
            ProjectionSet.Dimension dim = relClass == Range.class ?
                    ProjectionSet.Dimension.RANGE :
                    ProjectionSet.Dimension.DOMAIN;
            set = new ProjectionSet(g, dim);
        } else if (relClass == Union.class || relClass == Intersection.class) {
            SetPredicate[] graphs = new SetPredicate[dependencies.size()];
            for (int i = 0; i < graphs.length; i++) {
                graphs[i] = getOrCreateSetFromRelation(dependencies.get(i));
            }
            set = relClass == Union.class ? new UnionSet(graphs) : new IntersectionSet(graphs);
        } else if (relClass == Difference.class) {
            SetPredicate s1 = getOrCreateSetFromRelation(dependencies.get(0));
            SetPredicate s2 = getOrCreateSetFromRelation(dependencies.get(1));
            set = new DifferenceSet(s1, s2);
        } else {
            throw new UnsupportedOperationException(String.format("Cannot handle set %s with definition of type %s", relation, relClass.getSimpleName()));
        }
        predicateToRelationMap.put(relation, set);
        set.setName(relation.getNameOrTerm());
        return set;
    }

    // =======================================================


}
