package dartagnan.program.event.pts;

import dartagnan.expression.AExpr;
import dartagnan.program.Register;
import dartagnan.program.Seq;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Load;
import dartagnan.program.event.MemEvent;
import dartagnan.program.event.utils.RegWriter;
import dartagnan.program.utils.EType;

public class Read extends MemEvent implements RegWriter {

    protected Register reg;

    public Read(Register register, AExpr address, String atomic) {
        this.reg = register;
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.hlId = hashCode();
        addFilters(EType.ANY, EType.MEMORY, EType.READ);
    }

    @Override
    public Register getModifiedReg(){
        return reg;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + reg + " = memory[" + address + "].load(" +  atomic + ")";
    }

    @Override
    public Read clone() {
        if(clone == null){
            clone = new Read(reg.clone(), address.clone(), atomic);
            afterClone();
        }
        return (Read)clone;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        Load ld = new Load(reg, address, atomic);
        ld.setHLId(hlId);
        ld.setUnfCopy(getUnfCopy());
        ld.setCondLevel(this.condLevel);
        ld.setMaxLocationSet(getMaxLocationSet());

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
