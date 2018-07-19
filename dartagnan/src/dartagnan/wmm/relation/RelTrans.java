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
public class RelTrans extends UnaryRelation {

    public RelTrans(Relation r1) {
        super(r1, String.format("%s^+", r1.getName()));
    }

    @Override
    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                BoolExpr orTrans = ctx.mkFalse();
                for (Event e3 : events) {
                    //e1e2 caused by transitivity:
                    orTrans = ctx.mkOr(orTrans, ctx.mkAnd(Utils.edge(this.getName(), e1, e3, ctx), Utils.edge(this.getName(), e3, e2, ctx),
                            ctx.mkGt(Utils.intCount(String.format(this.getName()), e1, e2, ctx), Utils.intCount(this.getName(), e1, e3, ctx)),
                            ctx.mkGt(Utils.intCount(String.format(this.getName()), e1, e2, ctx), Utils.intCount(this.getName(), e3, e2, ctx))));
                }
                //r(e1,e2) caused by r1:
                BoolExpr orr1 = Utils.edge(r1.getName(), e1, e2, ctx);
                //allow for recursion in r1:
                if(r1.containsRec){
                    orr1 = ctx.mkAnd(orr1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e2, ctx)));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkOr(orTrans, orr1)));
            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        BoolExpr orclose1 = ctx.mkFalse();
        BoolExpr orclose2 = ctx.mkFalse();

        for (Event e1 : events) {
            for (Event e2 : events) {
                //transitive
                BoolExpr orClause = ctx.mkFalse();
                for (Event e3 : events) {
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(getName(), e1, e3, ctx), Utils.edge(getName(), e3, e2, ctx)));
                    if(Relation.CloseApprox){
                        orclose1 = ctx.mkOr(orclose1, Utils.edge(r1.getName(), e1, e3, ctx));
                        orclose2 = ctx.mkOr(orclose2, Utils.edge(r1.getName(), e3, e2, ctx));
                    }
                }
                //original relation
                orClause = ctx.mkOr(orClause, Utils.edge(r1.getName(), e1, e2, ctx));
                //putting it together:
                if(Relation.CloseApprox){
                	enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(getName(), e1, e2, ctx), ctx.mkAnd(orclose1, orclose2)));
                }
                if(Relation.PostFixApprox) {
                	enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, Utils.edge(getName(), e1, e2, ctx)));
                } else {
                	enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), orClause));
                }
            }
        }
        return enc;
    }
}