package com.dat3m.dartagnan.program.arch.pts.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.pts.utils.Mo;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.LinkedList;

public class Read extends MemEvent implements RegWriter {

    private final Register resultRegister;
    private final String mo;

    public Read(Register register, IExpr address, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.mo = mo;
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.REG_WRITER);
    }

    private Read(Read other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.mo = other.mo;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public String toString() {
        return resultRegister + " = load(*" + address + (mo != null ? ", " + mo : "") + ")";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Read getCopy(){
        return new Read(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new Load(resultRegister, address, mo));

        switch (target) {
            case NONE: case TSO:
                break;
            case POWER:
                if(Mo.SC.equals(mo) || Mo.ACQUIRE.equals(mo) || Mo.CONSUME.equals(mo)){
                    events.addLast(new Fence("Lwsync"));
                    if(Mo.SC.equals(mo)){
                        events.addFirst(new Fence("Sync"));
                    }
                }
                break;
            case ARM: case ARM8:
                if(Mo.SC.equals(mo) || Mo.ACQUIRE.equals(mo) || Mo.CONSUME.equals(mo)) {
                    events.addLast(new Fence("Ish"));
                }
                break;
            default:
                    throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }

        return compileSequence(target, nextId, predecessor, events);
    }
}
