package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
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
    public Set<Tuple> getMaxTupleSet(Program program){
        if(maxTupleSet == null){
            maxTupleSet = new HashSet<>();
            for(Tuple rel1 : r1.getMaxTupleSet(program)){
                for(Tuple rel2 : r2.getMaxTupleSet(program)){
                    if(rel1.getSecond().getEId().equals(rel2.getFirst().getEId())){
                        maxTupleSet.add(new Tuple(rel1.getFirst(), rel2.getSecond()));
                    }
                }
            }
        }
        return maxTupleSet;
    }

    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);

        Set<Tuple> activeSet = new HashSet<>(tuples);
        activeSet.retainAll(maxTupleSet);

        if(!activeSet.isEmpty()){
            Set<Tuple> r1NewSet = new HashSet<>();
            Set<Tuple> r2NewSet = new HashSet<>();

            // TODO: Sort tuples and O(n^2)
            for(Tuple newRel : activeSet){
                for(Tuple rel1 : r1.maxTupleSet){
                    if(newRel.getFirst().getEId().equals(rel1.getFirst().getEId())){
                        for(Tuple rel2 : r2.maxTupleSet){
                            if(rel1.getSecond().getEId().equals(rel2.getFirst().getEId()) && newRel.getSecond().getEId().equals(rel2.getSecond().getEId())){
                                r1NewSet.add(rel1);
                                r2NewSet.add(rel2);
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
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        Collection<Event> events = program.getEventRepository().getEvents(this.eventMask | EventRepository.EVENT_SKIP | EventRepository.EVENT_IF | EventRepository.EVENT_LOCAL);
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                BoolExpr orClause = ctx.mkFalse();
                for (Event e3 : events) {
                    BoolExpr opt1 = Utils.edge(r1.getName(), e1, e3, ctx);
                    if (r1.containsRec) {
                        opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e3, ctx)));
                    }
                    BoolExpr opt2 = Utils.edge(r2.getName(), e3, e2, ctx);
                    if (r2.containsRec) {
                        opt2 = ctx.mkAnd(opt2, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r2.getName(), e3, e2, ctx)));
                    }
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(opt1, opt2));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), orClause));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple : encodeTupleSet){
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();

            BoolExpr orClause = ctx.mkFalse();
            for(Tuple tuple1 : r1.encodeTupleSet){
                if(tuple1.getFirst().getEId().equals(e1.getEId())){
                    Event e3 = tuple1.getSecond();
                    for(Tuple tuple2 : r2.encodeTupleSet){
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
