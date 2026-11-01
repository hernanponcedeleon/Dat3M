package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.ID;

/*
    Removes transitive closures that are semantically redundant. All rewrites are exact.

    (1) Closures of transitive relations:  R+ = R  if R is (syntactically) transitive.
        R is considered transitive if it is
          - a transitive closure or program order,
          - an intersection of transitive relations,
          - a composition A;B* or A;B+ (or B*;A, B+;A) where A ⊆ B+ follows syntactically,
            because then (A;B*);(A;B*) ⊆ A;B*;B+;B* ⊆ A;B*.
        Example (Power): propbase = (fence | rfe;fence);hb* with hb = ppo | fence | rfe,
        hence propbase* = propbase?.

    (2) Closures inside acyclicity/irreflexivity axioms:
          acyclic(R+)              <=>  acyclic(R)
          acyclic(A | R+)          <=>  acyclic(A | R)
          irreflexive(R+)          <=>  acyclic(R)
        Together with EliminateRecursion, this turns e.g.
          let rec X = F | X;X   irreflexive X
        into
          acyclic F
 */
public class SimplifyClosures implements WmmProcessor {

    private static final Logger logger = LoggerFactory.getLogger(SimplifyClosures.class);

    private SimplifyClosures() { }

    public static SimplifyClosures newInstance() {
        return new SimplifyClosures();
    }

    @Override
    public void run(Wmm wmm) {
        removeClosuresOfTransitiveRelations(wmm);
        simplifyAxioms(wmm);
    }

    // ============================================================================================
    // (1) R+ = R for transitive R

    private void removeClosuresOfTransitiveRelations(Wmm wmm) {
        for (Relation r : List.copyOf(wmm.getRelations())) {
            if (r.getDefinition() instanceof TransitiveClosure tc && isTransitive(tc.getOperand(), new HashSet<>())) {
                final Relation operand = tc.getOperand();
                logger.info("Removing closure of transitive relation {}", operand.getNameOrTerm());
                wmm.removeDefinition(r);
                wmm.addDefinition(new Union(r, operand));
            }
        }
    }

    private static boolean isTransitive(Relation r, Set<Relation> visited) {
        if (!visited.add(r)) {
            return false;
        }
        final Definition def = r.getDefinition();
        if (def instanceof TransitiveClosure || def instanceof ProgramOrder) {
            return true;
        }
        if (def instanceof Union u && u.getOperands().size() == 1) {
            return isTransitive(u.getOperands().getFirst(), visited);
        }
        if (def instanceof Intersection i) {
            return i.getOperands().stream().allMatch(o -> isTransitive(o, new HashSet<>(visited)));
        }
        if (def instanceof Composition c) {
            final Relation left = c.getLeftOperand();
            final Relation right = c.getRightOperand();
            final Relation rightBase = closureBase(right);
            if (rightBase != null && isSubsetOfClosure(left, rightBase, new HashSet<>())) {
                return true;
            }
            final Relation leftBase = closureBase(left);
            return leftBase != null && isSubsetOfClosure(right, leftBase, new HashSet<>());
        }
        return false;
    }

    // Returns B if r is B+ or B* (= B+ | id), otherwise null.
    private static Relation closureBase(Relation r) {
        final Definition def = r.getDefinition();
        if (def instanceof TransitiveClosure tc) {
            return tc.getOperand();
        }
        if (def instanceof Union u) {
            final List<Relation> ops = u.getOperands();
            if (ops.size() == 1) {
                return closureBase(ops.getFirst());
            }
            if (ops.size() == 2) {
                for (int i = 0; i < 2; i++) {
                    if (ops.get(1 - i).hasName(ID) && ops.get(i).getDefinition() instanceof TransitiveClosure tc) {
                        return tc.getOperand();
                    }
                }
            }
        }
        return null;
    }

    // Sound (incomplete) syntactic check for a ⊆ b+.
    private static boolean isSubsetOfClosure(Relation a, Relation b, Set<Relation> visited) {
        if (unionLeaves(b).contains(a)) {
            return true;
        }
        if (!visited.add(a)) {
            return false;
        }
        final Definition def = a.getDefinition();
        if (def instanceof Union u) {
            return u.getOperands().stream().allMatch(o -> isSubsetOfClosure(o, b, visited));
        }
        if (def instanceof Composition c) {
            return isSubsetOfClosure(c.getLeftOperand(), b, visited)
                    && isSubsetOfClosure(c.getRightOperand(), b, visited);
        }
        if (def instanceof TransitiveClosure tc) {
            return isSubsetOfClosure(tc.getOperand(), b, visited);
        }
        if (def instanceof Intersection i) {
            return i.getOperands().stream().anyMatch(o -> isSubsetOfClosure(o, b, visited));
        }
        if (def instanceof Difference d) {
            return isSubsetOfClosure(d.getMinuend(), b, visited);
        }
        return false;
    }

    // b together with all (transitive) operands of unions defining b.
    private static Set<Relation> unionLeaves(Relation b) {
        final Set<Relation> leaves = new HashSet<>();
        final Deque<Relation> stack = new ArrayDeque<>(List.of(b));
        while (!stack.isEmpty()) {
            final Relation r = stack.pop();
            if (leaves.add(r) && r.getDefinition() instanceof Union u) {
                stack.addAll(u.getOperands());
            }
        }
        return leaves;
    }

    // ============================================================================================
    // (2) Closures inside acyclicity / irreflexivity

    private void simplifyAxioms(Wmm wmm) {
        for (Axiom axiom : List.copyOf(wmm.getAxioms())) {
            final Relation rel = axiom.getRelation();
            final Axiom replacement;
            if (axiom instanceof Acyclicity) {
                final Relation generator = acyclicityGenerator(wmm, rel);
                replacement = generator == rel ? null
                        : new Acyclicity(generator, axiom.isNegated(), axiom.isFlagged());
            } else if (axiom instanceof Irreflexivity && unwrap(rel).getDefinition() instanceof TransitiveClosure tc) {
                replacement = new Acyclicity(acyclicityGenerator(wmm, tc.getOperand()),
                        axiom.isNegated(), axiom.isFlagged());
            } else {
                replacement = null;
            }
            if (replacement != null) {
                logger.info("Replacing axiom {} by {}", axiom, replacement);
                replacement.setName(axiom.getName());
                replacement.copyAllMetadataFrom(axiom);
                wmm.removeConstraint(axiom);
                wmm.addConstraint(replacement);
            }
        }
    }

    // Returns a relation G such that acyclic(r) <=> acyclic(G), dropping closures where possible.
    private static Relation acyclicityGenerator(Wmm wmm, Relation r) {
        final Relation u = unwrap(r);
        final Definition def = u.getDefinition();
        if (def instanceof TransitiveClosure tc) {
            return acyclicityGenerator(wmm, tc.getOperand());
        }
        if (def instanceof Union union) {
            boolean changed = false;
            final List<Relation> ops = new ArrayList<>();
            for (Relation o : union.getOperands()) {
                final Relation g = acyclicityGenerator(wmm, o);
                changed |= g != o;
                ops.add(g);
            }
            if (changed) {
                return wmm.addDefinition(new Union(wmm.newRelation(), ops.toArray(Relation[]::new)));
            }
        }
        return r;
    }

    // Looks through single-operand unions.
    private static Relation unwrap(Relation r) {
        Relation cur = r;
        while (cur.getDefinition() instanceof Union u && u.getOperands().size() == 1) {
            cur = u.getOperands().getFirst();
        }
        return cur;
    }
}
