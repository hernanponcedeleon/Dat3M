package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.svcomp.event.BeginAtomic;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;
import com.dat3m.dartagnan.program.utils.EType;

public class SvcompProcedures {
	
	static List<String> FENCES = Arrays.asList("After_atomic", "Before_atomic", "Isync" ," Lwsync" ," Mb", "Mfence", 
										"Rcu_lock" , "Rcu_unlock", "Rmb", "Sync", "Sync_rcu","Wmb", "Ish");

	public static List<String> SVCOMPPROCEDURES = Arrays.asList(
			"__VERIFIER_assert",
			"__VERIFIER_fence",
			"__VERIFIER_atomic_begin",
			"__VERIFIER_atomic_end",
			"__VERIFIER_nondet_bool",
			"__VERIFIER_nondet_int",
			"__VERIFIER_nondet_uint",
			"__VERIFIER_nondet_unsigned_int",
			"__VERIFIER_nondet_short",
			"__VERIFIER_nondet_ushort",
			"__VERIFIER_nondet_unsigned_short",
			"__VERIFIER_nondet_long",
			"__VERIFIER_nondet_ulong",
			"__VERIFIER_nondet_char",
			"__VERIFIER_nondet_uchar");

	public static void handleSvcompFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.contains("__VERIFIER_fence")) {
			__VERIFIER_fence(visitor, ctx);
			return;
		}
		if(name.contains("__VERIFIER_assert")) {
			__VERIFIER_assert(visitor, ctx);
			return;
		}
		if(name.contains("__VERIFIER_atomic_begin")) {
			__VERIFIER_atomic_begin(visitor);
			return;			
		}
		if(name.contains("__VERIFIER_atomic_end")) {
			__VERIFIER_atomic_end(visitor);
			return;
		}
		if(name.contains("__VERIFIER_nondet_bool")) {
			__VERIFIER_nondet_bool(visitor, ctx);
			return;
		}
		if(name.contains("__VERIFIER_nondet_int") || name.contains("__VERIFIER_nondet_uint") || name.contains("__VERIFIER_nondet_unsigned_int") || 
		   name.contains("__VERIFIER_nondet_short") || name.contains("__VERIFIER_nondet_ushort") || name.contains("__VERIFIER_nondet_unsigned_short") ||
		   name.contains("__VERIFIER_nondet_long") || name.contains("__VERIFIER_nondet_ulong") || 
		   name.contains("__VERIFIER_nondet_char") || name.contains("__VERIFIER_nondet_uchar")) {
			__VERIFIER_nondet(visitor, ctx, name);
			return;
		}
		throw new UnsupportedOperationException(name + " procedure is not part of SVCOMPPROCEDURES");
	}

	private static void __VERIFIER_fence(VisitorBoogie visitor, Call_cmdContext ctx) {
    	int index = (int)((IConst)ctx.call_params().exprs().accept(visitor)).getValue();
    	if(index >= FENCES.size()) {
    		throw new UnsupportedOperationException(ctx.getText() + " cannot be handled");
    	}
    	visitor.programBuilder.addChild(visitor.threadCount, new Fence(FENCES.get(index)));
	}

	private static void __VERIFIER_assert(VisitorBoogie visitor, Call_cmdContext ctx) {
    	Register ass = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, "assert_" + visitor.assertionIndex, -1);
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
		} else if (name.equals("__VERIFIER_nondet_ushort") || name.equals("__VERIFIER_nondet_unsigned_short")) {
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
	    	Local child = new Local(register, new INonDet(type, register.getPrecision()));
	    	child.setCLine(visitor.currentLine);
			visitor.programBuilder.addChild(visitor.threadCount, child);
	    }
	}

	private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
	    	Local child = new Local(register, new BNonDet(register.getPrecision()));
	    	child.setCLine(visitor.currentLine);
			visitor.programBuilder.addChild(visitor.threadCount, child);
	    }
	}
}
