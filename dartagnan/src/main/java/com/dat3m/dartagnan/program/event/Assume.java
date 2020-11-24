package com.dat3m.dartagnan.program.event;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;

import java.util.LinkedList;

import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class Assume extends Event {

	private ExprInterface exp;
	private Label label;
	
	public Assume(ExprInterface e, Label l) {
		this.exp = e;
		this.label = l;
        addFilters(EType.ANY);
	}

	protected Assume(Assume other){
		super(other);
		this.exp = other.exp;
		this.label = other.label;
	}

	@Override
    public String toString() {
        return "assume(" + exp + ")";
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Assume getCopy(){
		return new Assume(this);
	}

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

	@Override
    public int compile(Arch target, int nextId, Event predecessor) {
        LinkedList<Event> events = new LinkedList<>();
        events.add(new CondJump(new BExprUn(NOT, exp), label));
		return compileSequence(target, nextId, predecessor, events);
	}
}
