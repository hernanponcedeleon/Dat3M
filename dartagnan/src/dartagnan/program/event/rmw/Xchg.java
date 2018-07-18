package dartagnan.program.event.rmw;

import dartagnan.program.*;
import dartagnan.program.event.Event;
import dartagnan.program.event.Load;
import dartagnan.program.event.Local;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.utils.LastModMap;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class Xchg extends AbstractRMW {

    private Register dummyReg = new Register("DUMMY_REG_" + hashCode());

    public Xchg(Location location, Register register, String atomic) {
        super(location, register, atomic);
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

    public LastModMap setLastModMap(LastModMap map) {
        this.lastModMap = map;
        LastModMap retMap = map.clone();
        Set<Event> set = new HashSet<Event>();
        set.add(this);
        retMap.put(loc, set);
        retMap.put(reg, set);
        retMap.put(dummyReg, set);
        return retMap;
    }

    public Xchg clone() {
        Xchg newXchg = new Xchg(loc, reg, atomic);
        newXchg.setCondLevel(condLevel);
        newXchg.memId = memId;
        newXchg.setUnfCopy(getUnfCopy());
        return newXchg;
    }

    public dartagnan.program.Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("tso") && atomic.equals("_rx")) {
            Load load = new Load(dummyReg, loc, atomic);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);
            load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            RMWStore store = new RMWStore(load, loc, reg, atomic);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);
            store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

            return new Seq(new Seq(load, store), new Local(reg, dummyReg));
        }
        throw new RuntimeException("Xchg " + atomic + " is not implemented for " + target);
    }

    public dartagnan.program.Thread optCompile(String target, boolean ctrl, boolean leading) {
        throw new RuntimeException("Method optCompile is not implemented for Xchg");
    }

    public dartagnan.program.Thread allCompile() {
        throw new RuntimeException("Method allCompile is not implemented for Xchg");
    }
}
