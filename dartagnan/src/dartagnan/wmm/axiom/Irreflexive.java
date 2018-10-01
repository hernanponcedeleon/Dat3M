package dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class Irreflexive extends Axiom {

    public Irreflexive(Relation rel) {
        super(rel);
    }

    public Irreflexive(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        TupleSet set = new TupleSet();
        for(Tuple tuple : rel.getMaxTupleSet()){
            if(tuple.getFirst().getEId().equals(tuple.getSecond().getEId())){
                set.add(tuple);
            }
        }
        return set;
    }

    @Override
    protected BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            if(tuple.getFirst().getEId().equals(tuple.getSecond().getEId())){
                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(rel.getName(), tuple.getFirst(), tuple.getFirst(), ctx)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr _inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            if(tuple.getFirst().getEId().equals(tuple.getSecond().getEId())){
                enc = ctx.mkOr(enc, Utils.edge(rel.getName(), tuple.getFirst(), tuple.getFirst(), ctx));
            }
        }
        return enc;
    }

    @Override
    protected String _toString() {
        return String.format("irreflexive %s", rel.getName());
    }
}
