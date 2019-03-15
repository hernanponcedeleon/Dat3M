package com.dat3m.dartagnan.program.arch.pts.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;

import java.util.LinkedList;

public class Write extends MemEvent implements RegReaderData {

    private final ExprInterface value;
    //TODO(HP) shouldn't it be com.dat3m.dartagnan.program.arch.pts.utils.Mo?
    private final String mo;
    private final ImmutableSet<Register> dataRegs;

    public Write(IExpr address, ExprInterface value, String mo){
        super(address);
        this.value = value;
        this.mo = mo;
        this.dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.WRITE, EType.REG_READER);
    }

    private Write(Write other){
        super(other);
        this.value = other.value;
        this.mo = other.mo;
        this.dataRegs = other.dataRegs;
    }

    @Override
    public boolean is(String param){
        return super.is(param) || (mo != null && mo.equals(param));
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
        return "store(*" + address + ", " +  value + (mo != null ? ", " + mo : "") + ")";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Write getCopy(){
        return new Write(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new Store(address, value, mo));

        switch (target){
            case NONE:
                break;
            case TSO:
                //TODO(HP) shouldn't it be Mo.SC? Similar for the rest below
                if(mo.equals("_sc")){
                    events.addLast(new Fence("Mfence"));
                }
                break;
            case POWER:
                if(mo.equals("_rel")){
                    events.addFirst(new Fence("Lwsync"));
                } else if(mo.equals("_sc")){
                    events.addFirst(new Fence("Sync"));
                }
                break;
            case ARM: case ARM8:
                if(mo.equals("_rel") || mo.equals("_sc")){
                    events.addFirst(new Fence("Ish"));
                    if(mo.equals("_sc")){
                        events.addLast(new Fence("Ish"));
                    }
                }
                break;
                default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }

        return compileSequence(target, nextId, predecessor, events);
    }
}
