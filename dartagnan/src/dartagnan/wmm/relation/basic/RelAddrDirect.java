package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.Set;
import java.util.stream.Collectors;

import static dartagnan.utils.Utils.edge;

public class RelAddrDirect extends BasicRelation {

    public RelAddrDirect(){
        term = "addrDirect";
        forceDoEncode = true;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
            maxTupleSet = new TupleSet();
            for(Thread t : program.getThreads()){
                Set<Event> events = t.getEventRepository().getEvents(EventRepository.ALL);
                Set<Event> regWriters = events.stream().filter(e -> e instanceof RegWriter).collect(Collectors.toSet());
                Set<Event> regReaders = t.getEventRepository().getEvents(EventRepository.MEMORY);
                for(Event e1 : regWriters){
                    for(Event e2 : regReaders){
                        for(Register register : ((MemEvent)e2).getAddressRegs()){
                            if(e1.getEId() < e2.getEId() && register == ((RegWriter)e1).getModifiedReg()){
                                maxTupleSet.add(new Tuple(e1, e2));
                            }
                        }
                    }
                }
            }
        }
        return maxTupleSet;
    }

    @Override
    protected BoolExpr encodeApprox() {
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : maxTupleSet) {
            Event e1 = tuple.getFirst();
            Event e2 = tuple.getSecond();
            BoolExpr rel = edge(this.getName(), tuple.getFirst(), tuple.getSecond(), ctx);
            enc = ctx.mkAnd(enc, ctx.mkEq(rel, ctx.mkAnd(tuple.getFirst().executes(ctx), tuple.getSecond().executes(ctx))));

            Register reg = ((RegWriter)e1).getModifiedReg();
            enc = ctx.mkAnd(enc, ctx.mkImplies(edge(this.getName(), e1, e2, ctx),
                    ctx.mkEq(((RegWriter)e1).getRegResultExpr(), reg.toZ3Int(e2, ctx))
            ));
        }
        return enc;
    }
}
