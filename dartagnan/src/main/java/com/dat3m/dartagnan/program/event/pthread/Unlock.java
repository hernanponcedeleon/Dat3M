package com.dat3m.dartagnan.program.event.pthread;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.utils.EType.LOCK;
import static com.dat3m.dartagnan.program.utils.EType.RMW;

import java.math.BigInteger;
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
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Unlock extends Event {
	
	private final String name;
	private final IExpr address;
	private final Register reg;
	private Label label;
    private Label label4Copy;

	public Unlock(String name, IExpr address, Register reg, Label label){
		this.name = name;
        this.address = address;
        this.reg = reg;
        this.label = label;
        this.label.addListener(this);
    }

	private Unlock(Unlock other){
		this.name = other.name;
        this.address = other.address;
        this.reg = other.reg;
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "pthread_mutex_unlock(&" + name + ")";
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
    public Unlock getCopy(){
        return new Unlock(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new Load(reg, address, SC));
        events.add(new CondJump(new Atom(reg, NEQ, new IConst(BigInteger.ONE, -1)),label));
        events.add(new Store(address, new IConst(BigInteger.ZERO, -1), SC));
        for(Event e : events) {
            e.addFilters(LOCK, RMW);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
