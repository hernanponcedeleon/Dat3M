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
    protected Context ctx;
    protected int encodingMode;

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

    public void initialise(Program program, Context ctx, int encodingMode){
        this.program = program;
        this.ctx = ctx;
        this.encodingMode = encodingMode;
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

    public BoolExpr encode() throws Z3Exception {
        if(isEncoded){
            return ctx.mkTrue();
        }
        isEncoded = true;
        return doEncode();
    }

    protected abstract BoolExpr encodeBasic() throws Z3Exception;

    protected BoolExpr encodeIdl() throws Z3Exception{
        return encodeApprox();
    }

    protected BoolExpr encodeApprox() throws Z3Exception {
        return encodeBasic();
    }

    public BoolExpr encodeIteration(int recGroupId, int iteration){
        return ctx.mkTrue();
    }

    public BoolExpr encodeFinalIteration(int recGroupId, int iteration){
        BoolExpr enc = ctx.mkTrue();
        for(Tuple tuple : encodeTupleSet){
            enc = ctx.mkAnd(enc, ctx.mkEq(
                    Utils.edge(getName(), tuple.getFirst(), tuple.getSecond(), ctx),
                    Utils.edge(getName() + "_" + iteration, tuple.getFirst(), tuple.getSecond(), ctx)
            ));
        }

        return enc;
    }

    protected BoolExpr doEncode(){
        BoolExpr enc = encodeNegations();
        if(!encodeTupleSet.isEmpty()){
            if(encodingMode == FIXPOINT) {
                return ctx.mkAnd(enc, encodeBasic());
            } else if(encodingMode == IDL) {
                return ctx.mkAnd(enc, encodeIdl());
            }
            return ctx.mkAnd(enc, encodeApprox());
        }
        return enc;
    }

    private BoolExpr encodeNegations(){
        BoolExpr enc = ctx.mkTrue();
        if(!encodeTupleSet.isEmpty()){
            Set<Tuple> negations = new HashSet<>(encodeTupleSet);
            negations.removeAll(maxTupleSet);
            for(Tuple tuple : negations){
                enc = ctx.mkAnd(enc, ctx.mkNot(edge(this.getName(), tuple.getFirst(), tuple.getSecond(), ctx)));
            }
            encodeTupleSet.removeAll(negations);
        }
        return enc;
    }
}
