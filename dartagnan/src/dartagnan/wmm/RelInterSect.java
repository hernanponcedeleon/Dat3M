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
public class RelInterSect extends BinaryRelation{

    public RelInterSect(Relation r1, Relation r2, String name) {
        super(r1,r2,name,String.format("(%s&%s)", r1.getName(), r2.getName()));

    }
    
    public RelInterSect(Relation r1, Relation r2) {
        super(r1,r2,String.format("(%s&%s)", r1.getName(), r2.getName()));
    }
    
    @Override
    public BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
            BoolExpr enc=ctx.mkTrue();
            Set<Event> events = program.getMemEvents();
            for(Event e1 : events) {
            for(Event e2 : events) {
                            BoolExpr opt1=Utils.edge(r1.getName(), e1, e2, ctx);
                            if(r1.containsRec) opt1=ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(getName(),e1,e2, ctx), Utils.intCount(r1.getName(),e1,e2, ctx)));
                            BoolExpr opt2=Utils.edge(r2.getName(), e1, e2, ctx);
                            if(r2.containsRec) opt2=ctx.mkAnd(opt2, ctx.mkGt(Utils.intCount(getName(),e1,e2, ctx), Utils.intCount(r2.getName(),e1,e2, ctx)));            
                            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), ctx.mkAnd(opt1,opt2)));
                                
            }
        }
        return enc;
    }

    @Override
    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
            BoolExpr enc=ctx.mkTrue();
            Set<Event> events = program.getMemEvents();
            for(Event e1 : events) {
            for(Event e2 : events) {
                            BoolExpr opt1=Utils.edge(r1.getName(), e1, e2, ctx);
                            BoolExpr opt2=Utils.edge(r2.getName(), e1, e2, ctx);
                            enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), ctx.mkAnd(opt1,opt2)));                                
            }
        }
        return enc;    }


    @Override
    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
//        BoolExpr enc = ctx.mkTrue();
//        Set<Event> events = program.getMemEvents();
//        Expr e1 = ctx.mkConst("e1", program.eventSort);
//        Expr e2 = ctx.mkConst("e2", program.eventSort);
//        Expr evts12[] = {e1, e2};
//        Expr body = ctx.mkAnd(PredicateUtils.getEdge(r1.getName(), e1, e2, ctx), PredicateUtils.getEdge(r2.getName(), e1, e2, ctx));
//        Expr body2 = ctx.mkEq(PredicateUtils.getEdge(name, e1, e2, ctx),body);
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
//        BoolExpr opt1 = PredicateUtils.getEdge(r1.getName(), e1, e2, ctx);
//        if (r1.containsRec) {
//            opt1 = ctx.mkAnd(opt1, ctx.mkGt((IntExpr) PredicateUtils.getBinaryInt(getName(), ctx).apply( e1, e2), (IntExpr) PredicateUtils.getBinaryInt(r1.getName(), ctx).apply( e1, e2)));
//        }
//        BoolExpr opt2 = PredicateUtils.getEdge(r2.getName(), e1, e2, ctx);
//        if (r2.containsRec) {
//            opt2 = ctx.mkAnd(opt2, ctx.mkGt((IntExpr) PredicateUtils.getBinaryInt(getName(), ctx).apply( e1, e2), (IntExpr) PredicateUtils.getBinaryInt(r2.getName(), ctx).apply( e1, e2)));
//        }
//        Expr body = ctx.mkAnd(opt1,opt2);
//
//        Expr body2 = ctx.mkEq(PredicateUtils.getEdge(name, e1, e2, ctx), body);
//        return ctx.mkForall(evts12, body2, 0, null, null, null, null);
    	return null;
    }    
}
