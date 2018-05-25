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
import dartagnan.program.Program;
import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public abstract class Axiom {
        protected Relation rel;

    public Axiom(Relation rel) {
        this.rel = rel;
    }

    public Relation getRel() {
        return rel;
    }
    
    public abstract String write();
        public abstract BoolExpr Consistent(Set<Event> events, Context ctx) throws Z3Exception;
        public abstract BoolExpr Inconsistent(Set<Event> events, Context ctx) throws Z3Exception;


}
