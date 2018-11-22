package dartagnan.program.event.address;

import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.utils.RegReaderAddress;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class ReadFromAddress extends MemEventAddress implements RegWriter, RegReaderAddress {

    private Register register;

    public ReadFromAddress(Register register, Register address, String atomic) {
        this.register = register;
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.memId = hashCode();
        addFilters(EType.ANY, EType.MEMORY, EType.READ);
    }

    @Override
    public Register getModifiedReg(){
        return register;
    }

    @Override
    public String toString() {
        // TODO: Figure out better representation
        return nTimesCondLevel() + register + " = " + address + ".load(" +  atomic + ")";
    }

    @Override
    public ReadFromAddress clone() {
        ReadFromAddress newRead = new ReadFromAddress(register.clone(), address.clone(), atomic);
        newRead.condLevel = condLevel;
        newRead.memId = memId;
        newRead.setUnfCopy(getUnfCopy());
        return newRead;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        LoadFromAddress ld = new LoadFromAddress(register, address, atomic);
        ld.setHLId(memId);
        ld.setUnfCopy(getUnfCopy());
        ld.setCondLevel(this.condLevel);

        if(!target.equals("power") && !target.equals("arm")) {
            return ld;
        }

        if(atomic.equals("_rx") || atomic.equals("_na")) {
            return ld;
        }

        if(target.equals("power")) {
            Fence lwsync = new Fence("Lwsync", this.condLevel);
            if(atomic.equals("_con") || atomic.equals("_acq")) {
                return new Seq(ld, lwsync);
            }

            if(atomic.equals("_sc")) {
                if(leading) {
                    Fence sync = new Fence("Sync", this.condLevel);
                    return new Seq(sync, new Seq(ld, lwsync));
                }
                return new Seq(ld, lwsync);
            }
        }

        if(target.equals("arm")) {
            if(atomic.equals("_con") || atomic.equals("_acq") || atomic.equals("_sc")) {
                Fence ish = new Fence("Ish", this.condLevel);
                return new Seq(ld, ish);
            }
        }

        throw new RuntimeException("Compilation is not supported for " + this);
    }
}
