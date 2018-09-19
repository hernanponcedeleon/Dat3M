package dartagnan.wmm.relation.unary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Map;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelTransRef extends RelTrans {

    private TupleSet identityEncodeTupleSet = new TupleSet();
    private TupleSet transEncodeTupleSet = new TupleSet();

    public static String makeTerm(Relation r1){
        return r1.getName() + "^*";
    }

    public RelTransRef(Relation r1) {
        super(r1);
        term = makeTerm(r1);
    }

    public RelTransRef(Relation r1, String name) {
        super(r1, name);
        term = makeTerm(r1);
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){

            super.getMaxTupleSet();

            for (Map.Entry<Event, Set<Event>> entry : transReachabilityMap.entrySet()) {
                entry.getValue().remove(entry.getKey());
            }

            for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
                maxTupleSet.add(new Tuple(e, e));
            }
        }
        return maxTupleSet;
    }

    @Override
    public void addEncodeTupleSet(TupleSet tuples){
        for(Tuple tuple : tuples){
            if(tuple.getFirst().getEId().equals(tuple.getSecond().getEId())){
                identityEncodeTupleSet.add(tuple);
            }
        }

        tuples.removeAll(encodeTupleSet);
        tuples.removeAll(identityEncodeTupleSet);

        encodeTupleSet.removeAll(identityEncodeTupleSet);
        super.addEncodeTupleSet(tuples);

        transEncodeTupleSet.addAll(tuples);
        encodeTupleSet.addAll(identityEncodeTupleSet);
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        TupleSet temp = encodeTupleSet;
        encodeTupleSet = transEncodeTupleSet;
        BoolExpr enc = super.encodeBasic(ctx);
        encodeTupleSet = temp;

        for(Tuple tuple : identityEncodeTupleSet){
            enc = ctx.mkAnd(enc, Utils.edge(this.getName(), tuple.getFirst(), tuple.getFirst(), ctx));
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        TupleSet temp = encodeTupleSet;
        encodeTupleSet = transEncodeTupleSet;
        BoolExpr enc = super.encodeApprox(ctx);
        encodeTupleSet = temp;

        for(Tuple tuple : identityEncodeTupleSet){
            enc = ctx.mkAnd(enc, Utils.edge(this.getName(), tuple.getFirst(), tuple.getFirst(), ctx));
        }
        return enc;
    }
}