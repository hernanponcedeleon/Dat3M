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

public class SmackPredicates {

	public static List<String> SMACKPREDICATES = Arrays.asList(
			"$tou.i1", "$tou.i5", "$tou.i6", "$tou.i8", "$tou.i16", "$tou.i24", "$tou.i32", "$tou.i33", "$tou.i40", "$tou.i48", 
			"$tou.i56", "$tou.i64", "$tou.i80", "$tou.i88", "$tou.i96", "$tou.i128", "$tou.i160", "$tou.i256",
			"$tos.i1", "$tos.i5", "$tos.i6", "$tos.i8", "$tos.i16", "$tos.i24", "$tos.i32", "$tos.i33", "$tos.i40", "$tos.i48", 
			"$tos.i56", "$tos.i64", "$tos.i80", "$tos.i88", "$tos.i96", "$tos.i128", "$tos.i160", "$tos.i256"
			);
	
	public static Object smackPredicate(String name, List<Object> callParams) {
		String min = "0";
		String max = "1";
		ExprInterface var = (ExprInterface)callParams.get(0);
		if(name.startsWith("$tou.")) {
			switch(name.substring(name.lastIndexOf(".")+1)) {
			case "i1":
				max = "1"; break;
			case "i5":
				max = "32"; break;
			case "i6":
				max = "64"; break;
			case "i8":
				max = "256"; break;
			case "i16":
				max = "65536"; break;
			case "i24":
				max = "16777216"; break;
			case "i32":
				max = "4294967296"; break;
			case "i33":
				max = "8589934592"; break;
			case "i40":
				max = "1099511627776"; break;
			case "i48":
				max = "281474976710656"; break;
			case "i56":
				max = "72057594037927936"; break;
			case "i64":
				max = "18446744073709551616"; break;
			case "i80":
				max = "1208925819614629174706176"; break;
			case "i88":
				max = "309485009821345068724781056"; break;
			case "i96":
				max = "79228162514264337593543950336"; break;
			case "i128":
				max = "340282366920938463463374607431768211456"; break;
			case "i160":
				max = "1461501637330902918203684832716283019655932542976"; break;
			case "i256":
				max = "115792089237316195423570985008687907853269984665640564039457584007913129639936"; break;
			default:
				throw new ParsingException("Function " + name + " has no implementation");
			}
		}
		if(name.startsWith("$tos.")) {
			switch(name.substring(name.lastIndexOf(".")+1)) {
			case "i1":
				min = "-1"; max = "1"; break;
			case "i5":
				min = "-16"; max = "16"; break;
			case "i6":
				min = "-32"; max = "32"; break;
			case "i8":
				min = "-128"; max = "128"; break;
			case "i16":
				min = "-32768"; max = "32768"; break;
			case "i24":
				min = "-8388608"; max = "8388608"; break;
			case "i32":
				min = "-2147483648"; max = "2147483648"; break;
			case "i33":
				min = "-4294967296"; max = "4294967296"; break;
			case "i40":
				min = "-549755813888"; max = "549755813888"; break;
			case "i48":
				min = "-140737488355328"; max = "140737488355328"; break;
			case "i56":
				min = "-36028797018963968"; max = "36028797018963968"; break;
			case "i64":
				min = "-9223372036854775808"; max = "9223372036854775808"; break;
			case "i80":
				min = "-604462909807314587353088"; max = "604462909807314587353088"; break;
			case "i88":
				min = "-154742504910672534362390528"; max = "154742504910672534362390528"; break;
			case "i96":
				min = "-39614081257132168796771975168"; max = "39614081257132168796771975168"; break;
			case "i128":
				min = "-170141183460469231731687303715884105728"; max = "170141183460469231731687303715884105728"; break;
			case "i160":
				min = "-730750818665451459101842416358141509827966271488"; max = "730750818665451459101842416358141509827966271488"; break;
			case "i256":
				min = "-57896044618658097711785492504343953926634992332820282019728792003956564819968"; max = "57896044618658097711785492504343953926634992332820282019728792003956564819968"; break;
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
