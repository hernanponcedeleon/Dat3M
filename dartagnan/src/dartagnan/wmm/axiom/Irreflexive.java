/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.utils.Utils;
import dartagnan.wmm.relation.Relation;

import static dartagnan.wmm.EncodingsCAT.satIrref;

import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class Irreflexive extends Axiom {

    public Irreflexive(Relation rel) {
        super(rel);
    }

    public Irreflexive(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    protected BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception {
        return satIrref(rel.getName(), events, ctx);
    }

    @Override
    protected BoolExpr _inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Event e : events){
            enc = ctx.mkOr(enc, Utils.edge(rel.getName(), e, e, ctx));
        }
        return enc;
    }

    @Override
    protected String _toString() {
        return String.format("irreflexive %s", rel.getName());
    }
}
