package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.BOpBin.AND;
import static com.dat3m.dartagnan.expression.op.COpBin.LTE;
import static com.dat3m.dartagnan.expression.op.COpBin.GTE;
import static com.dat3m.dartagnan.expression.op.IOpBin.MOD;
import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BExprBin;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IfExpr;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.google.common.primitives.UnsignedInteger;

public class SmackPredicates {

	public static List<String> SMACKPREDICATES = Arrays.asList(
			"$tou.i1", "$tou.i5", "$tou.i6", "$tou.i8", "$tou.i16", "$tou.i24", "$tou.i32", "$tou.i40", "$tou.i48", 
			"$tou.i56", "$tou.i64", "$tou.i80", "$tou.i88", "$tou.i96", "$tou.i128", "$tou.i160", "$tou.i256",
			"$tos.i1", "$tos.i5", "$tos.i6", "$tos.i8", "$tos.i16", "$tos.i24", "$tos.i32", "$tos.i40", "$tos.i48", 
			"$tos.i56", "$tos.i64", "$tos.i80", "$tos.i88", "$tos.i96", "$tos.i128", "$tos.i160", "$tos.i256"
			);
	
	public static Object smackPredicate(String name, List<Object> callParams) {
		long min = 0;
		long max = 1;
		ExprInterface var = (ExprInterface)callParams.get(0);
		if(name.startsWith("$tou.")) {
			switch(name.substring(name.lastIndexOf(".")+1)) {
			case "i1":
				max = 1; break;
			case "i5":
				max = 31; break;
			case "i6":
				max = 63; break;
			case "i8":
				max = 255; break;
			case "i16":
				max = 65535; break;
			case "i24":
				max = 16777215; break;
			case "i32":
				max = UnsignedInteger.MAX_VALUE.longValue(); break;
			default:
				throw new ParsingException("Function " + name + " has no implementation");
			}
		}
		if(name.startsWith("$tos.")) {
			switch(name.substring(name.lastIndexOf(".")+1)) {
			case "i1":
				min = -1; max = 1; break;
			case "i5":
				min = -16; max = 15; break;
			case "i6":
				min = -32; max = 31; break;
			case "i8":
				min = -128; max = 127; break;
			case "i16":
				min = -32768; max = 32767; break;
			case "i24":
				min = -8388608; max = 8388607; break;
			case "i32":
				min = -2147483648; max = 2147483647; break;
			default:
				throw new ParsingException("Function " + name + " has no implementation");
			}
		}
		Atom c1 = new Atom(var, GTE, new IConst(min, var.getPrecision()));
		Atom c2 = new Atom(var, LTE, new IConst(max, var.getPrecision()));
		BExprBin guard = new BExprBin(c1, AND, c2);
		ExprInterface fbranch = new IExprBin(var, MOD, new IConst(max, var.getPrecision()));
		return new IfExpr(guard, var, fbranch);
	}
}
