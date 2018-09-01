package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.program.utils.EventRepository;
import dartagnan.utils.PredicateUtils;
import dartagnan.wmm.relation.utils.Tuple;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.edge;

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
    public static boolean EncodeCtrlPo = true; // depends on target architecture

    protected String name;
    protected String term;
    protected boolean containsRec;
    protected boolean isNamed;
    protected int eventMask = EventRepository.EVENT_MEMORY | EventRepository.EVENT_RCU;
    protected Set<Tuple> maxTupleSet;
    protected Set<Tuple> encodeTupleSet = new HashSet<>();

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

    public Relation setEventMask(int mask){
        this.eventMask = mask;
        return this;
    }

    public abstract Set<Tuple> getMaxTupleSet(Program program);

    public void addEncodeTupleSet(Set<Tuple> tuples){
        encodeTupleSet.addAll(tuples);
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

    public BoolExpr encode(Program program, Context ctx, Collection<String> encodedRels) throws Z3Exception {
        if(encodedRels != null){
            if(encodedRels.contains(this.getName())){
                return ctx.mkTrue();
            }
            encodedRels.add(this.getName());
        }
        return doEncode(program, ctx);
    }

    protected BoolExpr encodeBasic(Program program, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodeBasic is not implemented for " + getClass().getName());
    }

    protected BoolExpr encodeApprox(Program program, Context ctx) throws Z3Exception {
        return encodeBasic(program, ctx);
    }

    protected BoolExpr encodePredicateBasic(Program program, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodePredicateBasic is not implemented for " + getClass().getName());
    }

    protected BoolExpr encodePredicateApprox(Program program, Context ctx) throws Z3Exception {
        throw new RuntimeException("Method encodePredicateApprox is not implemented for " + getClass().getName());
    }

    protected BoolExpr doEncode(Program program, Context ctx){
        BoolExpr enc = encodeNoSet(ctx);

        if(!encodeTupleSet.isEmpty()){
            if(PredicateUtils.getUsePredicate()){
                if(Relation.Approx){
                    return ctx.mkAnd(enc, encodePredicateApprox(program, ctx));
                }
                return ctx.mkAnd(enc, encodePredicateBasic(program, ctx));
            }

            if(Relation.Approx){
                return ctx.mkAnd(enc, encodeApprox(program, ctx));
            }
            return ctx.mkAnd(enc, encodeBasic(program, ctx));
        }
        return enc;
    }

    protected BoolExpr encodeNoSet(Context ctx){
        BoolExpr enc = ctx.mkTrue();
        if(!encodeTupleSet.isEmpty()){
            Set<Tuple> noTupleSet = new HashSet<>(encodeTupleSet);
            noTupleSet.removeAll(maxTupleSet);
            for(Tuple tuple : noTupleSet){
                enc = ctx.mkAnd(enc, ctx.mkNot(edge(this.getName(), tuple.getFirst(), tuple.getSecond(), ctx)));
            }
            encodeTupleSet.removeAll(noTupleSet);
        }
        return enc;
    }
}
