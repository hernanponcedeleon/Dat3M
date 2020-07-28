package com.dat3m.dartagnan.program.memory;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public class Address extends IConst implements ExprInterface {

    private final int index;
    private Integer constValue;

    Address(int index){
        super(index);
        this.index = index;
    }

    @Override
    public ImmutableSet<Register> getRegs(){
        return ImmutableSet.of();
    }

    @Override
    public Expr toZ3Int(Event e, EncodingConf conf){
        return toZ3Int(conf);
    }

    @Override
    public Expr getLastValueExpr(EncodingConf conf){
        return toZ3Int(conf);
    }

    public Expr getLastMemValueExpr(EncodingConf conf){
    	Context ctx = conf.getCtx();
        return conf.getBP() ? ctx.mkBVConst("last_val_at_memory_" + index, 32) : ctx.mkIntConst("last_val_at_memory_" + index);
    }

    @Override
    public BoolExpr toZ3Bool(Event e, EncodingConf conf){
        return conf.getCtx().mkTrue();
    }

    @Override
    public String toString(){
        return "&mem" + index;
    }

    @Override
    public int hashCode(){
        return index;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        return index == ((Address)obj).index;
    }

    @Override
    public Expr toZ3Int(EncodingConf conf){
    	Context ctx = conf.getCtx();
		return conf.getBP() ? ctx.mkBVConst("memory_" + index, 32) : ctx.mkIntConst("memory_" + index);
    }

    @Override
    public int getIntValue(Event e, Model model, EncodingConf conf){
        return Integer.parseInt(model.getConstInterp(toZ3Int(conf)).toString());
    }
    
    public boolean hasConstValue() {
    	return constValue != null;
    }
    
    public Integer getConstValue() {
    	return constValue;
    }
    
    public void setConstValue(Integer value) {
    	this.constValue = value;
    }
}
