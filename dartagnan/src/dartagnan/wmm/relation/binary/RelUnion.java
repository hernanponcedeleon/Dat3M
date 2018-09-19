package dartagnan.wmm.relation.binary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;
import dartagnan.wmm.relation.utils.TupleSet;

/**
 *
 * @author Florian Furbach
 */
public class RelUnion extends BinaryRelation {

    private int lastEncodedIteration = -1;

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
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            maxTupleSet.addAll(r1.getMaxTupleSet());
            maxTupleSet.addAll(r2.getMaxTupleSet());
        }
        return maxTupleSet;
    }

    public BoolExpr encodeIteration(int recGroupId, Context ctx, int iteration){

        BoolExpr enc = ctx.mkTrue();

        if(iteration <= lastEncodedIteration){
            return enc;
        }
        lastEncodedIteration = iteration;

        if((recGroupId & recursiveGroupId) > 0){
            if(iteration == 0 && isRecursive){
                for(Tuple tuple : encodeTupleSet){
                    enc = ctx.mkAnd(ctx.mkNot(Utils.edge(this.getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)));
                }

            } else {

                int myIteration = iteration;
                int childIteration = iteration;
                if(isRecursive){
                    childIteration--;
                }

                for(Tuple tuple : encodeTupleSet){
                    BoolExpr edge = Utils.edge(this.getName() + "_" + myIteration, tuple.getFirst(), tuple.getSecond(), ctx);

                    BoolExpr opt1;
                    if(r1.getRecursiveGroupId() == recGroupId){
                        opt1 = Utils.edge(r1.getName() + "_" + childIteration, tuple.getFirst(), tuple.getSecond(), ctx);
                    } else {
                        opt1 = Utils.edge(r1.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
                    }

                    BoolExpr opt2;
                    if(r2.getRecursiveGroupId() == recGroupId){
                        opt2 = Utils.edge(r2.getName() + "_" + childIteration, tuple.getFirst(), tuple.getSecond(), ctx);
                    } else {
                        opt2 = Utils.edge(r2.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
                    }

                    enc = ctx.mkAnd(enc, ctx.mkEq(edge, ctx.mkOr(opt1, opt2)));
                }

                if((r1.getRecursiveGroupId() & recGroupId) > 0){
                    enc = ctx.mkAnd(enc, r1.encodeIteration(recGroupId, ctx, childIteration));
                }

                if((r2.getRecursiveGroupId() & recGroupId) > 0){
                    enc = ctx.mkAnd(enc, r2.encodeIteration(recGroupId, ctx, childIteration));
                }
            }
        }

        return enc;
    }

    @Override
    public TupleSet getMaxTupleSetRecursive(){
        if(recursiveGroupId > 0 && maxTupleSet != null){
            maxTupleSet.addAll(r1.getMaxTupleSetRecursive());
            maxTupleSet.addAll(r2.getMaxTupleSetRecursive());
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        if(tuples == null){
            System.out.println("tuples is null");
        }
        if(encodeTupleSet == null){
            System.out.println("encodeTupleSet is null");
        }
        encodeTupleSet.addAll(tuples);
        TupleSet activeSet = new TupleSet();
        activeSet.addAll(tuples);
        activeSet.retainAll(maxTupleSet);
        if(!activeSet.isEmpty()){
            r1.addEncodeTupleSet(activeSet);
            r2.addEncodeTupleSet(activeSet);
        }
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        if(recursiveGroupId > 0){
            return ctx.mkTrue();
        }
        return encodeApprox(ctx);
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
            BoolExpr opt2 = Utils.edge(r2.getName(), e1, e2, ctx);
            if (Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkOr(opt1, opt2), Utils.edge(this.getName(), e1, e2, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkOr(opt1, opt2)));
            }
        }
        return enc;
    }
}
