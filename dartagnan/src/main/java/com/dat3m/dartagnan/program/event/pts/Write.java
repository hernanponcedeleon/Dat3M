package com.dat3m.dartagnan.program.event.pts;

import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Seq;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.program.Thread;

public class Write extends MemEvent implements RegReaderData {

    protected ExprInterface value;
    private ImmutableSet<Register> dataRegs;

    public Write(IExpr address, ExprInterface value, String atomic){
        this.value = value;
        this.address = address;
        this.atomic = atomic;
        this.condLevel = 0;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.MEMORY, EType.WRITE);
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
        return nTimesCondLevel() + "store(*" + address + ", " +  value + ", " + (atomic != null ? ", " + atomic : "") + ")";
    }

    @Override
    public Write clone() {
        if(clone == null){
            clone = new Write(address.clone(), value.clone(), atomic);
            afterClone();
        }
        return (Write)clone;
    }

    @Override
    public Thread compile(String target, boolean ctrl, boolean leading) {
        Store st = new Store(address, value, atomic);
        st.setHLId(hlId);
        st.setCondLevel(this.condLevel);

        if(!target.equals("power") && !target.equals("arm") && atomic.equals("_sc")) {
            Fence mfence = new Fence("Mfence");
            mfence.setCondLevel(this.condLevel);
            return new Seq(st, mfence);
        }

        if(!target.equals("power") && !target.equals("arm")) {
            return st;
        }

        if(target.equals("power")) {
            if(atomic.equals("_rx") || atomic.equals("_na")) {
                return st;
            }

            Fence lwsync = new Fence("Lwsync");
            lwsync.setCondLevel(this.condLevel);
            if(atomic.equals("_rel")) {
                return new Seq(lwsync, st);
            }

            if(atomic.equals("_sc")) {
                Fence sync = new Fence("Sync");
                sync.setCondLevel(this.condLevel);
                if(leading) {
                    return new Seq(sync, st);
                }
                return new Seq(lwsync, new Seq(st, sync));
            }
        }

        if(target.equals("arm")) {
            if(atomic.equals("_rx") || atomic.equals("_na")) {
                return st;
            }

            Fence ish1 = new Fence("Ish");
            ish1.setCondLevel(this.condLevel);
            if(atomic.equals("_rel")) {
                return new Seq(ish1, st);
            }

            Fence ish2 = new Fence("Ish");
            ish2.setCondLevel(this.condLevel);
            if(atomic.equals("_sc")) {
                return new Seq(ish1, new Seq(st, ish2));
            }
        }

        throw new RuntimeException("Compilation is not supported for " + this);
    }
}
