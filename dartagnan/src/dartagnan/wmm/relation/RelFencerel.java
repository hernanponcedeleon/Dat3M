package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.Fence;
import dartagnan.program.event.MemEvent;
import dartagnan.utils.Utils;

import java.util.HashMap;
import java.util.Map;
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


    public static BoolExpr encodeBatch(Set<Event> events, Context ctx, Collection<RelFencerel> relations){
        Set<Event> mEvents = events.stream().filter(e -> e instanceof MemEvent).collect(Collectors.toSet());
        Set<Fence> barriers = events.stream().filter(e -> e instanceof Fence).map(e -> (Fence)e).collect(Collectors.toSet());
        Map<String, String> fencerelMap = relations.stream().collect(Collectors.toMap(RelFencerel::getFenceName, RelFencerel::getName));

        BoolExpr enc = ctx.mkTrue();

        for(Event e1 : mEvents) {
            for(Event e2 : mEvents) {
                if(!(e1.getMainThread() == e2.getMainThread() && e1.getEId() < e2.getEId())) {
                    for(Map.Entry<String, String> entry: fencerelMap.entrySet()){
                        enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(entry.getValue(), e1, e2, ctx)));
                    }

                } else {
                    Map<String, BoolExpr> encMap = new HashMap<String, BoolExpr>();
                    for(Fence f : barriers.stream().filter(e -> e.getMainThread() == e1.getMainThread()
                            && e1.getEId() < e.getEId()
                            && e.getEId() < e2.getEId()).collect(Collectors.toSet())) {

                        String fenceName = f.getName();
                        if(!encMap.containsKey(fenceName)){
                            encMap.put(fenceName, ctx.mkFalse());
                        }

                        BoolExpr fenceEnc = encMap.get(fenceName);
                        fenceEnc = ctx.mkOr(fenceEnc, f.executes(ctx));
                        encMap.put(fenceName, fenceEnc);

                        enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(e1.executes(ctx), ctx.mkAnd(f.executes(ctx), e2.executes(ctx))),
                                Utils.edge(fencerelMap.get(fenceName), e1, e2, ctx)));
                    }

                    for(Map.Entry<String, String> entry: fencerelMap.entrySet()){
                        String fenceName = entry.getKey();
                        String fenceRelName = entry.getValue();
                        if(encMap.containsKey(fenceName)){
                            enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(fenceRelName, e1, e2, ctx), encMap.get(fenceName)));
                        } else {
                            enc = ctx.mkAnd(enc, ctx.mkNot(Utils.edge(fenceRelName, e1, e2, ctx)));
                        }
                    }
                }
            }
        }
        return enc;
    }

    public static BoolExpr encodeBatch(Program program, Context ctx, Collection<RelFencerel> relations){
        return encodeBatch(program.getEvents(), ctx, relations);
    }

    protected String getFenceName(){
        return fenceName;
    }
}
