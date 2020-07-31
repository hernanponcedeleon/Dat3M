package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;
import static com.dat3m.dartagnan.expression.op.COpBin.LTE;
import static com.dat3m.dartagnan.expression.op.COpBin.LT;
import static com.dat3m.dartagnan.expression.op.COpBin.GTE;
import static com.dat3m.dartagnan.expression.op.COpBin.GT;
import static com.dat3m.dartagnan.expression.op.COpBin.ULTE;
import static com.dat3m.dartagnan.expression.op.COpBin.ULT;
import static com.dat3m.dartagnan.expression.op.COpBin.UGTE;
import static com.dat3m.dartagnan.expression.op.COpBin.UGT;
import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;

public class LlvmPredicates {

	public static List<String> LLVMPREDICATES = Arrays.asList(
			"$ule.bv8.bool", "$ule.bv16.bool", "$ule.bv32.bool", "$ule.bv64.bool",
			"$ult.bv8.bool", "$ult.bv16.bool", "$ult.bv32.bool", "$ult.bv64.bool",
			"$uge.bv8.bool", "$uge.bv16.bool", "$uge.bv32.bool", "$uge.bv64.bool",
			"$ugt.bv8.bool", "$ugt.bv16.bool", "$ugt.bv32.bool", "$ugt.bv64.bool",
			"$sle.bv8.bool", "$sle.bv16.bool", "$sle.bv32.bool", "$sle.bv64.bool",
			"$slt.bv8.bool", "$slt.bv16.bool", "$slt.bv32.bool", "$slt.bv64.bool",
			"$sge.bv8.bool", "$sge.bv16.bool", "$sge.bv32.bool", "$sge.bv64.bool",
			"$sgt.bv8.bool", "$sgt.bv16.bool", "$sgt.bv32.bool", "$sgt.bv64.bool",
			"$eq.bv8.bool", "$eq.bv16.bool", "$eq.bv32.bool", "$eq.bv64.bool",
			"$ne.bv8.bool", "$ne.bv16.bool", "$ne.bv32.bool", "$ne.bv64.bool"
			);
	
	public static Object llvmPredicate(String name, List<Object> callParams) {
		COpBin op = null;
		if(name.startsWith("$sle.")) {
			op = LTE;
		}
		if(name.startsWith("$ule.")) {
			op = ULTE;
		}
		if(name.startsWith("$slt.")) {
			op = LT;
		}
		if(name.startsWith("$ult.")) {
			op = ULT;
		}
		if(name.startsWith("$sge.")) {
			op = GTE;
		}
		if(name.startsWith("$uge.")) {
			op = UGTE;
		}
		if(name.startsWith("$sgt.")) {
			op = GT;
		}
		if(name.startsWith("$ugt.")) {
			op = UGT;
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
