/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Event;
import dartagnan.program.Program;
import dartagnan.utils.PredicateUtils;
import dartagnan.utils.Utils;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelInverse extends UnaryRelation {

    public RelInverse(Relation r1) {
        super(r1,String.format("%s^+", r1.getName()));
    }

    @Override
    public BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> events = program.getMemEvents();
        for (Event e1 : events) {
            for (Event e2 : events) {
                //allow for recursion in r1:
                BoolExpr temp=Utils.edge(this.getName(), e2, e1, ctx);
                if(r1.containsRec) temp=ctx.mkAnd(temp,ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e2, e1, ctx)));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx),temp));
            }
        }
        return enc;
    }

    
    @Override
    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> events = program.getMemEvents();
        for (Event e1 : events) {
            for (Event e2 : events) {
                //allow for recursion in r1:
                BoolExpr temp=Utils.edge(this.getName(), e2, e1, ctx);
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx),temp));
            }
        }
        return enc;
    }
    
    
    
    @Override
    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
//        BoolExpr enc = ctx.mkTrue();
//        Set<Event> events = program.getMemEvents();
//        Expr e1 = ctx.mkConst("e1", program.eventSort);
//        Expr e2 = ctx.mkConst("e2", program.eventSort);
//        Expr evts12[] = {e1, e2};
//        Expr body2 = ctx.mkEq(PredicateUtils.getEdge(this.getName(), e1, e2, ctx), PredicateUtils.getEdge(r1.getName(), e2, e1, ctx));
//        return ctx.mkForall(evts12, body2, 0, null, null, null, null);
    	return null;
    }
    
    @Override
    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
//        BoolExpr enc = ctx.mkTrue();
//        Set<Event> events = program.getMemEvents();
//        Expr e1 = ctx.mkConst("e1", program.eventSort);
//        Expr e2 = ctx.mkConst("e2", program.eventSort);
//        Expr evts12[] = {e1, e2};
//        BoolExpr body = PredicateUtils.getEdge(r1.getName(), e2, e1, ctx);
//        BoolExpr temp=ctx.mkGt((IntExpr) PredicateUtils.getBinaryInt(this.getName(),ctx).apply(e1, e2), (IntExpr) PredicateUtils.getBinaryInt(r1.getName(),ctx).apply(e2, e1));
//        body = ctx.mkAnd(temp, body);
//        body = ctx.mkEq(PredicateUtils.getEdge(this.getName(), e1, e2, ctx), body);
//        return ctx.mkForall(evts12, body, 0, null, null, null, null);
    	return null;
    }
}
    

