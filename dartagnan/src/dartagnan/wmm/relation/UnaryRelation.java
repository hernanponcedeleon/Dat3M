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
public abstract class UnaryRelation extends Relation {

    protected Relation r1;

    public UnaryRelation(Relation r1, String name, String term) {
        super(name, term);
        this.r1 = r1;
        containsRec = r1.containsRec;
        namedRelations.addAll(r1.getNamedRelations());
    }

    public UnaryRelation(Relation r1, String term) {
        super(term);
        this.r1 = r1;
        containsRec = r1.containsRec;
        namedRelations.addAll(r1.getNamedRelations());
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
        return ctx.mkAnd(enc, doEncode(events, ctx));
    }
}
