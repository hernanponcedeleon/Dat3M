package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelComposition extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + ";" + r2.getName() + ")";
    }

    public RelComposition(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelComposition(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            BranchEquivalence eq = task.getBranchEquivalence();
            minTupleSet = r1.getMinTupleSet().postComposition(r2.getMinTupleSet(),
                    (t1, t2) -> t1.getSecond().cfImpliesExec() &&
                            (eq.isImplied(t1.getFirst(), t1.getSecond()) || eq.isImplied(t2.getSecond(), t1.getSecond())));
            removeMutuallyExclusiveTuples(minTupleSet);
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = r1.getMaxTupleSet().postComposition(r2.getMaxTupleSet());
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            BranchEquivalence eq = task.getBranchEquivalence();
            minTupleSet = r1.getMinTupleSetRecursive().postComposition(r2.getMinTupleSetRecursive(),
                    (t1, t2) -> t1.getSecond().cfImpliesExec() &&
                            (eq.isImplied(t1.getFirst(), t1.getSecond()) || eq.isImplied(t2.getSecond(), t1.getSecond())));
            removeMutuallyExclusiveTuples(minTupleSet);
			disableTupleSet.addAll(Sets.difference(
					Sets.union(
							r1.getDisableTupleSet().postComposition(r2.getMaxTupleSet()),
							r1.getMaxTupleSet().postComposition(r2.getDisableTupleSet())),
					r1.getMaxTupleSet().postComposition(r2.getMaxTupleSet(),
							(a,b)->!r1.getDisableTupleSet().contains(a)&&!r2.getDisableTupleSet().contains(b))));
            return minTupleSet;
        }
        return getMinTupleSet();
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            BranchEquivalence eq = task.getBranchEquivalence();
            maxTupleSet = r1.getMaxTupleSetRecursive().postComposition(r2.getMaxTupleSetRecursive(),
                    (t1, t2) -> !eq.areMutuallyExclusive(t1.getFirst(), t2.getSecond()));
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

	@Override
	public boolean disable(TupleSet t) {
		super.disable(t);
		if(t.isEmpty())
			return false;
		BranchEquivalence eq = task.getBranchEquivalence();
		TupleSet t1 = new TupleSet();
		TupleSet t2 = new TupleSet();
		for(Tuple tuple : t) {
			Event x = tuple.getFirst();
			Event z = tuple.getSecond();
			if(z.cfImpliesExec())
				r1.getMinTupleSet().getByFirst(x).stream()
				.map(Tuple::getSecond)
				.filter(y -> eq.isImplied(y, z))
				.map(y -> new Tuple(y, z))
				.filter(r2.getMaxTupleSet()::contains)
				.forEach(t2::add);
			if(x.cfImpliesExec())
				r2.getMinTupleSet().getBySecond(z).stream()
				.map(Tuple::getFirst)
				.filter(y -> eq.isImplied(y, x))
				.map(y -> new Tuple(x, y))
				.filter(r2.getMaxTupleSet()::contains)
				.forEach(t1::add);
		}
		boolean b = r1.disable(t1);
		return r2.disable(t2) || b;
	}

	@Override
	public void initEncodeTupleSet() {
		TupleSet set = new TupleSet();
		set.addAll(Sets.difference(disableTupleSet,r1.getMaxTupleSet().postComposition(r2.getMaxTupleSet(),
				(a,b)->r1.getDisableTupleSet().contains(a)||r2.getDisableTupleSet().contains(b))));
		if(!set.isEmpty()) {
			addEncodeTupleSet(set);
		}
	}

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        Set<Tuple> activeSet = new HashSet<>(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);
        activeSet.removeAll(getMinTupleSet());

        if(!activeSet.isEmpty()){
            TupleSet r1Set = new TupleSet();
            TupleSet r2Set = new TupleSet();

            TupleSet r1Max = r1.getMaxTupleSet();
            TupleSet r2Max = r2.getMaxTupleSet();
            for (Tuple t : activeSet) {
                Event e1 = t.getFirst();
                Event e3 = t.getSecond();
                for (Tuple t1 : r1Max.getByFirst(e1)) {
                    Event e2 = t1.getSecond();
                    Tuple t2 = new Tuple(e2, e3);
                    if (r2Max.contains(t2)) {
                        r1Set.add(t1);
                        r2Set.add(t2);
                    }
                }
            }

            r1.addEncodeTupleSet(r1Set);
            r2.addEncodeTupleSet(r2Set);
        }
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        TupleSet r1Set = r1.getEncodeTupleSet();
        TupleSet r2Set = r2.getEncodeTupleSet();
        TupleSet minSet = getMinTupleSet();

        for(Tuple tuple : encodeTupleSet) {
            BooleanFormula expr = bmgr.makeFalse();
            if (minSet.contains(tuple)) {
                expr = getExecPair(tuple, ctx);
            } else {
                for (Tuple t1 : r1Set.getByFirst(tuple.getFirst())) {
                    Tuple t2 = new Tuple(t1.getSecond(), tuple.getSecond());
                    if (r2Set.contains(t2)) {
                        expr = bmgr.or(expr, bmgr.and(r1.getSMTVar(t1, ctx), r2.getSMTVar(t2, ctx)));
                    }
                }
            }

            enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), expr));
        }
        return enc;
    }
}