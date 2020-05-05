package com.dat3m.dartagnan.program.atomic.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.google.common.collect.ImmutableSet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.rmw.RMWLoad;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.arch.tso.utils.EType;

import java.util.Arrays;
import java.util.LinkedList;

public class AtomicFetchOp extends MemEvent implements RegWriter, RegReaderData {

    private final Register resultRegister;
    private final ExprInterface value;
    private final ImmutableSet<Register> dataRegs;
    private final IOpBin op;

    public AtomicFetchOp(Register register, IExpr address, ExprInterface value, IOpBin op, String mo) {
        super(address, mo);
        this.resultRegister = register;
        this.value= value;
        this.dataRegs = ImmutableSet.of(resultRegister);
        this.op = op;
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.WRITE, EType.ATOM, EType.REG_WRITER, EType.REG_READER);
    }

    private AtomicFetchOp(AtomicFetchOp other){
        super(other);
        this.resultRegister = other.resultRegister;
        this.value = other.value;
        this.dataRegs = other.dataRegs;
        this.op = other.op;
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
    	String tag = mo != null ? "_explicit" : "";
    	String opName;
    	switch(op) {
    		case PLUS: 
    			opName = "_add";
    			break;
    		case MINUS: 
    			opName = "_sub";
    			break;
    		default:
    			throw new RuntimeException("Operation " + op + " cannot be handled in AtomicFetchOp");
    	}
        return "atomic_fetch" + opName + tag + "(*" + address + ", " + resultRegister + (mo != null ? ", " + mo : "") + ")";
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
    public int compile(Arch target, int nextId, Event predecessor) {
    	switch(target) {
    		case NONE: case TSO:
                RMWLoad load = new RMWLoad(resultRegister, address, mo);
                load.addFilters(EType.ATOM);

                Register dummyReg = new Register(null, resultRegister.getThreadId());
                Local add = new Local(dummyReg, new IExprBin(resultRegister, op, value));
                
                RMWStore store = new RMWStore(load, address, dummyReg, mo);
                store.addFilters(EType.ATOM);

                LinkedList<Event> events = new LinkedList<>(Arrays.asList(load, add, store));
                return compileSequence(target, nextId, predecessor, events);
    		default:
    	        String tag = mo != null ? "_explicit" : "";
    	        throw new RuntimeException("Compilation of atomic_fetch_add" + tag + " is not implemented for " + target);    			
    	}
    }
}
