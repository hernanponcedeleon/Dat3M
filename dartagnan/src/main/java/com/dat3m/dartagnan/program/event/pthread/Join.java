package com.dat3m.dartagnan.program.event.pthread;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.utils.EType.PTHREAD;

public class Join extends Event {

	private final Register pthread_t;
	private final Register reg;
	private final Address address;
	private Label label;
    private Label label4Copy;

    public Join(Register pthread_t, Register reg, Address address, Label label){
        this.pthread_t = pthread_t;
        this.reg = reg;
        this.address = address;
        this.label = label;
        this.label.addListener(this);
    }

    public Join(Join other){
    	super(other);
        this.pthread_t = other.pthread_t;
        this.reg = other.reg;
        this.address = other.address;
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "pthread_join(" + pthread_t + ")";
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
    public Join getCopy(){
        return new Join(this);
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        List<Event> events = new ArrayList<>();
        Load load = newLoad(reg, address, SC);
        load.addFilters(PTHREAD);
        events.add(load);

        switch (target) {
            case NONE: case TSO:
                break;
            case POWER:
                Label label = newLabel("Jump_" + oId);
                events.addAll(eventSequence(
                        newFakeCtrlDep(reg, label),
                        label,
                        Power.newISyncBarrier()
                ));
                break;
            case ARM:
                events.add(Arm.newISHBarrier());
                break;
            case ARM8:
                events.add(Arm8.DMB.newISHBarrier());
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }

        events.add(newJumpUnless(new Atom(reg, EQ, IConst.ZERO), label));
        setCLineForAll(events, this.cLine);
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
