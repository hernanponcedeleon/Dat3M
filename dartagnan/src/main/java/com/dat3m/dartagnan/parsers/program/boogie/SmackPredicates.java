package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.util.Arrays;
import java.util.List;

public class SmackPredicates {

	public static List<String> SMACKPREDICATES = Arrays.asList(
			"$tou.i1", "$tou.i5", "$tou.i6", "$tou.i8", "$tou.i16", "$tou.i24", "$tou.i32", "$tou.i33", "$tou.i40", "$tou.i48", 
			"$tou.i56", "$tou.i64", "$tou.i80", "$tou.i88", "$tou.i96", "$tou.i128", "$tou.i160", "$tou.i256",
			"$tos.i1", "$tos.i5", "$tos.i6", "$tos.i8", "$tos.i16", "$tos.i24", "$tos.i32", "$tos.i33", "$tos.i40", "$tos.i48", 
			"$tos.i56", "$tos.i64", "$tos.i80", "$tos.i88", "$tos.i96", "$tos.i128", "$tos.i160", "$tos.i256"
			);
	
	public static Object smackPredicate(String name, List<Expression> callParams, ExpressionFactory expressions) {
		final Expression var = callParams.get(0);
		final IntegerType varType = (IntegerType) var.getType(); // TODO: Generalize

		String min = "0";
		String max = "1";
		if(name.startsWith("$tou.")) {
			max = switch (name.substring(name.lastIndexOf(".") + 1)) {
				case "i1" -> "1";
				case "i5" -> "32";
				case "i6" -> "64";
				case "i8" -> "256";
				case "i16" -> "65536";
				case "i24" -> "16777216";
				case "i32" -> "4294967296";
				case "i33" -> "8589934592";
				case "i40" -> "1099511627776";
				case "i48" -> "281474976710656";
				case "i56" -> "72057594037927936";
				case "i64" -> "18446744073709551616";
				case "i80" -> "1208925819614629174706176";
				case "i88" -> "309485009821345068724781056";
				case "i96" -> "79228162514264337593543950336";
				case "i128" -> "340282366920938463463374607431768211456";
				case "i160" -> "1461501637330902918203684832716283019655932542976";
				case "i256" -> "115792089237316195423570985008687907853269984665640564039457584007913129639936";
				default -> throw new ParsingException("Function " + name + " has no implementation");
			};
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
		final IValue maxValue = expressions.parseValue(max, varType);
		final IValue minValue = expressions.parseValue(min, varType);
		return expressions.makeConditional(
				expressions.makeAnd(
						expressions.makeGTE(var, minValue, true),
						expressions.makeLTE(var, maxValue, true)),
				var,
				expressions.makeMOD(var, maxValue));
	}
}
