package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.Store;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.edge;

public class RelIdd extends Relation {

    private Set<Tuple> maxRegTupleSet = new HashSet<>();
    private Set<Tuple> maxLocTupleSet = new HashSet<>();

    public RelIdd(){
        term = "idd";
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){

            for(Thread t : program.getThreads()){
                // Via register
                Set<Event> regWriters = t.getEventRepository().getEvents(EventRepository.LOCAL | EventRepository.LOAD);
                Set<Event> regReaders = t.getEventRepository().getEvents(EventRepository.STORE | EventRepository.LOCAL | EventRepository.IF);
                for(Event e1 : regWriters){
                    for(Event e2 : regReaders){
                        if(e1.getEId() < e2.getEId() && e2.getExpr().getRegs().contains(e1.getReg())){
                            maxRegTupleSet.add(new Tuple(e1, e2));
                        }
                    }
                }

                // Via location
                Set<Event> locWriters = t.getEventRepository().getEvents(EventRepository.STORE);
                Set<Event> locReaders = t.getEventRepository().getEvents(EventRepository.LOAD);
                for(Event e1 : locWriters){
                    for(Event e2 : locReaders){
                        if(e1.getEId() < e2.getEId() && e1.getLoc() == e2.getLoc()){
                            maxLocTupleSet.add(new Tuple(e1, e2));
                        }
                    }
                }
            }

            maxTupleSet = new TupleSet();
            maxTupleSet.addAll(maxRegTupleSet);
            maxTupleSet.addAll(maxLocTupleSet);
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();

        for(Tuple tuple1 : encodeTupleSet) {
            Event e1 = tuple1.getFirst();
            Event e2 = tuple1.getSecond();
            BoolExpr clause = ctx.mkAnd(e1.executes(ctx), e2.executes(ctx));

            if(e1 instanceof Store){
                for(Tuple tuple2 : maxLocTupleSet){
                    if(e2.getEId() == tuple2.getSecond().getEId()
                            && e2.getLoc() == tuple2.getSecond().getLoc()
                            && e1.getEId() < tuple2.getFirst().getEId()){
                        clause = ctx.mkAnd(clause, ctx.mkNot(tuple2.getFirst().executes(ctx)));
                    }
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.getName(), e1, e2, ctx), clause));
            } else {
                for(Tuple tuple2 : maxRegTupleSet){
                    if(e2.getEId() == tuple2.getSecond().getEId()
                            && e1.getReg() == tuple2.getFirst().getReg()
                            && e1.getEId() < tuple2.getFirst().getEId()){
                        clause = ctx.mkAnd(clause, ctx.mkNot(tuple2.getFirst().executes(ctx)));
                    }
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(edge(this.getName(), e1, e2, ctx), clause));
            }
        }
        return enc;
    }
}
