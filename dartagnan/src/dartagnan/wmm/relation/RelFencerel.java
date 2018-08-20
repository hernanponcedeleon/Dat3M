package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.Thread;
import dartagnan.program.event.Event;
import dartagnan.program.event.Fence;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;

import java.util.stream.Collectors;
import java.util.Collection;

public class RelFencerel extends Relation {

    private String fenceName;

    public RelFencerel(String fenceName) {
        this.fenceName = fenceName;
        term = "fencerel(" + fenceName + ")";
    }

    public RelFencerel(String fenceName, String name) {
        super(name);
        this.fenceName = fenceName;
        term = "fencerel(" + fenceName + ")";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Event e1 : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)) {
            for(Event e2 : program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY)) {
                if(!e1.getMainThreadId().equals(e2.getMainThreadId())){
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));
                }
            }
        }

        for(Thread t : program.getThreads()){
            Collection<Event> threadMemEvents = t.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
            Collection<Fence> threadFences = t.getEventRepository()
                    .getEvents(EventRepository.EVENT_FENCE)
                    .stream()
                    .filter(e -> ((Fence)e).getName().equals(fenceName))
                    .map(e -> (Fence)e).collect(Collectors.toSet());

            if(threadFences.isEmpty()){
                for(Event e1 : threadMemEvents) {
                    for(Event e2 : threadMemEvents) {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));

                    }
                }
            } else {
                for(Event e1 : threadMemEvents) {
                    for(Event e2 : threadMemEvents) {
                        if(e1.getEId() >= e2.getEId()){
                            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));
                        } else {
                            BoolExpr fenceEnc = ctx.mkFalse();
                            for(Fence f : threadFences){
                                if(f.getEId() > e1.getEId() && f.getEId() < e2.getEId()){
                                    fenceEnc = ctx.mkOr(fenceEnc, f.executes(ctx));
                                    enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(f.executes(ctx), e2.executes(ctx))),
                                            Utils.edge(this.getName(), e1, e2, ctx)));
                                }
                            }
                            if(!(fenceEnc.equals(ctx.mkFalse()))){
                                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(this.getName(), e1, e2, ctx), fenceEnc));
                            } else {
                                enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));
                            }
                        }
                    }
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
