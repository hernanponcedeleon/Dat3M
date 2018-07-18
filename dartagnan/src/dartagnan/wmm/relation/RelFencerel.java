package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.Fence;
import dartagnan.program.event.MemEvent;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.Collection;

import static dartagnan.utils.Utils.edge;

public class RelFencerel extends Relation {

    private String fenceName;

    public RelFencerel(String fenceName, String name, String term) {
        super(name, term);
        this.fenceName = fenceName;
    }

    public RelFencerel(String fenceName, String name) {
        this(fenceName, name, "fencerel(" + fenceName + ")");
    }

    public String getFenceName(){
        return fenceName;
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
                        enc = ctx.mkAnd(enc, ctx.mkNot(edge(entry.getValue(), e1, e2, ctx)));
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
                                edge(fencerelMap.get(fenceName), e1, e2, ctx)));
                    }

                    for(Map.Entry<String, String> entry: fencerelMap.entrySet()){
                        String fenceName = entry.getKey();
                        String fenceRelName = entry.getValue();
                        if(encMap.containsKey(fenceName)){
                            enc = ctx.mkAnd(enc, ctx.mkImplies(edge(fenceRelName, e1, e2, ctx), encMap.get(fenceName)));
                        } else {
                            enc = ctx.mkAnd(enc, ctx.mkNot(edge(fenceRelName, e1, e2, ctx)));
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

    public BoolExpr encode(Set<Event> events, Context ctx) throws Z3Exception {
        throw new RuntimeException("Encode of single relation is not implemented for Fencerel");
    }

    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        return encode(program.getEvents(), ctx);
    }

    public BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception{
        return this.encodeBasic(program, ctx);
    }

    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception{
        return this.encodeBasic(program, ctx);
    }

    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
        return null;
    }

    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception{
        return null;
    }
}
