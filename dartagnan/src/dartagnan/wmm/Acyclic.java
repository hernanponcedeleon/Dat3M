/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm;

import com.microsoft.z3.ArithExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Event;
import dartagnan.utils.PredicateUtils;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

    @Override
    public BoolExpr Consistent(Set<Event> events, Context ctx) throws Z3Exception {
//        if (PredicateUtils.usePredicate) {
//            BoolExpr enc = ctx.mkTrue();
//            Expr e1 = ctx.mkConst("e1", PredicateUtils.getCurrentProg().eventSort);
//            Expr e2 = ctx.mkConst("e2", PredicateUtils.getCurrentProg().eventSort);
//            Expr evts12[] = {e1, e2};
//            Expr body = ctx.mkImplies(PredicateUtils.getEdge(rel.getName(), e1, e2, ctx),ctx.mkGt((ArithExpr) PredicateUtils.getUnaryInt(rel.getName(),ctx).apply(e2), (ArithExpr) PredicateUtils.getUnaryInt(rel.getName(),ctx).apply(e1)));
//            return ctx.mkForall(evts12, body, 0, null, null, null, null);
//        } else {
          return Encodings.satAcyclic(rel.getName(), events, ctx);
//        }
    }

    @Override
    public BoolExpr Inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        return ctx.mkAnd(Encodings.satCycleDef(rel.getName(), events, ctx), Encodings.satCycle(rel.getName(), events, ctx));
    }

    public Acyclic(Relation rel) {
        super(rel);
    }

    @Override
    public String write() {
        return String.format("Acyclic(%s)", rel.getName());
    }

}
