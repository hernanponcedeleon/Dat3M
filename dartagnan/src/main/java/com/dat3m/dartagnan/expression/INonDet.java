package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Verify;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;

import static com.dat3m.dartagnan.expression.INonDetTypes.*;
import static org.sosy_lab.java_smt.api.FormulaType.IntegerType;
import static org.sosy_lab.java_smt.api.FormulaType.getBitvectorTypeWithSize;

// TODO why is INonDet not a IConst?
public class INonDet extends IExpr {
	
	private final INonDetTypes type;
	private final int precision;
	
	public INonDet(INonDetTypes type, int precision) {
		this.type = type;
		this.precision = precision;
	}

	public INonDetTypes getType() {
		return type;
	}
	
	@Override
	public Formula toIntFormula(Event e, SolverContext ctx) {
		String name = Integer.toString(hashCode());
		FormulaManager fmgr = ctx.getFormulaManager();
		FormulaType<?> type = precision > 0 ? getBitvectorTypeWithSize(precision) : IntegerType;
		return fmgr.makeVariable(type, name);
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx) {
		Object value = model.evaluate(toIntFormula(e, ctx));
		Verify.verify(value != null, "No value in the model for " + this);
		return new BigInteger(value.toString());			
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}
	
	@Override
	public String toString() {
        switch(type){
        case INT:
            return "nondet_int()";
        case UINT:
            return "nondet_uint()";
		case LONG:
			return "nondet_long()";
		case ULONG:
			return "nondet_ulong()";
		case SHORT:
			return "nondet_short()";
		case USHORT:
			return "nondet_ushort()";
		case CHAR:
			return "nondet_char()";
		case UCHAR:
			return "nondet_uchar()";
        }
        throw new UnsupportedOperationException("toString() not supported for " + this);
	}

	public long getMin() {
        switch(type){
        case UINT:
		case ULONG:
		case USHORT:
		case UCHAR:
            return 0;
        case INT:
            return Integer.MIN_VALUE;
		case LONG:
            return Long.MIN_VALUE;
		case SHORT:
            return Short.MIN_VALUE;
		case CHAR:
            return -128;
        }
        throw new UnsupportedOperationException("getMin() not supported for " + this);
	}

	public long getMax() {
        switch(type){
        case INT:
            return Integer.MAX_VALUE;
        case UINT:
            return UnsignedInteger.MAX_VALUE.longValue();
		case LONG:
            return Long.MAX_VALUE;
		case ULONG:
            return UnsignedLong.MAX_VALUE.longValue();
		case SHORT:
            return Short.MAX_VALUE;
		case USHORT:
            return 65535;
		case CHAR:
            return 127;
		case UCHAR:
            return 255;
        }
        throw new UnsupportedOperationException("getMax() not supported for " + this);
	}

	@Override
	public int getPrecision() {
		return precision;
	}
	
	public BooleanFormula encodeBounds(boolean bp, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
		BooleanFormula enc = bmgr.makeTrue();
		long min = getMin();
		long max = getMax();
		if(bp) {
			boolean signed = !(type.equals(UINT) || type.equals(ULONG) || type.equals(USHORT) || type.equals(UCHAR));
			BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
			enc = bmgr.and(enc, bvmgr.greaterOrEquals((BitvectorFormula) toIntFormula(null,ctx), bvmgr.makeBitvector(precision, min), signed));
	        enc = bmgr.and(enc, bvmgr.lessOrEquals((BitvectorFormula) toIntFormula(null,ctx), bvmgr.makeBitvector(precision, max), signed));
		} else {
			IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
			enc = bmgr.and(enc, imgr.greaterOrEquals((IntegerFormula) toIntFormula(null,ctx), imgr.makeNumber(min)));
			enc = bmgr.and(enc, imgr.lessOrEquals((IntegerFormula) toIntFormula(null,ctx), imgr.makeNumber(max)));
		}
		return enc;
	}
}
