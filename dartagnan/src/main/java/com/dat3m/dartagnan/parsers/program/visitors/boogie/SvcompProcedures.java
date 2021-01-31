package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BNonDet;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.INonDetTypes;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.utils.EType;

public class SvcompProcedures {

	public static List<String> SVCOMPPROCEDURES = Arrays.asList(
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
		if(name.contains("__VERIFIER_atomic")) {
			__VERIFIER_atomic(visitor, name.contains("begin"));
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

	public static void __VERIFIER_atomic(VisitorBoogie visitor, boolean begin) {
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, -1);
        Address lockAddress = visitor.programBuilder.getOrCreateLocation("__VERIFIER_atomic", -1).getAddress();
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		LinkedList<Event> events = new LinkedList<>();
        events.add(new Load(register, lockAddress, null));
        events.add(new CondJump(new Atom(register, NEQ, new IConst(begin ? 0 : 1, -1)),label));
        events.add(new Store(lockAddress, new IConst(begin ? 1 : 0, -1), null));
        for(Event e : events) {
        	e.addFilters(EType.LOCK, EType.RMW);
        	visitor.programBuilder.addChild(visitor.threadCount, e);
        }
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
