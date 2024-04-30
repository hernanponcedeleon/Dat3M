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
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_SYMMETRIC_LEARNING;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

// The CoreReasoner transforms base reasons of the CAATSolver to core reasons of the WMMSolver.
public class CoreReasoner {

    // An upper bound on the number of reasons computed per iteration,
    // This is mostly used to limit "reason explosion" for highly symmetric benchmarks.
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

    /*
        NOTE: When we compute symmetric core reasons, we may generate too many (blow-up)
        if the program is highly symmetric. To avoid this blow-up, we artificially stop the
        reason computation at some bound B.
        This is sound because even a single reason is sufficient to make progress,
        but it may result in making more refinement iterations.
        Since we compute only (at most) B core reasons, we try to estimate which
        base reasons give us the best (smallest) core reasons (Steps (1)-(3)).
     */
    public Set<Conjunction<CoreLiteral>> toCoreReasons(DNF<CAATLiteral> baseReasons) {

        // (1) Reduce base reasons to simplified core reasons (without symmetry).
        final BiMap<Conjunction<CAATLiteral>, Conjunction<CoreLiteral>> base2core =
                HashBiMap.create(baseReasons.getNumberOfCubes());
        for (Conjunction<CAATLiteral> baseReason : baseReasons.getCubes()) {
            final Conjunction<CoreLiteral> coreReason = toCoreReasonNoSymmetry(baseReason);
            if (!coreReason.isFalse() && !base2core.containsValue(coreReason)) {
                // NOTE: We only add productive base reasons whose core reasons are not FALSE.
                base2core.put(baseReason, coreReason);
            }
        }

        // (2) Remove dominated core reasons and sort by reason length
        final List<Conjunction<CoreLiteral>> reducedCoreReasons = new ArrayList<>(new DNF<>(base2core.values()).getCubes());
        reducedCoreReasons.sort(Comparator.comparingInt(Conjunction::getSize));

        // (3) Translate back to base reasons (we need the original base reasons for symmetry reasoning)
        final List<Conjunction<CAATLiteral>> reducedBaseReasons =
                reducedCoreReasons.stream().map(base2core.inverse()::get).toList();

        // (4) Recompute core reasons with symmetry reasoning.
        //  Stop early, if the number of reasons exceeds a bound.
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

        // We compute the orbit of <baseReason> under the symmetry group of the program's threads.
        // We use a standard worklist algorithm to do so.
        // NOTE: We compute the orbit of an "unreduced" core reason, because
        // reductions we can apply to a core reason may not be sound for its symmetric counterparts.
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

        // Now we can reduce all computed (symmetric) reasons.
        return orbit.stream().map(this::reduce).filter(Objects::nonNull).map(Conjunction::new).collect(Collectors.toSet());
    }

    private Conjunction<CoreLiteral> toCoreReasonNoSymmetry(Conjunction<CAATLiteral> baseReason) {
        List<CoreLiteral> reduced = reduce(toUnreducedCoreReason(baseReason, executionGraph.getDomain()));
        return reduced == null ? Conjunction.FALSE() : new Conjunction<>(reduced);
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

    // An "unreduced" core reason is a faithful (invertible) translation of a base relation to a core reason.
    private List<CoreLiteral> toUnreducedCoreReason(Conjunction<CAATLiteral> baseReason, EventDomain domain) {
        final List<CoreLiteral> coreReason = new ArrayList<>(baseReason.getSize());
        for (CAATLiteral lit : baseReason.getLiterals()) {
            if (lit instanceof ElementLiteral eleLit) {
                // FIXME: This step is not really faithful because we forget the unary predicate
                //  from which we derived the exec literals.
                //  This should be fine for now because all unary sets are static so they behave similarly.
                //  If we ever support dynamic unary predicates, this code needs to get updated.
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
    // This may return NULL, if our knowledge tells us that this is impossible to happen.
    private List<CoreLiteral> reduce(List<CoreLiteral> reason) {
        final List<CoreLiteral> simplified = new ArrayList<>();
        for (CoreLiteral lit : reason) {
            if (lit instanceof ExecLiteral execLiteral) {
                simplified.add(execLiteral);
            } else if (lit instanceof RelLiteral relLiteral) {
                final Event e1 = relLiteral.getSource();
                final Event e2 = relLiteral.getTarget();
                final Relation rel = relLiteral.getRelation();
                final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);

                if (relLiteral.isPositive() && k.getMustSet().contains(e1, e2)) {
                    addExecReason(e1, e2, simplified);
                } else if (!k.getMaySet().contains(e1, e2)) {
                    if (lit.isPositive()) {
                        // Positive literal is never true, so the whole reason is impossible.
                        // We return NULL to indicate this.
                        return null;
                    } else {
                        // Negated literal is always true, no need to remember it / do anything.
                    }
                } else {
                    final String name = rel.getName().orElse(null);
                    if (RF.equals(name) || CO.equals(name) || executionGraph.getCutRelations().contains(rel)) {
                        simplified.add(lit);
                    } else if (LOC.equals(name)) {
                        simplified.add(new AddressLiteral(e1, e2, lit.isPositive()));
                    } else {
                        final String errorMsg = String.format("Literals of type %s are not supported.", rel);
                        throw new UnsupportedOperationException(errorMsg);
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

    // =============================================================================================
    // ======================================== Symmetry ===========================================
    // =============================================================================================

    // Computes a list of generators for the symmetry group of threads.
    // NOTE We always add the identity as generator, although it is unnecessary.
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
