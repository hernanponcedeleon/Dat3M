package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

public abstract class MemEvent extends AbstractEvent {

    protected final IExpr address;
    protected final String mo;

    protected Formula memAddressExpr;
    protected Formula memValueExpr;

    public MemEvent(IExpr address, String mo){
        this.address = address;
        this.mo = mo;
        if(mo != null){
            addFilters(mo);
        }
    }
    
    protected MemEvent(MemEvent other){
        super(other);
        this.address = other.address;
        this.memAddressExpr = other.memAddressExpr;
        this.memValueExpr = other.memValueExpr;
        this.mo = other.mo;
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        memAddressExpr = address.toIntFormula(this, ctx);
    }

    public Formula getMemAddressExpr(){
    	Preconditions.checkState(memAddressExpr != null);
    	return memAddressExpr;
    }

    public Formula getMemValueExpr(){
    	Preconditions.checkState(memValueExpr != null);
    	return memValueExpr;
    }

    public IExpr getAddress(){
        return address;
    }

    public ExprInterface getMemValue(){
        throw new RuntimeException("MemValue is not available for event " + this.getClass().getName());
    }
    
    public String getMo(){
        return mo;
    }

    public boolean canRace() {
    	return mo == null || mo.equals("NA");
    }
}