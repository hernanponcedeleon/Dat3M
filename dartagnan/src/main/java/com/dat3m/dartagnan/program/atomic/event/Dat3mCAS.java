package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Events;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStoreExclusive;
import com.dat3m.dartagnan.program.event.rmw.RMWStoreExclusiveStatus;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

public class Dat3mCAS extends AtomicAbstract implements RegWriter, RegReaderData {

    private final IExpr expected;

    public Dat3mCAS(Register register, IExpr address, IExpr expected, ExprInterface value, String mo) {
        super(address, register, value, mo);
        this.expected = expected;
    }

    private Dat3mCAS(Dat3mCAS other){
        super(other);
        this.expected = other.expected;
    }

    @Override
    public String toString() {
        return resultRegister + " = __DAT3M_CAS(*" + address + ", " + expected + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Dat3mCAS getCopy(){
        return new Dat3mCAS(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
    	Load load;
    	Store store;
    	LinkedList<Event> events = new LinkedList<>();
        switch(target) {
            case NONE: case TSO: {
                Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
                load = Events.newRMWLoad(dummy, address, mo);
                Local casResult = Events.newLocal(resultRegister, new Atom(dummy, EQ, expected));
                Label endCas = Events.newLabel("CAS_end");
                CondJump branch = Events.newJump(new Atom(resultRegister, NEQ, IConst.ONE), endCas);
                store = Events.newRMWStore((RMWLoad)load, address, value, mo);
                events.addAll(Arrays.asList(load, casResult, branch, store, endCas));
                break;
            }
            case POWER:
            case ARM8: {
                String loadMo;
                String storeMo;
                switch (mo) {
                    case SC:
                    case ACQ_REL:
                        loadMo = ACQ;
                        storeMo = REL;
                        break;
                    case ACQUIRE:
                        loadMo = ACQ;
                        storeMo = RX;
                        break;
                    case RELEASE:
                        loadMo = RX;
                        storeMo = REL;
                        break;
                    case RELAXED:
                        loadMo = RX;
                        storeMo = RX;
                        break;
                    default:
                        throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
                }

                Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
                load = Events.newRMWLoadExclusive(dummy, address, loadMo);
                Local casResult = Events.newLocal(resultRegister, new Atom(dummy, EQ, expected));
                Label endCas = Events.newLabel("CAS_end");
                CondJump branch = Events.newJump(new Atom(resultRegister, NEQ, IConst.ONE), endCas);
                // ---- CAS success ----
                store = Events.newRMWStoreExclusive(address, value, storeMo);
                Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                RMWStoreExclusiveStatus status = Events.newRMWStoreExclusiveStatus(statusReg, (RMWStoreExclusive)store);
                Event jumpStoreFail = Events.newJump(new Atom(statusReg, EQ, IConst.ONE), (Label) getThread().getExit());
                jumpStoreFail.addFilters(EType.BOUND);
                // ---------------------

                // --- Add Fence before under POWER ---
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        events.addFirst(Events.Power.newSyncBarrier());
                    } else if (storeMo.equals(REL)) {
                        events.addFirst(Events.Power.newLwSyncBarrier());
                    }                	
                }
                // --- Add success events ---
                events.addAll(Arrays.asList(load, casResult, branch, store, status, jumpStoreFail));
                // --- Add Fence after success under POWER ---
                if (target.equals(POWER) && loadMo.equals(ACQ)) {
                    events.addLast(Events.Power.newISyncBarrier());
                }
                // --- Add exit ---
                events.addAll(Collections.singletonList(endCas));
                break;
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
