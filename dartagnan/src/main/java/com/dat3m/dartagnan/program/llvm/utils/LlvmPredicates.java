package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.expression.op.COpBin.LTE;
import static com.dat3m.dartagnan.expression.op.COpBin.LT;
import static com.dat3m.dartagnan.expression.op.COpBin.GTE;
import static com.dat3m.dartagnan.expression.op.COpBin.GT;
import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;

public class LlvmPredicates {

	public static List<String> LLVMPREDICATES = Arrays.asList(
			"$ule.",
			"$ult.",
			"$uge.",
			"$ugt.",
			"$sle.",
			"$slt.",
			"$sge.",
			"$sgt.",
			"$eq.",
			"$ne.");
	
	public static Object llvmPredicate(String name, List<Object> callParams) {
		COpBin op = null; 
		if(name.startsWith("$sle.") | name.startsWith("$ule.")) {
			op = LTE;
		}
		if(name.startsWith("$slt.") | name.startsWith("$ult.")) {
			op = LT;
		}
		if(name.startsWith("$sge.") | name.startsWith("$uge.")) {
			op = GTE;
		}
		if(name.startsWith("$sgt.") | name.startsWith("$ugt.")) {
			op = GT;
		}
		if(name.startsWith("$eq.")) {
			op = EQ;
		}
		if(name.startsWith("$ne.")) {
			op = NEQ;
		}
		if(op == null) {
			throw new ParsingException("Function " + name + " has no implementation");
		}
		return new Atom((ExprInterface)callParams.get(0), op, (ExprInterface)callParams.get(1));
	}
}
