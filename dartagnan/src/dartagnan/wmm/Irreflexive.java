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
import dartagnan.utils.Utils;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public class Irreflexive extends Axiom{

    @Override
    public BoolExpr Consistent(Set<Event> events, Context ctx) throws Z3Exception {
        return Encodings.satIrref(rel.getName(), events, ctx);
    }

    @Override
    public BoolExpr Inconsistent(Set<Event> events, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        for(Event e : events){
            enc = ctx.mkOr(enc, Utils.edge(rel.getName(), e, e, ctx));
        }
        return enc;
    }

    public Irreflexive(Relation rel) {
        super(rel);
    }

    @Override
    public String write() {
        return String.format("Irreflexive(%s)", rel.getName());
    }
    
}
