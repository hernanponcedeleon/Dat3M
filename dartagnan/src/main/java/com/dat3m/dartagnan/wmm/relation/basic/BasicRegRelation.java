package com.dat3m.dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import static com.dat3m.dartagnan.utils.Utils.edge;

public abstract class BasicRegRelation extends BasicRelation {

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple1 : maxTupleSet) {
            Event e1 = tuple1.getFirst();
            Event e2 = tuple1.getSecond();
            Register register = ((RegWriter)e1).getResultRegister();

            BoolExpr clause = ctx.mkAnd(e1.executes(ctx), e2.executes(ctx));
            for(Tuple tuple2 : maxTupleSet.getBySecond(e2)){
                if(register == ((RegWriter)tuple2.getFirst()).getResultRegister() && e1.getCId() < tuple2.getFirst().getCId()){
                    clause = ctx.mkAnd(clause, ctx.mkNot(tuple2.getFirst().executes(ctx)));
                }
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.getName(), e1, e2, ctx), clause));
            enc = ctx.mkAnd(enc, ctx.mkImplies(edge(this.getName(), e1, e2, ctx),
                    ctx.mkEq(((RegWriter)e1).getResultRegisterExpr(), register.toZ3Int(e2, ctx))
            ));
        }
        return enc;
    }
}
