package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.SolverContext;

public class Store extends MemEvent implements RegReaderData {

    protected ExprInterface value;
    private ImmutableSet<Register> dataRegs;

    public Store(IExpr address, ExprInterface value, String mo){
    	super(address, mo);
        this.value = value;
        dataRegs = value.getRegs();
        addFilters(Tag.ANY, Tag.VISIBLE, Tag.MEMORY, Tag.WRITE, Tag.REG_READER);
    }
    
    protected Store(Store other){
        super(other);
        this.value = other.value;
        dataRegs = other.dataRegs;
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
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

    @Override
    public void setMemValue(ExprInterface value){
        this.value = value;
        this.dataRegs = value.getRegs();
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Store getCopy(){
        return new Store(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitStore(this);
	}
}