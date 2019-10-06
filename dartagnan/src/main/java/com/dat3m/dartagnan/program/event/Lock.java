package com.dat3m.dartagnan.program.event;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

import java.util.LinkedList;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Lock extends Event {

	private Register reg;
	private IExpr lockAddress;
	private Label label;
	
    public Lock(Register reg, IExpr lockAddress, Label label) {
    	this.reg = reg;
    	this.lockAddress = lockAddress;
    	this.label = label;
        addFilters(EType.LOCK);
    }

    protected Lock(Lock other){
		super(other);
	}

    @Override
    public String toString() {
    	return "lock(&" + lockAddress + ")";
    }
    	
    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new Load(reg, lockAddress, "NA"));
        events.add(new CondJump(new Atom(reg, NEQ, new IConst(0)),label));
        events.add(new Store(lockAddress, new IConst(1), "NA"));
        for(Event e : events) {
        	e.addFilters(EType.LOCK);
        	e.addFilters(EType.RMW);
        }
		return compileSequence(target, nextId, predecessor, events);
	}
}
