package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Address;
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
		switch(name) {
		case "__VERIFIER_assert":
			__VERIFIER_assert(visitor, ctx);
			break;
		case "__VERIFIER_fence":
			__VERIFIER_fence(visitor, ctx);
			break;
		case "__VERIFIER_atomic_begin":
			if(GlobalSettings.ATOMIC_AS_LOCK) {
				__VERIFIER_atomic(visitor, true);
			} else {
				__VERIFIER_atomic_begin(visitor);	
			}
			break;
		case "__VERIFIER_atomic_end":
			if(GlobalSettings.ATOMIC_AS_LOCK) {
				__VERIFIER_atomic(visitor, false);
			} else {
				__VERIFIER_atomic_end(visitor);
			}
			break;
		case "__VERIFIER_nondet_bool":
			__VERIFIER_nondet_bool(visitor, ctx);
			break;
		case "__VERIFIER_nondet_int":
		case "__VERIFIER_nondet_uint":
		case "__VERIFIER_nondet_unsigned_int":
		case "__VERIFIER_nondet_short":
		case "__VERIFIER_nondet_ushort":
		case "__VERIFIER_nondet_unsigned_short":
		case "__VERIFIER_nondet_long":
		case "__VERIFIER_nondet_ulong":
		case "__VERIFIER_nondet_char":
		case "__VERIFIER_nondet_uchar":
			__VERIFIER_nondet(visitor, ctx, name);
			break;
		default:
			throw new UnsupportedOperationException(name + " procedure is not part of SVCOMPPROCEDURES");
		}
	}

	private static void __VERIFIER_fence(VisitorBoogie visitor, Call_cmdContext ctx) {
    	int index = (int)((IConst)ctx.call_params().exprs().accept(visitor)).getIntValue();
    	if(index >= FENCES.size()) {
    		throw new UnsupportedOperationException(ctx.getText() + " cannot be handled");
    	}
    	visitor.programBuilder.addChild(visitor.threadCount, new Fence(FENCES.get(index)));
	}

	private static void __VERIFIER_assert(VisitorBoogie visitor, Call_cmdContext ctx) {
    	Register ass = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, "assert_" + visitor.assertionIndex, -1);
    	visitor.assertionIndex++;
    	ExprInterface expr = (ExprInterface)ctx.call_params().exprs().accept(visitor);
    	if(expr instanceof IConst && ((IConst)expr).getIntValue() == 1) {
    		return;
    	}
    	Local event = new Local(ass, expr);
		event.addFilters(EType.ASSERTION);
		visitor.programBuilder.addChild(visitor.threadCount, event);
	}

	public static void __VERIFIER_atomic(VisitorBoogie visitor, boolean begin) {
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, -1);
        Address lockAddress = visitor.programBuilder.getOrCreateLocation("__VERIFIER_atomic", -1).getAddress();
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		LinkedList<Event> events = new LinkedList<>();
        events.add(new Load(register, lockAddress, null));
        events.add(new CondJump(new Atom(register, NEQ, new IConst(begin ? 0 : 1, -1)), label));
        events.add(new Store(lockAddress, new IConst(begin ? 1 : 0, -1), null));
        for(Event e : events) {
        	e.addFilters(EType.LOCK, EType.RMW);
        	visitor.programBuilder.addChild(visitor.threadCount, e);
        }
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
			visitor.programBuilder.addChild(visitor.threadCount, new Local(register, new INonDet(type, register.getPrecision()), visitor.currentLine));
	    }
	}

	private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
			visitor.programBuilder.addChild(visitor.threadCount, new Local(register, new BNonDet(register.getPrecision()), visitor.currentLine));
	    }
	}
}
