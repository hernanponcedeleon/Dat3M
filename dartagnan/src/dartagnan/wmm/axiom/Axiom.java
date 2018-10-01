package dartagnan.wmm.axiom;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.event.Event;
import dartagnan.wmm.relation.Relation;
import dartagnan.wmm.utils.TupleSet;

import java.util.Set;

/**
 *
 * @author Florian Furbach
 */
public abstract class Axiom {

    protected Relation rel;

    private boolean negate = false;

    public Axiom(Relation rel) {
        this.rel = rel;
    }

    public Axiom(Relation rel, boolean negate) {
        this.rel = rel;
        this.negate = negate;
    }

    public Relation getRel() {
        return rel;
    }

    public BoolExpr consistent(Set<Event> events, Context ctx) throws Z3Exception{
        if(negate){
            return _inconsistent(events, ctx);
        }
        return _consistent(events, ctx);
    }

    public BoolExpr inconsistent(Set<Event> events, Context ctx) throws Z3Exception{
        if(negate){
            return _consistent(events, ctx);
        }
        return _inconsistent(events, ctx);
    }

    public String toString(){
        if(negate){
            return "~" + _toString();
        }
        return _toString();
    }

    public abstract TupleSet getEncodeTupleSet();

    protected abstract BoolExpr _consistent(Set<Event> events, Context ctx) throws Z3Exception;

    protected abstract BoolExpr _inconsistent(Set<Event> events, Context ctx) throws Z3Exception;

    protected abstract String _toString();
}
