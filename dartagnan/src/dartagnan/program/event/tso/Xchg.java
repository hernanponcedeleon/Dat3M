package dartagnan.program.event.tso;

import dartagnan.program.Location;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.rmw.RMWLoad;
import dartagnan.program.event.rmw.RMWStore;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.tso.EType;

import java.util.HashSet;
import java.util.Set;

public class Xchg extends MemEvent implements RegWriter, RegReaderData {

    private Register reg;
    private String atomic;

    public Xchg(Location location, Register register, String atomic) {
        this.loc = location;
        this.reg = register;
        this.atomic = atomic;
        this.condLevel = 0;
        this.memId = hashCode();
        addFilters(EType.ANY, EType.MEMORY, EType.READ, EType.WRITE, EType.ATOM);
    }

    @Override
    public Register getModifiedReg(){
        return reg;
    }

    @Override
    public Set<Register> getDataRegs(){
        Set<Register> regs = new HashSet<>();
        regs.add(reg);
        return regs;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        if(target.equals("tso") && atomic.equals("_rx")) {
            Register dummyReg = new Register(null);
            RMWLoad load = new RMWLoad(dummyReg, loc, atomic);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);
            load.addFilters(EType.ATOM);

            RMWStore store = new RMWStore(load, loc, reg, atomic);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);
            store.addFilters(EType.ATOM);

            return Thread.fromArray(false, load, store, new Local(reg, dummyReg));
        }
        throw new RuntimeException("xchg " + atomic + " is not implemented for " + target);
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + loc + ".xchg(" + atomic + ", " + reg + ")";
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
