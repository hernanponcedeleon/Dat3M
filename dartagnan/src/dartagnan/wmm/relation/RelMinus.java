package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public class RelMinus extends BinaryRelation {

    public RelMinus(Relation r1, Relation r2) {
        super(r1, r2);
        term = "(" + r1.getName() + " \\ " + r2.getName() + ")";
        if(r2.containsRec){
            throw new RuntimeException(r2.getName() + " is not allowed to be recursive since it occurs in a setminus.");
        }
    }

    public RelMinus(Relation r1, Relation r2, String name) {
        super(r1, r2, name);
        term = "(" + r1.getName() + " \\ " + r2.getName() + ")";
        if(r2.containsRec){
            throw new RuntimeException(r2.getName() + " is not allowed to be recursive since it occurs in a setminus.");
        }
    }

    @Override
    public BoolExpr encode(Collection<Event> events, Context ctx, Collection<String> encodedRels) throws Z3Exception {
        if(encodedRels != null){
            if(encodedRels.contains(name)){
                return ctx.mkTrue();
            }
            encodedRels.add(getName());
        }
        BoolExpr enc = r1.encode(events, ctx, encodedRels);
        boolean approx = Relation.Approx;
        Relation.Approx = false;
        enc = ctx.mkAnd(enc, r2.encode(events, ctx, encodedRels));
        Relation.Approx = approx;
        return ctx.mkAnd(enc, doEncode(events, ctx));
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
                if (r1.containsRec) {
                    opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e2, ctx)));
                }
                BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
                BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
                if (Relation.PostFixApprox) {
                    enc = ctx.mkAnd(enc, ctx.mkImplies(ctx.mkAnd(opt1, opt2), Utils.edge(this.getName(), e1, e2, ctx)));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));
                }
            }
        }
        return enc;
    }
}
