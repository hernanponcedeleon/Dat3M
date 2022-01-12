package com.dat3m.dartagnan.program.event.lang.catomic;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;

import java.util.List;

import static com.dat3m.dartagnan.configuration.Arch.POWER;
import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.arch.aarch64.utils.Tag.*;
import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Tag.SC;

public class Dat3mCAS extends AtomicAbstract implements RegWriter, RegReaderData {

    private final ExprInterface expectedValue;

    public Dat3mCAS(Register register, IExpr address, ExprInterface expectedVal, IExpr desiredValue, String mo) {
        super(address, register, desiredValue, mo);
        this.expectedValue = expectedVal;
    }

    private Dat3mCAS(Dat3mCAS other){
        super(other);
        this.expectedValue = other.expectedValue;
    }

    @Override
    public String toString() {
        return resultRegister + " = __DAT3M_CAS(*" + address + ", " + expectedValue + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public ExprInterface getMemValue() {
    	return value;
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
    public List<Event> compile(Arch target) {
        List<Event> events;

        // Events common for all compilation schemes.
        Register regValue = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
        Local casCmpResult = newLocal(resultRegister, new Atom(regValue, EQ, expectedValue));
        Label casEnd = newLabel("CAS_end");
        CondJump branchOnCasCmpResult = newJump(new Atom(resultRegister, NEQ, IConst.ONE), casEnd);

        switch(target) {
            case NONE: case TSO: {
                Load load = newRMWLoad(regValue, address, mo);
                Store store = newRMWStore(load, address, value, mo);

                events = eventSequence(
                        // Indentation shows the branching structure
                        load,
                        casCmpResult,
                        branchOnCasCmpResult,
                            store,
                        casEnd
                );
                break;
            }
            case POWER:
            case ARM8: {
                String loadMo = extractLoadMo(mo);
                String storeMo = extractStoreMo(mo);

                Load load = newRMWLoadExclusive(regValue, address, loadMo);
                Store store = newRMWStoreExclusive(address, value, storeMo, true);

                // --- Add Fence before under POWER ---
                Fence optionalMemoryBarrier = null;
                Fence optionalISyncBarrier = (target.equals(POWER) && loadMo.equals(ACQ)) ? Power.newISyncBarrier() : null;
                if(target.equals(POWER)) {
                    optionalMemoryBarrier = mo.equals(SC) ? Power.newSyncBarrier()
                            : storeMo.equals(REL) ? Power.newLwSyncBarrier()
                            : null;
                }
                // --- Add success events ---
                events = eventSequence(
                        // Indentation shows the branching structure
                        optionalMemoryBarrier,
                        load,
                        casCmpResult,
                        branchOnCasCmpResult,
                            store,
                        optionalISyncBarrier,
                        casEnd
                );
                break;
            }
            default:
                throw new UnsupportedOperationException("Compilation to " + target + " is not supported for " + getClass().getName());
        }
        return events;
    }
}