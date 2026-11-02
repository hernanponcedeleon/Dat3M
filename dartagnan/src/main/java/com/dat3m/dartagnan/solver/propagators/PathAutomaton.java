package com.dat3m.dartagnan.solver.propagators;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.TransitiveClosure;
import com.dat3m.dartagnan.wmm.definition.Union;

import java.util.*;

/*
    A deterministic finite automaton describing the "path shape" of an axiom irreflexive(R) / acyclic(R)
    as a regular language over "atomic" relations (the alphabet).

    The relation R is unfolded through the regular operators ';', '|' and '+' (acyclic(R) is treated as
    irreflexive(R+)). Any other relation (base relations, intersections, differences, inverses, set identities,
    recursively defined relations, ...) becomes an atom/letter. Atoms are encoded as usual, whereas the
    propagator takes care of the composition, union, and closure.
    If the resulting automaton exceeds the maximal number of states, we reduce the unfolding depth
    (i.e., we treat larger subterms as atoms) until it fits.

    irreflexive(R) is violated iff there is an event x and a path from (x, initial) to (x, f) in the
    product of the execution graph (edges labelled by atoms) and this automaton, for some final state f.

    NOTE: Since every letter is a (non-reflexive by construction) atom, the language never contains the
    empty word. In particular, "r?" (= r | id) uses the "id" relation as an ordinary letter whose edges
    are the (conditional) self-loops (x, x).
 */
public final class PathAutomaton {

    private static final int[] NO_STATES = new int[0];

    private final Axiom axiom;
    private final List<Relation> alphabet;
    private final int numStates;
    private final int initialState;
    private final boolean[] isFinal;
    private final int[][][] successors;   // [state][letter] -> states
    private final int[][][] predecessors; // [state][letter] -> states

    private PathAutomaton(Axiom axiom, List<Relation> alphabet, int numStates, int initialState, boolean[] isFinal,
                          int[][] transitions) {
        this.axiom = axiom;
        this.alphabet = alphabet;
        this.numStates = numStates;
        this.initialState = initialState;
        this.isFinal = isFinal;

        final int numLetters = alphabet.size();
        final List<List<Integer>>[] succ = newTable(numStates, numLetters);
        final List<List<Integer>>[] pred = newTable(numStates, numLetters);
        for (int[] t : transitions) {
            succ[t[0]].get(t[1]).add(t[2]);
            pred[t[2]].get(t[1]).add(t[0]);
        }
        this.successors = toArray(succ);
        this.predecessors = toArray(pred);
    }

    public Axiom getAxiom() { return axiom; }
    public List<Relation> getAlphabet() { return alphabet; }
    public int getNumStates() { return numStates; }
    public int getInitialState() { return initialState; }
    public boolean isFinal(int state) { return isFinal[state]; }
    public int[] getSuccessors(int state, int letter) { return successors[state][letter]; }
    public int[] getPredecessors(int state, int letter) { return predecessors[state][letter]; }

    // ======================================== Construction ========================================

    // Returns the minimal DFA for the path shape of <axiom> with maximal unfolding depth such that the automaton
    // has at most <maxStates> states.
    // Returns empty if the axiom is not supported or if there is nothing to gain over the standard encoding
    // (an irreflexivity axiom whose relation cannot be unfolded).
    public static Optional<PathAutomaton> fromAxiom(Axiom axiom, int maxStates) {
        return fromAxiom(axiom, maxStates, Integer.MAX_VALUE);
    }

    public static Optional<PathAutomaton> fromAxiom(Axiom axiom, int maxStates, int maxUnfoldingDepth) {
        if (axiom.isFlagged() || axiom.isNegated()
                || !(axiom instanceof Acyclicity || axiom instanceof Irreflexivity)) {
            return Optional.empty();
        }
        // Unfolding depth 0 yields 2 states, so we always find an automaton for acyclicity axioms.
        int depth = maxUnfoldingDepth;
        while (depth >= 0) {
            final NfaBuilder nfa = new NfaBuilder(maxStates * 16, depth);
            try {
                final int[] fragment = axiom instanceof Acyclicity
                        ? nfa.buildPlus(nfa.build(axiom.getRelation(), 0))
                        : nfa.build(axiom.getRelation(), 0);
                if (axiom instanceof Irreflexivity && nfa.maxUsedDepth < 0) {
                    return Optional.empty();
                }
                final Optional<PathAutomaton> aut = determinizeAndMinimize(axiom, nfa, fragment[0], fragment[1], maxStates);
                if (aut.isPresent()) {
                    return aut;
                }
            } catch (TooLargeException e) {
                // Retry with smaller depth
            }
            depth = Math.min(depth, nfa.maxUsedDepth + 1) - 1;
        }
        return Optional.empty();
    }

    // We unfold all non-recursive relations defined by union, composition, or transitive closure.
    private static boolean isUnfoldable(Relation rel) {
        final Definition def = rel.getDefinition();
        return !rel.isRecursive()
                && (def instanceof Union || def instanceof Composition || def instanceof TransitiveClosure);
    }

    private static final class TooLargeException extends Exception {
        TooLargeException() { super(null, null, false, false); }
    }

    // Thompson construction (with epsilon transitions)
    private static final class NfaBuilder {
        private final int maxStates;
        private final int maxDepth;
        private int maxUsedDepth = -1; // Deepest level at which we unfolded a relation
        private final List<Relation> alphabet = new ArrayList<>();
        private final Map<Relation, Integer> letterIds = new HashMap<>();
        private final List<List<int[]>> transitions = new ArrayList<>(); // state -> [(letter, target)]
        private final List<List<Integer>> epsilons = new ArrayList<>();

        NfaBuilder(int maxStates, int maxDepth) {
            this.maxStates = maxStates;
            this.maxDepth = maxDepth;
        }

        int newState() throws TooLargeException {
            if (transitions.size() >= maxStates) {
                throw new TooLargeException();
            }
            transitions.add(new ArrayList<>());
            epsilons.add(new ArrayList<>());
            return transitions.size() - 1;
        }

        // Returns {start, end} of the fragment for <rel>, which occurs at unfolding depth <depth>.
        int[] build(Relation rel, int depth) throws TooLargeException {
            if (depth >= maxDepth || !isUnfoldable(rel)) {
                final int letter = letterIds.computeIfAbsent(rel, r -> {
                    alphabet.add(r);
                    return alphabet.size() - 1;
                });
                final int s = newState();
                final int t = newState();
                transitions.get(s).add(new int[] { letter, t });
                return new int[] { s, t };
            }
            maxUsedDepth = Math.max(maxUsedDepth, depth);
            final Definition def = rel.getDefinition();
            if (def instanceof Union union) {
                final int s = newState();
                final int t = newState();
                for (Relation op : union.getOperands()) {
                    final int[] f = build(op, depth + 1);
                    epsilons.get(s).add(f[0]);
                    epsilons.get(f[1]).add(t);
                }
                return new int[] { s, t };
            } else if (def instanceof Composition comp) {
                final int[] f1 = build(comp.getLeftOperand(), depth + 1);
                final int[] f2 = build(comp.getRightOperand(), depth + 1);
                epsilons.get(f1[1]).add(f2[0]);
                return new int[] { f1[0], f2[1] };
            } else if (def instanceof TransitiveClosure closure) {
                return buildPlus(build(closure.getOperand(), depth + 1));
            }
            throw new IllegalStateException("Unexpected definition " + def);
        }

        int[] buildPlus(int[] f) throws TooLargeException {
            final int s = newState();
            final int t = newState();
            epsilons.get(s).add(f[0]);
            epsilons.get(f[1]).add(t);
            epsilons.get(f[1]).add(f[0]);
            return new int[] { s, t };
        }

        BitSet closure(BitSet states) {
            final BitSet result = (BitSet) states.clone();
            final Deque<Integer> stack = new ArrayDeque<>();
            states.stream().forEach(stack::push);
            while (!stack.isEmpty()) {
                for (int next : epsilons.get(stack.pop())) {
                    if (!result.get(next)) {
                        result.set(next);
                        stack.push(next);
                    }
                }
            }
            return result;
        }
    }

    private static Optional<PathAutomaton> determinizeAndMinimize(Axiom axiom, NfaBuilder nfa, int start, int end,
                                                                  int maxStates) {
        final int numLetters = nfa.alphabet.size();

        // ---- Subset construction ----
        final List<BitSet> dfaStates = new ArrayList<>();
        final Map<BitSet, Integer> dfaStateIds = new HashMap<>();
        final List<int[]> dfaTransitions = new ArrayList<>();
        final BitSet init = new BitSet();
        init.set(start);
        final BitSet initClosure = nfa.closure(init);
        dfaStates.add(initClosure);
        dfaStateIds.put(initClosure, 0);
        for (int i = 0; i < dfaStates.size(); i++) {
            final BitSet cur = dfaStates.get(i);
            for (int letter = 0; letter < numLetters; letter++) {
                final BitSet next = new BitSet();
                for (int q = cur.nextSetBit(0); q >= 0; q = cur.nextSetBit(q + 1)) {
                    for (int[] t : nfa.transitions.get(q)) {
                        if (t[0] == letter) {
                            next.set(t[1]);
                        }
                    }
                }
                if (next.isEmpty()) {
                    continue;
                }
                final BitSet nextClosure = nfa.closure(next);
                Integer id = dfaStateIds.get(nextClosure);
                if (id == null) {
                    if (dfaStates.size() >= maxStates * 4) {
                        return Optional.empty();
                    }
                    id = dfaStates.size();
                    dfaStates.add(nextClosure);
                    dfaStateIds.put(nextClosure, id);
                }
                dfaTransitions.add(new int[] { i, letter, id });
            }
        }

        final int n = dfaStates.size();
        final boolean[] dfaFinal = new boolean[n];
        for (int i = 0; i < n; i++) {
            dfaFinal[i] = dfaStates.get(i).get(end);
        }
        final int[][] delta = new int[n][numLetters];
        for (int[] row : delta) {
            Arrays.fill(row, -1);
        }
        dfaTransitions.forEach(t -> delta[t[0]][t[1]] = t[2]);

        // ---- Moore minimization (all states are reachable; every state can reach the final state) ----
        int[] block = new int[n];
        for (int i = 0; i < n; i++) {
            block[i] = dfaFinal[i] ? 1 : 0;
        }
        int numBlocks;
        while (true) {
            final Map<List<Integer>, Integer> signatures = new HashMap<>();
            final int[] newBlock = new int[n];
            for (int i = 0; i < n; i++) {
                final List<Integer> sig = new ArrayList<>(numLetters + 1);
                sig.add(block[i]);
                for (int letter = 0; letter < numLetters; letter++) {
                    sig.add(delta[i][letter] < 0 ? -1 : block[delta[i][letter]]);
                }
                newBlock[i] = signatures.computeIfAbsent(sig, k -> signatures.size());
            }
            final boolean stable = signatures.size() == countDistinct(block);
            block = newBlock;
            numBlocks = signatures.size();
            if (stable) {
                break;
            }
        }
        if (numBlocks > maxStates) {
            return Optional.empty();
        }

        final boolean[] minFinal = new boolean[numBlocks];
        final Set<List<Integer>> minTransitions = new LinkedHashSet<>();
        for (int i = 0; i < n; i++) {
            minFinal[block[i]] |= dfaFinal[i];
            for (int letter = 0; letter < numLetters; letter++) {
                if (delta[i][letter] >= 0) {
                    minTransitions.add(List.of(block[i], letter, block[delta[i][letter]]));
                }
            }
        }
        final int[][] transitions = minTransitions.stream()
                .map(t -> new int[] { t.get(0), t.get(1), t.get(2) })
                .toArray(int[][]::new);
        assert !minFinal[block[0]] : "Path shapes never accept the empty word";
        return Optional.of(new PathAutomaton(axiom, List.copyOf(nfa.alphabet), numBlocks, block[0], minFinal, transitions));
    }

    private static int countDistinct(int[] values) {
        return (int) Arrays.stream(values).distinct().count();
    }

    @SuppressWarnings("unchecked")
    private static List<List<Integer>>[] newTable(int numStates, int numLetters) {
        final List<List<Integer>>[] table = new List[numStates];
        for (int i = 0; i < numStates; i++) {
            table[i] = new ArrayList<>(numLetters);
            for (int l = 0; l < numLetters; l++) {
                table[i].add(new ArrayList<>(1));
            }
        }
        return table;
    }

    private static int[][][] toArray(List<List<Integer>>[] table) {
        final int[][][] result = new int[table.length][][];
        for (int i = 0; i < table.length; i++) {
            result[i] = table[i].stream()
                    .map(l -> l.isEmpty() ? NO_STATES : l.stream().mapToInt(Integer::intValue).toArray())
                    .toArray(int[][]::new);
        }
        return result;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder();
        sb.append("PathAutomaton[").append(axiom).append("]: ").append(numStates).append(" states, init=")
                .append(initialState).append(", final={");
        final StringJoiner finals = new StringJoiner(",");
        for (int q = 0; q < numStates; q++) {
            if (isFinal[q]) {
                finals.add(String.valueOf(q));
            }
        }
        sb.append(finals).append("}, transitions={");
        final StringJoiner trans = new StringJoiner(", ");
        for (int q = 0; q < numStates; q++) {
            for (int l = 0; l < alphabet.size(); l++) {
                for (int t : successors[q][l]) {
                    trans.add(q + " -" + alphabet.get(l).getNameOrTerm() + "-> " + t);
                }
            }
        }
        return sb.append(trans).append("}").toString();
    }
}
