package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.TupleSet;

public class RelEmpty extends Relation {

    public RelEmpty(String name) {
        super(name);
        term = name;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        return ctx.mkTrue();
    }
}
