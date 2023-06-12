package com.dat3m.dartagnan.solver.caat4wmm;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ThreadSymmetry;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.AddressLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.ExecLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Relation;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Function;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_SYMMETRY_LEARNING;

/*
    This class handles the computation of refinement clauses from violations found by the WMM-solver procedure.
    Furthermore, it incorporates symmetry reasoning if possible.
 */
public class Refiner {

    public enum SymmetryLearning { NONE, LINEAR, QUADRATIC, FULL }

    private final ThreadSymmetry symm;
    private final List<Function<Event, Event>> symmPermutations;
    private final SymmetryLearning learningOption;

    public Refiner(Context analysisContext) {
        this.learningOption = REFINEMENT_SYMMETRY_LEARNING;
        symm = analysisContext.requires(ThreadSymmetry.class);
        symmPermutations = computeSymmetryPermutations();
    }


    // This method computes a refinement clause from a set of violations.
    // Furthermore, it computes symmetric violations if symmetry learning is enabled.
    public BooleanFormula refine(DNF<CoreLiteral> coreReasons, EncodingContext context) {
        //TODO: A specialized algorithm that computes the orbit under permutation may be better,
        // since most violations involve only few threads and hence the orbit is far smaller than the full
        // set of permutations.
        HashSet<BooleanFormula> addedFormulas = new HashSet<>(); // To avoid adding duplicates
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> refinement = new ArrayList<>();
        // For each symmetry permutation, we will create refinement clauses
        for (Function<Event, Event> perm : symmPermutations) {
            for (Conjunction<CoreLiteral> reason : coreReasons.getCubes()) {
                BooleanFormula permutedClause = bmgr.makeFalse();
                for (CoreLiteral lit : reason.getLiterals()) {
                    BooleanFormula litFormula = permuteAndConvert(lit, perm, context);
                    if (bmgr.isFalse(litFormula)) {
                        permutedClause = bmgr.makeTrue();
                        break;
                    } else {
                       permutedClause = bmgr.or(permutedClause, bmgr.not(litFormula));
                    }
                }
                if (addedFormulas.add(permutedClause)) {
                    refinement.add(permutedClause);
                }
            }
        }
        return bmgr.and(refinement);
    }

    // Computes a list of permutations allowed by the program.
    // Depending on the <learningOption>, the set of computed permutations differs.
    // In particular, for the option NONE, only the identity permutation will be returned.
    private List<Function<Event, Event>> computeSymmetryPermutations() {
        Set<? extends EquivalenceClass<Thread>> symmClasses = symm.getNonTrivialClasses();
        List<Function<Event, Event>> perms = new ArrayList<>();
        perms.add(Function.identity());

        for (EquivalenceClass<Thread> c : symmClasses) {
            List<Thread> threads = new ArrayList<>(c);
            threads.sort(Comparator.comparingInt(Thread::getId));

            switch (learningOption) {
                case NONE:
                    break;
                case LINEAR:
                    for (int i = 0; i < threads.size(); i++) {
                        int j = (i + 1) % threads.size();
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
                    List<Function<Event, Event>> allPerms = symm.createAllEventPermutations(c);
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


    // Changes a reasoning <literal> based on a given permutation <perm> and translates the result
    // into a BooleanFormula for Refinement.
    private BooleanFormula permuteAndConvert(CoreLiteral literal, Function<Event, Event> perm, EncodingContext encoder) {
        BooleanFormulaManager bmgr = encoder.getBooleanFormulaManager();
        BooleanFormula enc;
        if (literal instanceof ExecLiteral lit) {
            enc = encoder.execution(perm.apply(lit.getData()));
        } else if (literal instanceof AddressLiteral loc) {
            MemoryCoreEvent e1 = (MemoryCoreEvent) perm.apply(loc.getFirst());
            MemoryCoreEvent e2 = (MemoryCoreEvent) perm.apply(loc.getSecond());
            enc = encoder.sameAddress(e1, e2);
        } else if (literal instanceof RelLiteral lit) {
            Relation rel = encoder.getTask().getMemoryModel().getRelation(lit.getName());
            enc = encoder.edge(rel,
                    perm.apply(lit.getData().getFirst()),
                    perm.apply(lit.getData().getSecond()));
        } else {
            throw new IllegalArgumentException("CoreLiteral " + literal.toString() + " is not supported");
        }

        return literal.isNegative() ? bmgr.not(enc) : enc;
    }

}
