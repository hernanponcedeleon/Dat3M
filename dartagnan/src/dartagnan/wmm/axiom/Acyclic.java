package dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.Encodings;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

    public Acyclic(Relation rel) {
        super(rel);
    }

    public Acyclic(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    public TupleSet getEncodeTupleSet(){
        Map<Event, Set<Event>> transMap = rel.getMaxTupleSet().transMap();
        TupleSet result = new TupleSet();

        for(Event e1 : transMap.keySet()){
            if(transMap.get(e1).contains(e1)){
                for(Event e2 : transMap.get(e1)){
                    if(!e2.getEId().equals(e1.getEId()) && transMap.get(e2).contains(e1)){
                        result.add(new Tuple(e1, e2));
                    }
                }
            }
        }

        for(Tuple tuple : rel.getMaxTupleSet()){
            if(tuple.getFirst().getEId().equals(tuple.getSecond().getEId())){
                result.add(tuple);
            }
        }

        result.retainAll(rel.getMaxTupleSet());
        return result;
    }

    @Override
    protected BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : rel.getEncodeTupleSet()){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
            enc = ctx.mkAnd(enc, ctx.mkImplies(e1.executes(ctx), ctx.mkGt(Utils.intVar(rel.getName(), e1, ctx), ctx.mkInt(0))));
            enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(rel.getName(), e1, e2, ctx), ctx.mkLt(Utils.intVar(rel.getName(), e1, ctx), Utils.intVar(rel.getName(), e2, ctx))));
        }
        return enc;
    }

    @Override
    protected BoolExpr _inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        // TODO: Tuples
        return ctx.mkAnd(Encodings.satCycleDef(rel.getName(), events, ctx), Encodings.satCycle(rel.getName(), events, ctx));
    }

    @Override
    protected String _toString() {
        return String.format("acyclic %s", rel.getName());
    }
}
