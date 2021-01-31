package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.ACQUIRE;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.CONSUME;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

import java.util.LinkedList;

public class AtomicLoad extends MemEvent implements RegWriter {

    private final Register resultRegister;

    public AtomicLoad(Register register, IExpr address, String mo) {
        super(address, mo);
        this.resultRegister = register;
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.REG_WRITER);
    }

    private AtomicLoad(AtomicLoad other){
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_load" + tag + "(*" + address + (mo != null ? ", " + mo : "") + ")";
    }


    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicLoad getCopy(){
        return new AtomicLoad(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        Load load = new Load(resultRegister, address, mo);
        load.setCLine(cLine);
		events.add(load);


        switch (target) {
            case NONE: case TSO:
                break;
            case POWER:
                if(SC.equals(mo) || ACQUIRE.equals(mo) || CONSUME.equals(mo)){
                	Label label = new Label("Jump_" + oId);
                	CondJump jump = new CondJump(new Atom(resultRegister, EQ, resultRegister), label);
                	events.addLast(jump);
                	events.addLast(label);
                	events.addLast(new Fence("Isync"));
                    if(SC.equals(mo)){
                        events.addFirst(new Fence("Sync"));
                    }
                }
                break;
            case ARM: case ARM8:
                if(SC.equals(mo) || ACQUIRE.equals(mo) || CONSUME.equals(mo)) {
                    events.addLast(new Fence("Ish"));
                }
                break;
            default:
            	throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequence(target, nextId, predecessor, events);
    }
}
