package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Assume;
import com.dat3m.dartagnan.program.event.Jump;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.svcomp.event.BeginAtomic;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;
import com.dat3m.dartagnan.program.utils.EType;

public class SvcompFunctions {

	public static List<String> SVCOMPFUNCTIONS = Arrays.asList(
			"abort", 
			"__VERIFIER_assume", 
			"reach_error", 
			"__VERIFIER_error", 
			"__VERIFIER_assert",
			"__VERIFIER_atomic_begin",
			"__VERIFIER_atomic_end",
			"__VERIFIER_nondet_bool",
			"__VERIFIER_nondet_int",
			"__VERIFIER_nondet_uint",
			"__VERIFIER_nondet_unsigned_int",
			"__VERIFIER_nondet_short",
			"__VERIFIER_nondet_ushort",
			"__VERIFIER_nondet_long",
			"__VERIFIER_nondet_ulong",
			"__VERIFIER_nondet_char",
			"__VERIFIER_nondet_uchar");

	public static void handleSvcompFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		switch(name) {
			case "abort":
				abort(visitor);
				return;
			case "__VERIFIER_assume":
				__VERIFIER_assume(visitor, ctx);
				return;
			case "reach_error":
			case "__VERIFIER_error":
				__VERIFIER_error(visitor);
				return;
			case "__VERIFIER_assert":
				__VERIFIER_assert(visitor, ctx);
				return;
			case "__VERIFIER_atomic_begin":
				__VERIFIER_atomic_begin(visitor);
				return;
			case "__VERIFIER_atomic_end":
				__VERIFIER_atomic_end(visitor);
				return;
			case "__VERIFIER_nondet_bool":
				__VERIFIER_nondet_bool(visitor, ctx);
				return;
			case "__VERIFIER_nondet_int":
			case "__VERIFIER_nondet_uint":
			case "__VERIFIER_nondet_unsigned_int":
			case "__VERIFIER_nondet_short":
			case "__VERIFIER_nondet_ushort":
			case "__VERIFIER_nondet_long":
			case "__VERIFIER_nondet_ulong":
			case "__VERIFIER_nondet_char":
			case "__VERIFIER_nondet_uchar":
				__VERIFIER_nondet(visitor, ctx, name);
				return;
			default:
	        	throw new UnsupportedOperationException(name + " funcition is not part of SVCOMPFUNCTIONS");
		}
	}

	private static void abort(VisitorBoogie visitor) {
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
       	visitor.programBuilder.addChild(visitor.threadCount, new Jump(label));
	}
	
	//TODO: seems to be obsolete after SVCOMP 2020
	private static void __VERIFIER_assume(VisitorBoogie visitor, Call_cmdContext ctx) {
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
       	ExprInterface c = (ExprInterface)ctx.call_params().exprs().accept(visitor);
		if(c != null) {
			visitor.programBuilder.addChild(visitor.threadCount, new Assume(c, label));	
		}
	}

	//TODO: seems to be obsolete after SVCOMP 2020
	private static void __VERIFIER_error(VisitorBoogie visitor) {
    	Register ass = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, "assert_" + visitor.assertionIndex);
    	visitor.assertionIndex++;
    	Local event = new Local(ass, new BConst(false));
		event.addFilters(EType.ASSERTION);
		visitor.programBuilder.addChild(visitor.threadCount, event);
	}
	
	private static void __VERIFIER_assert(VisitorBoogie visitor, Call_cmdContext ctx) {
    	Register ass = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, "assert_" + visitor.assertionIndex);
    	visitor.assertionIndex++;
    	ExprInterface expr = (ExprInterface)ctx.call_params().exprs().accept(visitor);
    	if(expr instanceof IConst && ((IConst)expr).getValue() == 1) {
    		return;
    	}
    	Local event = new Local(ass, expr);
		event.addFilters(EType.ASSERTION);
		visitor.programBuilder.addChild(visitor.threadCount, event);
	}
	
	private static void __VERIFIER_atomic_begin(VisitorBoogie visitor) {
		visitor.currentBeginAtomic = new BeginAtomic();
		visitor.programBuilder.addChild(visitor.threadCount, visitor.currentBeginAtomic);	
	}
	
	private static void __VERIFIER_atomic_end(VisitorBoogie visitor) {
		if(visitor.currentBeginAtomic == null) {
            throw new ParsingException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
		}
		visitor.programBuilder.addChild(visitor.threadCount, new EndAtomic(visitor.currentBeginAtomic));	
		visitor.currentBeginAtomic = null;
	}


	private static void __VERIFIER_nondet(VisitorBoogie visitor, Call_cmdContext ctx, String name) {
		INonDetTypes type = null;
		if(name.equals("__VERIFIER_nondet_int")) {
			type = INonDetTypes.INT;
		} else if (name.equals("__VERIFIER_nondet_uint") || name.equals("__VERIFIER_nondet_unsigned_int")) {
			type = INonDetTypes.UINT;
		} else if (name.equals("__VERIFIER_nondet_short")) {
			type = INonDetTypes.SHORT;
		} else if (name.equals("__VERIFIER_nondet_ushort")) {
			type = INonDetTypes.USHORT;
		} else if (name.equals("__VERIFIER_nondet_long")) {
			type = INonDetTypes.LONG;
		} else if (name.equals("__VERIFIER_nondet_ulong")) {
			type = INonDetTypes.ULONG;
		} else if (name.equals("__VERIFIER_nondet_char")) {
			type = INonDetTypes.CHAR;
		} else if (name.equals("__VERIFIER_nondet_uchar")) {
			type = INonDetTypes.UCHAR;
		} else {
			throw new ParsingException(name + " is not supported");
		}
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
	    	visitor.programBuilder.addChild(visitor.threadCount, new Local(register, new INonDet(type)));
	    }
	}

	private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
	    	visitor.programBuilder.addChild(visitor.threadCount, new Local(register, new BNonDet()));
	    }
	}
}
