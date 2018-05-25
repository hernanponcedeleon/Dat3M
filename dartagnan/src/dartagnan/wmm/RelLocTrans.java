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
import dartagnan.program.Local;
import dartagnan.program.MemEvent;
import dartagnan.program.Program;
import dartagnan.utils.PredicateUtils;
import dartagnan.utils.Utils;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author Florian Furbach
 */
public class RelLocTrans extends UnaryRelation {

    public RelLocTrans(Relation r1) {
        super(r1, String.format("%s^+", r1.getName()));
    }

    @Override
    public BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
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
                if (r1.containsRec) {
                    orr1 = ctx.mkAnd(orr1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx), Utils.intCount(r1.getName(), e1, e2, ctx)));
                }
                //enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), e1, e2, ctx), orClause));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkOr(orTrans, orr1)));
            }
        }
        return enc;
    }

    @Override
    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        BoolExpr orclose1 = ctx.mkFalse();
        BoolExpr orclose2 = ctx.mkFalse();
        Set<Event> events = program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Local).collect(Collectors.toSet());
        for (Event e1 : events) {
            for (Event e2 : events) {
                //transitive
                BoolExpr orClause = ctx.mkFalse();
                for (Event e3 : events) {
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(getName(), e1, e3, ctx), Utils.edge(getName(), e3, e2, ctx)));
                    if (Relation.CloseApprox) {
                        orclose1 = ctx.mkOr(orclose1, Utils.edge(r1.getName(), e1, e3, ctx));
                        orclose2 = ctx.mkOr(orclose2, Utils.edge(r1.getName(), e3, e2, ctx));
                    }
                }
                //original relation
                orClause = ctx.mkOr(orClause, Utils.edge(r1.getName(), e1, e2, ctx));
                //putting it together:
                if (Relation.CloseApprox) {
                    enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkAnd(orclose1, orclose2)));
                }
                if (Relation.PostFixApprox) {
                    enc = ctx.mkAnd(enc, ctx.mkImplies(orClause, Utils.edge(this.getName(), e1, e2, ctx)));
                } else {
                    enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), orClause));
                }

            }
        }
        return enc;
    }

    @Override
    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
//        BoolExpr enc = ctx.mkTrue();
//        Expr e1 = ctx.mkConst("e1", program.eventSort);
//        Expr e2 = ctx.mkConst("e2", program.eventSort);
//        Expr e3 = ctx.mkConst("e3", program.eventSort);
//        Expr evts3[] = {e3};
//        Expr evts12[] = {e1, e2};
//        Expr body = ctx.mkAnd(PredicateUtils.getEdge(this.getName(), e1, e3, ctx), PredicateUtils.getEdge(this.getName(), e3, e2, ctx));
//
//        Expr body2 = ctx.mkEq(PredicateUtils.getEdge(name, e1, e2, ctx), ctx.mkOr(PredicateUtils.getEdge(r1.getName(), e1, e2, ctx), ctx.mkExists(evts3, body, 0, null, null, null, null)));
//        return ctx.mkForall(evts12, body2, 0, null, null, null, null);
    	return null;
    }

    @Override
    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
//        BoolExpr enc = ctx.mkTrue();
//        Expr e1 = ctx.mkConst("e1", program.eventSort);
//        Expr e2 = ctx.mkConst("e2", program.eventSort);
//        Expr e3 = ctx.mkConst("e3", program.eventSort);
//        Expr evts3[] = {e3};
//        Expr evts12[] = {e1, e2};
//        //r+(e1,e3) and r+(e3,e2)=r+;r+(e1,e2) +integer r+ before r+;r+
//        BoolExpr opt1 = PredicateUtils.getEdge(this.getName(), e1, e3, ctx);
//        IntExpr inte1e2 = (IntExpr) PredicateUtils.getBinaryInt(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), ctx).apply(e1, e2);
//        IntExpr inte1e3 = (IntExpr) PredicateUtils.getBinaryInt(r1.getName(), ctx).apply(e1, e3);
//        opt1 = ctx.mkAnd(opt1, ctx.mkGt(inte1e2, inte1e3));
//        BoolExpr opt2 = PredicateUtils.getEdge(this.getName(), e3, e2, ctx);
//        opt2 = ctx.mkAnd(opt2, ctx.mkGt((IntExpr) PredicateUtils.getBinaryInt(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), ctx).apply(e1, e2), (IntExpr) PredicateUtils.getBinaryInt(r1.getName(), ctx).apply(e3, e2)));
//        BoolExpr body = ctx.mkAnd(opt1, opt2);
//        body = ctx.mkExists(evts3, body, 0, null, null, null, null);
//        body = ctx.mkEq(PredicateUtils.getEdge(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), e1, e2, ctx), body);
//
//        //r+(e1,e2)=r+;r+(e1,e2) or r(e1,e2)
//        BoolExpr fromr1 = ctx.mkAnd(PredicateUtils.getEdge(r1.getName(), e1, e2, ctx), ctx.mkGt((IntExpr) PredicateUtils.getBinaryInt(this.getName(), ctx).apply(e1, e2), (IntExpr) PredicateUtils.getBinaryInt(r1.getName(), ctx).apply(e1, e2)));
//        BoolExpr fromconcat = ctx.mkAnd(PredicateUtils.getEdge(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), e1, e2, ctx),
//                ctx.mkGt((IntExpr) PredicateUtils.getBinaryInt(this.getName(), ctx).apply(e1, e2), (IntExpr) PredicateUtils.getBinaryInt(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), ctx).apply(e1, e2)));
//
//        BoolExpr body2 = ctx.mkEq(PredicateUtils.getEdge(this.getName(), e1, e2, ctx), ctx.mkOr(fromr1, fromconcat));
//
//        return ctx.mkForall(evts12, ctx.mkAnd(body, body2), 0, null, null, null, null);
    	return null;
    }
}
