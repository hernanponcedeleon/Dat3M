package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWLoadExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusive;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusiveNoFail;
import com.dat3m.dartagnan.program.arch.aarch64.event.RMWStoreExclusiveStatus;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;

import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.ACQ;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.REL;
import static com.dat3m.dartagnan.program.arch.aarch64.utils.Mo.RX;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.ACQUIRE;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.ACQ_REL;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.RELAXED;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.RELEASE;
import static com.dat3m.dartagnan.program.atomic.utils.Mo.SC;
import static com.dat3m.dartagnan.wmm.utils.Arch.POWER;

import java.util.Arrays;
import java.util.LinkedList;

public class AtomicFetchOp extends AtomicAbstract implements RegWriter, RegReaderData {

    private final IOpBin op;

    public AtomicFetchOp(Register register, IExpr address, ExprInterface value, IOpBin op, String mo) {
        super(address, register, value, mo);
        this.op = op;
    }

    private AtomicFetchOp(AtomicFetchOp other){
        super(other);
        this.op = other.op;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
        return resultRegister + " = atomic_fetch_" + op.toLinuxName() + tag + "(*" + address + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public AtomicFetchOp getCopy(){
        return new AtomicFetchOp(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
    	Load load;
    	Register dummyReg = new Register(null, resultRegister.getThreadId(), resultRegister.getPrecision());
    	Local add = new Local(dummyReg, new IExprBin(resultRegister, op, value));
    	Store store;
    	LinkedList<Event> events = new LinkedList<>();
        switch(target) {
            case NONE: case TSO:
                load = new RMWLoad(resultRegister, address, mo);
                store = new RMWStore((RMWLoad)load, address, dummyReg, mo);
                events = new LinkedList<>(Arrays.asList(load, add, store));
                break;
            case POWER:
            case ARM8:
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
            	load = new RMWLoadExclusive(resultRegister, address, loadMo);
                store = new RMWStoreExclusiveNoFail(address, dummyReg, storeMo);
            	Register statusReg = new Register("status(" + getOId() + ")", resultRegister.getThreadId(), resultRegister.getPrecision());
                RMWStoreExclusiveStatus status = new RMWStoreExclusiveStatus(statusReg, (RMWStoreExclusive)store);
                Label end = (Label)getThread().getExit();
                Event jump = new CondJump(new Atom(statusReg, COpBin.EQ, IConst.ONE), end);
                jump.addFilters(EType.BOUND);

                // Extra fences for POWER
                if(target.equals(POWER)) {
                    if (mo.equals(SC)) {
                        events.addFirst(new Fence("Sync"));
                    } else if (storeMo.equals(REL)) {
                        events.addFirst(new Fence("Lwsync"));
                    }                	
                }
                
                // All events for POWER and ARM8
                events.addAll(Arrays.asList(load, add, store, status, jump));
                
                // Extra fences for POWER
                if (target.equals(POWER) && loadMo.equals(ACQ)) {
                    events.addLast(new Fence("Isync"));
                }
                break;
            default:
                String tag = mo != null ? "_explicit" : "";
                throw new RuntimeException("Compilation of atomic_fetch_" + op.toLinuxName() + tag + " is not implemented for " + target);
        }
        return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);        
    }
}
