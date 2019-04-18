package com.dat3m.dartagnan.wmm.relation.binary;

import com.dat3m.dartagnan.wmm.utils.Mode;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
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
    public void initialise(Program program, Context ctx, Mode mode){
        super.initialise(program, ctx, mode);
        if(r2.getRecursiveGroupId() > 0){
            throw new RuntimeException("Relation " + r2.getName() + " cannot be recursive since it occurs in a set minus.");
        }
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            maxTupleSet.addAll(r1.getMaxTupleSet());
            r2.getMaxTupleSet();
        }
        return maxTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            maxTupleSet.addAll(r1.getMaxTupleSetRecursive());
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
            BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
            if (Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(opt1, opt2), Utils.edge(this.getName(), e1, e2, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeIDL() {
        if(recursiveGroupId == 0){
            return encodeApprox();
        }

        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
            BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));

            opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e2, ctx)));
            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));
        }
        return enc;
    }

    @Override
    public BoolExpr encodeIteration(int groupId, int iteration){
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
                    enc = ctx.mkAnd(enc, r1.encodeIteration(groupId, childIteration));
                }
            }
        }

        return enc;
    }
}
