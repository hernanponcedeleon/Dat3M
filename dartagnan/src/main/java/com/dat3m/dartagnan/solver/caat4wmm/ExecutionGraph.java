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
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.base.Preconditions;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.Maps;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ExecutionGraph {

    // ================== Fields =====================

    // All following variables can be considered "final".
    // Some are not declared final for purely technical reasons but all of them get
    // assigned during construction.

    private final Wmm memoryModel;
    private final Set<? extends com.dat3m.dartagnan.wmm.Constraint> encodedConstraints;
    private final BiMap<Relation, CAATPredicate> predicateToRelationMap = HashBiMap.create();
    private final BiMap<Axiom, Constraint> constraintMap = HashBiMap.create();

    private CAATModel caatModel;
    private EventDomain domain;

    // =================================================

    // ============= Construction & Init ===============

    public ExecutionGraph(Wmm model, Collection<? extends com.dat3m.dartagnan.wmm.Constraint> toBeEncoded) {
        memoryModel = Preconditions.checkNotNull(model);
        encodedConstraints = Set.copyOf(DependencyGraph.from(toBeEncoded).getNodeContents());
        constructMappings();
    }

    public void initializeFromModel(ExecutionModel executionModel) {
        domain = new EventDomain(executionModel);
        caatModel.initializeToDomain(domain);
    }

    // --------------------------------------------------

    private void constructMappings() {
        Set<RelationGraph> graphs = new HashSet<>();
        Set<Constraint> constraints = new HashSet<>();
        DependencyGraph<Relation> dependencyGraph = DependencyGraph.from(memoryModel.getRelations());

        // Special treatment for recursive relations.
        for (Set<DependencyGraph<Relation>.Node> component : dependencyGraph.getSCCs()) {
            if (encodedConstraints.contains(component.iterator().next().getContent().getDefinition())) {
                // We skip all relations that are below or on the cut, because we do not handle recursion on those
                continue;
            }

            if (component.size() > 1) {
                for (DependencyGraph<Relation>.Node node : component) {
                    Relation relation = node.getContent();
                    if (relation.isRecursive()) {
                        if (relation.isSet()) {
                            throw new UnsupportedOperationException("No support for recursive sets");
                        }
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
            if (axiom.isFlagged() || axiom.isNegated() || encodedConstraints.contains(axiom)) {
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

    public CAATPredicate getPredicate(Relation rel) {
        return predicateToRelationMap.get(rel);
    }

    public CAATPredicate getPredicateByName(String name) {
        return getPredicate(memoryModel.getRelation(name));
    }

    public Constraint getConstraint(Axiom axiom) {
        return constraintMap.get(axiom);
    }

    public Collection<Constraint> getConstraints() {
        return constraintMap.values();
    }

    public boolean isEncoded(Relation relation) {
        return encodedConstraints.contains(relation.getDefinition());
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

    private Constraint getOrCreateConstraintFromAxiom(Axiom axiom) {
        if (constraintMap.containsKey(axiom)) {
            return constraintMap.get(axiom);
        }

        Constraint constraint;
        Relation inner = axiom.getRelation();
        CAATPredicate innerPred = inner.isSet() ?
            getOrCreateSetFromRelation(inner) :
            getOrCreateGraphFromRelation(inner);
        if (axiom.isAcyclicity()) {
            constraint = new AcyclicityConstraint((RelationGraph) innerPred);
        } else if (axiom.isEmptiness()) {
            constraint = new EmptinessConstraint(innerPred);
        } else if (axiom.isIrreflexivity()) {
            constraint = new IrreflexivityConstraint((RelationGraph) innerPred);
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

        if (encodedConstraints.contains(rel.getDefinition())) {
            graph = new DynamicDefaultWMMGraph(rel);
        } else if (relClass == SameLocation.class) {
            graph = new LocationGraph();
        } else if (relClass == ProgramOrder.class) {
            graph = new ProgramOrderGraph();
        } else if (relClass == SameInstruction.class) {
            graph = new SameInstructionGraph();
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
        if (encodedConstraints.contains(relation.getDefinition())) {
            set = new DynamicDefaultWMMSet(relation);
        } else if (relClass == TagSet.class) {
            set = new StaticWMMSet(((TagSet) relation.getDefinition()).getTag());
        } else if (relClass == Projection.class) {
            final RelationGraph g = getOrCreateGraphFromRelation(dependencies.get(0));
            final boolean dom = ((Projection) relation.getDefinition()).getDimension() == Projection.Dimension.DOMAIN;
            final ProjectionSet.Dimension dim = dom ? ProjectionSet.Dimension.DOMAIN : ProjectionSet.Dimension.RANGE;
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
