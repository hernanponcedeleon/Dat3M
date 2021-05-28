package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import java.math.BigInteger;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class Address extends IConst implements ExprInterface {

    private final int index;
    private BigInteger constantValue;

    Address(int index, int precision){
        super(BigInteger.valueOf(index), precision);
        this.index = index;
    }

    public boolean hasConstantValue() {
     	return this.constantValue != null;
     }

    public BigInteger getConstantValue() {
     	return this.constantValue;
     }

    public void setConstantValue(BigInteger value) {
     	this.constantValue = value;
     }

    @Override
    public ImmutableSet<Register> getRegs(){
        return ImmutableSet.of();
    }

    @Override
    public Expr toZ3Int(Event e, Context ctx){
        return toZ3Int(ctx);
    }

    @Override
    public Expr getLastValueExpr(Context ctx){
        return toZ3Int(ctx);
    }

    public Expr getLastMemValueExpr(Context ctx){
        return precision > 0 ? ctx.mkBVConst("last_val_at_memory_" + index, precision) : ctx.mkIntConst("last_val_at_memory_" + index);
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx){
        return ctx.mkTrue();
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
    public Expr toZ3Int(Context ctx){
    	if(constantValue != null) {
    		return precision > 0 ? ctx.mkBV(constantValue.toString(), precision) : ctx.mkInt(constantValue.toString());
    	}
		return precision > 0 ? ctx.mkBVConst("memory_" + index, precision) : ctx.mkIntConst("memory_" + index);
    }

    @Override
    public BigInteger getIntValue(Event e, Model model, Context ctx){
        return new BigInteger(model.getConstInterp(toZ3Int(ctx)).toString());
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
