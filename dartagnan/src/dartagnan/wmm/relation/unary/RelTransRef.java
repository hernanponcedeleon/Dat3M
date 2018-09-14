package dartagnan.wmm.relation.unary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.*;

/**
 *
 * @author Florian Furbach
 */
public class RelTransRef extends UnaryRelation {

    private Map<Event, Set<Event>> reachabilityMap;

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
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            reachabilityMap = new HashMap<>();
            for(Tuple tuple : r1.getMaxTupleSet()){
                reachabilityMap.putIfAbsent(tuple.getFirst(), new HashSet<>());
                reachabilityMap.putIfAbsent(tuple.getSecond(), new HashSet<>());
                Set<Event> events = reachabilityMap.get(tuple.getFirst());
                events.add(tuple.getSecond());
            }

            boolean changed;
            do {
                changed = false;
                for(Event e1 : reachabilityMap.keySet()){
                    Set<Event> newEls = new HashSet<>();
                    for(Event e2 : reachabilityMap.get(e1)){
                        if(!(e1.getEId().equals(e2.getEId()))){
                            newEls.addAll(reachabilityMap.get(e2));
                        }
                    }
                    if(reachabilityMap.get(e1).addAll(newEls))
                        changed = true;
                }
            } while (changed);

            for(Event e1 : reachabilityMap.keySet()){
                reachabilityMap.get(e1).add(e1);
                for(Event e2 : reachabilityMap.get(e1)){
                    maxTupleSet.add(new Tuple(e1, e2));
                }
            }

            // TODO: Better version
            for(Event e : program.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
                reachabilityMap.putIfAbsent(e, new HashSet<>());
                reachabilityMap.get(e).add(e);
                maxTupleSet.add(new Tuple(e, e));
            }
        }
        return maxTupleSet;
    }

    @Override
    public Set<Tuple> getMaxTupleSetRecursive(){
        if(containsRec && maxTupleSet != null){
            throw new RuntimeException("Method getMaxTupleSetRecursive is not implemented for " + this.getClass().getName());
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);
        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);
        if(!activeSet.isEmpty()){
            // TODO: Implementation
            r1.addEncodeTupleSet(r1.getMaxTupleSet());
        }
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        return encodeApprox(ctx);

        /*
        Collection<Event> events = program.getEventRepository().getEvents(this.eventMask);
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                //reflexive
                if (e1 == e2) {
                    enc = ctx.mkAnd(enc, Utils.edge(this.getName(), e1, e2, ctx));
                } else {
                    BoolExpr orTrans = ctx.mkFalse();
                    for (Event e3 : events) {
                        //e1e2 caused by transitivity:
                        orTrans = ctx.mkOr(orTrans, ctx.mkAnd(Utils.edge(this.getName(), e1, e3, ctx), Utils.edge(this.getName(), e3, e2, ctx),
                                ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(this.getName(), e1, e3, ctx)),
                                ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(this.getName(), e3, e2, ctx))));
                    }
                    //e1e2 caused by r1:
                    BoolExpr orr1 = Utils.edge(r1.getName(), e1, e2, ctx);
                    //allow for recursion in r1:
                    if (r1.getContainsRec()) {
                        orr1 = ctx.mkAnd(orr1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e2, ctx)));
                    }
                    enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkOr(orTrans, orr1)));
                }
            }
        }
        return enc;
        */
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        // TODO: Add necessary tuples to r1 for CloseApprox option
        //BoolExpr orClose1 = ctx.mkFalse();
        //BoolExpr orClose2 = ctx.mkFalse();

        Set<Tuple> allEncoded = new HashSet<>(encodeTupleSet);
        Set<Tuple> encodeNow = new HashSet<>(encodeTupleSet);

        while(true){
            Set<Tuple> encodeNext = new HashSet<>();

            for(Tuple tuple : encodeNow){
                BoolExpr orClause = ctx.mkFalse();
                Event e1 = tuple.getFirst();
                Event e2 = tuple.getSecond();

                if(e1.getEId().equals(e2.getEId()))
                    continue;

                Set<Event> reachableEvents = reachabilityMap.get(e1);
                if(r1.getMaxTupleSet().contains(new Tuple(e1, e2))){
                    orClause = ctx.mkOr(orClause, Utils.edge(r1.getName(), e1, e2, ctx));
                }

                for(Event e3 : reachableEvents){
                    if(!e3.getEId().equals(e1.getEId()) && !e3.getEId().equals(e2.getEId())){
                        orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(this.getName(), e1, e3, ctx), Utils.edge(this.getName(), e3, e2, ctx)));

                        //if(Relation.CloseApprox){
                        //    orclose1 = ctx.mkOr(orclose1, Utils.edge(r1.getName(), e1, e3, ctx));
                        //    orclose2 = ctx.mkOr(orclose2, Utils.edge(r1.getName(), e3, e2, ctx));
                        //}

                        if(!allEncoded.contains(new Tuple(e1, e3))){
                            encodeNext.add(new Tuple(e1, e3));
                        }
                        if(!allEncoded.contains(new Tuple(e3, e2))){
                            encodeNext.add(new Tuple(e3, e2));
                        }
                    }
                }

                //if(Relation.CloseApprox){
                //    enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(orclose1, orclose2)));
                //}

                if(Relation.PostFixApprox) {
                    enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, Utils.edge(this.getName(), e1, e2, ctx)));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), orClause));
                }
            }

            if(encodeNext.isEmpty())
                break;

            encodeNow.clear();
            encodeNow.addAll(encodeNext);
            allEncoded.addAll(encodeNext);
        }

        Set<Event> events = new HashSet<>();
        for(Tuple tuple : encodeTupleSet){
            events.add(tuple.getFirst());
            events.add(tuple.getSecond());
        }

        for(Event e : events){
            enc = ctx.mkAnd(enc, Utils.edge(this.getName(), e, e, ctx));
        }

        return enc;
    }
}