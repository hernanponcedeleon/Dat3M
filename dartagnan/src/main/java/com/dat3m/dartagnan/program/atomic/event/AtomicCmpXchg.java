package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.EventFactory.*;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.*;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;
import static com.dat3m.dartagnan.program.utils.EType.STRONG;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

public class AtomicCmpXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    private final Register expected;

    public AtomicCmpXchg(Register register, IExpr address, Register expected, ExprInterface value, String mo, boolean strong) {
        super(address, register, value, mo);
        this.expected = expected;
        if(strong) {
        	addFilters(STRONG);
        }
    }

    public AtomicCmpXchg(Register register, IExpr address, Register expected, ExprInterface value, String mo) {
        this(register, address, expected, value, mo, false);
    }

    private AtomicCmpXchg(AtomicCmpXchg other){
        super(other);
        this.expected = other.expected;
    }

    //TODO: Override getDataRegs???

    @Override
    public String toString() {
    	String tag = is(STRONG) ? "_strong" : "_weak";
    	tag += mo != null ? "_explicit" : "";
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
    	List<Event> events;
        switch(target) {
            case NONE:
            case TSO: {
                Register dummy = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
                Label casFail = newLabel("CAS_fail");
                Label casEnd = newLabel("CAS_end");
                Load load = newRMWLoad(dummy, address, mo);
                Local casResult = newLocal(resultRegister, new Atom(dummy, EQ, expected));
                CondJump branchOnCasResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
                Store store = newRMWStore(load, address, value, mo);
                CondJump gotoCasEnd = newGoto(casEnd);
                Local updateReg = newLocal(expected, dummy);

                events = eventSequence(
                        load,
                        casResult,
                        branchOnCasResult,
                            store,
                            gotoCasEnd,
                        casFail,
                            updateReg,
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
                Label casFail = newLabel("CAS_fail");
                Label casEnd = newLabel("CAS_end");
                Load load = newRMWLoadExclusive(dummy, address, loadMo);
                Local casResult = newLocal(resultRegister, new Atom(dummy, EQ, expected));
                CondJump branchOnCasResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
                // ---- CAS success ----
                Store store = newRMWStoreExclusive(address, value, storeMo, is(STRONG));
                Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                ExecutionStatus execStatus = newExecutionStatus(statusReg, store);
                // TODO: We should not terminate anymore but instead update the CAS result
                CondJump terminateOnStoreFail = newJump(new Atom(statusReg, EQ, IConst.ONE), (Label) getThread().getExit());
                terminateOnStoreFail.addFilters(EType.BOUND);
                CondJump gotoCasEnd = newGoto(casEnd);
                // ---------------------
                // ---- CAS Fail ----
                Local updateReg = newLocal(expected, dummy);
               
                // --- Add Fence before under POWER ---
                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        //events.addFirst(Power.newSyncBarrier());
                        optionalMemoryBarrier = Power.newSyncBarrier();
                    } else if (storeMo.equals(REL)) {
                        //events.addFirst(Power.newLwSyncBarrier());
                        optionalMemoryBarrier = Power.newLwSyncBarrier();
                    }                	
                }

                events = eventSequence(
                        optionalMemoryBarrier,
                        load,
                        casResult,
                        branchOnCasResult,
                            // Cas Success
                            store,
                            execStatus,
                            terminateOnStoreFail,
                            optionalISyncBarrier,
                            gotoCasEnd,
                        casFail,
                            // Cas Fail
                            updateReg,
                        casEnd
                );

                break;
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
