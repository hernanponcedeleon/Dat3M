package dartagnan.wmm.relation.unary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.wmm.relation.Relation;

/**
 *
 * @author Florian Furbach
 */
public abstract class UnaryRelation extends Relation {

    protected Relation r1;

    UnaryRelation(Relation r1) {
        this.r1 = r1;
        containsRec = r1.getContainsRec();
    }

    UnaryRelation(Relation r1, String name) {
        super(name);
        this.r1 = r1;
        containsRec = r1.getContainsRec();
    }

    @Override
    public BoolExpr encode(Context ctx) throws Z3Exception {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return ctx.mkAnd(r1.encode(ctx), doEncode(ctx));
    }
}
