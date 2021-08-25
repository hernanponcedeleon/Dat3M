package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.ACQ;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.RX;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;

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
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        List<Event> events = new ArrayList<>();
        Load load = newLoad(resultRegister, address, mo);
        events.add(load);

        switch (target) {
            case NONE: 
            case TSO:
                break;
            case POWER: {
                if (SC.equals(mo) || ACQUIRE.equals(mo) || CONSUME.equals(mo)) {
                    Fence optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier() : null;
                    Label label = newLabel("Jump_" + oId);
                    events = eventSequence(
                            optionalMemoryBarrier,
                            load,
                            newFakeCtrlDep(resultRegister, label),
                            label,
                            Power.newISyncBarrier()
                    );
                }
                break;
            }
            case ARM:
                Fence optionalISHBarrier =
                        mo.equals(SC) || mo.equals(ACQUIRE) || mo.equals(CONSUME) ? Arm.newISHBarrier() : null;
                events = eventSequence(
                        load,
                        optionalISHBarrier
                );
                break;
            case ARM8:
            	String loadMo;
            	switch (mo) {
					case SC:
					case ACQUIRE:
						loadMo = ACQ;
						break;
					case RELAXED:
						loadMo = RX;
						break;
					default:
					    //TODO: Fix this error message?
		                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
					}
		        events = eventSequence(
                        newLoad(resultRegister, address, loadMo)
                );
                break;
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
