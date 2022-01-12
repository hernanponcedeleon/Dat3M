package com.dat3m.dartagnan.program.event.lang.pthread;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.memory.Address;
import com.google.common.base.Preconditions;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.Tag.C11.MO_SC;

public class Start extends Load {

	private Label label;
    private Label label4Copy;

	public Start(Register reg, Address address, Label label){
		super(reg, address, MO_SC);
        this.label = label;
        this.label.addListener(this);
    }

	private Start(Start other){
		super(other);
		this.label = other.label4Copy;
		Event notifier = label != null ? label : other.label;
		notifier.addListener(this);
    }

    @Override
    public String toString() {
        return "start_thread()";
    }
	
    @Override
    public void notify(Event label) {
    	if(this.label == null) {
        	this.label = (Label)label;
    	} else if (oId > label.getOId()) {
    		this.label4Copy = (Label)label;
    	}
    }

    public Label getLabel() {
    	return label;
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
    public List<Event> compile(Arch target) {
    	Preconditions.checkNotNull(target, "Target cannot be null");

        List<Event> events = new ArrayList<>();
        Load load = newLoad(resultRegister, address, mo);
        events.add(load);

        switch (target) {
            case NONE:
            case TSO:
                break;
            case POWER:
                Label label = newLabel("Jump_" + oId);
                events.addAll(eventSequence(
                        newFakeCtrlDep(resultRegister, label),
                        label,
                        Power.newISyncBarrier()
                ));
                break;
            case ARM8:
                events.add(AArch64.DMB.newISHBarrier());
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }

        events.add(newJumpUnless(new Atom(resultRegister, EQ, IConst.ONE), label));
        return events;
    }
}