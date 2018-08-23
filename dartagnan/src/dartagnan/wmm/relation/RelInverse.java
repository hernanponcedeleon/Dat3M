package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;

import java.util.Collection;

/**
 *
 * @author Florian Furbach
 */
public class RelInverse extends UnaryRelation {

    public RelInverse(Relation r1){
        super(r1);
        term = r1.getName() + "^-1";
    }

    public RelInverse(Relation r1, String name) {
        super(r1, name);
        term = r1.getName() + "^-1";
    }

    @Override
    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        Collection<Event> events = program.getEventRepository().getEvents(this.eventMask);
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                //allow for recursion in r1:
                BoolExpr temp = Utils.edge(r1.getName(), e2, e1, ctx);
                if(r1.containsRec) temp = ctx.mkAnd(temp, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e2, e1, ctx)));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx),temp));
            }
        }
        return enc;
    }

    
    @Override
    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        Collection<Event> events = program.getEventRepository().getEvents(this.eventMask);
        BoolExpr enc = ctx.mkTrue();
        for (Event e1 : events) {
            for (Event e2 : events) {
                //allow for recursion in r1:
                BoolExpr temp = Utils.edge(r1.getName(), e2, e1, ctx);
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), temp));
            }
        }
        return enc;
    }
}
    

