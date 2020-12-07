package com.dat3m.dartagnan.utils;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.FuncDecl;
import com.microsoft.z3.Sort;

public class BitwiseEncodings {

	public static String MYAND = "over-approximating-and";
	public static String MYOR = "over-approximating-or";
	public static String MYXOR = "over-approximating-xor";
	
	public static BoolExpr BVOpasUF(Context ctx) {
		
		FuncDecl and = ctx.mkFuncDecl(MYAND, new Sort[] { ctx.getIntSort(), ctx.getIntSort() }, ctx.getIntSort());
		BoolExpr enc = ctx.mkEq(and.apply(ctx.mkInt(0), ctx.mkInt(0)), ctx.mkInt(0));
		enc = ctx.mkAnd(enc, ctx.mkEq(and.apply(ctx.mkInt(0), ctx.mkInt(1)), ctx.mkInt(0)));
		enc = ctx.mkAnd(enc, ctx.mkEq(and.apply(ctx.mkInt(1), ctx.mkInt(0)), ctx.mkInt(0)));
		enc = ctx.mkAnd(enc, ctx.mkEq(and.apply(ctx.mkInt(1), ctx.mkInt(1)), ctx.mkInt(1)));
		
		FuncDecl or = ctx.mkFuncDecl(MYOR, new Sort[] { ctx.getIntSort(), ctx.getIntSort() }, ctx.getIntSort());
		enc = ctx.mkAnd(enc, ctx.mkEq(or.apply(ctx.mkInt(0), ctx.mkInt(0)), ctx.mkInt(0)));
		enc = ctx.mkAnd(enc, ctx.mkEq(or.apply(ctx.mkInt(0), ctx.mkInt(1)), ctx.mkInt(1)));
		enc = ctx.mkAnd(enc, ctx.mkEq(or.apply(ctx.mkInt(1), ctx.mkInt(0)), ctx.mkInt(1)));
		enc = ctx.mkAnd(enc, ctx.mkEq(or.apply(ctx.mkInt(1), ctx.mkInt(1)), ctx.mkInt(1)));
		
		FuncDecl xor = ctx.mkFuncDecl(MYXOR, new Sort[] { ctx.getIntSort(), ctx.getIntSort() }, ctx.getIntSort());
		enc = ctx.mkAnd(enc, ctx.mkEq(xor.apply(ctx.mkInt(0), ctx.mkInt(0)), ctx.mkInt(0)));
		enc = ctx.mkAnd(enc, ctx.mkEq(xor.apply(ctx.mkInt(0), ctx.mkInt(1)), ctx.mkInt(1)));
		enc = ctx.mkAnd(enc, ctx.mkEq(xor.apply(ctx.mkInt(1), ctx.mkInt(0)), ctx.mkInt(1)));
		enc = ctx.mkAnd(enc, ctx.mkEq(xor.apply(ctx.mkInt(1), ctx.mkInt(1)), ctx.mkInt(0)));

		return enc;
	}
	
}
