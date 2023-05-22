package com.dat3m.dartagnan.parsers.program.boogie;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;

import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.IOpUn.*;

public class LlvmUnary {

	public static List<String> LLVMUNARY = Arrays.asList(
			"$not.",

			"$bv2uint.", "$bv2int.",

			"$uint2bv.1", "$uint2bv.8", "$uint2bv.16", "$uint2bv.32", "$uint2bv.64",
			"$int2bv.1", "$int2bv.8", "$int2bv.16", "$int2bv.32", "$int2bv.64",
			
			"$trunc.bv64.bv32", "$trunc.bv64.bv16", "$trunc.bv64.bv8", "$trunc.bv64.bv1",
			"$trunc.bv32.bv16", "$trunc.bv32.bv8", "$trunc.bv32.bv1",
			"$trunc.bv16.bv8", "$trunc.bv16.bv1",
			"$trunc.bv8.bv1",
			
			"$zext.bv1.bv8", "$zext.bv1.bv16", "$zext.bv1.bv32","$zext.bv1.bv64", 
			"$zext.bv8.bv16", "$zext.bv8.bv32", "$zext.bv8.bv64",
			"$zext.bv16.bv32", "$zext.bv16.bv64",
			"$zext.bv32.bv64",
			
			"$sext.bv1.bv8", "$sext.bv1.bv16", "$sext.bv1.bv32","$sext.bv1.bv64", 
			"$sext.bv8.bv16", "$sext.bv8.bv32", "$sext.bv8.bv64",
			"$sext.bv16.bv32", "$sext.bv16.bv64",
			"$sext.bv32.bv64"
			);
	
	public static Object llvmUnary(String name, List<Object> callParams, ExpressionFactory factory) {
		if(name.startsWith("$not.")) {
			return factory.makeNot((Expression)callParams.get(0));
		}

		IOpUn op = null;
		if(name.startsWith("$bv2uint.")) {
			op = BV2UINT;
		} else if(name.startsWith("$bv2int.")) {
			op = BV2INT;
		} else if (name.contains("int2bv")) {
			// ============ INT2BV ============
			if (name.equals("$uint2bv.1") || name.equals("$int2bv.1")) {
				op = INT2BV1;
			} else if (name.equals("$uint2bv.8") || name.equals("$int2bv.8")) {
				op = INT2BV8;
			} else if (name.equals("$uint2bv.16") || name.equals("$int2bv.16")) {
				op = INT2BV16;
			} else if (name.equals("$uint2bv.32") || name.equals("$int2bv.32")) {
				op = INT2BV32;
			} else if (name.equals("$uint2bv.64") || name.equals("$int2bv.64")) {
				op = INT2BV64;
			}
		} else if (name.startsWith("$trunc.")) {
			// ============ TRUNC ============
			if (name.equals("$trunc.bv64.bv32")) {
				op = TRUNC6432;
			} else if (name.equals("$trunc.bv64.bv16")) {
				op = TRUNC6416;
			} else if (name.equals("$trunc.bv64.bv8")) {
				op = TRUNC648;
			} else if (name.equals("$trunc.bv64.bv1")) {
				op = TRUNC641;
			} else if (name.equals("$trunc.bv32.bv16")) {
				op = TRUNC3216;
			} else if (name.equals("$trunc.bv32.bv8")) {
				op = TRUNC328;
			} else if (name.equals("$trunc.bv32.bv1")) {
				op = TRUNC321;
			} else if (name.equals("$trunc.bv16.bv8")) {
				op = TRUNC168;
			} else if (name.equals("$trunc.bv16.bv1")) {
				op = TRUNC161;
			} else if (name.equals("$trunc.bv8.bv1")) {
				op = TRUNC81;
			}
		} else if (name.startsWith("$zext")) {
			// ============ ZEXT ============
			if (name.equals("$zext.bv1.bv8")) {
				op = ZEXT18;
			} else if (name.equals("$zext.bv1.bv16")) {
				op = ZEXT116;
			} else if (name.equals("$zext.bv1.bv32")) {
				op = ZEXT132;
			} else if (name.equals("$zext.bv1.bv64")) {
				op = ZEXT164;
			} else if (name.equals("$zext.bv8.bv16")) {
				op = ZEXT816;
			} else if (name.equals("$zext.bv8.bv32")) {
				op = ZEXT832;
			} else if (name.equals("$zext.bv8.bv64")) {
				op = ZEXT864;
			} else if (name.equals("$zext.bv16.bv32")) {
				op = ZEXT1632;
			} else if (name.equals("$zext.bv16.bv64")) {
				op = ZEXT1664;
			} else if (name.equals("$zext.bv32.bv64")) {
				op = ZEXT3264;
			}
		} else if (name.startsWith("$sext")) {
			// ============ SEXT ============
			if (name.equals("$sext.bv1.bv8")) {
				op = SEXT18;
			} else if (name.equals("$sext.bv1.bv16")) {
				op = SEXT116;
			} else if (name.equals("$sext.bv1.bv32")) {
				op = SEXT132;
			} else if (name.equals("$sext.bv1.bv64")) {
				op = SEXT164;
			} else if (name.equals("$sext.bv8.bv16")) {
				op = SEXT816;
			} else if (name.equals("$sext.bv8.bv32")) {
				op = SEXT832;
			} else if (name.equals("$sext.bv8.bv64")) {
				op = SEXT864;
			} else if (name.equals("$sext.bv16.bv32")) {
				op = SEXT1632;
			} else if (name.equals("$sext.bv16.bv64")) {
				op = SEXT1664;
			} else if (name.equals("$sext.bv32.bv64")) {
				op = SEXT3264;
			}
		}

		if(op == null) {
			throw new ParsingException("Function " + name + " has no implementation");
		}
		return factory.makeUnary(op, (Expression)callParams.get(0));
	}
}
