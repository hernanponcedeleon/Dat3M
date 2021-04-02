package com.dat3m.dartagnan.program.arch.aarch64.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.utils.recursion.RecursiveFunction;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.Arrays;
import java.util.LinkedList;

public class StoreExclusive extends Store implements RegWriter, RegReaderData {

    private final Register register;

    public StoreExclusive(Register register, IExpr address, ExprInterface value, String mo){
        super(address, value, mo);
        this.register = register;
        addFilters(EType.EXCL, EType.REG_WRITER);
    }

    private StoreExclusive(StoreExclusive other){
        super(other);
        this.register = other.register;
    }

    @Override
    public Register getResultRegister(){
        return register;
    }

    @Override
    public String toString(){
        return register + " <- store(*" + address + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public StoreExclusive getCopy(){
        return new StoreExclusive(this);
    }


    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    protected RecursiveFunction<Integer> compileRecursive(Arch target, int nextId, Event predecessor, int depth) {
        if(target == Arch.ARM || target == Arch.ARM8) {
            RMWStoreExclusive store = new RMWStoreExclusive(address, value, mo);
            RMWStoreExclusiveStatus status = new RMWStoreExclusiveStatus(register, store);
            LinkedList<Event> events = new LinkedList<>(Arrays.asList(store, status));
            return compileSequenceRecursive(target, nextId, predecessor, events, depth + 1);
        }
        throw new RuntimeException("Compilation of StoreExclusive is not implemented for " + target);
    }


    // Encoding
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public BoolExpr encodeCF(Context ctx, BoolExpr cond) {
        throw new RuntimeException("StoreExclusive event must be compiled before encoding");
    }
}
