package com.dat3m.dartagnan.program.event.pthread;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;

import java.util.LinkedList;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Lock extends Event {
	
	private final String name;
	private final IExpr address;
	private final Register reg;
	private final Label label;

	public Lock(String name, IExpr address, Register reg, Label label){
		this.name = name;
        this.address = address;
        this.reg = reg;
        this.label = label;
    }

	private Lock(Lock other){
		this.name = other.name;
        this.address = other.address;
        this.reg = other.reg;
        this.label = other.label;
    }

    @Override
    public String toString() {
        return "pthread_mutex_lock(&" + name + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Lock getCopy(){
        return new Lock(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new Load(reg, address, SC));
        events.add(new CondJump(new Atom(reg, NEQ, new IConst(0, -1)),label));
        events.add(new Store(address, new IConst(1, -1), SC));
        for(Event e : events) {
        	e.addFilters(EType.LOCK, EType.RMW);
        }
        return compileSequence(target, nextId, predecessor, events);
    }
}
