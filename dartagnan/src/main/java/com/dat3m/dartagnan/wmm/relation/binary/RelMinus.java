package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.Sets;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RelMinus extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + "\\" + r2.getName() + ")";
    }

    public RelMinus(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelMinus(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public void initialise(VerificationTask task, Context ctx){
        super.initialise(task, ctx);
        if(r2.getRecursiveGroupId() > 0){
            throw new RuntimeException("Relation " + r2.getName() + " cannot be recursive since it occurs in a set minus.");
        }
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet(Sets.difference(r1.getMinTupleSet(), r2.getMaxTupleSet()));
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet(Sets.difference(r1.getMaxTupleSet(), r2.getMinTupleSet()));
            r2.getMaxTupleSet();
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMinTupleSetRecursive(){
        if(recursiveGroupId > 0 && minTupleSet != null){
            minTupleSet.addAll(Sets.difference(r1.getMinTupleSetRecursive(), r2.getMaxTupleSetRecursive()));
            return minTupleSet;
        }
        return getMinTupleSet();
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            maxTupleSet.addAll(Sets.difference(r1.getMaxTupleSetRecursive(), r2.getMinTupleSetRecursive()));
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) {
        BoolExpr enc = ctx.mkTrue();

        TupleSet min = getMinTupleSet();
        for(Tuple tuple : encodeTupleSet){
            if (min.contains(tuple)) {
                enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), getExecPair(tuple, ctx)));
                continue;
            }

            BoolExpr opt1 = r1.getSMTVar(tuple, ctx);
            BoolExpr opt2 = ctx.mkNot(r2.getSMTVar(tuple, ctx));
            if (Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(opt1, opt2), this.getSMTVar(tuple, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(this.getSMTVar(tuple, ctx), ctx.mkAnd(opt1, opt2)));
            }
        }
        return enc;
    }

    @Override
    public BoolExpr encodeIteration(int groupId, int iteration, Context ctx){
        BoolExpr enc = ctx.mkTrue();

        if((groupId & recursiveGroupId) > 0 && iteration > lastEncodedIteration){
            lastEncodedIteration = iteration;

            String name = this.getName() + "_" + iteration;

            if(iteration == 0 && isRecursive){
                for(Tuple tuple : encodeTupleSet){
                    enc = ctx.mkAnd(ctx.mkNot(Utils.edge(name, tuple.getFirst(), tuple.getSecond(), ctx)));
                }
            } else {
                int childIteration = isRecursive ? iteration - 1 : iteration;
                boolean recurse = (r1.getRecursiveGroupId() & groupId) > 0;

                String r1Name = recurse ? r1.getName() + "_" + childIteration : r1.getName();
                String r2Name = r2.getName();

                for(Tuple tuple : encodeTupleSet){
                    BoolExpr edge = Utils.edge(name, tuple.getFirst(), tuple.getSecond(), ctx);
                    BoolExpr opt1 = Utils.edge(r1Name, tuple.getFirst(), tuple.getSecond(), ctx);
                    BoolExpr opt2 = ctx.mkNot(Utils.edge(r2Name, tuple.getFirst(), tuple.getSecond(), ctx));
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge, ctx.mkAnd(opt1, opt2)));
                }

                if(recurse){
                    enc = ctx.mkAnd(enc, r1.encodeIteration(groupId, childIteration, ctx));
                }
            }
        }

        return enc;
    }
}
