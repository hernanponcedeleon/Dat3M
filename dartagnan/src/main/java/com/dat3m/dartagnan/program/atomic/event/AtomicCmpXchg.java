package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
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
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.program.utils.EType.STRONG;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

public class AtomicCmpXchg extends AtomicAbstract implements RegWriter, RegReaderData {

    private final IExpr expectedAddr;

    public AtomicCmpXchg(Register register, IExpr address, IExpr expectedAddr, ExprInterface value, String mo, boolean strong) {
        super(address, register, value, mo);
        this.expectedAddr = expectedAddr;
        if(strong) {
        	addFilters(STRONG);
        }
    }

    private AtomicCmpXchg(AtomicCmpXchg other){
        super(other);
        this.expectedAddr = other.expectedAddr;
    }

    //TODO: Override getDataRegs???

    @Override
    public String toString() {
    	String tag = is(STRONG) ? "_strong" : "_weak";
    	tag += mo != null ? "_explicit" : "";
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
    	List<Event> events;

    	// These events are common to all compilation schemes.
        // The difference of each architecture lies in the used Store/Load to/from <address>
        // and the fences that get inserted
    	Register regExpected = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    	Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Load loadExpected = newLoad(regExpected, expectedAddr, null);
        Store storeExpected = newStore(expectedAddr, regValue, null);
        Label casFail = newLabel("CAS_fail");
        Label casEnd = newLabel("CAS_end");
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, regExpected));
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casFail);
        CondJump gotoCasEnd = newGoto(casEnd);

        switch(target) {
            case NONE:
            case TSO: {
                Load loadValue = newRMWLoad(regValue, address, mo);
                Store storeValue = newRMWStore(loadValue, address, value, mo);

                events = eventSequence(
                		// Indentation shows the branching structure
                        loadExpected,
                        loadValue,
                        casCmpResult,
                        branchOnCasCmpResult,
                            storeValue,
                        	gotoCasEnd,
                        casFail,
                        	storeExpected,
                        casEnd
                );
                break;
            }
            case POWER:
            case ARM8: {
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

                Load loadValue = newRMWLoadExclusive(regValue, address, loadMo);
                Store storeValue = newRMWStoreExclusive(address, value, storeMo, is(STRONG));
                ExecutionStatus optionalExecStatus = null;
                Local optionalUpdateCasCmpResult = null;
                if (!is(STRONG)) {
                    Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                    optionalExecStatus = newExecutionStatus(statusReg, storeValue);
                    optionalUpdateCasCmpResult = newLocal(resultRegister, new BExprUn(BOpUn.NOT, statusReg));
                }
               
                // --- Add Fence before under POWER ---
                Fence optionalMemoryBarrier = null;
                // if mo.equals(SC) then loadMo.equals(ACQ)
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            // if mo.equals(SC) then storeMo.equals(REL)
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
                            : null;
                }

                events = eventSequence(
                		// Indentation shows the branching structure
                        optionalMemoryBarrier,
                        loadExpected,
                        loadValue,
                        casCmpResult,
                        branchOnCasCmpResult,
                            storeValue,
                        	optionalExecStatus,
                        	optionalUpdateCasCmpResult,
                        	gotoCasEnd,
                        casFail,
                        	storeExpected,
                        casEnd,
                    	optionalISyncBarrier
                );

                break;
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + this);
        }
        setCLineForAll(events, this.cLine);
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
    }
}
