package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;

public class LlvmUnary {

	public static List<String> LLVMUNARY = Arrays.asList(
			"$not.",
			"$zext.",
			"$sext.",
			"$bv2uint.",
			"$bv2int.",
			"$uint2bv.",
			"$int2bv.",
			"$trunc.");
	
	public static Object llvmUnary(String name, List<Object> callParams) {
		if(name.startsWith("$not.")) {
			return new BExprUn(NOT, (ExprInterface)callParams.get(0));
		}
		return callParams.get(0);
	}
}
