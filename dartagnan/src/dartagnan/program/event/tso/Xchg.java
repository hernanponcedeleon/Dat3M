package dartagnan.program.event.tso;

import dartagnan.program.event.rmw.RMWLoadFromAddress;
import dartagnan.program.event.rmw.RMWStoreToAddress;
import dartagnan.program.memory.Address;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.Local;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.utils.RegReaderData;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.tso.EType;

import java.util.HashSet;
import java.util.Set;

public class Xchg extends MemEvent implements RegWriter, RegReaderData {

    private Register reg;
    private String atomic;

    public Xchg(Address address, Register register, String atomic) {
        this.address = address;
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
            RMWLoadFromAddress load = new RMWLoadFromAddress(dummyReg, address, atomic);
            load.setHLId(memId);
            load.setUnfCopy(getUnfCopy());
            load.setCondLevel(condLevel);
            load.addFilters(EType.ATOM);
            load.setMaxLocationSet(locations);

            RMWStoreToAddress store = new RMWStoreToAddress(load, address, reg, atomic);
            store.setHLId(memId);
            store.setUnfCopy(getUnfCopy());
            store.setCondLevel(condLevel);
            store.addFilters(EType.ATOM);
            store.setMaxLocationSet(locations);

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
        if(clone == null){
            clone= new Xchg((Address) address.clone(), reg.clone(), atomic);
            afterClone();
        }
        return (Xchg)clone;
    }
}
