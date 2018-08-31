package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.linux.rcu.RCUReadLock;
import dartagnan.program.event.linux.rcu.RCUReadUnlock;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;

import static dartagnan.utils.Utils.edge;

public class RelCrit extends Relation {

    public RelCrit(){
        term = "crit";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_VISIBLE)){
            for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_VISIBLE)){
                if(!e1.getMainThreadId().equals(e2.getMainThreadId()) || e1.getEId() >= e2.getEId()){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("crit", e1, e2, ctx)));
                }
            }
        }

        for(Event unlock : program.getEventRepository().getEvents(EventRepository.EVENT_RCU_UNLOCK)){
            RCUReadLock myLock = ((RCUReadUnlock)unlock).getLockEvent();
            enc = ctx.mkAnd(enc, edge("crit", myLock, unlock, ctx));
            for(Event lock : program.getEventRepository().getEvents(EventRepository.EVENT_RCU_LOCK)){
                if(!lock.equals(myLock)){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("crit", lock, unlock, ctx)));
                }
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }
}
