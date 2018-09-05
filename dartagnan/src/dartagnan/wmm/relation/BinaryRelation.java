package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;

    BinaryRelation(Relation r1, Relation r2) {
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
    }

    BinaryRelation(Relation r1, Relation r2, String name) {
        super(name);
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
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
        enc = ctx.mkAnd(enc, r2.encode(ctx, encodedRels));
        return ctx.mkAnd(enc, doEncode(ctx));
    }
}
