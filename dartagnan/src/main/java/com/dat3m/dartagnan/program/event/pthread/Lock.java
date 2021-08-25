package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.utils.EType.LOCK;
import static com.dat3m.dartagnan.program.utils.EType.RMW;

public class Lock extends Event {
	
	private final String name;
	private final IExpr address;
	private final Register reg;
	private Label label;
    private Label label4Copy;

	public Lock(String name, IExpr address, Register reg, Label label){
		this.name = name;
        this.address = address;
        this.reg = reg;
        this.label = label;
        this.label.addListener(this);
    }

	private Lock(Lock other){
		this.name = other.name;
        this.address = other.address;
        this.reg = other.reg;
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "pthread_mutex_lock(&" + name + ")";
    }

    @Override
    public void notify(Event label) {
    	if(this.label == null) {
        	this.label = (Label)label;
    	} else if (oId > label.getOId()) {
    		this.label4Copy = (Label)label;
    	}
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Lock getCopy(){
        return new Lock(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        List<Event> events = eventSequence(
                newLoad(reg, address, SC),
                newJump(new Atom(reg, NEQ, IConst.ZERO), label),
                newStore(address, IConst.ONE, SC)
        );
        for(Event e : events) {
            e.addFilters(LOCK, RMW);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
