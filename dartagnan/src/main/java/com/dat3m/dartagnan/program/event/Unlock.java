package com.dat3m.dartagnan.program.event;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

import java.util.LinkedList;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Unlock extends Event {

	private IExpr lock;
	private Label label;

    public Unlock(IExpr lock, Label label) {
    	this.lock = lock;
    	this.label = label;
        addFilters(EType.LOCK);
    }

    protected Unlock(Unlock other){
		super(other);
	}

    @Override
    public String toString() {
    	return "unlock(&" + lock + ")";
    }
    
    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new CondJump(new Atom(lock, NEQ, new IConst(1)), label));
        events.add(new Store(lock, new IConst(0), "NA"));
		return compileSequence(target, nextId, predecessor, events);
	}
}
