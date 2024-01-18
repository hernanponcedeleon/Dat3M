package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.ElementLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomain;
import com.dat3m.dartagnan.solver.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.FenceGraph;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.Fences;

import java.util.*;
import java.util.function.Function;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_SYMMETRIC_LEARNING;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

// The CoreReasoner transforms base reasons of the CAATSolver to core reason of the WMMSolver.
public class CoreReasoner {

    public enum SymmetricLearning { NONE, LINEAR, QUADRATIC, FULL }

    private final ExecutionGraph executionGraph;
    private final ExecutionAnalysis exec;
    private final RelationAnalysis ra;
    private final Map<String, Relation> termMap = new HashMap<>();

    private final ThreadSymmetry symm;
    private final List<Function<Event, Event>> symmPermutations;
    private final SymmetricLearning learningOption;

    public CoreReasoner(VerificationTask task, Context analysisContext, ExecutionGraph executionGraph) {
        this.executionGraph = executionGraph;
        this.exec = analysisContext.requires(ExecutionAnalysis.class);
        this.ra = analysisContext.requires(RelationAnalysis.class);
        for (Relation r : task.getMemoryModel().getRelations()) {
            termMap.put(r.getNameOrTerm(), r);
        }

        this.learningOption = REFINEMENT_SYMMETRIC_LEARNING;
        symm = analysisContext.requires(ThreadSymmetry.class);
        symmPermutations = computeSymmetryPermutations();
    }

    // Returns the (reduced) core reason of a base reason. If symmetry reasoning is enabled,
    // this can return multiple core reasons corresponding to symmetric versions of the base reason.
    public Set<Conjunction<CoreLiteral>> toCoreReasons(Conjunction<CAATLiteral> baseReason) {
        final EventDomain domain = executionGraph.getDomain();
        final Set<Conjunction<CoreLiteral>> symmetricReasons = new HashSet<>();

        //TODO: A specialized algorithm that computes the orbit under permutation may be better,
        // since most violations involve only few threads and hence the orbit is far smaller than the full
        // set of permutations.
        for (Function<Event, Event> perm : symmPermutations) {
            List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
            for (CAATLiteral lit : baseReason.getLiterals()) {
                if (lit instanceof ElementLiteral elLit) {
                    final Event e = perm.apply(domain.getObjectById(elLit.getElement().getId()).getEvent());
                    // We only have static tags, so all of them reduce to execution literals
                    coreReason.add(new ExecLiteral(e, lit.isNegative()));
                } else {
                    final EdgeLiteral edgeLit = (EdgeLiteral) lit;
                    final Edge edge = edgeLit.getEdge();
                    final Event e1 = perm.apply(domain.getObjectById(edge.getFirst()).getEvent());
                    final Event e2 = perm.apply(domain.getObjectById(edge.getSecond()).getEvent());
                    final Relation rel = termMap.get(lit.getName());

                    if (lit.isPositive() && ra.getKnowledge(rel).getMustSet().contains(e1, e2)) {
                        // Statically present edges
                        addExecReason(e1, e2, coreReason);
                    } else if (lit.isNegative() && !ra.getKnowledge(rel).getMaySet().contains(e1, e2)) {
                        // Statically absent edges
                    } else {
                        final String name = rel.getNameOrTerm();
                        if (name.equals(RF) || name.equals(CO)
                                || executionGraph.getCutRelations().contains(rel)) {
                            coreReason.add(new RelLiteral(name, e1, e2, lit.isNegative()));
                        } else if (name.equals(LOC)) {
                            coreReason.add(new AddressLiteral(e1, e2, lit.isNegative()));
                        } else if (rel.getDefinition() instanceof Fences) {
                            // This is a special case since "fencerel(F) = po;[F];po".
                            // We should do this transformation directly on the Wmm to avoid this special reasoning
                            if (lit.isNegative()) {
                                throw new UnsupportedOperationException(String.format("FenceRel %s is not allowed on the rhs of differences.", rel));
                            }
                            addFenceReason(rel, edge, coreReason);
                        } else {
                            // FIXME: Right now, we assume many relations like data, ctrl and addr to be static.
                            //  In order to fix this, we would need to cut/eagerly encode the dependency relations.
                            if (lit.isNegative()) {
                                // TODO: Support negated literals (ideally via lazy/on-demand cutting)
                                throw new UnsupportedOperationException(String.format("Negated literals of type %s are not supported.", rel));
                            }
                            addExecReason(e1, e2, coreReason);
                        }
                    }
                }
            }
            minimize(coreReason);
            symmetricReasons.add(new Conjunction<>(coreReason));
        }

        return symmetricReasons;
    }


    private void minimize(List<CoreLiteral> reason) {
        reason.removeIf( lit -> {
            if (!(lit instanceof ExecLiteral execLit) || lit.isNegative()) {
                return false;
            }
            final Event ev = execLit.getData();
            return reason.stream().filter(e -> e instanceof RelLiteral && e.isPositive())
                    .map(RelLiteral.class::cast)
                    .anyMatch(e -> exec.isImplied(e.getData().first(), ev)
                            || exec.isImplied(e.getData().second(), ev));

        });
    }

    private void addExecReason(Event e1, Event e2, List<CoreLiteral> coreReasons) {
        if (e1.getGlobalId() > e2.getGlobalId()) {
            // Normalize edge direction
            Event temp = e1;
            e1 = e2;
            e2 = temp;
        }

        if (exec.isImplied(e1, e2)) {
            coreReasons.add(new ExecLiteral(e1));
        } else if (exec.isImplied(e2, e1)) {
            coreReasons.add(new ExecLiteral(e2));
        } else {
            coreReasons.add(new ExecLiteral(e1));
            coreReasons.add(new ExecLiteral(e2));
        }
    }

    private void addFenceReason(Relation rel, Edge edge, List<CoreLiteral> coreReasons) {
        FenceGraph fenceGraph = (FenceGraph) executionGraph.getRelationGraph(rel);
        EventDomain domain = executionGraph.getDomain();
        EventData e1 = domain.getObjectById(edge.getFirst());
        EventData e2 = domain.getObjectById(edge.getSecond());
        EventData f = fenceGraph.getNextFence(e1);

        coreReasons.add(new ExecLiteral(f.getEvent()));
        if (!exec.isImplied(f.getEvent(), e1.getEvent())) {
            coreReasons.add(new ExecLiteral(e1.getEvent()));
        }
        if (!exec.isImplied(f.getEvent(), e2.getEvent())) {
            coreReasons.add(new ExecLiteral(e2.getEvent()));
        }
    }

    // =============================================================================================
    // ======================================== Symmetry ===========================================
    // =============================================================================================

    // Computes a list of permutations between events of symmetric threads.
    // Depending on the <learningOption>, the set of computed permutations differs.
    // In particular, for the option NONE, only the identity permutation will be returned.
    private List<Function<Event, Event>> computeSymmetryPermutations() {
        final Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
        final List<Function<Event, Event>> perms = new ArrayList<>();
        perms.add(Function.identity());

        for (EquivalenceClass<Thread> c : symmClasses) {
            final List<Thread> threads = new ArrayList<>(c);
            threads.sort(Comparator.comparingInt(Thread::getId));

            switch (learningOption) {
                case NONE:
                    break;
                case LINEAR:
                    for (int i = 0; i < threads.size(); i++) {
                        final int j = (i + 1) % threads.size();
                        perms.add(symm.createEventTransposition(threads.get(i), threads.get(j)));
                    }
                    break;
                case QUADRATIC:
                    for (int i = 0; i < threads.size(); i++) {
                        for (int j = i + 1; j < threads.size(); j++) {
                            perms.add(symm.createEventTransposition(threads.get(i), threads.get(j)));
                        }
                    }
                    break;
                case FULL:
                    final List<Function<Event, Event>> allPerms = symm.createAllEventPermutations(c);
                    allPerms.remove(Function.identity()); // We avoid adding multiple identities
                    perms.addAll(allPerms);
                    break;
                default:
                    throw new UnsupportedOperationException("Symmetry learning option: "
                            + learningOption + " is not recognized.");
            }
        }

        return perms;
    }
}
