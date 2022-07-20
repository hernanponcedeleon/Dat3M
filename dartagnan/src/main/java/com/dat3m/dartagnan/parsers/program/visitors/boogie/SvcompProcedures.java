package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

public class SvcompProcedures {

	public static List<String> SVCOMPPROCEDURES = Arrays.asList(
			"__VERIFIER_assert",
//			"__VERIFIER_assume",
//			"assume_abort_if_not",
			"__VERIFIER_loop_bound",
			"__VERIFIER_loop_begin",
			"__VERIFIER_spin_start",
			"__VERIFIER_spin_end",
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
			case "__VERIFIER_loop_bound":
				__VERIFIER_loop_bound(visitor, ctx);
				break;
			case "__VERIFIER_loop_begin":
				visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Svcomp.newLoopBegin());
				break;
			case "__VERIFIER_spin_start":
				visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Svcomp.newLoopStart());
				break;
			case "__VERIFIER_spin_end":
				visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Svcomp.newLoopEnd());
				break;
			case "__VERIFIER_assert":
				visitor.addAssertion((IExpr)ctx.call_params().exprs().accept(visitor));
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

	private static void __VERIFIER_assume(VisitorBoogie visitor, Call_cmdContext ctx) {
    	ExprInterface expr = (ExprInterface)ctx.call_params().exprs().accept(visitor);
       	visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newAssume(expr));
	}

	public static void __VERIFIER_atomic(VisitorBoogie visitor, boolean begin) {
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, ARCH_PRECISION);
        MemoryObject lockAddress = visitor.programBuilder.getOrNewObject("__VERIFIER_atomic");
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		LinkedList<Event> events = new LinkedList<>();
        events.add(EventFactory.newLoad(register, lockAddress, null));
        events.add(EventFactory.newJump(new Atom(register, NEQ, begin?IValue.ZERO:IValue.ONE), label));
        events.add(EventFactory.newStore(lockAddress, begin?IValue.ONE:IValue.ZERO, null));
        for(Event e : events) {
        	e.addFilters(Tag.C11.LOCK, Tag.RMW);
        	visitor.programBuilder.addChild(visitor.threadCount, e);
        }
	}
	
	public static void __VERIFIER_atomic_begin(VisitorBoogie visitor) {
		visitor.currentBeginAtomic = EventFactory.Svcomp.newBeginAtomic();
		visitor.programBuilder.addChild(visitor.threadCount, visitor.currentBeginAtomic);	
	}
	
	public static void __VERIFIER_atomic_end(VisitorBoogie visitor) {
		if(visitor.currentBeginAtomic == null) {
            throw new MalformedProgramException("__VERIFIER_atomic_end() does not have a matching __VERIFIER_atomic_begin()");
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
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLocal(register, new INonDet(type, register.getPrecision())))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
	    }
	}

	private static void __VERIFIER_nondet_bool(VisitorBoogie visitor, Call_cmdContext ctx) {
		String registerName = ctx.call_params().Ident(0).getText();
		Register register = visitor.programBuilder.getRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + registerName);
	    if(register != null){
			visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLocal(register, new BNonDet(register.getPrecision())))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);		
	    }
	}

	private static void __VERIFIER_loop_bound(VisitorBoogie visitor, Call_cmdContext ctx) {
		int bound = ((IExpr)ctx.call_params().exprs().expr(0).accept(visitor)).reduce().getValueAsInt();
		visitor.programBuilder.addChild(visitor.threadCount, EventFactory.Svcomp.newLoopBound(bound));
	}
}
