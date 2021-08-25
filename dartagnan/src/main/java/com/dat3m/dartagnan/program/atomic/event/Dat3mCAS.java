package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.EventFactory.*;
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
    	List<Event> events;
        switch(target) {
            case NONE: case TSO: {
                Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
                Load load = newRMWLoad(dummy, address, mo);
                Local casResult = newLocal(resultRegister, new Atom(dummy, EQ, expected));
                Label casEnd = newLabel("CAS_end");
                CondJump branchOnCasResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);
                Store store = newRMWStore(load, address, value, mo);

                events = eventSequence(
                        load,
                        casResult,
                        branchOnCasResult,
                            store,
                        casEnd
                );
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
                Load load = newRMWLoadExclusive(dummy, address, loadMo);
                Local casResult = newLocal(resultRegister, new Atom(dummy, EQ, expected));
                Label endCas = newLabel("CAS_end");
                CondJump branchOnCasResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), endCas);
                // ---- CAS success ----
                Store store = newRMWStoreExclusive(address, value, storeMo, true);
                // ---------------------

                // --- Add Fence before under POWER ---
                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        optionalMemoryBarrier = Power.newSyncBarrier();
                    } else if (storeMo.equals(REL)) {
                        optionalMemoryBarrier = Power.newLwSyncBarrier();
                    }
                }
                // --- Add success events ---
                events = eventSequence(
                        optionalMemoryBarrier,
                        load,
                        casResult,
                        branchOnCasResult,
                            store,
                            optionalISyncBarrier,
                        endCas
                );
                break;
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
