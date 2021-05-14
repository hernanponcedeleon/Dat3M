package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWLoadExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusiveStatus;
import com.dat3m.dartagnan.program.atomic.utils.Mo;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.Arrays;
import java.util.LinkedList;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;

public class AtomicCmpXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    private final Register expected;

    public AtomicCmpXchg(Register register, IExpr address, Register expected, ExprInterface value, String mo) {
        super(address, register, value, mo);
        this.expected = expected;
    }

    private AtomicCmpXchg(AtomicCmpXchg other){
        super(other);
        this.expected = other.expected;
    }

    //TODO: Override getDataRegs???

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_compare_exchange" + tag + "(*" + address + ", " + expected + ", " + value + (mo != null ? ", " + mo : "") + ")";
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
    	LinkedList<Event> events;
        switch(target) {
            case NONE: case TSO: {
                Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
                RMWLoad load = new RMWLoad(dummy, address, mo);
                Local casResult = new Local(resultRegister, new Atom(dummy, EQ, expected));
                Label fail = new Label("CAS_fail");
                Label endCas = new Label("CAS_end");
                CondJump branch = new CondJump(new Atom(resultRegister, NEQ, IConst.ONE), fail);
                RMWStore succStore = new RMWStore(load, address, value, mo);
                CondJump jumpToEnd = new CondJump(BConst.TRUE, endCas);
                Local updateReg = new Local(expected, dummy);

                events = new LinkedList<>(Arrays.asList(load, casResult, branch, succStore, jumpToEnd, fail, updateReg, endCas));

                return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
            }
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
                RMWLoadExclusive load = new RMWLoadExclusive(dummy, address, loadMo);
                Local casResult = new Local(resultRegister, new Atom(dummy, EQ, expected));
                Label fail = new Label("CAS_fail");
                Label endCas = new Label("CAS_end");
                CondJump branch = new CondJump(new Atom(resultRegister, NEQ, IConst.ONE), fail);
                // ---- CAS success ----
                RMWStoreExclusive succStore = new RMWStoreExclusive(address, value, storeMo);
                Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                RMWStoreExclusiveStatus status = new RMWStoreExclusiveStatus(statusReg, succStore);
                Event jumpStoreFail = new CondJump(new Atom(statusReg, EQ, IConst.ONE), (Label) getThread().getExit());
                jumpStoreFail.addFilters(EType.BOUND);
                CondJump jumpToEndCas = new CondJump(BConst.TRUE, endCas);
                // ---------------------
                // ---- CAS Fail ----
                Local updateReg = new Local(expected, dummy);
                // ------------------

                events = new LinkedList<>(Arrays.asList(load, casResult, branch, succStore, status, jumpStoreFail, jumpToEndCas, fail, updateReg, endCas));
                return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
            }
            case POWER: {
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
                RMWLoadExclusive load = new RMWLoadExclusive(dummy, address, loadMo);
                Local casResult = new Local(resultRegister, new Atom(dummy, EQ, expected));
                Label fail = new Label("CAS_fail");
                Label endCas = new Label("CAS_end");
                CondJump branch = new CondJump(new Atom(resultRegister, NEQ, IConst.ONE), fail);
                // ---- CAS success ----
                RMWStoreExclusive succStore = new RMWStoreExclusive(address, value, storeMo);
                Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                RMWStoreExclusiveStatus status = new RMWStoreExclusiveStatus(statusReg, succStore);
                Event jumpStoreFail = new CondJump(new Atom(statusReg, EQ, IConst.ONE), (Label) getThread().getExit());
                jumpStoreFail.addFilters(EType.BOUND);
                CondJump jumpToEndCas = new CondJump(BConst.TRUE, endCas);
                // ---------------------
                // ---- CAS Fail ----
                Local updateReg = new Local(expected, dummy);
                // ------------------

                events = new LinkedList<>();
                // --- Add Fence before ---
                if (mo.equals(SC)) {
                    events.addFirst(new Fence("sync"));
                } else if (storeMo.equals(REL)) {
                    events.addFirst(new Fence("lwsync"));
                }
                // --- Add success events ---
                events.addAll(Arrays.asList(load, casResult, branch, succStore, status, jumpStoreFail));
                // --- Add Fence after success ---
                if (loadMo.equals(ACQ)) {
                    events.addLast(new Fence("isync"));
                }
                // --- Add fail events + exit ---
                events.addAll(Arrays.asList(jumpToEndCas, fail, updateReg, endCas));

                return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
    }
}
