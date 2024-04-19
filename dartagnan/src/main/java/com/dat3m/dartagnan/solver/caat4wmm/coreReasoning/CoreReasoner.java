package com.dat3m.dartagnan.solver.caat4wmm.coreReasoning;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.EdgeLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.ElementLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.EventDomain;
import com.dat3m.dartagnan.solver.caat4wmm.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat4wmm.basePredicates.FenceGraph;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.definition.Fences;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_SYMMETRIC_LEARNING;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

// The CoreReasoner transforms base reasons of the CAATSolver to core reason of the WMMSolver.
public class CoreReasoner {

    private final static int MAX_NUM_COMPUTED_REASONS = 1000;

    public enum SymmetricLearning { NONE, FULL }

    private final ExecutionGraph executionGraph;
    private final ExecutionAnalysis exec;
    private final RelationAnalysis ra;
    private final List<Function<Event, Event>> symmGenerators;

    public CoreReasoner(Context analysisContext, ExecutionGraph executionGraph) {
        this.executionGraph = executionGraph;
        this.exec = analysisContext.requires(ExecutionAnalysis.class);
        this.ra = analysisContext.requires(RelationAnalysis.class);
        this.symmGenerators = computeSymmetryGenerators(
                analysisContext.requires(ThreadSymmetry.class), REFINEMENT_SYMMETRIC_LEARNING);
    }

    public Set<Conjunction<CoreLiteral>> toCoreReasons(DNF<CAATLiteral> baseReasons) {

        // (1) Find valuable base reasons by reducing them to simplified core reasons first
        // and filtering out duplicates
        BiMap<Conjunction<CAATLiteral>, Conjunction<CoreLiteral>> base2core = HashBiMap.create(baseReasons.getNumberOfCubes());
        BiMap<Conjunction<CoreLiteral>, Conjunction<CAATLiteral>> core2base = base2core.inverse();
        for (Conjunction<CAATLiteral> baseReason : baseReasons.getCubes()) {
            final Conjunction<CoreLiteral> coreReason = toCoreReasonNoSymmetry(baseReason);
            if (!base2core.containsValue(coreReason)) {
                base2core.put(baseReason, coreReason);
            }
        }

        // (2) Remove dominated core reasons and sort by reason length
        List<Conjunction<CoreLiteral>> reducedCoreReasons = new ArrayList<>(new DNF<>(base2core.values()).getCubes());
        reducedCoreReasons.sort(Comparator.comparingInt(Conjunction::getSize));

        // (3) Translate back to base reasons (we need the original base reasons for symmetry reasoning)
        List<Conjunction<CAATLiteral>> reducedBaseReasons = reducedCoreReasons.stream().map(core2base::get).toList();

        // (4) Recompute core reasons with symmetry reasoning.
        //  Stop early, if the number of reasons gets too large.
        final Set<Conjunction<CoreLiteral>> coreReasons = new HashSet<>();
        for (Conjunction<CAATLiteral> baseReason : reducedBaseReasons) {
            coreReasons.addAll(toCoreReasons(baseReason));
            if (coreReasons.size() > MAX_NUM_COMPUTED_REASONS) {
                break;
            }
        }

        return coreReasons;
    }

    public Set<Conjunction<CoreLiteral>> toCoreReasons(Conjunction<CAATLiteral> baseReason) {
        final EventDomain domain = executionGraph.getDomain();

        final Set<List<CoreLiteral>> orbit = new HashSet<>();
        final Deque<List<CoreLiteral>> workqueue = new ArrayDeque<>();
        workqueue.add(toUnreducedCoreReason(baseReason, domain));

        while (!workqueue.isEmpty()) {
            final List<CoreLiteral> reason = workqueue.removeFirst();
            for (Function<Event, Event> generator : symmGenerators) {
                final List<CoreLiteral> permuted = getPermuted(reason, generator);
                if (orbit.add(permuted)) {
                    workqueue.add(permuted);
                }
            }
        }

        return orbit.stream().map(this::reduce).map(Conjunction::new).collect(Collectors.toSet());
    }

    private Conjunction<CoreLiteral> toCoreReasonNoSymmetry(Conjunction<CAATLiteral> baseReason) {
        return new Conjunction<>(reduce(toUnreducedCoreReason(baseReason, executionGraph.getDomain())));
    }

    private List<CoreLiteral> getPermuted(List<CoreLiteral> reason, Function<Event, Event> perm) {
        final List<CoreLiteral> permuted = new ArrayList<>(reason.size());

        for (CoreLiteral lit : reason) {
            if (lit instanceof ExecLiteral execLiteral) {
                final Event e = perm.apply(execLiteral.getEvent());
                permuted.add(new ExecLiteral(e, execLiteral.isPositive()));
            } else if (lit instanceof RelLiteral relLiteral) {
                final Event e1 = perm.apply(relLiteral.getSource());
                final Event e2 = perm.apply(relLiteral.getTarget());
                permuted.add(new RelLiteral(relLiteral.getRelation(), e1, e2, relLiteral.isPositive()));
            } else {
                assert false : "Unexpected core literal type: violated invariant.";
            }
        }
        return permuted;
    }

    private List<CoreLiteral> toUnreducedCoreReason(Conjunction<CAATLiteral> baseReason, EventDomain domain) {
        final List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
        for (CAATLiteral lit : baseReason.getLiterals()) {
            if (lit instanceof ElementLiteral eleLit) {
                final Event e = domain.getObjectById(eleLit.getData().getId()).getEvent();
                coreReason.add(new ExecLiteral(e, lit.isPositive()));
            } else if (lit instanceof EdgeLiteral edgeLit) {
                final Event e1 = domain.getObjectById(edgeLit.getData().getFirst()).getEvent();
                final Event e2 = domain.getObjectById(edgeLit.getData().getSecond()).getEvent();
                final Relation rel = executionGraph.getRelationGraphMap().inverse().get(edgeLit.getPredicate());
                coreReason.add(new RelLiteral(rel, e1, e2, edgeLit.isPositive()));
            }
        }
        return coreReason;
    }

    // Reduce a core reason by applying knowledge about the semantics of its literals
    // (relation analysis / base semantics / control-flow information etc.)
    private List<CoreLiteral> reduce(List<CoreLiteral> reason) {
        final List<CoreLiteral> simplified = new ArrayList<>();
        for (CoreLiteral lit : reason) {
            if (lit instanceof ExecLiteral execLiteral) {
                simplified.add(execLiteral);
            } else if (lit instanceof RelLiteral relLiteral) {
                final Event e1 = relLiteral.getSource();
                final Event e2 = relLiteral.getTarget();
                final Relation rel = relLiteral.getRelation();
                if (relLiteral.isPositive() && ra.getKnowledge(rel).getMustSet().contains(e1, e2)) {
                    addExecReason(e1, e2, simplified);
                } else if (relLiteral.isNegative() && !ra.getKnowledge(rel).getMaySet().contains(e1, e2)) {
                    // Negated literal is always true, no need to remember it.
                } else {
                    String name = rel.getName().orElse(null);
                    if (RF.equals(name) || CO.equals(name) || executionGraph.getCutRelations().contains(rel)) {
                        simplified.add(lit);
                    } else if (LOC.equals(name)) {
                        simplified.add(new AddressLiteral(e1, e2, lit.isPositive()));
                    } else if (rel.getDefinition() instanceof Fences) {
                        // This is a special case since "fencerel(F) = po;[F];po".
                        // We should do this transformation directly on the Wmm to avoid this special reasoning
                        if (lit.isNegative()) {
                            throw new UnsupportedOperationException(String.format("FenceRel %s is not allowed on the rhs of differences.", rel));
                        }
                        addFenceReason(rel, e1, e2, simplified);
                    } else {
                        throw new UnsupportedOperationException(String.format("Literals of type %s are not supported.", rel));
                    }
                }
            }
        }
        removeDominatedLiterals(simplified);
        return simplified;
    }

    private void removeDominatedLiterals(List<CoreLiteral> reason) {
        reason.removeIf( lit -> {
            if (!(lit instanceof ExecLiteral execLit) || lit.isNegative()) {
                return false;
            }
            final Event ev = execLit.getEvent();
            return reason.stream().filter(e -> e instanceof RelLiteral && e.isPositive())
                    .map(RelLiteral.class::cast)
                    .anyMatch(e -> exec.isImplied(e.getSource(), ev) || exec.isImplied(e.getTarget(), ev));
        });
        //TODO: Remove dominated exec literals and maybe address literals
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

    private void addFenceReason(Relation rel, Event e1, Event e2, List<CoreLiteral> coreReasons) {
        final FenceGraph fenceGraph = (FenceGraph) executionGraph.getRelationGraph(rel);
        final EventData ed1 = executionGraph.getDomain().getExecution().getData(e1).get();
        final Event f = fenceGraph.getNextFence(ed1).getEvent();

        coreReasons.add(new ExecLiteral(f));
        if (!exec.isImplied(f, e1)) {
            coreReasons.add(new ExecLiteral(e1));
        }
        if (!exec.isImplied(f, e2)) {
            coreReasons.add(new ExecLiteral(e2));
        }
    }

    // =============================================================================================
    // ======================================== Symmetry ===========================================
    // =============================================================================================

    // Computes a list of generators for the symmetry group of threads.
    private List<Function<Event, Event>> computeSymmetryGenerators(
            ThreadSymmetry symm, SymmetricLearning learningOption) {
        final Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
        final List<Function<Event, Event>> perms = new ArrayList<>();
        perms.add(Function.identity());

        if (learningOption == SymmetricLearning.NONE) {
            return perms;
        }

        assert learningOption == SymmetricLearning.FULL;

        for (EquivalenceClass<Thread> c : symmClasses) {
            final List<Thread> threads = new ArrayList<>(c);
            threads.sort(Comparator.comparingInt(Thread::getId));
            for (int i = 0; i < threads.size(); i++) {
                final int j = (i + 1) % threads.size();
                perms.add(symm.createEventTransposition(threads.get(i), threads.get(j)));
            }
        }

        return perms;
    }
}
