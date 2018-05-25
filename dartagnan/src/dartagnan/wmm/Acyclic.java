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

    @Override
    public BoolExpr Consistent(Set<Event> events, Context ctx) throws Z3Exception {
          return Encodings.satAcyclic(rel.getName(), events, ctx);
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
