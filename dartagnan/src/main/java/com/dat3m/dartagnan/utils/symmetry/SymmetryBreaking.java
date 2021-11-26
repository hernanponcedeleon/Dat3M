package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.equivalence.EquivalenceClass;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Function;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;


// A first rough implementation for symmetry breaking
@Options
public class SymmetryBreaking {

	public static final String OPTION_SYMMETRY_BREAKING = "encoding.enableSymmetryBreaking";

    private static final int LEX_LEADER_SIZE = 1000;

    private final ThreadSymmetry symm;
    private final Relation rf;

	@Option(name=OPTION_SYMMETRY_BREAKING,
		description="Adds a symmetry breaking formula to the encoding. "
			+ "This is unsound if the program contains assertions that distinguish symmetric threads.",
		secure=true)
	private boolean enable = false;

    public SymmetryBreaking(VerificationTask task) throws InvalidConfigurationException {
        this.symm = task.getThreadSymmetry();
        this.rf = task.getMemoryModel().getRelationRepository().getRelation(RF);
		task.getConfig().inject(this);
    }

    public BooleanFormula encode(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
		if(!enable) {
			return enc;
		}
        for (EquivalenceClass<Thread> symmClass : symm.getNonTrivialClasses()) {
            enc = bmgr.and(enc, encode(symmClass, ctx));
        }
        return enc;
    }

    public BooleanFormula encode(EquivalenceClass<Thread> symmClass, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula enc = bmgr.makeTrue();
        if (symmClass.getEquivalence() != symm) {
            return enc;
        }

        Thread rep = symmClass.getRepresentative();
        List<Thread> symmThreads = new ArrayList<>(symmClass);
        symmThreads.sort(Comparator.comparingInt(Thread::getId));


        // ===== Construct row =====
        //IMPORTANT: Each thread writes to its own special location for the purpose of starting/terminating threads
        // These need to get skipped!
        Thread t1 = symmThreads.get(0);
        List<Tuple> r1 = new ArrayList<>();
        for (Tuple t : rf.getMaxTupleSet()) {
            Event a = t.getFirst();
            Event b = t.getSecond();
            if (!a.is(EType.PTHREAD) && !b.is(EType.PTHREAD) && a.getThread() == t1) {
                r1.add(t);
            }
        }
        r1.sort(Comparator.naturalOrder());

        // Construct symmetric rows
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createTransposition(t1, t2);
            List<Tuple> r2 = new ArrayList<>();
            for (Tuple t : r1) {
                r2.add(mapTuple(t, p));
                // assert rf.getMaxTupleSet().contains(r2.get(r2.size() - 1));
            }


            enc = bmgr.and(enc, encodeLexLeader(rep, i, r1, r2, ctx));
            t1 = t2;
            r1 = r2;
        }

        return enc;
    }

    /*
    Used variables:
    - y0, ..., y(n-1)
    - x1, ..., xn
    with a suffix for the involved symmetry class.
     */
    private BooleanFormula encodeLexLeader(Thread rep, int index, List<Tuple> r1, List<Tuple> r2, SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        int size = Math.min(r1.size(), LEX_LEADER_SIZE);
        String suffix = "_" + rep.getId() + "_" + index;
        BooleanFormula ylast = bmgr.makeVariable("y0" + suffix);
        BooleanFormula enc = bmgr.equivalence(ylast, bmgr.makeTrue());
        // From x1 to x(n-1)
        for (int i = 1; i < size; i++) {
            BooleanFormula y = bmgr.makeVariable("y" + i + suffix);
            BooleanFormula orig = rf.getSMTVar(r1.get(i-1), ctx);
            BooleanFormula perm = rf.getSMTVar(r2.get(i-1), ctx);
            enc = bmgr.and(
                    enc,
                    bmgr.or(y, bmgr.not(ylast), bmgr.not(orig)),
                    bmgr.or(y, bmgr.not(ylast), perm),
                    bmgr.or(bmgr.not(ylast), bmgr.not(orig), perm)
            );
            ylast = y;
        }
        // Final iteration is handled differently
        BooleanFormula orig = rf.getSMTVar(r1.get(size-1), ctx);
        BooleanFormula perm = rf.getSMTVar(r2.get(size-1), ctx);
        enc = bmgr.and(enc, bmgr.or(bmgr.not(ylast), bmgr.not(orig), perm));


        return enc;
    }

    private Tuple mapTuple(Tuple t, Function<Event, Event> p) {
        return new Tuple(p.apply(t.getFirst()), p.apply(t.getSecond()));
    }
}
