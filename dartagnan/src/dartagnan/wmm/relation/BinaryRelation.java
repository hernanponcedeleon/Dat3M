package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public abstract class BinaryRelation extends Relation {

    protected Relation r1;
    protected Relation r2;

    /**
     * Creates a binary relation.
     *
     * @param r1 the left child.
     * @param r2 the right child.
     */
    BinaryRelation(Relation r1, Relation r2) {
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
    }

    /**
     * Creates a named binary relation.
     *
     * @param r1 the left child
     * @param r2 the right child
     * @param name
     */
    BinaryRelation(Relation r1, Relation r2, String name) {
        super(name);
        this.r1 = r1;
        this.r2 = r2;
        containsRec = r1.containsRec || r2.containsRec;
    }

    @Override
    public BoolExpr encode(Collection<Event> events, Context ctx, Collection<String> encodedRels) throws Z3Exception {
        if(encodedRels != null){
            if(encodedRels.contains(name)){
                return ctx.mkTrue();
            }
            encodedRels.add(name);
        }
        BoolExpr enc = r1.encode(events, ctx, encodedRels);
        enc = ctx.mkAnd(enc, r2.encode(events, ctx, encodedRels));
        return ctx.mkAnd(enc, doEncode(events, ctx));
    }
}
