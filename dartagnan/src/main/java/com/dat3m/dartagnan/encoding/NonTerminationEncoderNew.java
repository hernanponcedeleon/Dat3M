package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.special.StateSnapshot;
import com.dat3m.dartagnan.program.event.metadata.UnrollingId;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

/*
    Goal: Find a single execution (fragment) that exhibits fairly repeatable behaviour.
    Such behaviour witnesses the existence of infinite executions (by repeating it indefinitely) and thus a liveness issue.
    The search is based on a decomposition of the execution into prefix, infix, and (repeatable) suffix.

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

    FIXME:
     (1) To detect asymmetric non-termination patterns (L1 runs X times, but L2 runs k*X times), we need to find
         such an asymmetric execution. However, since we unroll all the loops the same amount of times, they won't be asymmetric.
         Potential solution: Allow loops to (spuriously) stop earlier (non-det bound event), so that asymmetry can be achieved
         CAREFUL: Spurious bounds should be avoided when checking for bound reachability
     (2) Cases where all iterations are claimed to be Suffix are not correctly covered: We still need to check
         equivalent local state between beginning of first suffix iteration and end of last suffix iteration.
         (If infixes are non-empty, we do this check automatically as part of infix-suffix-equivalence)
     (3) The requirement for visibility of prefix-stores is incorrect. Furthermore, we are not guaranteeing
         that the co-maximal prefix stores (at least observed one's) are correctly repeated in the cut.
 */
public class NonTerminationEncoderNew {

    private final EncodingContext context;
    private final VerificationTask task;


    private final List<Loop> allLoops = new ArrayList<>();
    private final Map<Event, NonterminationCase> nonterm2Case = new HashMap<>();
    private final Map<LoopAnalysis.LoopIterationInfo, Iteration> iterInfo2Iter = new HashMap<>();
    // Maps an event to all the loop iterations it is contained in (sorted from innermost to outermost loop)
    private final Map<Event, List<Iteration>> event2Iterations = new HashMap<>();


    public NonTerminationEncoderNew(VerificationTask task, EncodingContext context) {
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
                .allMatch(nonterm2Case::containsKey);
    }

    private void analyseLoop(LoopAnalysis.LoopInfo loopInfo) {
        assert (loopInfo.isUnrolled());

        final Loop loop = new Loop(loopInfo);
        allLoops.add(loop);

        for (final LoopAnalysis.LoopIterationInfo iter : loopInfo.iterations()) {
            final List<Event> body = iter.computeBody();

            final Iteration iteration = new Iteration(loop, iter, body);
            iterInfo2Iter.put(iter, iteration);
            body.forEach(e -> event2Iterations.computeIfAbsent(e, key -> new ArrayList<>()).add(iteration));

            // NOTE: If a nontermination event is inside nested loops, we only want to associate
            //  it to the innermost loop it is contained within. To achieve this,
            //  we assign it to the loop that contains the event while having the smallest body.
            // TODO: For now, we expect to only find spinloop nontermination
            body.stream().filter(e -> e.hasTag(Tag.NONTERMINATION) && !e.hasTag(Tag.BOUND)).forEach(nonterm -> {
                final NonterminationCase cNew = nonterm2Case.get(nonterm);
                if (cNew == null || cNew.iteration.body.size() > body.size()) {
                    nonterm2Case.put(nonterm, new NonterminationCase(nonterm, iteration));
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

            nonterm2Case.put(bound, new NonterminationCase(bound, iteration));
        }
    }

    private void computeEventToCaseInformation() {
        // Sort from inner loop to outer loop
        event2Iterations.values().forEach(Collections::reverse);
        nonterm2Case.values().forEach(c -> c.getLoop().nontermCases.add(c));
        allLoops.forEach(loop -> loop.nontermCases.sort(Comparator.comparingInt(c -> c.iteration().getIterationNumber())));
    }

    // ================================================================================================
    // ====================================== Encoding ================================================
    // ================================================================================================

    public BooleanFormula encodeNontermination() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final BooleanFormula nonTerminating = bmgr.and(
                bmgr.or(encodeLoopsAreStuck(), encodeBarrierIsStuck()),
                encodeNoExceptionalTermination()
        );
        final BooleanFormula infixSuffixDecomposition = encodeInfixSuffixDecomposition();
        final BooleanFormula infixSuffixEquivalence = encodeInfixSuffixEquivalence();
        final BooleanFormula strongSuffixExtension = encodeStrongSuffixExtension();

        return bmgr.and(
                nonTerminating,
                infixSuffixDecomposition,
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
        final BooleanFormula atLeastOneNontermination = nonterm2Case.values().stream()
                .map(this::isNonterminating)
                .reduce(bmgr.makeFalse(), bmgr::or);
        return atLeastOneNontermination;
    }

    private BooleanFormula encodeBarrierIsStuck() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return task.getProgram().getThreadEvents(ControlBarrier.class).stream()
                .map(this::isStuckAtBarrier)
                .reduce(bmgr.makeFalse(), bmgr::or);
    }

    private BooleanFormula isStuckAtBarrier(ControlBarrier barrier) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return bmgr.and(context.controlFlow(barrier), bmgr.not(context.execution(barrier)));
    }

    // ------------------------------------------------------------------------------------------------------
    // Static approximations (~ may/must ) for more compact encodings.

    private boolean isPossiblySuffix(Iteration iter) {
        return !iter.loop.isAlwaysTerminating();
    }

    private boolean isPossiblyInfix(Iteration iter) {
        return !iter.loop.isAlwaysTerminating() && !iter.isLast();
    }

    private boolean isAlwaysPrefix(Iteration iter) {
        return iter.loop.isAlwaysTerminating();
    }

    private boolean isPossiblySuffix(Event e) {
        return event2Iterations.getOrDefault(e, List.of()).stream().anyMatch(this::isPossiblySuffix);
    }

    private boolean isPossiblyInfix(Event e) {
        return event2Iterations.getOrDefault(e, List.of()).stream().anyMatch(this::isPossiblyInfix);
    }

    private boolean isAlwaysPrefix(Event e) {
        return event2Iterations.getOrDefault(e, List.of()).stream().allMatch(this::isAlwaysPrefix);
    }

    private boolean arePossiblyEquivalent(Iteration a, Iteration b) {
        // TODO: We should also compare the contained events.
        if (a.loop != b.loop || a.body.size() != b.body.size()) {
            return false;
        }
        return true;
    }

    private boolean arePossiblyInfixSuffixMatching(Iteration a, Iteration b) {
        return arePossiblyEquivalent(a, b) && a.getIterationNumber() < b.getIterationNumber();
    }

    // TODO: Do we need this?
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

    // ------------------------------------------------------------------------------------------------------
    // Basic encoding primitives

    private BooleanFormula isNonterminating(NonterminationCase iter) {
        final CondJump jump = (CondJump) iter.nontermEvent;
        return context.getBooleanFormulaManager().and(
                context.jumpCondition(jump),
                context.execution(iter.nontermEvent)
        );
    }

    private BooleanFormula isInSuffix(Iteration iter) {
        return isInSuffixVar(iter);
    }

    private BooleanFormula isInInfix(Iteration iter) {
        return isInInfixVar(iter);
    }

    private BooleanFormula areInfixSuffixMatching(Iteration a, Iteration b) {
        if (!arePossiblyInfixSuffixMatching(a, b)) {
            return context.getBooleanFormulaManager().makeFalse();
        }
        return areInfixSuffixMatchingVar(a, b);
    }

    private BooleanFormula isInPrefix(Iteration iter) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return bmgr.and(bmgr.not(isInInfix(iter)), bmgr.not(isInSuffix(iter)));
    }

    private BooleanFormula isInSuffix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (!isPossiblySuffix(e)) {
            return bmgr.makeFalse();
        }

        final List<Iteration> cases = event2Iterations.get(e);
        return bmgr.and(context.execution(e),
                cases.stream().map(this::isInSuffix)
                        .reduce(bmgr.makeFalse(), bmgr::or)
        );
    }

    private BooleanFormula isCfInSuffix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (!isPossiblySuffix(e)) {
            return bmgr.makeFalse();
        }

        final List<Iteration> cases = event2Iterations.get(e);
        return bmgr.and(context.controlFlow(e),
                cases.stream().map(this::isInSuffix)
                        .reduce(bmgr.makeFalse(), bmgr::or)
        );
    }

    private BooleanFormula isInInfix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (!isPossiblyInfix(e)) {
            return bmgr.makeFalse();
        }

        final List<Iteration> cases = event2Iterations.get(e);
        return bmgr.and(context.execution(e),
                cases.stream().map(this::isInInfix)
                        .reduce(bmgr.makeFalse(), bmgr::or)
        );
    }

    private BooleanFormula isInPrefix(Event e) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        if (isAlwaysPrefix(e)) {
            return context.execution(e);
        }

        final List<Iteration> cases = event2Iterations.get(e);
        return bmgr.and(context.execution(e),
                cases.stream().map(this::isInPrefix)
                        .reduce(bmgr.makeTrue(), bmgr::and)
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

    // ------------------------------------------------------------------------------------------------
    // Infix-Suffix decomposition encoding

    private BooleanFormula encodeInfixSuffixDecomposition() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> totalEnc = new ArrayList<>();

        final Map<LoopAnalysis.LoopInfo, List<NonterminationCase>> loop2Cases = new HashMap<>();
        for (NonterminationCase c : nonterm2Case.values()) {
            loop2Cases.computeIfAbsent(c.getLoop().loopInfo, key -> new ArrayList<>()).add(c);
        }

        for (LoopAnalysis.LoopInfo loop : loop2Cases.keySet()) {
            final List<Iteration> iters = loop.iterations().stream().map(iterInfo2Iter::get).toList();

            // If an iteration is suffix, then all subsequent ones are as well
            // If an iteration is infix, then the subsequents ones are infix or suffix
            for (int i = 0; i < iters.size() - 1; i++) {
                final Iteration iter = iters.get(i);
                final Iteration next = iters.get(i + 1);
                totalEnc.add(bmgr.implication(isInSuffixVar(iter), isInSuffixVar(next)));
                totalEnc.add(bmgr.implication(isInInfixVar(iter), bmgr.or(isInSuffixVar(next), isInInfixVar(next))));
            }

            // No iteration is both suffix and infix
            for (Iteration iter : iters) {
                totalEnc.add(bmgr.not(bmgr.and(isInSuffixVar(iter), isInInfixVar(iter))));
            }

            final Iteration last = iters.get(iters.size() - 1);;
            final BooleanFormula loopIsNonterminating = loop2Cases.get(loop).stream()
                    .map(this::isNonterminating)
                    .reduce(bmgr.makeFalse(), bmgr::or);
            // Last iteration is never infix ...
            totalEnc.add(bmgr.not(isInInfixVar(last)));
            // ... and only suffix if the loop is non-terminating
            totalEnc.add(bmgr.equivalence(loopIsNonterminating, isInSuffixVar(last)));


            for (NonterminationCase c : loop2Cases.get(loop)) {
                // Non-terminating iteration is always suffix
                totalEnc.add(bmgr.implication(isNonterminating(c), isInSuffixVar(c.iteration)));

                if (c.isSideEffectFree()) {
                    // For side-effect-free iterations, no preceding iteration is infix or suffix.
                    final int iterNumber = c.iteration.loopIterInfo.getIterationNumber();
                    if (iterNumber > 1) {
                        final Iteration prev = c.getLoop().getIterations().get(iterNumber - 1);
                        totalEnc.add(bmgr.implication(isNonterminating(c), bmgr.and(
                                bmgr.not(isInInfixVar(prev)),
                                bmgr.not(isInSuffixVar(prev))
                        )));
                    }
                } else {
                    // TODO: This is theoretically not accurate, but we do some approximations that require this:
                    //  - We use infixes to compare local state because we do not have a state snapshot of the
                    //    local state right before entering the loop.
                    // For side-effectful, we require the existence of some infix in order to check that local state
                    //  repeats
                    final int iterNumber = c.iteration.loopIterInfo.getIterationNumber();
                    final BooleanFormula someInfix = c.getLoop().getIterations().subList(0, iterNumber - 1).stream()
                            .map(this::isInInfix)
                            .reduce(bmgr.makeFalse(), bmgr::or);
                    totalEnc.add(bmgr.implication(isNonterminating(c), someInfix));
                }
            }
        }

        return bmgr.and(totalEnc);
    }

    // ------------------------------------------------------------------------------------------------
    // Infix-Suffix equivalence encoding

    // Encodes that infix and suffix are equivalent:
    //  (1) Events in infix have an equivalent event in the suffix
    //  (2) co/rf-edges within the infix have equivalent co/rf-edges in the suffix
    // NOTE: We rely on a matching relation between iterations of infix and suffix to implement (1) and (2)

    private BooleanFormula encodeInfixSuffixEquivalence() {
        final List<BooleanFormula> totalEnc = new ArrayList<>();
        // Encode matching relation
        for (Loop loop : allLoops) {
            totalEnc.add(encodeInfixSuffixMatchingRelation(loop));
        }
        // Encode actual equivalences
        for (Loop loop : allLoops) {
            totalEnc.add(encodeInfixSuffixEventEquivalence(loop));
        }
        final Wmm memoryModel = task.getMemoryModel();
        totalEnc.add(encodeInfixSuffixRelationEquivalence(memoryModel.getRelation(CO)));
        totalEnc.add(encodeInfixSuffixRelationEquivalence(memoryModel.getRelation(RF)));

        return context.getBooleanFormulaManager().and(totalEnc);
    }

    private BooleanFormula encodeInfixSuffixEventEquivalence(Loop loop) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final ImmutableList<Iteration> iterations = ImmutableList.copyOf(loop.getIterations());

        final List<BooleanFormula> enc = new ArrayList<>();
        for (Iteration inf : iterations) {
            for (Iteration suf : iterations) {
                if (!arePossiblyInfixSuffixMatching(inf, suf)) {
                    continue;
                }

                final List<Event> bodyInfix = inf.body();
                final List<Event> bodySuffix = suf.body();
                assert bodyInfix.size() == bodySuffix.size();

                final List<BooleanFormula> equalities = new ArrayList<>();
                for (int i = 0; i < bodyInfix.size(); i++) {
                    equalities.add(areEquivalent(bodyInfix.get(i), bodySuffix.get(i)));
                }

                final BooleanFormula match = areInfixSuffixMatching(inf, suf);
                enc.add(bmgr.implication(match, bmgr.and(equalities)));
            }
        }

        return bmgr.and(enc);
    }

    private BooleanFormula encodeInfixSuffixRelationEquivalence(Relation rel) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EventGraph may = context.getAnalysisContext().requires(RelationAnalysis.class).getKnowledge(rel).getMaySet();
        final List<BooleanFormula> enc = new ArrayList<>();

        for (Event x : may.getDomain()) {
            if (!isPossiblyInfix(x)) {
                continue;
            }
            final List<Iteration> xIters = event2Iterations.get(x);
            // TODO: isPossiblyInfix(Event) can be specialized to isPossiblyInfix(Event, Iteration/Loop)

            for (Event y : may.getOutMap().get(x)) {
                if (!isPossiblyInfix(y)) {
                    continue;
                }
                final List<Iteration> yIters = event2Iterations.get(y);

                for (Iteration xIter : xIters) {
                    final int xIndex = xIter.body.indexOf(x);
                    for (Iteration xIterSuffix : xIter.loop.getIterations()) {
                        if (!arePossiblyInfixSuffixMatching(xIter, xIterSuffix)) {
                            continue;
                        }
                        for (Iteration yIter : yIters) {
                            final int yIndex = yIter.body.indexOf(y);
                            for (Iteration yIterSuffix : yIter.loop.getIterations()) {
                                if (!arePossiblyInfixSuffixMatching(yIter, yIterSuffix)) {
                                    continue;
                                }
                                final Event suffixX = xIterSuffix.body.get(xIndex);
                                final Event suffixY = yIterSuffix.body.get(yIndex);

                                // TODO: We can optimize by avoiding cases where x and y cannot simultaneously be in the infix
                                //  because, e.g., they come from two different loops of the same thread
                                enc.add(bmgr.implication(
                                        bmgr.and(areInfixSuffixMatching(xIter, xIterSuffix), areInfixSuffixMatching(yIter, yIterSuffix)),
                                        bmgr.equivalence(context.edge(rel, x, y), context.edge(rel, suffixX, suffixY))
                                ));
                            }
                        }
                    }
                }
            }
        }

        return bmgr.and(enc);
    }

    // Encodes the basic properties of the infix-suffix matching relation.
    // The semantics of what a matching actually implies is done by the above methods.
    private BooleanFormula encodeInfixSuffixMatchingRelation(Loop loop) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final ImmutableList<Iteration> iterations = ImmutableList.copyOf(loop.getIterations());

        if (iterations.size() == 1) {
            return bmgr.makeTrue();
        }

        final List<BooleanFormula> totalEnc = new ArrayList<>();
        for (int infixSuffixStartIndex = 1; infixSuffixStartIndex < iterations.size(); infixSuffixStartIndex++) {
            final Iteration firstSuffixIter = iterations.get(infixSuffixStartIndex);
            final Iteration lastInfixIter = iterations.get(infixSuffixStartIndex - 1);

            final BooleanFormula infixSuffixStarts = bmgr.and(
                    isInSuffix(firstSuffixIter),
                    isInInfix(lastInfixIter)
            );

            final List<BooleanFormula> enc = new ArrayList<>();
            for (int i = 1; i <= infixSuffixStartIndex; i++) {
                final Iteration infixIter = iterations.get(infixSuffixStartIndex - i);
                final int matchingSuffixIterIndex = iterations.size() - i;

                if (matchingSuffixIterIndex < infixSuffixStartIndex) {
                    // No possible match, this iteration cannot be in infix
                    enc.add(bmgr.not(isInInfix(infixIter)));
                } else {
                    // This infix iteration must match with corresponding suffix
                    final Iteration suffixIter = iterations.get(matchingSuffixIterIndex);
                    enc.add(bmgr.equivalence(isInInfix(infixIter), areInfixSuffixMatchingVar(infixIter, suffixIter)));
                }

            }

            totalEnc.add(bmgr.implication(infixSuffixStarts, bmgr.and(enc)));
        }

        // TODO: Possibly make explicit which matchings cannot hold anymore?

        return bmgr.and(totalEnc);
    }


    // ------------------------------------------------------------------------------------------------------
    // Strong suffix extension encoding

    // TODO: A necessary condition for correctness is that the prefix memory state (co-last values in prefix) matches
    //  with the memory state of the new prefix obtained by suffix extension + cutting.
    //  Note: This can be relativized to only observed memory state (unobserved memory state is allowed to change)
    //  However, we do not do this check and instead rely on the following:
    //   - If an address is not written to by infix/suffix, then the state on that address won't change
    //   - If infix/suffix write to an address, then we disallow suffix from reading the prefix.
    //     This does not guarantee that the memory state does not change, but it guarantees that it does not matter.

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

        // (4) Events that can spuriously fail must succeed in the suffix (infinite spurious failure is unfair)
        for (RMWStoreExclusive exclStore : task.getProgram().getThreadEvents(RMWStoreExclusive.class)) {
            if (isPossiblySuffix(exclStore)) {
                enc.add(bmgr.implication(isCfInSuffix(exclStore), context.execution(exclStore)));
            }
        }

        return bmgr.and(enc);
    }


    // ------------------------------------------------------------------------------------------------------
    // Helper variables for encoding

    private BooleanFormula isInInfixVar(Iteration iter) {
        return context.getBooleanFormulaManager().makeVariable(iter.getUniqueId() + "_infix");
    }

    private BooleanFormula isInSuffixVar(Iteration iter) {
        return context.getBooleanFormulaManager().makeVariable(iter.getUniqueId() + "_suffix");
    }

    private BooleanFormula areInfixSuffixMatchingVar(Iteration a, Iteration b) {
        final String varName = String.format("match(%s, %s)", a.getUniqueId(), b.getUniqueId());
        return context.getBooleanFormulaManager().makeVariable(varName);
    }

    // ------------------------------------------------------------------------------------------------------
    // Internal classes

    /*
        - A (possibly nonterminating) "Loop" contains a list of "NonterminationCase"s.
        - A "NonterminationCase" is an "Iteration" + a nontermination event (marked by Tag.NONTERMINATION)
        - An "Iteration" is just a loop iteration with a cached body.
     */

    private class Loop {
        private final LoopAnalysis.LoopInfo loopInfo;
        private final List<NonterminationCase> nontermCases = new ArrayList<>();

        public Loop(LoopAnalysis.LoopInfo loopInfo) {
            this.loopInfo = loopInfo;
        }

        public List<Iteration> getIterations() { return Lists.transform(loopInfo.iterations(), iterInfo2Iter::get); }
        public boolean isAlwaysTerminating() { return nontermCases.isEmpty(); }

        @Override
        public String toString() {
            return String.format("%s:%s#L%s@E%s", loopInfo.function().getId(), loopInfo.function().getName(),
                    loopInfo.loopNumber(), loopInfo.iterations().get(0).getIterationStart().getGlobalId());
        }
    }

    private record Iteration(Loop loop, LoopAnalysis.LoopIterationInfo loopIterInfo, List<Event> body) {
        @Override
        public String toString() {
            final Function containingFunc = loopIterInfo.getContainingLoop().function();
            return String.format("Iter#%s@L%s@%s#%s", loopIterInfo.getIterationNumber(), loopIterInfo.getContainingLoop().loopNumber(),
                    containingFunc.getName(), containingFunc.getId());
        }

        public String getUniqueId() { return toString(); }
        public boolean isLast() { return loopIterInfo.isLast(); }
        public int getIterationNumber() { return loopIterInfo().getIterationNumber(); }
    }

    private record NonterminationCase(Event nontermEvent, Iteration iteration) {

        public boolean isSideEffectFree() { return nontermEvent.hasTag(Tag.SPINLOOP); }
        public boolean isLoopBound() { return nontermEvent.hasTag(Tag.BOUND); }

        public Loop getLoop() { return iteration.loop; }

        @Override
        public String toString() {
            return String.format("Nonterm@%s:%s", nontermEvent.getGlobalId(), nontermEvent);
        }
    }




}
