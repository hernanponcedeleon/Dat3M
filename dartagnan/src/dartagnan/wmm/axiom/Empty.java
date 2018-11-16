package dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

public class Empty extends Axiom {

    public Empty(Relation rel) {
        super(rel);
    }

    public Empty(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        return rel.getMaxTupleSet();
    }

    @Override
    protected BoolExpr _consistent(Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(rel.getName(), tuple.getFirst(), tuple.getSecond(), ctx)));
        }
        return enc;
    }

    @Override
    protected BoolExpr _inconsistent(Context ctx) {
        BoolExpr enc = ctx.mkFalse();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            enc = ctx.mkOr(enc, Utils.edge(rel.getName(), tuple.getFirst(), tuple.getSecond(), ctx));
        }
        return enc;
    }

    @Override
    protected String _toString() {
        return "empty " + rel.getName();
    }
}
