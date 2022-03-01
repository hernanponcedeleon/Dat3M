package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.exception.ParsingException;

import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.*;

public class LlvmPredicates {

	public static List<String> LLVMPREDICATES = Arrays.asList(
			"$ule.i8", "$ule.i16", "$ule.i32", "$ule.i64",
			"$ult.i8", "$ult.i16", "$ult.i32", "$ult.i64",
			"$uge.i8", "$uge.i16", "$uge.i32", "$uge.i64",
			"$ugt.i8", "$ugt.i16", "$ugt.i32", "$ugt.i64",
			"$sle.i8", "$sle.i16", "$sle.i32", "$sle.i64",
			"$slt.i8", "$slt.i16", "$slt.i32", "$slt.i64",
			"$sge.i8", "$sge.i16", "$sge.i32", "$sge.i64",
			"$sgt.i8", "$sgt.i16", "$sgt.i32", "$sgt.i64",
			"$eq.i8", "$eq.i16", "$eq.i32", "$eq.i64",
			"$ne.i8", "$ne.i16", "$ne.i32", "$ne.i64",
			"$ule.i8.bool", "$ule.i16.bool", "$ule.i32.bool", "$ule.i64.bool",
			"$ult.i8.bool", "$ult.i16.bool", "$ult.i32.bool", "$ult.i64.bool",
			"$uge.i8.bool", "$uge.i16.bool", "$uge.i32.bool", "$uge.i64.bool",
			"$ugt.i8.bool", "$ugt.i16.bool", "$ugt.i32.bool", "$ugt.i64.bool",
			"$sle.i8.bool", "$sle.i16.bool", "$sle.i32.bool", "$sle.i64.bool",
			"$slt.i8.bool", "$slt.i16.bool", "$slt.i32.bool", "$slt.i64.bool",
			"$sge.i8.bool", "$sge.i16.bool", "$sge.i32.bool", "$sge.i64.bool",
			"$sgt.i8.bool", "$sgt.i16.bool", "$sgt.i32.bool", "$sgt.i64.bool",
			"$eq.i8.bool", "$eq.i16.bool", "$eq.i32.bool", "$eq.i64.bool",
			"$ne.i8.bool", "$ne.i16.bool", "$ne.i32.bool", "$ne.i64.bool",
			// Our toIntFormula implementation always convert BExpr to integer variables
			// (never to bit-vector), thus we need to parse functions like "$ule.ref" or "$ule.bv8"
			// using smack definition which will create the constants 1 and 0 as BV
			"$ule.ref.bool",
			"$ult.ref.bool",
			"$uge.ref.bool",
			"$ugt.ref.bool",
			"$sle.ref.bool",
			"$slt.ref.bool",
			"$sge.ref.bool",
			"$sgt.ref.bool",
			"$eq.ref.bool",
			"$ne.ref.bool",
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
		} else if(name.startsWith("$ule.")) {
			op = ULTE;
		} else if(name.startsWith("$slt.")) {
			op = LT;
		} else if(name.startsWith("$ult.")) {
			op = ULT;
		} else if(name.startsWith("$sge.")) {
			op = GTE;
		} else if(name.startsWith("$uge.")) {
			op = UGTE;
		} else if(name.startsWith("$sgt.")) {
			op = GT;
		} else if(name.startsWith("$ugt.")) {
			op = UGT;
		} else if(name.startsWith("$eq.")) {
			op = EQ;
		} else if(name.startsWith("$ne.")) {
			op = NEQ;
		}
		if(op == null) {
			throw new ParsingException("Function " + name + " has no implementation");
		}
		return new Atom((ExprInterface)callParams.get(0), op, (ExprInterface)callParams.get(1));
	}
}
