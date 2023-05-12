package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;

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
	
	public static Object llvmFunction(String name, List<Object> callParams, ExpressionFactory factory) {
		IOpBin op = null; 
		if(name.startsWith("$add.")) {
			op = PLUS;
		} else if(name.startsWith("$sub.")) {
			op = MINUS;
		} else if(name.startsWith("$mul.")) {
			op = MULT;
		} else if(name.startsWith("$smod.")) {
			op = MOD;
		} else if(name.startsWith("$srem.")) {
			op = SREM;
		} else if(name.startsWith("$urem.")) {
			op = UREM;
		} else if(name.startsWith("$sdiv.")) {
			op = DIV;
		} else if(name.startsWith("$udiv.")) {
			op = UDIV;
		} else if(name.startsWith("$shl.")) {
			op = L_SHIFT;
		} else if(name.startsWith("$lshr.")) {
			op = R_SHIFT;
		} else if(name.startsWith("$ashr.")) {
			op = AR_SHIFT;
		} else if(name.startsWith("$xor.")) {
			//TODO: This is a temporary fix to parse xor.x1 as boolean negation.
			// Once we have proper preprocessing code, we should remove this here!
			if (name.startsWith("$xor.i1") && callParams.get(1) instanceof IConst) {
				IConst c = (IConst) callParams.get(1);
				if (c.getValueAsInt() == 0) {
					return callParams.get(0);
				} else if (c.getValueAsInt() == 1) {
					return factory.makeUnary(BOpUn.NOT, (Expression) callParams.get(0));
				}
			}
			op = XOR;
		} else if(name.startsWith("$or.")) {
			op = OR;
		} else if(name.startsWith("$and.") || name.startsWith("$nand.")) {
			op = AND;
		}
		if(op == null) {
			throw new ParsingException("Function " + name + " has no implementation");
		}
		return factory.makeBinary((Expression)callParams.get(0), op, (Expression)callParams.get(1));
	}
}
