package dartagnan.program.rmw;

import dartagnan.program.*;
import dartagnan.utils.LastModMap;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class Xchg extends AbstractRMW {

    private Register dummyReg = new Register("DUMMY_REG_" + hashCode());

    public Xchg(Location location, Register register, String atomic) {
        super(location, register, atomic);
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
            Load load = new Load(dummyReg, loc);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);

            RMWStore store = new RMWStore(load, loc, reg);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);

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
