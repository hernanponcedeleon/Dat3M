package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.IOpBin;

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
	
	public static Object llvmFunction(String name, List<Expression> callParams, ExpressionFactory factory) {
		IOpBin op = null; 
		if(name.startsWith("$add.")) {
			op = ADD;
		} else if(name.startsWith("$sub.")) {
			op = SUB;
		} else if(name.startsWith("$mul.")) {
			op = MUL;
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
			op = LSHIFT;
		} else if(name.startsWith("$lshr.")) {
			op = RSHIFT;
		} else if(name.startsWith("$ashr.")) {
			op = ARSHIFT;
		} else if(name.startsWith("$xor.")) {
			//TODO: This is a temporary fix to parse xor.x1 as boolean negation.
			// Once we have proper preprocessing code, we should remove this here!
			if (name.startsWith("$xor.i1") && callParams.get(1) instanceof IConst c) {
				if (c.getValueAsInt() == 0) {
					return callParams.get(0);
				} else if (c.getValueAsInt() == 1) {
					return factory.makeNot(callParams.get(0));
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
		return factory.makeBinary(callParams.get(0), op, callParams.get(1));
	}
}
