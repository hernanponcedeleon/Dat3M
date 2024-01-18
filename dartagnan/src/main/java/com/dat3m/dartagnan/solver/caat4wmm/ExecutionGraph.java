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
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Maps;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

public class ExecutionGraph {

    // These graphs are only relevant for data, ctrl and addr, all of which have a special event graph (see below)
    //TODO: We need a better way to handle the composed relations (in case we rename them as well?)
    private static final Set<String> EXCLUDED_RELS = ImmutableSet.of(
            IDD, IDDTRANS, CTRLDIRECT, ADDRDIRECT, String.format("(%s;%s)", IDDTRANS, ADDRDIRECT),
            String.format("(%s+(%s;%s))", ADDRDIRECT, IDDTRANS, ADDRDIRECT),
            String.format("(%s;%s)", IDDTRANS, CTRLDIRECT)
    );


    // These relations have special event graphs associated with them
    private static final Set<String> SPECIAL_RELS = ImmutableSet.of(ADDR, DATA, CTRL, CRIT);


    // ================== Fields =====================

    // All following variables can be considered "final".
    // Some are not declared final for purely technical reasons but all of them get
    // assigned during construction.

    private final VerificationTask verificationTask;
    private final RelationAnalysis ra;
    private final BiMap<Relation, RelationGraph> relationGraphMap;
    private final BiMap<Filter, SetPredicate> filterSetMap;
    private final BiMap<Axiom, Constraint> constraintMap;
    private final Set<Relation> cutRelations;

    private CAATModel caatModel;
    private EventDomain domain;

    // =================================================

    // ============= Construction & Init ===============

    public ExecutionGraph(VerificationTask verificationTask, Context analysisContext, Set<Relation> cutRelations, boolean createOnlyAxiomRelevantGraphs) {
        this.verificationTask = verificationTask;
        ra = analysisContext.requires(RelationAnalysis.class);
        relationGraphMap = HashBiMap.create();
        filterSetMap = HashBiMap.create();
        constraintMap = HashBiMap.create();
        this.cutRelations = cutRelations;
        constructMappings(createOnlyAxiomRelevantGraphs);
    }

    public void initializeFromModel(ExecutionModel executionModel) {
        domain = new EventDomain(executionModel);
        caatModel.initializeToDomain(domain);
    }

    // --------------------------------------------------

    private void constructMappings(boolean createOnlyAxiomRelevantGraphs) {
        final Wmm memoryModel = verificationTask.getMemoryModel();

        Set<RelationGraph> graphs = new HashSet<>();
        Set<Constraint> constraints = new HashSet<>();
        DependencyGraph<Relation> dependencyGraph = DependencyGraph.from(memoryModel.getRelations());

        for (Set<DependencyGraph<Relation>.Node> component : dependencyGraph.getSCCs()) {
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

        if (!createOnlyAxiomRelevantGraphs) {
            for (Relation rel : DependencyGraph.from(memoryModel.getRelations()).getNodeContents()) {
                if (!EXCLUDED_RELS.contains(rel.getNameOrTerm())) {
                    RelationGraph graph = getOrCreateGraphFromRelation(rel);
                    graphs.add(graph);
                }
            }
        }

        caatModel = CAATModel.from(graphs, constraints);
    }

    // =================================================

    // ================ Accessors =======================

    public VerificationTask getVerificationTask() { return verificationTask; }

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
        return getRelationGraph(verificationTask.getMemoryModel().getRelation(name));
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
        RelationGraph graph;
        Class<?> relClass = rel.getDefinition().getClass();
        List<Relation> dependencies = rel.getDependencies();

        // ===== Filter special relations ======
        String name = rel.getNameOrTerm();
        if (SPECIAL_RELS.contains(name)) {
            switch (name) {
                case CTRL:
                    graph = new CtrlDepGraph();
                    break;
                case DATA:
                    graph = new DataDepGraph();
                    break;
                case ADDR:
                    graph = new AddrDepGraph();
                    break;
                case CRIT:
                    graph = new RcuGraph();
                    break;
                default:
                    throw new UnsupportedOperationException(name + " is marked as special relation but has associated graph.");
            }
        } else if (cutRelations.contains(rel)) {
            graph = new DynamicDefaultWMMGraph(name);
        } else if (relClass == ReadFrom.class) {
            graph = new ReadFromGraph();
        } else if (relClass == SameAddress.class) {
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
        } else if (relClass == DifferentThreads.class) {
            graph = new ExternalGraph();
        } else if (relClass == SameThread.class) {
            graph = new InternalGraph();
        } else if (relClass == Fences.class) {
            graph = new FenceGraph(((Fences) rel.getDefinition()).getFilter());
        } else if (relClass == Identity.class) {
            SetPredicate set = getOrCreateSetFromFilter(((Identity) rel.getDefinition()).getFilter());
            graph = new SetIdentityGraph(set);
        } else if (relClass == Empty.class) {
            graph = new EmptyGraph();
        } else {
            // This is a fallback for all unimplemented static graphs
            graph = new StaticDefaultWMMGraph(rel, ra);
        }

        graph.setName(name);
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
