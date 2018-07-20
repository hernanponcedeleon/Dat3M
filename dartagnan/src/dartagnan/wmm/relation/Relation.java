package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.event.Event;
import dartagnan.program.event.Fence;
import dartagnan.program.event.MemEvent;
import dartagnan.utils.PredicateUtils;

import java.util.Collection;
import java.util.stream.Collectors;

/**
 *
 * @author Florian Furbach
 */
public abstract class Relation {

    /**
     * Describes whether the encoding process uses an over-approximation which is only suitable for checking consistency, NOT inconsistency.
     */
    public static boolean Approx = false;
    public static boolean CloseApprox = false;
    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;
    protected boolean containsRec;
    protected boolean isNamed;

    /**
     * Creates a relation with an automatically generated identifier.
     */
    public Relation() {}

    /**
     * Creates a relation that is explicitly named either for recursion or readability.
     * @param name (manually chosen)
     */
    public Relation(String name) {
        this.name = name;
        isNamed = true;
    }

    /**
     * @return boolean
     */
    public boolean getIsNamed(){
        return isNamed;
    }

    /**
     *
     * @return the name of the relation (with a prefix if that was set for aramis)
     */
    public String getName() {
        if(isNamed){
            return name;
        }
        return term;
    }

    /**
     * This is only used by the parser where a relation is defined and named later.
     * Only use this method before relations depending on this one are encoded!!!
     * @param name
     */
    public void setName(String name){
        this.name = name;
        isNamed = true;
    }

    /**
     * The term that defines the relation.
     * @return String
     */
    public String toString(){
        if(isNamed){
            return name + " := " + term;
        }
        return term;
    }

    public BoolExpr encode(Collection<Event> events, Context ctx, Collection<String> encodedRels) throws Z3Exception {
        if(encodedRels != null){
            if(encodedRels.contains(this.getName())){
                return ctx.mkTrue();
            }
            encodedRels.add(this.getName());
        }
        return doEncode(events, ctx);
    }

    public BoolExpr encode(Program program, Context ctx, Collection<String> encodedRels) throws Z3Exception {
        return encode(getProgramEvents(program), ctx, encodedRels);
    }

    protected BoolExpr encodeBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodeBasic is not implemented for " + getClass().getCanonicalName());
    }

    protected BoolExpr encodeApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodeApprox is not implemented for " + getClass().getCanonicalName());
    }

    protected BoolExpr encodePredicateBasic(Collection<Event> events, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodePredicateBasic is not implemented for " + getClass().getCanonicalName());
    }

    protected BoolExpr encodePredicateApprox(Collection<Event> events, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodePredicateApprox is not implemented for " + getClass().getCanonicalName());
    }

    protected Collection<Event> getProgramEvents(Program program){
        return program.getEvents().stream().filter(e -> e instanceof MemEvent || e instanceof Fence).collect(Collectors.toSet());
    }

    protected BoolExpr doEncode(Collection<Event> events, Context ctx){
        if(PredicateUtils.getUsePredicate()){
            if(Relation.Approx){
                return encodePredicateApprox(events, ctx);
            }
            return encodePredicateBasic(events, ctx);
        }

        if(Relation.Approx){
            return encodeApprox(events, ctx);
        }
        return encodeBasic(events, ctx);
    }
}
