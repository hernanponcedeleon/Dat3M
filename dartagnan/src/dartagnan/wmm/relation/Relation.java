package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
import dartagnan.utils.Utils;
import dartagnan.wmm.utils.Tuple;
import dartagnan.wmm.utils.TupleSet;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Utils.edge;

/**
 *
 * @author Florian Furbach
 */
public abstract class Relation {

    public static final int FIXPOINT    = 0;
    public static final int IDL         = 1;
    public static final int APPROX      = 2;

    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;
    private boolean isNamed;

    protected TupleSet maxTupleSet;
    protected TupleSet encodeTupleSet = new TupleSet();

    protected int recursiveGroupId = 0;
    protected boolean forceUpdateRecursiveGroupId = false;
    protected boolean isRecursive = false;

    protected Program program;

    protected boolean isEncoded = false;

    public Relation() {}

    public Relation(String name) {
        this.name = name;
        isNamed = true;
    }

    public int getRecursiveGroupId(){
        return recursiveGroupId;
    }

    public void setRecursiveGroupId(int id){
        forceUpdateRecursiveGroupId = true;
        recursiveGroupId = id;
    }

    public int updateRecursiveGroupId(int parentId){
        return recursiveGroupId;
    }

    public void initialise(Program program){
        this.program = program;
        this.maxTupleSet = null;
        this.isEncoded = false;
        encodeTupleSet = new TupleSet();
    }

    public abstract TupleSet getMaxTupleSet();

    public TupleSet getMaxTupleSetRecursive(){
        return getMaxTupleSet();
    }

    public void addEncodeTupleSet(TupleSet tuples){
        encodeTupleSet.addAll(tuples);
    }

    public TupleSet getEncodeTupleSet(){
        return encodeTupleSet;
    }

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

    public String getTerm(){
        return term;
    }

    /**
     * This is only used by the parser where a relation is defined and named later.
     * Only use this method before relations depending on this one are encoded!!!
     * @param name
     */
    public Relation setName(String name){
        this.name = name;
        isNamed = true;
        return this;
    }

    public String toString(){
        if(isNamed){
            return name + " := " + term;
        }
        return term;
    }

    public BoolExpr encode(Context ctx, int option) throws Z3Exception {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return doEncode(ctx, option);
    }

    protected abstract BoolExpr encodeBasic(Context ctx) throws Z3Exception;

    protected BoolExpr encodeIdl(Context ctx) throws Z3Exception{
        return encodeApprox(ctx);
    }

    protected BoolExpr encodeApprox(Context ctx) throws Z3Exception {
        return encodeBasic(ctx);
    }

    public BoolExpr encodeIteration(int recGroupId, Context ctx, int iteration){
        return ctx.mkTrue();
    }

    public BoolExpr encodeFinalIteration(int recGroupId, Context ctx, int iteration){
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    Utils.edge(getName(), tuple.getFirst(), tuple.getSecond(), ctx),
                    Utils.edge(getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        return enc;
    }

    protected BoolExpr doEncode(Context ctx, int option){
        BoolExpr enc = encodeNoSet(ctx);
        if(!encodeTupleSet.isEmpty()){
            if(option == FIXPOINT) {
                return ctx.mkAnd(enc, encodeBasic(ctx));
            } else if(option == IDL) {
                return ctx.mkAnd(enc, encodeIdl(ctx));
            }
            return ctx.mkAnd(enc, encodeApprox(ctx));
        }
        return enc;
    }

    private BoolExpr encodeNoSet(Context ctx){
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
