package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.Fence;
import dartagnan.program.event.MemEvent;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.Utils;

import java.util.Set;
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
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        Set<Event> mEvents = events.stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
        Set<Fence> barriers = events.stream().filter(e -> e instanceof Fence).map(e -> (Fence)e).collect(Collectors.toSet());

        BoolExpr enc = ctx.mkTrue();

        for(Event e1 : mEvents) {
            for(Event e2 : mEvents) {
                if(!(e1.getMainThread() == e2.getMainThread() && e1.getEId() < e2.getEId())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));

                } else {
                    BoolExpr fenceEnc = ctx.mkFalse();

                    for(Fence f : barriers.stream().filter(e -> e.getMainThread() == e1.getMainThread()
                            && e1.getEId() < e.getEId()
                            && e.getEId() < e2.getEId()
                            && e.getName().equals(getFenceName())).collect(Collectors.toSet())) {

                        fenceEnc = ctx.mkOr(fenceEnc, f.executes(ctx));
                        enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(f.executes(ctx), e2.executes(ctx))),
                                Utils.edge(this.getName(), e1, e2, ctx)));
                    }

                    if(!(fenceEnc.equals(ctx.mkFalse()))){
                        enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(this.getName(), e1, e2, ctx), fenceEnc));
                    } else {
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));
                    }
                }
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        return encodeBasic(events, ctx);
    }

    protected Collection<Event> getProgramEvents(Program program){
        return program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY | EventRepository.EVENT_FENCE);
    }

    protected String getFenceName(){
        return fenceName;
    }
}
