package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.IOpBin.AND;
import static com.dat3m.dartagnan.expression.op.IOpBin.AR_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.DIV;
import static com.dat3m.dartagnan.expression.op.IOpBin.L_SHIFT;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;
import static com.dat3m.dartagnan.expression.op.IOpBin.OR;
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
		if(name.contains("$srem.") || name.contains("$urem.") || name.contains("$smod.")) {
			op = MOD;
		}
		if(name.contains("$sdiv.") || name.contains("$udiv.")) {
			op = DIV;
		}
		if(name.contains("$shl.")) {
			op = L_SHIFT;
		}
		if(name.contains("$lshr.")) {
			op = R_SHIFT;
		}
		if(name.contains("$ashr.")) {
			op = AR_SHIFT;
		}
		if(name.contains("$xor.")) {
			op = XOR;
		}
		if(name.contains("$or.")) {
			op = OR;
		}
		if(name.contains("$and.") || name.contains("$nand.")) {
			op = AND;
		}
		if(op == null) {
			throw new ParsingException("Function " + name + " has no implementation");
		}
		op.disableBV();
		return new IExprBin((ExprInterface)callParams.get(0), op, (ExprInterface)callParams.get(1));
	}
}
