package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;

import static dartagnan.utils.Utils.edge;

public abstract class StaticRelation extends Relation {

    public StaticRelation() {
        super();
    }

    public StaticRelation(String name) {
        super(name);
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet) {
            BoolExpr rel = edge(this.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx))));
        }
        return enc;
    }
}
