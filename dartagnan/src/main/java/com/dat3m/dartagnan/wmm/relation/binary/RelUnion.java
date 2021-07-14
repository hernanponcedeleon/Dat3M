package com.dat3m.dartagnan.wmm.relation.binary;

import com.google.common.collect.Sets;
import com.dat3m.dartagnan.wmm.utils.Utils;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RelUnion extends BinaryRelation {
    //TODO: We can make use of minTupleSet when propagating active sets
    // If (e1,e2) is in min(r1), then we don't need to propagate it to r2
    // Actually, we might not need to propagate at all if it is in the unions minSet.
    // CARE 1: If it is in the minSet of both, we need to propagate to at least one of them
    // Care 2: When encoding, we need to make use of this fact

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "+" + r2.getName() + ")";
    }

    public RelUnion(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelUnion(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet(Sets.union(r1.getMinTupleSet(), r2.getMinTupleSet()));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet(Sets.union(r1.getMaxTupleSet(), r2.getMaxTupleSet()));
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(recursiveGroupId > 0 && minTupleSet != null){
            minTupleSet.addAll(Sets.union(r1.getMinTupleSetRecursive(), r2.getMinTupleSetRecursive()));
            return minTupleSet;
        }
        return getMinTupleSet();
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            maxTupleSet.addAll(Sets.union(r1.getMaxTupleSetRecursive(), r2.getMaxTupleSetRecursive()));
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        TupleSet min = getMinTupleSet();
        for(Tuple tuple : encodeTupleSet){
            if (min.contains(tuple)) {
                enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                continue;
            }
            BooleanFormula opt1 = r1.getSMTVar(tuple, ctx);
            BooleanFormula opt2 = r2.getSMTVar(tuple, ctx);
            if (Relation.PostFixApprox) {
                enc = bmgr.and(enc, bmgr.implication(bmgr.or(opt1, opt2), this.getSMTVar(tuple, ctx)));
            } else {
                enc = bmgr.and(enc, bmgr.equivalence(this.getSMTVar(tuple, ctx), bmgr.or(opt1, opt2)));
            }
        }
        return enc;
    }

    @Override
    public BooleanFormula encodeIteration(int groupId, int iteration, SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();

        if((groupId & recursiveGroupId) > 0 && iteration > lastEncodedIteration){
            lastEncodedIteration = iteration;

            String name = this.getName() + "_" + iteration;

            if(iteration == 0 && isRecursive){
                for(Tuple tuple : encodeTupleSet){
                    enc = bmgr.and(bmgr.not(Utils.edge(name, tuple.getFirst(), tuple.getSecond(), ctx)));
                }
            } else {
                int childIteration = isRecursive ? iteration - 1 : iteration;

                boolean recurseInR1 = (r1.getRecursiveGroupId() & groupId) > 0;
                boolean recurseInR2 = (r2.getRecursiveGroupId() & groupId) > 0;

                String r1Name = recurseInR1 ? r1.getName() + "_" + childIteration : r1.getName();
                String r2Name = recurseInR2 ? r2.getName() + "_" + childIteration : r2.getName();

                for(Tuple tuple : encodeTupleSet){
                	BooleanFormula edge = Utils.edge(name, tuple.getFirst(), tuple.getSecond(), ctx);
                	BooleanFormula opt1 = Utils.edge(r1Name, tuple.getFirst(), tuple.getSecond(), ctx);
                    BooleanFormula opt2 = Utils.edge(r2Name, tuple.getFirst(), tuple.getSecond(), ctx);
                    enc = bmgr.and(enc, bmgr.equivalence(edge, bmgr.or(opt1, opt2)));
                }

                if(recurseInR1){
                    enc = bmgr.and(enc, r1.encodeIteration(groupId, childIteration, ctx));
                }

                if(recurseInR2){
                    enc = bmgr.and(enc, r2.encodeIteration(groupId, childIteration, ctx));
                }
            }
        }
        return enc;
    }
}