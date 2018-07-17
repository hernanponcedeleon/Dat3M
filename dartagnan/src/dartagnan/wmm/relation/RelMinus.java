/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Event;
import dartagnan.program.Program;
import dartagnan.utils.PredicateUtils;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.BinaryRelation;
import dartagnan.wmm.relation.Relation;

import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class RelMinus extends BinaryRelation {

    public RelMinus(Relation r1, Relation r2, String name) {
        super(r1, r2, name, String.format("(%s\\%s)", r1.getName(), r2.getName()));
        if(r2.containsRec) System.err.println(r2.getName()+" is not allowed to be recursive since it occurs in a setminus.");
    }

    public RelMinus(Relation r1, Relation r2) {
        super(r1, r2, String.format("(%s\\%s)", r1.getName(), r2.getName()));
        if(r2.containsRec) System.err.println(r2.getName()+" is not allowed to be recursive since it occurs in a setminus.");
    }

    @Override
    public BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> events = program.getMemEvents();
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
    public BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        Set<Event> events = program.getMemEvents();
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

    @Override
    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
    	return null;
    }

    @Override
    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
    	return null;
    }

    @Override
    public BoolExpr encode(Program program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        if (!encodedRels.contains(getName())) {
            encodedRels.add(getName());
            BoolExpr enc = r1.encode(program, ctx, encodedRels);
            //the second relation must not be overapproximated since that would mean the inverse is underapproximated.
            boolean approx = Relation.Approx;
            Relation.Approx = false;
            enc = ctx.mkAnd(enc, r2.encode(program, ctx, encodedRels));
            Relation.Approx = approx;
            if (PredicateUtils.usePredicate) {
                if (Relation.Approx) {
                    return ctx.mkAnd(enc, this.encodePredicateApprox(program, ctx));
                } else {
                    return ctx.mkAnd(enc, this.encodePredicateBasic(program, ctx));
                }
            } else {
                if (Relation.Approx) {
                    return ctx.mkAnd(enc, this.encodeApprox(program, ctx));
                } else {
                    return ctx.mkAnd(enc, this.encodeBasic(program, ctx));
                }
            }
        } else {
            return ctx.mkTrue();
        }
    }
}
