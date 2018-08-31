package dartagnan.wmm.relation.basic;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.If;
import dartagnan.program.utils.EventRepository;
import dartagnan.wmm.relation.Relation;

import java.util.Set;

import static dartagnan.utils.Utils.edge;

public class RelCtrl extends Relation {

    public RelCtrl(){
        term = "ctrl";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();

        for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE)){
            for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE)){
                if(!e1.getMainThreadId().equals(e2.getMainThreadId()) || e1.getEId() >= e2.getEId()){
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrl", e1, e2, ctx)));
                }
            }
        }

        for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_IF)){
            Set<Event> branchEvents = ((If) e1).getT1().getEvents();
            branchEvents.addAll(((If) e1).getT2().getEvents());
            for(Event e2 : e1.getMainThread().getEventRepository().getEvents(EventRepository.EVENT_ALL)){
                if(branchEvents.contains(e2)){
                    enc = ctx.mkAnd(enc, edge("ctrlDirect", e1, e2, ctx));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkNot(edge("ctrlDirect", e1, e2, ctx)));
                }
            }
        }

        for(Thread t : program.getThreads()){
            for(Event e1 : t.getEventRepository().getEvents(EventRepository.EVENT_LOAD | EventRepository.EVENT_LOCAL | EventRepository.EVENT_IF)) {
                for(Event e2 : t.getEventRepository().getEvents(EventRepository.EVENT_ALL)){
                    BoolExpr ctrlClause = edge("ctrlDirect", e1, e2, ctx);
                    for(Event e3 : t.getEventRepository().getEvents(EventRepository.EVENT_ALL)) {
                        ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("idd^+", e1, e3, ctx), edge("ctrl", e3, e2, ctx)));
                        if(Relation.EncodeCtrlPo) {
                            ctrlClause = ctx.mkOr(ctrlClause, ctx.mkAnd(edge("ctrl", e1, e3, ctx), edge("po", e3, e2, ctx)));
                        }
                    }
                    enc = ctx.mkAnd(enc, ctx.mkEq(edge("ctrl", e1, e2, ctx), ctrlClause));
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
