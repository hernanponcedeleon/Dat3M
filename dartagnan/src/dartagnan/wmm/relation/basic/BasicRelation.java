package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;

import static dartagnan.utils.Utils.edge;

public abstract class BasicRelation extends Relation {

    public BasicRelation() {
        super();
    }

    public BasicRelation(String name) {
        super(name);
    }

    @Override
    protected BoolExpr encodeApprox() throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet) {
            BoolExpr rel = edge(this.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx))));
        }
        return enc;
    }
}
