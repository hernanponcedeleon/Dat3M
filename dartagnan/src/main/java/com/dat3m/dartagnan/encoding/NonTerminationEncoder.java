package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.special.StateSnapshot;
import com.dat3m.dartagnan.program.event.metadata.UnrollingId;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.Iterables;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

/*
    Goal: Find a single execution that exhibits repeatable behaviour based on a decomposition
          into prefix, infix, and (repeatable) suffix.

    Intuition: The suffix consists of all non-terminating loop iterations (i.e., reaching some bound)
               and the infix consists of the preceding iterations. The prefix is the rest.
               If suffix and infix are equivalent, we have seen a single repetition.
               If furthermore the shape of the suffix is "nice", we can conclude that if we can do it once
               we can repeat it as often as we want.

    Approach:
        (1) All executed events are separated into prefix, infix, and suffix
            - Executed code outside of loops are always prefix events.
            - For non-terminating loops, the last iteration has suffix events,
              the second-to-last iteration infix events.
              If a loop iterates only once (e.g. B=1, or due to no side-effect), we have no
              corresponding infix events.
              NOTE: For side-effectful loops, we need to have an infix which means we need to unroll
              the program at least twice.
        (2) Infix and suffix must be equivalent:
            - Events in infix must have an equivalent event in suffix with same value/address
              (TODO: Can maybe be restricted to equivalence on non-dead events)
              (FIXME: Loop unrolling + SCCP can hide local side-effect resulting in wrong equivalence verdicts)
            - rf/co-edges between infix events must have an equivalent edge in the suffix.
            - NOTE: In the special case where we have no infix but a suffix, the only requirement
              is that the local state at the beginning and the end of the suffix match.
              This is always true for side-effect-free loops, the only one's where we do not have an infix!
        (3) Suffix must be strongly fair/consistent:
            - Prefix stores must be co-before suffix stores
            - Only suffix reads can read from suffix stores, prefix/infix reads can not.
            - Suffix reads can only read from infix/suffix or from co-maximal stores in the prefix,
              if they access an address not stored to by infix/suffix.
              Actually, this requirement is just that there are no fr-edges from suffix to prefix,
              but since we might not have encoded fr (lazy solving), we formulate this indirectly.

    ASSUMPTIONS:
      - We assume co/fr-fairness only.
      - We assume that if the suffix is consistent with the infix and co/fr-fair, then it must be "strongly"
        consistent. This may not be true and we could possibly report a liveness violation that is not consistently
        repeatable. Fixing this would require additional checks relative to the memory model, possibly requiring
        encoding of the memory model or native handling in CAAT.

    TODO: We have not considered uninit reads, i.e., reads without rf-edges in the implementation.
          There might be issues if init events are missing.
    TODO 2: We do not consider ControlBarriers at all. The current version is only for loop-based nontermination.
    TODO 3: We do not (yet) consider fairness of weak atomics like StoreExclusive
 */
public class NonTerminationEncoder {

    private final EncodingContext context;
    private final VerificationTask task;

    private final Map<Event, NonterminationCase> bound2Case = new HashMap<>();
    // Order of stack: from inner loop to outer loop (opposite to usual stack)
    private final Map<Event, List<NonterminationCase>> event2Cases = new HashMap<>();

    public NonTerminationEncoder(VerificationTask task, EncodingContext context) {
        this.task = task;
        this.context = context;

        init();
    }

    // ================================================================================================
    // =================================== Preanalysis ================================================
    // ================================================================================================

    private void init() {
        final LoopAnalysis loopAnalysis = LoopAnalysis.newInstance(task.getProgram());
        final Program program = task.getProgram();
        for (Thread thread : program.getThreads()) {
            loopAnalysis.getLoopsOfFunction(thread).forEach(this::analyseLoop);
        }

        computeEventToCaseInformation();

        assert program.getThreadEventsWithAllTags(Tag.NONTERMINATION).stream()
                .allMatch(bound2Case::containsKey);
    }

    private void analyseLoop(LoopAnalysis.LoopInfo loopInfo) {
        assert (loopInfo.isUnrolled());

        final List<LoopAnalysis.LoopIterationInfo> iterations = loopInfo.iterations();
        for (int m = 0; m < iterations.size(); m++) {
            final LoopAnalysis.LoopIterationInfo iter = iterations.get(m);
            final List<Event> body = iter.computeBody();

            // NOTE: If a spin event is inside nested loops, we only want to associate
            //  it to the innermost loop it is contained within. To achieve this,
            //  we assign it to the loop that contains the event while having the smallest body.
            body.stream().filter(e -> e.hasTag(Tag.SPINLOOP)).forEach(spinEvent -> {
                final SpinNontermination c = (SpinNontermination) bound2Case.get(spinEvent);
                if (c == null || c.getSuffixEvents().size() > body.size()) {
                    bound2Case.put(spinEvent, new SpinNontermination(spinEvent, new HashSet<>(body)));
                }
            });

            if (!iter.isLast()) {
                continue;
            }

            // ----------- Find bound event -----------
            final Event lastEvent = body.get(body.size() - 1);
            final Event bound = lastEvent.getSuccessor().getSuccessor();
            if (!(bound instanceof CondJump && bound.hasTag(Tag.BOUND))) {
                // Loop seems fully unrolled
                return;
            }

            // ----------- Non-isomorphic loop iterations (~guaranteed side-effect) -----------
            final List<Event> prevBody = m > 0 ? iterations.get(m - 1).computeBody() : List.of();
            if (prevBody.size() != body.size()) {
                // Has single iteration or has multiple iterations, but they appear not equivalent.
                bound2Case.put(bound, new BoundNontermination(bound, false, HashBiMap.create()));
                return;
            }

            // ----------- Possibly isomorphic loop iterations -----------
            final BiMap<Event, Event> suffix2InfixMap = HashBiMap.create();
            boolean isEquivalent = true;
            for (int i = 0; i < prevBody.size(); i++) {
                final Event infix = prevBody.get(i);
                final Event suffix = body.get(i);
                if (arePossiblyEquivalent(infix, suffix)) {
                    suffix2InfixMap.put(suffix, infix);
                } else {
                    isEquivalent = false;
                    suffix2InfixMap.clear();
                    break;
                }
            }
            bound2Case.put(bound, new BoundNontermination(bound, isEquivalent, suffix2InfixMap));
        }
    }

    private boolean arePossiblyEquivalent(Event e1, Event e2) {
        if (e1.getClass() != e2.getClass()) {
            return false;
        }
        if (!Objects.equals(e1.getMetadata(UnrollingId.class), e2.getMetadata(UnrollingId.class))) {
            return false;
        }
        // TODO: Check that the expressions in the events are identical.

        return true;
    }

    private void computeEventToCaseInformation() {
        for (NonterminationCase c : bound2Case.values()) {
            Iterables.concat(c.getInfixEvents(), c.getSuffixEvents()).forEach(e ->
                    event2Cases.computeIfAbsent(e, key -> new ArrayList<>()).add(c)
            );
        }
        // Sort to form a real stack.
        event2Cases.values().forEach(stack -> stack.sort(Comparator.comparingInt(c -> c.getBound().getGlobalId())));
    }

    // ================================================================================================
    // ====================================== Encoding ================================================
    // ================================================================================================

    public BooleanFormula encodeNontermination() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final BooleanFormula atLeastOneStuckLoop = encodeLoopsAreStuck();
        final BooleanFormula noExceptionalTermination = encodeNoExceptionalTermination();
        final BooleanFormula infixSuffixEquivalence = encodeInfixSuffixEquivalence();
        final BooleanFormula strongSuffixExtension = encodeStrongSuffixExtension();

        return bmgr.and(
                noExceptionalTermination,
                atLeastOneStuckLoop,
                infixSuffixEquivalence,
                strongSuffixExtension
        );
    }

    private BooleanFormula encodeNoExceptionalTermination() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final BooleanFormula noExceptionalTermination = task.getProgram()
                .getThreadEventsWithAllTags(Tag.EXCEPTIONAL_TERMINATION).stream()
                .map(e -> bmgr.not(context.execution(e)))
                .reduce(bmgr.makeTrue(), bmgr::and);
        return noExceptionalTermination;
    }

    private BooleanFormula encodeLoopsAreStuck() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final BooleanFormula atLeastOneNontermination = bound2Case.values().stream()
                .map(this::isNonterminating)
                .reduce(bmgr.makeFalse(), bmgr::or);
        return atLeastOneNontermination;
    }

    // ------------------------------------------------------------------------------------------------
    // Infix-Suffix equivalence encoding

    // Encodes that infix and suffix are equivalent:
    // (1) Events in infix have an equivalent event in the suffix
    // (2) co/rf-edges within the infix have equivalent co/rf-edges in the suffix
    private BooleanFormula encodeInfixSuffixEquivalence() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Iterable<NonterminationCase> possibleCases = bound2Case.values();

        BooleanFormula enc = bmgr.makeTrue();
        for (NonterminationCase c : possibleCases) {
            enc = bmgr.and(enc, bmgr.implication(isNonterminating(c), encodeInfixSuffixEventEquivalence(c)));
        }
        enc = bmgr.and(enc, encodeInfixSuffixRelationEquivalence());

        return enc;
    }

    private BooleanFormula encodeInfixSuffixEventEquivalence(NonterminationCase c) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        if (!(c instanceof BoundNontermination boundCase)) {
            // For spin iterations we have an empty infix, i.e., no events and only local state,
            // but the local state is trivially the same between infix and suffix due to side-effect-freeness
            assert c instanceof SpinNontermination;
            return bmgr.makeTrue();
        }

        if (!boundCase.hasEquivalentInfix()) {
            return bmgr.makeFalse();
        }

        // TODO: Could be reduced to equivalence on the loops input variables (~ live variables).
        //  We could also avoid equivalence on stores, if they are not accessed in the non-termination case.
        return boundCase.suffix2InfixMap.entrySet().stream()
                .map(e -> areEquivalent(e.getKey(), e.getValue()))
                .reduce(bmgr.makeTrue(), bmgr::and);
    }

    private BooleanFormula encodeInfixSuffixRelationEquivalence() {
        final Wmm memoryModel = task.getMemoryModel();
        return context.getBooleanFormulaManager().and(
                encodeInfixSuffixRelationEquivalence(memoryModel.getRelation(CO)),
                encodeInfixSuffixRelationEquivalence(memoryModel.getRelation(RF))
        );
    }

    private BooleanFormula encodeInfixSuffixRelationEquivalence(Relation rel) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EventGraph may = context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(rel).getMaySet();
        final List<BooleanFormula> enc = new ArrayList<>();
        for (Event x : may.getDomain()) {
            if (!isPossiblyInfix(x)) {
                continue;
            }
            final List<BoundNontermination> xCases = event2Cases.get(x).stream()
                    .filter(c -> c instanceof BoundNontermination && c.getInfixEvents().contains(x))
                    .map(BoundNontermination.class::cast).toList();

            for (Event y : may.getOutMap().get(x)) {
                if (!isPossiblyInfix(y)) {
                    continue;
                }
                final List<BoundNontermination> yCases = event2Cases.get(y).stream()
                        .filter(c -> c instanceof BoundNontermination && c.getInfixEvents().contains(y))
                        .map(BoundNontermination.class::cast).toList();

                for (BoundNontermination xCase : xCases) {
                    for (BoundNontermination yCase : yCases) {
                        final Event suffixX = xCase.suffix2InfixMap.inverse().get(x);
                        final Event suffixY = yCase.suffix2InfixMap.inverse().get(y);

                        // TODO: We can optimize by avoiding cases where x and y cannot simultaneously be in the infix
                        //  because, e.g., they come from two different loops of the same thread
                        enc.add(bmgr.implication(
                                bmgr.and(isInInfix(x), isInInfix(y)),
                                bmgr.equivalence(context.edge(rel, x, y), context.edge(rel, suffixX, suffixY))
                        ));
                    }
                }
            }
        }

        return bmgr.and(enc);
    }

    // ------------------------------------------------------------------------------------------------
    // Strong suffix extension encoding

    // (1) Store is not in prefix (i.e. in infix or suffix)
    // OR (2) it is in prefix and no store in infix/suffix accesses the same address
    private BooleanFormula isSuffixReadable(Store store) {
        // For (2): We abuse the following observation: if infix would store to the same address,
        // then there would also be an equivalent suffix store to that address.
        // However, if there is a suffix store to the same address, it must be co-after by suffix requirements.
        // It follows: the prefix store is co-maximal IFF there is no same-address store in infix/suffix.
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return bmgr.or(bmgr.not(isInPrefix(store)), context.lastCoVar(store));
    }

    private BooleanFormula encodeStrongSuffixExtension() {
        final Wmm memoryModel = task.getMemoryModel();
        final RelationAnalysis ra = context.getAnalysisContext().requires(RelationAnalysis.class);
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>();

        // (1) Prefix-stores are co-before suffix stores
        final Relation co = memoryModel.getRelation(CO);
        final EventGraph coMay = ra.getKnowledge(co).getMaySet();
        coMay.apply((x, y) -> {
            if (isPossiblySuffix(y)) {
                enc.add(bmgr.implication(
                        bmgr.and(isInSuffix(y), isInPrefix(x)),
                        bmgr.not(context.edge(co, y, x))
                ));
            }
        });

        final Relation rf = memoryModel.getRelation(RF);
        final EventGraph rfMay = ra.getKnowledge(rf).getMaySet();
        rfMay.apply((w, r) -> {
            // (2) Nobody can read from suffix except suffix itself
            if (isPossiblySuffix(w)) {
                enc.add(bmgr.implication(
                        bmgr.and(isInSuffix(w), context.edge(rf, w, r)),
                        isInSuffix(r)
                ));
            }
            // (3) Suffix can not read from prefix except from co-maximal prefix stores
            if (isPossiblySuffix(r)) {
                enc.add(bmgr.implication(
                        bmgr.and(isInSuffix(r), context.edge(rf, w, r)),
                        isSuffixReadable((Store)w)
                ));
            }
        });

        return bmgr.and(enc);
    }

    // ------------------------------------------------------------------------------------------------------
    // Basic encoding

    private boolean isPossiblySuffix(Event e) {
        final List<NonterminationCase> cases = event2Cases.get(e);
        if (cases == null) {
            return false;
        }
        return cases.stream().anyMatch(c -> c.getSuffixEvents().contains(e));
    }

    private boolean isPossiblyInfix(Event e) {
        final List<NonterminationCase> cases = event2Cases.get(e);
        if (cases == null) {
            return false;
        }
        return cases.stream().anyMatch(c -> c.getInfixEvents().contains(e));
    }

    private boolean isAlwaysPrefix(Event e) {
        final List<NonterminationCase> cases = event2Cases.get(e);
        if (cases == null) {
            return true;
        }
        return cases.stream().noneMatch(c -> c.getSuffixEvents().contains(e) || c.getInfixEvents().contains(e));
    }

    private BooleanFormula isNonterminating(NonterminationCase iter) {
        final CondJump jump = (CondJump) iter.getBound();
        return context.getBooleanFormulaManager().and(
                context.jumpCondition(jump),
                context.execution(iter.getBound())
        );
    }

    private BooleanFormula isInSuffix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (!isPossiblySuffix(e)) {
            return bmgr.makeFalse();
        }
        final List<NonterminationCase> cases = event2Cases.get(e);
        return bmgr.and(context.execution(e),
                cases.stream().filter(c -> c.getSuffixEvents().contains(e))
                        .map(this::isNonterminating)
                        .reduce(bmgr.makeFalse(), bmgr::or)
        );
    }

    private BooleanFormula isInInfix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (!isPossiblyInfix(e)) {
            return bmgr.makeFalse();
        }
        final List<NonterminationCase> cases = event2Cases.get(e);
        return bmgr.and(context.execution(e),
                cases.stream().filter(c -> c.getInfixEvents().contains(e))
                        .map(this::isNonterminating)
                        .reduce(bmgr.makeFalse(), bmgr::or)
        );
    }

    private BooleanFormula isInPrefix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (isAlwaysPrefix(e)) {
            return context.execution(e);
        }
        final List<NonterminationCase> cases = event2Cases.get(e);
        return bmgr.and(context.execution(e),
                cases.stream().map(c -> bmgr.not(isNonterminating(c))).reduce(bmgr.makeTrue(), bmgr::and)
        );
    }

    private BooleanFormula areEquivalent(Event x, Event y) {
        assert x.getClass() == y.getClass();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();

        BooleanFormula equality = bmgr.equivalence(context.execution(x), context.execution(y));
        if (x instanceof Local e && y instanceof Local f) {
            equality = bmgr.and(
                    equality,
                    context.equal(context.result(e), context.result(f))
            );
        }
        if (x instanceof StateSnapshot e && y instanceof StateSnapshot f) {
            if (e.getExpressions().size() != f.getExpressions().size()) {
                equality = bmgr.makeFalse();
            } else {
                for (int i = 0; i < e.getExpressions().size(); i++) {
                    final Expression exprE = e.getExpressions().get(i);
                    final Expression exprF = f.getExpressions().get(i);
                    equality = bmgr.and(
                            equality,
                            context.equal(context.encodeExpressionAt(exprE, e), context.encodeExpressionAt(exprF, f))
                    );
                }
            }
        }
        if (x instanceof MemoryCoreEvent e && y instanceof MemoryCoreEvent f) {
            equality = bmgr.and(
                    equality,
                    context.equal(context.value(e), context.value(f)),
                    context.equal(context.address(e), context.address(f))
            );
        }

        // TODO: Check other types of events as well.
        return equality;
    }


    // ------------------------------------------------------------------------------------------------------
    // Internal classes

    private interface NonterminationCase {
        Event getBound();
        Set<Event> getSuffixEvents();
        Set<Event> getInfixEvents();
    }

    private record BoundNontermination(Event bound,
                                       boolean hasEquivalentInfix,
                                       BiMap<Event, Event> suffix2InfixMap) implements NonterminationCase {
        @Override
        public Event getBound() { return bound; }

        @Override
        public Set<Event> getSuffixEvents() {
            return hasEquivalentInfix ? suffix2InfixMap.keySet() : Set.of();
        }

        @Override
        public Set<Event> getInfixEvents() {
            return hasEquivalentInfix ? suffix2InfixMap.values() : Set.of();
        }

        @Override
        public String toString() {
            return String.format("Bound(bound=%s, isomorphicInfix=%s)", bound, hasEquivalentInfix);
        }
    }

    private record SpinNontermination(Event spinBound, Set<Event> suffixEvents) implements NonterminationCase {
        @Override
        public Event getBound() { return spinBound; }

        @Override
        public Set<Event> getInfixEvents() {
            return Set.of();
        }

        @Override
        public Set<Event> getSuffixEvents() {
            return suffixEvents;
        }

        @Override
        public String toString() {
            return String.format("Spin(bound=%s)", spinBound);
        }
    }


}
