package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
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
        Collection<Event> mEvents = program.getEventRepository().getEvents(EventRepository.EVENT_MEMORY);
        Collection<Fence> barriers = program.getEventRepository().getEvents(EventRepository.EVENT_FENCE).stream().map(e -> (Fence)e).collect(Collectors.toSet());

        BoolExpr enc = ctx.mkTrue();

        for(Event e1 : mEvents) {
            for(Event e2 : mEvents) {
                if(!(e1.getMainThreadId() == e2.getMainThreadId() && e1.getEId() < e2.getEId())) {
                    enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(this.getName(), e1, e2, ctx)));

                } else {
                    BoolExpr fenceEnc = ctx.mkFalse();

                    for(Fence f : barriers.stream().filter(e -> e.getMainThreadId() == e1.getMainThreadId()
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
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }

    protected String getFenceName(){
        return fenceName;
    }
}
