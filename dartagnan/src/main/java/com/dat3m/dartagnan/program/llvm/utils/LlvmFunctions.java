package com.dat3m.dartagnan.program.llvm.utils;

import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;

import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.IOpBin.*;

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
			//TODO: This is a temporary fix to parse xor.x1 as boolean negation.
			// Once we have proper preprocessing code, we should remove this here!
			if (name.startsWith("$xor.i1") && callParams.get(1) instanceof IConst) {
				IConst c = (IConst) callParams.get(1);
				if (c.getIntValue().intValue() == 0) {
					return callParams.get(0);
				} else if (c.getIntValue().intValue() == 1) {
					return new BExprUn(BOpUn.NOT, (ExprInterface) callParams.get(0));
				}
			}
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
