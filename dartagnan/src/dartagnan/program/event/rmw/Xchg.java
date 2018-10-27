package dartagnan.program.event.rmw;

import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.filter.FilterUtils;

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

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
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

    @Override
    public String toString() {
        return nTimesCondLevel() + loc + ".xchg(" + atomic + ", " + reg + ")";
    }

    @Override
    public Register getReg() {
        return reg;
    }

    @Override
    public Xchg clone() {
        Location newLoc = loc.clone();
        Register newReg = reg.clone();
        Xchg newXchg = new Xchg(newLoc, newReg, atomic);
        newXchg.setCondLevel(condLevel);
        newXchg.memId = memId;
        newXchg.setUnfCopy(getUnfCopy());
        return newXchg;
    }
}
