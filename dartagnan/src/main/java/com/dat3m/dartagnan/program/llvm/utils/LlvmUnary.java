package com.dat3m.dartagnan.program.llvm.utils;

import static com.dat3m.dartagnan.expression.op.BOpUn.NOT;
import static com.dat3m.dartagnan.expression.op.IOpUn.BV2UINT;
import static com.dat3m.dartagnan.expression.op.IOpUn.BV2INT;

import static com.dat3m.dartagnan.expression.op.IOpUn.INT2BV1;
import static com.dat3m.dartagnan.expression.op.IOpUn.INT2BV8;
import static com.dat3m.dartagnan.expression.op.IOpUn.INT2BV16;
import static com.dat3m.dartagnan.expression.op.IOpUn.INT2BV32;
import static com.dat3m.dartagnan.expression.op.IOpUn.INT2BV64;

import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC6432;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC6416;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC648;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC641;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC3216;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC328;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC321;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC168;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC161;
import static com.dat3m.dartagnan.expression.op.IOpUn.TRUNC81;

import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT18;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT116;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT132;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT164;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT816;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT832;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT864;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT1632;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT1664;
import static com.dat3m.dartagnan.expression.op.IOpUn.ZEXT3264;

import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT18;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT116;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT132;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT164;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT816;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT832;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT864;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT1632;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT1664;
import static com.dat3m.dartagnan.expression.op.IOpUn.SEXT3264;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.BExprUn;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExprUn;
import com.dat3m.dartagnan.expression.op.IOpUn;

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
	
	public static Object llvmUnary(String name, List<Object> callParams) {
		if(name.startsWith("$not.")) {
			return new BExprUn(NOT, (ExprInterface)callParams.get(0));
		}

		IOpUn op = null;
		if(name.startsWith("$bv2uint.")) {
			op = BV2UINT;
		}
		if(name.startsWith("$bv2int.")) {
			op = BV2INT;
		}
		// ============ INT2BV ============
		if(name.equals("$uint2bv.1") || name.equals("$int2bv.1")) {
			op = INT2BV1;
		}
		if(name.equals("$uint2bv.8") || name.equals("$int2bv.8")) {
			op = INT2BV8;
		}
		if(name.equals("$uint2bv.16") || name.equals("$int2bv.16")) {
			op = INT2BV16;
		}
		if(name.equals("$uint2bv.32") || name.equals("$int2bv.32")) {
			op = INT2BV32;
		}
		if(name.equals("$uint2bv.64") || name.equals("$int2bv.64")) {
			op = INT2BV64;
		}
		// ============ TRUNC ============
		if(name.equals("$trunc.bv64.bv32")) {
			op = TRUNC6432;
		}
		if(name.equals("$trunc.bv64.bv16")) {
			op = TRUNC6416;
		}
		if(name.equals("$trunc.bv64.bv8")) {
			op = TRUNC648;
		}
		if(name.equals("$trunc.bv64.bv1")) {
			op = TRUNC641;
		}
		if(name.equals("$trunc.bv32.bv16")) {
			op = TRUNC3216;
		}
		if(name.equals("$trunc.bv32.bv8")) {
			op = TRUNC328;
		}
		if(name.equals("$trunc.bv32.bv1")) {
			op = TRUNC321;
		}
		if(name.equals("$trunc.bv16.bv8")) {
			op = TRUNC168;
		}
		if(name.equals("$trunc.bv16.bv1")) {
			op = TRUNC161;
		}
		if(name.equals("$trunc.bv8.bv1")) {
			op = TRUNC81;
		}
		// ============ ZEXT ============ 
		if(name.equals("$zext.bv1.bv8")) {
			op = ZEXT18;
		}
		if(name.equals("$zext.bv1.bv16")) {
			op = ZEXT116;
		}
		if(name.equals("$zext.bv1.bv32")) {
			op = ZEXT132;
		}
		if(name.equals("$zext.bv1.bv64")) {
			op = ZEXT164;
		}
		if(name.equals("$zext.bv8.bv16")) {
			op = ZEXT816;
		}
		if(name.equals("$zext.bv8.bv32")) {
			op = ZEXT832;
		}
		if(name.equals("$zext.bv8.bv64")) {
			op = ZEXT864;
		}
		if(name.equals("$zext.bv16.bv32")) {
			op = ZEXT1632;
		}
		if(name.equals("$zext.bv16.bv64")) {
			op = ZEXT1664;
		}
		if(name.equals("$zext.bv32.bv64")) {
			op = ZEXT3264;
		}
		// ============ SEXT ============
		if(name.equals("$sext.bv1.bv8")) {
			op = SEXT18;
		}
		if(name.equals("$sext.bv1.bv16")) {
			op = SEXT116;
		}
		if(name.equals("$sext.bv1.bv32")) {
			op = SEXT132;
		}
		if(name.equals("$sext.bv1.bv64")) {
			op = SEXT164;
		}
		if(name.equals("$sext.bv8.bv16")) {
			op = SEXT816;
		}
		if(name.equals("$sext.bv8.bv32")) {
			op = SEXT832;
		}
		if(name.equals("$sext.bv8.bv64")) {
			op = SEXT864;
		}
		if(name.equals("$sext.bv16.bv32")) {
			op = SEXT1632;
		}
		if(name.equals("$sext.bv16.bv64")) {
			op = SEXT1664;
		}
		if(name.equals("$sext.bv32.bv64")) {
			op = SEXT3264;
		}
		if(op == null) {
			throw new RuntimeException("Problem with " + name + " method");
		}
		return new IExprUn(op, (ExprInterface)callParams.get(0));
	}
}
