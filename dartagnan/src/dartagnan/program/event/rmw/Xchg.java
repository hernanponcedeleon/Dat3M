package dartagnan.program.event.rmw;

import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.filter.FilterUtils;

import java.util.Collections;

public class Xchg extends MemEvent {

    private Register reg;
    private String atomic;

    public Xchg(Location location, Register register, String atomic) {
        this.loc = location;
        this.reg = register;
        this.atomic = atomic;
        this.condLevel = 0;
        this.memId = hashCode();
        addFilters(
                FilterUtils.EVENT_TYPE_ANY,
                FilterUtils.EVENT_TYPE_MEMORY,
                FilterUtils.EVENT_TYPE_READ,
                FilterUtils.EVENT_TYPE_WRITE,
                FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE,
                FilterUtils.EVENT_TYPE_ATOMIC
        );
    }

    public dartagnan.program.Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("tso") && atomic.equals("_rx")) {
            Register dummyReg = new Register(null);
            RMWLoad load = new RMWLoad(dummyReg, loc, atomic);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);
            load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            RMWStore store = new RMWStore(load, loc, reg, atomic);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);
            store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            return Thread.fromArray(false, load, store, new Local(reg, dummyReg));
        }
        throw new RuntimeException("xchg " + atomic + " is not implemented for " + target);
    }

    public String toString() {
        return String.join("", Collections.nCopies(condLevel, "  ")) + loc + ".xchg(" + atomic + ", " + reg + ")";
    }

    public Register getReg() {
        return reg;
    }

    public Xchg clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        Xchg newXchg = new Xchg(newLoc, newReg, atomic);
        newXchg.setCondLevel(condLevel);
        newXchg.memId = memId;
        newXchg.setUnfCopy(getUnfCopy());
        return newXchg;
    }

    public dartagnan.program.Thread optCompile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method optCompile is not implemented for Xchg");
    }

    public dartagnan.program.Thread allCompile() {
        throw new RuntimeException("Method allCompile is not implemented for Xchg");
    }
}
