package dartagnan.program.event.rmw;

import dartagnan.expression.ExprInterface;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Load;
import dartagnan.program.event.Local;
import dartagnan.program.event.filter.FilterUtils;

import java.util.Collections;

public class Xchg extends AbstractRMW {

    private Register dummyReg = new Register(null);
    private ExprInterface value;

    public Xchg(Location location, Register register, ExprInterface value, String atomic) {
        super(location, register, atomic);
        this.value = value;
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
        return String.join("", Collections.nCopies(condLevel, "  ")) + loc + ".xchg(" + atomic + ", " + reg + ")";
    }

    // TODO: Should we clone loc, reg, value?
    public Xchg clone() {
        Xchg newXchg = new Xchg(loc, reg, value, atomic);
        newXchg.setCondLevel(condLevel);
        newXchg.memId = memId;
        newXchg.setUnfCopy(getUnfCopy());
        return newXchg;
    }

    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("sc") || (target.equals("tso") && atomic.equals("_rx"))) {

            // For TSO xchg or instructions like "r0 = atomic_xchg(x,r0)" we need an additional dummy register
            // Otherwise we can write directly to the result and skip one Local event
            Register loadReg = reg == value ? dummyReg : reg;

            String loadMO = atomic.equals("_acq") ? "_acq" : "_rx";
            Load load = new Load(loadReg, loc, loadMO);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);
            load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            String storeMO = atomic.equals("_rel") ? "_rel" : "_rx";
            RMWStore store = new RMWStore(load, loc, value, storeMO);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);
            store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            Seq result = new Seq(load, store);
            if (loadReg != reg) {
                result = new Seq(result, new Local(reg, loadReg));
            }

            if (atomic.equals("_mb")) {
                result = new Seq(new Seq(new Fence("Mb"), result), new Fence("Mb"));
            }
            return result;
        }

        throw new RuntimeException("xchg " + atomic + " is not implemented for " + target);
    }

    public Thread optCompile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method optCompile is not implemented for Xchg");
    }

    public Thread allCompile() {
        throw new RuntimeException("Method allCompile is not implemented for Xchg");
    }
}
