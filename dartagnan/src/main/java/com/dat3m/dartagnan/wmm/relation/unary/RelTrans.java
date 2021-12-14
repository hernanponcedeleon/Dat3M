package com.dat3m.dartagnan.wmm.relation.unary;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.collect.Sets;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.util.LinkedList;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelTrans extends UnaryRelation {

    Map<Event, Set<Event>> transitiveReachabilityMap;
    private TupleSet fullEncodeTupleSet;

    public static String makeTerm(Relation r1){
        return r1.getName() + "^+";
    }

    public RelTrans(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTrans(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx){
        super.initialise(task, ctx);
        fullEncodeTupleSet = new TupleSet();
        transitiveReachabilityMap = null;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            transitiveReachabilityMap = r1.getMaxTupleSet().transMap();
            maxTupleSet = new TupleSet();
            for(Event e1 : transitiveReachabilityMap.keySet()){
                for(Event e2 : transitiveReachabilityMap.get(e1)){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
        }
        return maxTupleSet;
    }

	@Override
	public void fetchMinTupleSet() {
		r1.fetchMinTupleSet();
		minTupleSet.addAll(r1.getMinTupleSet());
		//TODO: Make sure this is correct and efficient
		BranchEquivalence eq = task.getBranchEquivalence();
		boolean changed;
		int size = minTupleSet.size();
		do {
			minTupleSet.addAll(minTupleSet.postComposition(r1.getMinTupleSet(),
				(t1, t2) -> t1.getSecond().cfImpliesExec() &&
					(eq.isImplied(t1.getFirst(), t1.getSecond()) || eq.isImplied(t2.getSecond(), t1.getSecond()))));
			changed = minTupleSet.size() != size;
			size = minTupleSet.size();
		} while (changed);
		removeMutuallyExclusiveTuples(minTupleSet);
	}

	@Override
	public boolean disable(TupleSet t) {
		super.disable(t);
		if(t.isEmpty()) {
			return false;
		}
		BranchEquivalence eq = task.getBranchEquivalence();
		TupleSet t1 = new TupleSet(t);
		LinkedList<Tuple> q = new LinkedList<>(t);
		while(!q.isEmpty()) {
			Tuple tuple = q.remove();
			Event x = tuple.getFirst();
			Event z = tuple.getSecond();
			if(x.cfImpliesExec()) {
				//disable (y,z) that imply t
				r1.getMinTupleSet().getByFirst(x).stream()
				.map(Tuple::getSecond)
				.filter(eq.isImplied(z, x) ? y -> true : y -> eq.isImplied(y, x))
				.map(y -> new Tuple(y, z))
				.filter(r1.getMaxTupleSet()::contains)
				.filter(t1::add)
				.forEach(q::add);
			}
			if(z.cfImpliesExec()) {
				//disable (x,y) that imply t
				r1.getMinTupleSet().getBySecond(z).stream()
				.map(Tuple::getFirst)
				.filter(eq.isImplied(x, z) ? y -> true : y -> eq.isImplied(y, z))
				.map(y -> new Tuple(x, y))
				.filter(r1.getMaxTupleSet()::contains)
				.filter(t1::add)
				.forEach(q::add);
			}
		}
		return r1.disable(t1);
	}

	@Override
	public void initEncodeTupleSet() {
		//TODO filter tuples with remaining support
		if(!disableTupleSet.isEmpty()) {
			addEncodeTupleSet(disableTupleSet);
		}
	}

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        TupleSet activeSet = new TupleSet(Sets.intersection(Sets.difference(tuples, encodeTupleSet), maxTupleSet));
        encodeTupleSet.addAll(activeSet);

        TupleSet fullActiveSet = getFullEncodeTupleSet(activeSet);
        if(fullEncodeTupleSet.addAll(fullActiveSet)){
            fullActiveSet.removeAll(getMinTupleSet());
            r1.addEncodeTupleSet(fullActiveSet);
        }
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        TupleSet minSet = getMinTupleSet();
        TupleSet r1Max = r1.getMaxTupleSet();
        for(Tuple tuple : fullEncodeTupleSet){
            if (minSet.contains(tuple)) {
                if(Relation.PostFixApprox) {
                    enc = bmgr.and(enc, bmgr.implication(getExecPair(tuple, ctx), this.getSMTVar(tuple, ctx)));
                } else {
                    enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                }
                continue;
            }

            BooleanFormula orClause = bmgr.makeFalse();
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            if(r1Max.contains(tuple)){
                orClause = bmgr.or(orClause, r1.getSMTVar(tuple, ctx));
            }


            for(Tuple t : r1Max.getByFirst(e1)){
                Event e3 = t.getSecond();
                if(e3.getCId() != e1.getCId() && e3.getCId() != e2.getCId() && transitiveReachabilityMap.get(e3).contains(e2)){
                    BooleanFormula tVar = minSet.contains(t) ? this.getSMTVar(t, ctx) : r1.getSMTVar(t, ctx);
                    orClause = bmgr.or(orClause, bmgr.and(tVar, this.getSMTVar(e3, e2, ctx)));
                }
            }

            if(Relation.PostFixApprox) {
                enc = bmgr.and(enc, bmgr.implication(orClause, this.getSMTVar(tuple, ctx)));
            } else {
                enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), orClause));
            }
        }

        return enc;
    }

    private TupleSet getFullEncodeTupleSet(TupleSet tuples){
        TupleSet processNow = new TupleSet(Sets.intersection(tuples, getMaxTupleSet()));
        TupleSet result = new TupleSet();

        while(!processNow.isEmpty()) {
            TupleSet processNext = new TupleSet();
            result.addAll(processNow);

            for (Tuple tuple : processNow) {
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();
                for (Tuple t : r1.getMaxTupleSet().getByFirst(e1)) {
                    Event e3 = t.getSecond();
                    if (e3.getCId() != e1.getCId() && e3.getCId() != e2.getCId() &&
                            transitiveReachabilityMap.get(e3).contains(e2)) {
                        result.add(new Tuple(e1, e3));
                        processNext.add(new Tuple(e3, e2));
                    }
                }

            }
            processNext.removeAll(result);
            processNow = processNext;
        }

        return result;
    }
}