package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

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
        if(r2.containsRec){
            throw new RuntimeException(r2.getName() + " is not allowed to be recursive since it occurs in a setminus.");
        }
    }

    public RelMinus(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
        if(r2.containsRec){
            throw new RuntimeException(r2.getName() + " is not allowed to be recursive since it occurs in a setminus.");
        }
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            maxTupleSet.addAll(r1.getMaxTupleSet());
            r2.getMaxTupleSet();
        }
        return maxTupleSet;
    }

    @Override
    public Set<Tuple> getMaxTupleSetRecursive(){
        if(containsRec && maxTupleSet != null){
            throw new RuntimeException("Method getMaxTupleSetRecursive is not implemented for " + this.getClass().getName());
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);
        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);
        if(!activeSet.isEmpty()){
            r1.addEncodeTupleSet(activeSet);
            r2.addEncodeTupleSet(activeSet);
        }
    }

    @Override
    public BoolExpr encode(Context ctx, Collection<String> encodedRels) throws Z3Exception {
        if(encodedRels != null){
            if(encodedRels.contains(this.getName())){
                return ctx.mkTrue();
            }
            encodedRels.add(this.getName());
        }
        BoolExpr enc = r1.encode(ctx, encodedRels);
        boolean approx = Relation.Approx;
        Relation.Approx = false;
        enc = ctx.mkAnd(enc, r2.encode(ctx, encodedRels));
        Relation.Approx = approx;
        return ctx.mkAnd(enc, doEncode(ctx));
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
            if(r1.containsRec) {
                opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e2, ctx)));
            }
            BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
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
}
