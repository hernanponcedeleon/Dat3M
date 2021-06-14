package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWLoadExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusive;
import com.dat3m.dartagnan.program.atomic.utils.Mo;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.Arrays;
import java.util.LinkedList;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

public class AtomicCmpXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    private final IExpr expectedAddr;

    public AtomicCmpXchg(Register register, IExpr address, IExpr expectedAddr, ExprInterface value, String mo) {
        super(address, register, value, mo);
        this.expectedAddr = expectedAddr;
    }

    private AtomicCmpXchg(AtomicCmpXchg other){
        super(other);
        this.expectedAddr = other.expectedAddr;
    }

    //TODO: Override getDataRegs???

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_compare_exchange" + tag + "(*" + address + ", " + expectedAddr + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicCmpXchg getCopy(){
        return new AtomicCmpXchg(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        Register expected = new Register(null, getThread().getId(), resultRegister.getPrecision());
        Load expectLoad = new Load(expected, expectedAddr, null); // TODO: Figure out what mo should be used (none?)
    	Load load;
    	Store store;
    	LinkedList<Event> events = new LinkedList<>();
        switch(target) {
            case NONE:
            case TSO: {
                Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
                load = new RMWLoad(dummy, address, mo);
                Local casResult = new Local(resultRegister, new Atom(dummy, EQ, expected));
                Label failCas = new Label("CAS_fail");
                Label endCas = new Label("CAS_end");
                CondJump branch = new CondJump(new Atom(resultRegister, NEQ, IConst.ONE), failCas);
                store = new RMWStore((RMWLoad)load, address, value, mo);
                CondJump jumpToEnd = new CondJump(BConst.TRUE, endCas);
                Store updateExpected = new Store(expectedAddr, dummy, mo); //TODO: Should use <mo on failure>
                events.addAll(Arrays.asList(expectLoad, load, casResult, branch, store, jumpToEnd, failCas, updateExpected, endCas));
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
                load = new RMWLoadExclusive(dummy, address, loadMo);
                Local casResult = new Local(resultRegister, new Atom(dummy, EQ, expected));
                Label fail = new Label("CAS_fail");
                Label endCas = new Label("CAS_end");
                CondJump branch = new CondJump(new Atom(resultRegister, NEQ, IConst.ONE), fail);
                // ---- CAS success ----
                //TODO: We assume a strong CAS here. Once we can parse weak and strong CAS, we will change this!
                store = new RMWStoreExclusive(address, value, storeMo, true);
                CondJump jumpToEndCas = new CondJump(BConst.TRUE, endCas);
                // ---------------------
                // ---- CAS Fail ----
                Store updateExpected = new Store(expectedAddr, dummy, storeMo); //TODO: Should use <mo on failure>
                // ---------------------

                // --- Add Fence before under POWER ---
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        events.addFirst(new Fence("Sync"));
                    } else if (storeMo.equals(REL)) {
                        events.addFirst(new Fence("Lwsync"));
                    }                	
                }
                // --- Add success events ---
                events.addAll(Arrays.asList(expectLoad, load, casResult, branch, store));
                // --- Add Fence after success under POWER ---
                if (target.equals(POWER) && loadMo.equals(ACQ)) {
                    events.addLast(new Fence("Isync"));
                }
                // --- Add fail events + exit ---
                events.addAll(Arrays.asList(jumpToEndCas, fail, updateExpected, endCas));
                break;
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
