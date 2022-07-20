package com.dat3m.dartagnan.program.memory;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.HashMap;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.google.common.base.Preconditions.checkArgument;

/**
 * Associated with an array of memory locations.
 */
public class MemoryObject extends IConst implements ExprInterface, LastValueInterface {

    private final int index;
    private int size;
    BigInteger address;
	private String cVar;
    // TODO
    // Right now we assume that either the whole object is atomic or it is not.
    // Generally, this is no necessarily true for structs, but right now we
    // don't have a way of marking anything as atomic for bpl files. 
    private boolean atomic = false;

    private final HashMap<Integer,IConst> initialValues = new HashMap<>();

    MemoryObject(int index, int s) {
        this.index = index;
        size = s;
    }

	public String getCVar() {
		return cVar;
	}

	public void setCVar(String name) {
		this.cVar = name;
	}

    /**
     * @return
     * Number of fields in this array.
     */
    public int size() {
        return size;
    }

    /**
     * Initial value at a certain field of this array.
     * @param offset
     * Non-negative number of fields before the target.
     * @return
     * Readable value at the start of each execution.
     */
    public IConst getInitialValue(int offset) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        return initialValues.getOrDefault(offset,IValue.ZERO);
    }

    /**
     * Defines the initial value at a certain field of this array.
     * @param offset
     * Non-negative number of fields before the target.
     * @param value
     * New value to be read at the start of each execution.
     */
    public void setInitialValue(int offset, IConst value) {
        checkArgument(offset >= 0 && offset < size, "array index out of bounds");
        initialValues.put(offset,value);
    }

    /**
     * Updates the initial value at a certain field of this array.
     * Resizes this array if the index exceeds the bounds.
     * @param offset
     * Non-negative number of fields before the target.
     * @param value
     * New value to be read at the start of each execution.
     */
    public void appendInitialValue(int offset, IConst value) {
        checkArgument(offset >= 0, "array index out of bounds");
        //The current implementation of Smack does not provide proper size information on static arrays.
        //Instead, it indicates the size in the Boogie file by initializing each of the fields in a special procedure.
        if(size <= offset) {
            size = offset + 1;
        }
        initialValues.put(offset,value);
    }

    /**
     * Expresses the address of a field of this array.
     * @param offset
     * Non-negative number of fields before the target field.
     * @return
     * Points to the target.
     */
    public IExpr add(int offset) {
        checkArgument(0<=offset && offset<size, "array index out of bounds");
        return offset == 0 ? this : new IExprBin(this,PLUS,new IValue(BigInteger.valueOf(offset),getPrecision()));
    }

    /**
     * Encodes the final state of a location.
     * @param ctx
     * Builder of formulas.
     * @param offset
     * Non-negative number of fields before the target field.
     * @return
     * Variable associated with the value at the location after the execution ended.
     */
    public Formula getLastMemValueExpr(SolverContext ctx, int offset) {
        checkArgument(0<=offset && offset<size, "array index out of bounds");
        String name = String.format("last_val_at_memory_%d_%d",index,offset);
        if(ARCH_PRECISION > -1) {
        	return ctx.getFormulaManager().getBitvectorFormulaManager().makeVariable(ARCH_PRECISION, name);
        } else {
        	return ctx.getFormulaManager().getIntegerFormulaManager().makeVariable(name);
        }
    }

    public boolean isAtomic() {
        return atomic;
    }

    public void markAsAtomic() {
        this.atomic = true;
    }

    @Override
    public BigInteger getValue() {
        return address != null ? address : BigInteger.valueOf(index);
    }

    @Override
    public int getPrecision() {
        return ARCH_PRECISION;
    }

    @Override
    public BooleanFormula toBoolFormula(Event e, SolverContext ctx){
        return ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
    }

    @Override
    public String toString(){
        return cVar != null ? cVar : ("&mem" + index);
    }

    @Override
    public int hashCode(){
        return index;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        return index == ((MemoryObject)obj).index;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
