package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.IOpBin.AND;
import static com.dat3m.dartagnan.expression.op.IOpBin.AR_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.DIV;
import static com.dat3m.dartagnan.expression.op.IOpBin.UDIV;
import static com.dat3m.dartagnan.expression.op.IOpBin.L_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.MINUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;
import static com.dat3m.dartagnan.expression.op.IOpBin.UREM;
import static com.dat3m.dartagnan.expression.op.IOpBin.SREM;
import static com.dat3m.dartagnan.expression.op.IOpBin.MULT;
import static com.dat3m.dartagnan.expression.op.IOpBin.OR;
import static com.dat3m.dartagnan.expression.op.IOpBin.PLUS;
import static com.dat3m.dartagnan.expression.op.IOpBin.R_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.XOR;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;

public class LlvmFunctions {

	public static List<String> LLVMFUNCTIONS = Arrays.asList(
			"$add.",
			"$sub.",
			"$mul.",
			"$srem.",
			"$urem.",
			"$smod.",
			"$sdiv.",
			"$udiv.",
			"$shl.",
			"$lshr.",
			"$ashr.",
			"$xor.",
			"$or.",
			"$and.",
			"$nand.");
	
	public static Object llvmFunction(String name, List<Object> callParams) {
		IOpBin op = null; 
		if(name.startsWith("$add.")) {
			op = PLUS;
		}
		if(name.startsWith("$sub.")) {
			op = MINUS;
		}
		if(name.startsWith("$mul.")) {
			op = MULT;
		}
		if(name.startsWith("$smod.")) {
			op = MOD;
		}
		if(name.startsWith("$srem.")) {
			op = SREM;
		}
		if(name.startsWith("$urem.")) {
			op = UREM;
		}
		if(name.startsWith("$sdiv.")) {
			op = DIV;
		}
		if(name.startsWith("$udiv.")) {
			op = UDIV;
		}
		if(name.startsWith("$shl.")) {
			op = L_SHIFT;
		}
		if(name.startsWith("$lshr.")) {
			op = R_SHIFT;
		}
		if(name.startsWith("$ashr.")) {
			op = AR_SHIFT;
		}
		if(name.startsWith("$xor.")) {
			op = XOR;
		}
		if(name.startsWith("$or.")) {
			op = OR;
		}
		if(name.startsWith("$and.") || name.startsWith("$nand.")) {
			op = AND;
		}
		if(op == null) {
			throw new ParsingException("Function " + name + " has no implementation");
		}
		return new IExprBin((ExprInterface)callParams.get(0), op, (ExprInterface)callParams.get(1));
	}
}
