package com.dat3m.dartagnan.program.event.pthread;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

import java.util.LinkedList;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Start extends Event {

	private final Register reg;
	private final Address address;
	private final Label label;

	public Start(Register reg, Address address, Label label){
        this.reg = reg;
        this.address = address;
        this.label = label;
    }

	private Start(Start other){
        this.reg = other.reg;
        this.address = other.address;
        this.label = other.label;
    }

    @Override
    public String toString() {
        return "start_thread()";
    }
	
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Start getCopy(){
        return new Start(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        Load load = new Load(reg, address, SC);
		events.add(load);

        switch (target) {
            case NONE: case TSO:
                break;
            case POWER:
                Label label = new Label("Jump_" + oId);
                CondJump jump = new CondJump(new Atom(reg, EQ, reg), label);
                events.addLast(jump);
                events.addLast(label);
                events.addLast(new Fence("Isync"));
                break;
            case ARM: case ARM8:
            	events.addLast(new Fence("Ish"));
                break;
            default:
            	throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        
        events.add(new CondJump(new BExprUn(NOT, new Atom(reg, EQ, new IConst(1, -1))), label));
        return compileSequence(target, nextId, predecessor, events);
    }

}
