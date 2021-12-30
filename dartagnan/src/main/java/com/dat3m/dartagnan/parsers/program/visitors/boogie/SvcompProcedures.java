package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

public class SvcompProcedures {

	public static List<String> SVCOMPPROCEDURES = Arrays.asList(
			"__VERIFIER_assert",
//			"__VERIFIER_assume",
//			"assume_abort_if_not",
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
		case "__VERIFIER_assume":
		case "assume_abort_if_not":
			__VERIFIER_assume(visitor, ctx);
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

	private static void __VERIFIER_assert(VisitorBoogie visitor, Call_cmdContext ctx) {
    	IExpr expr = (IExpr)ctx.call_params().exprs().accept(visitor);
    	Register ass = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, "assert_" + visitor.assertionIndex, expr.getPrecision());
    	visitor.assertionIndex++;
    	if(expr instanceof IConst && ((IConst)expr).getIntValue().equals(BigInteger.ONE)) {
    		return;
    	}
    	Local event = EventFactory.newLocal(ass, expr);
		event.addFilters(EType.ASSERTION);
		visitor.programBuilder.addChild(visitor.threadCount, event);
       	Label end = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
       	visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newJump(new Atom(ass, NEQ, new IConst(BigInteger.ONE, -1)), end));
	}

	private static void __VERIFIER_assume(VisitorBoogie visitor, Call_cmdContext ctx) {
    	ExprInterface expr = (ExprInterface)ctx.call_params().exprs().accept(visitor);
       	visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newAssume(expr));
	}

	public static void __VERIFIER_atomic(VisitorBoogie visitor, boolean begin) {
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, -1);
        Address lockAddress = visitor.programBuilder.getOrCreateLocation("__VERIFIER_atomic", -1).getAddress();
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		LinkedList<Event> events = new LinkedList<>();
        events.add(EventFactory.newLoad(register, lockAddress, null));
        events.add(EventFactory.newJump(new Atom(register, NEQ, new IConst(begin ? BigInteger.ZERO : BigInteger.ONE, -1)), label));
        events.add(EventFactory.newStore(lockAddress, new IConst(begin ? BigInteger.ONE : BigInteger.ZERO, -1), null));
        for(Event e : events) {
        	e.addFilters(EType.LOCK, EType.RMW);
        	visitor.programBuilder.addChild(visitor.threadCount, e);
        }
	}
	
	private static void __VERIFIER_atomic_begin(VisitorBoogie visitor) {
		visitor.currentBeginAtomic = EventFactory.Svcomp.newBeginAtomic();
		visitor.programBuilder.addChild(visitor.threadCount, visitor.currentBeginAtomic);	
	}
	
	private static void __VERIFIER_atomic_end(VisitorBoogie visitor) {
		if(visitor.currentBeginAtomic == null) {
            throw new ParsingException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
		}
		visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Svcomp.newEndAtomic(visitor.currentBeginAtomic));
		visitor.currentBeginAtomic = null;
	}
	
	private static void __VERIFIER_nondet(VisitorBoogie visitor, Call_cmdContext ctx, String name) {
		INonDetTypes type = null;
		switch (name) {
			case "__VERIFIER_nondet_int":
				type = INonDetTypes.INT;
				break;
			case "__VERIFIER_nondet_uint":
			case "__VERIFIER_nondet_unsigned_int":
				type = INonDetTypes.UINT;
				break;
			case "__VERIFIER_nondet_short":
				type = INonDetTypes.SHORT;
				break;
			case "__VERIFIER_nondet_ushort":
			case "__VERIFIER_nondet_unsigned_short":
				type = INonDetTypes.USHORT;
				break;
			case "__VERIFIER_nondet_long":
				type = INonDetTypes.LONG;
				break;
			case "__VERIFIER_nondet_ulong":
				type = INonDetTypes.ULONG;
				break;
			case "__VERIFIER_nondet_char":
				type = INonDetTypes.CHAR;
				break;
			case "__VERIFIER_nondet_uchar":
				type = INonDetTypes.UCHAR;
				break;
			default:
				throw new ParsingException(name + " is not supported");
		}
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLocal(register, new INonDet(type, register.getPrecision()), visitor.currentLine));
	    }
	}

	private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLocal(register, new BNonDet(register.getPrecision()), visitor.currentLine));
	    }
	}
}
