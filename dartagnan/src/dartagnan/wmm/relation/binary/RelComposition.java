package dartagnan.wmm.relation.binary;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelComposition extends BinaryRelation {

    public static String makeTerm(Relation r1, Relation r2){
        return "(" + r1.getName() + ";" + r2.getName() + ")";
    }

    public RelComposition(Relation r1, Relation r2) {
        super(r1, r2);
        term = makeTerm(r1, r2);
    }

    public RelComposition(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = makeTerm(r1, r2);
    }

    @Override
    public Set<Tuple> getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Tuple rel1 : r1.getMaxTupleSet()){
                for(Tuple rel2 : r2.getMaxTupleSet()){
                    if(rel1.getSecond().getEId().equals(rel2.getFirst().getEId())){
                        maxTupleSet.add(new Tuple(rel1.getFirst(), rel2.getSecond()));
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    public Set<Tuple> getMaxTupleSetRecursive(){
        if(containsRec && maxTupleSet != null){
            Set<Tuple> set1 = r1.getMaxTupleSetRecursive();
            Set<Tuple> set2 = r2.getMaxTupleSetRecursive();
            for(Tuple rel1 : set1){
                for(Tuple rel2 : set2){
                    if(rel1.getSecond().getEId().equals(rel2.getFirst().getEId())){
                        maxTupleSet.add(new Tuple(rel1.getFirst(), rel2.getSecond()));
                    }
                }
            }
            return maxTupleSet;
        }
        return getMaxTupleSet();
    }

    @Override
    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);

        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);

        if(!activeSet.isEmpty()){

            Set<Event> startEvents = new HashSet<>();
            Set<Event> endEvents = new HashSet<>();
            for(Tuple tuple : activeSet){
                startEvents.add(tuple.getFirst());
                endEvents.add(tuple.getSecond());
            }

            Set<Tuple> r1Candidates = new HashSet<>();
            for(Tuple tuple : r1.getMaxTupleSet()){
                if(startEvents.contains(tuple.getFirst())){
                    r1Candidates.add(tuple);
                }
            }

            Set<Tuple> r2Candidates = new HashSet<>();
            for(Tuple tuple : r2.getMaxTupleSet()){
                if(endEvents.contains(tuple.getSecond())){
                    r2Candidates.add(tuple);
                }
            }

            Set<Tuple> r1NewSet = new HashSet<>();
            Set<Tuple> r2NewSet = new HashSet<>();

            for(Tuple tuple : activeSet){
                for(Tuple tuple1 : r1Candidates){
                    if(tuple.getFirst().getEId().equals(tuple1.getFirst().getEId())){
                        for(Tuple tuple2 : r2Candidates){
                            if(tuple1.getSecond().getEId().equals(tuple2.getFirst().getEId()) && tuple.getSecond().getEId().equals(tuple2.getSecond().getEId())){
                                r1NewSet.add(tuple1);
                                r2NewSet.add(tuple2);
                            }
                        }
                    }
                }
            }
            r1.addEncodeTupleSet(r1NewSet);
            r2.addEncodeTupleSet(r2NewSet);
        }
    }

    @Override
    protected BoolExpr encodeBasic(Context ctx) throws Z3Exception {
        return encodeApprox(ctx);
        /*
        BoolExpr enc = ctx.mkTrue();

        // TODO: A new attribute for this type of set
        Set<Tuple> r1Set = new HashSet<>(r1.getEncodeTupleSet());
        r1Set.retainAll(r1.getMaxTupleSet());
        Set<Tuple> r2Set = new HashSet<>(r2.getEncodeTupleSet());
        r2Set.retainAll(r2.getMaxTupleSet());

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Tuple tuple1 : r1Set){
                if(tuple1.getFirst().getEId().equals(e1.getEId())){
                    Event e3 = tuple1.getSecond();
                    for(Tuple tuple2 : r2Set){
                        if(tuple2.getSecond().getEId().equals(e2.getEId())
                                && tuple2.getFirst().getEId().equals(e3.getEId())){
                            BoolExpr opt1 = Utils.edge(r1.getName(), e1, e3, ctx);
                            if (r1.getContainsRec()) {
                                opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e3, ctx)));
                            }
                            BoolExpr opt2 = Utils.edge(r2.getName(), e3, e2, ctx);
                            if (r2.getContainsRec()) {
                                opt2 = ctx.mkAnd(opt2, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r2.getName(), e3, e2, ctx)));
                            }
                            orClause = ctx.mkOr(orClause, ctx.mkAnd(opt1, opt2));
                        }
                    }
                }
            }
            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), orClause));
        }
        return enc;
        */
    }

    @Override
    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        // TODO: A new attribute for this type of set
        Set<Tuple> r1Set = new HashSet<>(r1.getEncodeTupleSet());
        r1Set.retainAll(r1.getMaxTupleSet());
        Set<Tuple> r2Set = new HashSet<>(r2.getEncodeTupleSet());
        r2Set.retainAll(r2.getMaxTupleSet());

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Tuple tuple1 : r1Set){
                if(tuple1.getFirst().getEId().equals(e1.getEId())){
                    Event e3 = tuple1.getSecond();
                    for(Tuple tuple2 : r2Set){
                        if(tuple2.getSecond().getEId().equals(e2.getEId())
                        && tuple2.getFirst().getEId().equals(e3.getEId())){
                            BoolExpr opt1 = Utils.edge(r1.getName(), e1, e3, ctx);
                            BoolExpr opt2 = Utils.edge(r2.getName(), e3, e2, ctx);
                            orClause = ctx.mkOr(orClause, ctx.mkAnd(opt1, opt2));
                        }
                    }
                }
            }

            if (Relation.PostFixApprox) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, Utils.edge(this.getName(), e1, e2, ctx)));
            } else {
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), orClause));
            }
        }
        return enc;
    }
}
