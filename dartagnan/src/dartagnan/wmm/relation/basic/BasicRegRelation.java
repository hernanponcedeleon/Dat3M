package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.program.Register;
import dartagnan.program.event.Event;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.wmm.utils.Tuple;

import static dartagnan.utils.Utils.edge;

public abstract class BasicRegRelation extends BasicRelation {

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple1 : maxTupleSet) {
            Event e1 = tuple1.getFirst();
            Event e2 = tuple1.getSecond();
            Register register = ((RegWriter)e1).getModifiedReg();

            BoolExpr clause = ctx.mkAnd(e1.executes(ctx), e2.executes(ctx));
            for(Tuple tuple2 : maxTupleSet.getBySecond(e2)){
                if(register == ((RegWriter)tuple2.getFirst()).getModifiedReg() && e1.getEId() < tuple2.getFirst().getEId()){
                    clause = ctx.mkAnd(clause, ctx.mkNot(tuple2.getFirst().executes(ctx)));
                }
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.getName(), e1, e2, ctx), clause));
            enc = ctx.mkAnd(enc, ctx.mkImplies(edge(this.getName(), e1, e2, ctx),
                    ctx.mkEq(((RegWriter)e1).getRegResultExpr(), register.toZ3Int(e2, ctx))
            ));
        }
        return enc;
    }
}
