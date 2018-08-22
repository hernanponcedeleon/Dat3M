package dartagnan.program.event.rmw;

import dartagnan.expression.AExpr;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Load;
import dartagnan.program.event.filter.FilterUtils;

import java.util.Collections;

// TODO: After removing "extra" register in C parser, handle a situation when value == register,
// e.g. C-atomic-fetch-simple-05.litmus

public class RMWFetchOp extends AbstractRMW {

    private ExprInterface value;
    private String op;

    public RMWFetchOp(Location location, Register register, ExprInterface value, String op, String atomic) {
        super(location, register, atomic);
        this.value = value;
        this.op = op;
        addFilters(
                FilterUtils.EVENT_TYPE_ANY,
                FilterUtils.EVENT_TYPE_MEMORY,
                FilterUtils.EVENT_TYPE_READ,
                FilterUtils.EVENT_TYPE_WRITE,
                FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE,
                FilterUtils.EVENT_TYPE_ATOMIC
        );
    }

    public String toString() {
        return String.join("", Collections.nCopies(condLevel, "  "))
                + reg + " := atomic_fetch_" + opToText(op) + atomicToString(atomic) + "(" + value + ", " + loc + ")";
    }

    // TODO: Should we clone loc, reg, value?
    public RMWFetchOp clone() {
        RMWFetchOp newOp = new RMWFetchOp(loc, reg, value, op, atomic);
        newOp.setCondLevel(condLevel);
        newOp.memId = memId;
        newOp.setUnfCopy(getUnfCopy());
        return newOp;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {

        // Linux without real compilation
        if(target.equals("sc")) {
            String loadMO = atomic.equals("_acq") ? "_acq" : "_rx";
            Load load = new Load(reg, loc, loadMO);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);
            load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            String storeMO = atomic.equals("_rel") ? "_rel" : "_rx";
            RMWStore store = new RMWStore(load, loc, new AExpr(reg, op, value), storeMO);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);
            store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            Seq result = new Seq(load, store);
            if(atomic.equals("_mb")){
                result = new Seq(new Seq(new Fence("Mb"), result), new Fence("Mb"));
            }
            return result;
        }

        throw new RuntimeException("OpReturn " + atomic + " is not implemented for " + target);
    }

    public Thread optCompile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method optCompile is not implemented for " + this.getClass().getName());
    }

    public Thread allCompile() {
        throw new RuntimeException("Method allCompile is not implemented for " + this.getClass().getName());
    }

    private String opToText(String op){
        switch (op){
            case "+":
                return "add";
            case "-":
                return "sub";
            default:
                throw new RuntimeException("Unsupported operation " + op + " in " + this.getClass().getName());
        }
    }

    private String atomicToString(String atomic){
        switch (atomic){
            case "_rx":
                return "_relaxed";
            case "_acq":
                return "_acquire";
            case "_rel":
                return "_release";
            case "_mb":
                return "";
            default:
                throw new RuntimeException("Unsupported memory order " + atomic + " in " + this.getClass().getName());
        }
    }
}