package dartagnan.wmm.relation;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import dartagnan.program.Program;
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

    public static final int LFP     = 0;
    public static final int IDL     = 1;
    public static final int APPROX  = 2;

    public static boolean PostFixApprox = false;

    protected String name;
    protected String term;

    protected Program program;
    protected Context ctx;

    protected boolean isEncoded = false;
    private int encodingMode;

    protected TupleSet maxTupleSet;
    protected TupleSet encodeTupleSet = new TupleSet();

    protected int recursiveGroupId = 0;
    protected boolean forceUpdateRecursiveGroupId = false;
    protected boolean isRecursive = false;

    public Relation() {}

    public Relation(String name) {
        this.name = name;
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

    public TupleSet getEncodeTupleSet(){
        return encodeTupleSet;
    }

    public void addEncodeTupleSet(TupleSet tuples){
        encodeTupleSet.addAll(tuples);
    }

    public String getName() {
        if(name != null){
            return name;
        }
        return term;
    }

    public Relation setName(String name){
        this.name = name;
        return this;
    }

    public String getTerm(){
        return term;
    }

    public boolean getIsNamed(){
        return name != null;
    }

    public String toString(){
        if(name != null){
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

    protected BoolExpr encodeLFP() throws Z3Exception {
        if(recursiveGroupId > 0){
            return ctx.mkTrue();
        }
        return encodeApprox();
    }

    protected BoolExpr encodeIDL() throws Z3Exception{
        return encodeApprox();
    }

    protected abstract BoolExpr encodeApprox() throws Z3Exception;

    public BoolExpr encodeIteration(int recGroupId, int iteration){
        return ctx.mkTrue();
    }

    protected BoolExpr doEncode(){
        BoolExpr enc = encodeNegations();
        if(!encodeTupleSet.isEmpty()){
            if(encodingMode == LFP) {
                return ctx.mkAnd(enc, encodeLFP());
            } else if(encodingMode == IDL) {
                return ctx.mkAnd(enc, encodeIDL());
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
