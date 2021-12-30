package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.SolverContext;

public class Store extends MemEvent implements RegReaderData {

    protected final ExprInterface value;
    private final ImmutableSet<Register> dataRegs;

    public Store(IExpr address, ExprInterface value, String mo){
    	super(address, mo);
        this.value = value;
        dataRegs = value.getRegs();
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.WRITE, EType.REG_READER);
    }
    
    protected Store(Store other){
        super(other);
        this.value = other.value;
        dataRegs = other.dataRegs;
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
        memValueExpr = value.toIntFormula(this, ctx);
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    @Override
    public String toString() {
        return "store(*" + address + ", " + value + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public ExprInterface getMemValue(){
        return value;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Store getCopy(){
        return new Store(this);
    }
}
