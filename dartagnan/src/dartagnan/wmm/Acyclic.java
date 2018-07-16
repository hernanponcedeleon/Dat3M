/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dartagnan.wmm;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Event;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class Acyclic extends Axiom {

    public Acyclic(Relation rel) {
        super(rel);
    }

    public Acyclic(Relation rel, boolean negate) {
        super(rel, negate);
    }

    @Override
    protected BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception {
        return Encodings.satAcyclic(rel.getName(), events, ctx);
    }

    @Override
    protected BoolExpr _inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        return ctx.mkAnd(Encodings.satCycleDef(rel.getName(), events, ctx), Encodings.satCycle(rel.getName(), events, ctx));
    }

    @Override
    protected String _toString() {
        return String.format("acyclic %s", rel.getName());
    }
}
