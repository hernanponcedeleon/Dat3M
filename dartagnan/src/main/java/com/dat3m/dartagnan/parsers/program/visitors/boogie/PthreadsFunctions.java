package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.expression.op.COpBin.EQ;
import static com.dat3m.dartagnan.expression.op.COpBin.NEQ;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Assume;
import com.dat3m.dartagnan.program.event.CondJump;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.memory.Location;
import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.base.Joiner;

public class PthreadsFunctions {
	
	public static List<String> PTHREADFUNCTIONS = Arrays.asList( 
			"pthread_create", 
			"pthread_join", 
			"__pthread_join", 
			"pthread_mutex_init", 
			"pthread_mutex_lock", 
			"pthread_mutex_unlock");

	public static void handlePthreadsFunctions(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		switch(name) {
			case "pthread_create":
				pthread_create(visitor, ctx);
				return;
			case "pthread_join":
			case "__pthread_join":
				pthread_join(visitor, ctx);
				return;
			case "pthread_mutex_init":
				mutexInit(visitor, ctx);
				return;
			case "pthread_mutex_lock":
				mutexLock(visitor, ctx);
				return;
			case "pthread_mutex_unlock":
				mutexUnlock(visitor, ctx);
				return;
			default:
	        	throw new UnsupportedOperationException(name + " funcition is not part of " + Joiner.on(",").join(PTHREADFUNCTIONS));
			}
	}
	
	private static void pthread_create(VisitorBoogie visitor, Call_cmdContext ctx) {
		String namePtr = ctx.call_params().exprs().expr().get(0).getText();
		// This names are global so we don't use currentScope.getID(), but per thread.
		Register threadPtr = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, namePtr);
		String threadName = ctx.call_params().exprs().expr().get(2).getText();
		ExprInterface callingValue = (ExprInterface)ctx.call_params().exprs().expr().get(3).accept(visitor);
		visitor.mainCallingValues.clear();
		visitor.mainCallingValues.add(callingValue);
		visitor.pool.add(threadPtr, threadName);
		Location loc = visitor.programBuilder.getOrCreateLocation(threadPtr + "_active");
		visitor.programBuilder.addChild(visitor.threadCount, new Store(loc.getAddress(), new IConst(1), null));
	}
	
	private static void pthread_join(VisitorBoogie visitor, Call_cmdContext ctx) {
		String namePtr = ctx.call_params().exprs().expr().get(0).getText();
		// This names are global so we don't use currentScope.getID(), but per thread.
		Register callReg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, namePtr);
		Location loc = visitor.programBuilder.getOrCreateLocation(visitor.pool.getPtrFromReg(callReg) + "_active");
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null);
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
       	visitor.programBuilder.addChild(visitor.threadCount, new Load(reg, loc.getAddress(), null));
       	visitor.programBuilder.addChild(visitor.threadCount, new Assume(new Atom(reg, EQ, new IConst(0)), label));
	}

	private static void mutexInit(VisitorBoogie visitor, Call_cmdContext ctx) {
		ExprContext lock = ctx.call_params().exprs().expr(0);
		ExprContext value = ctx.call_params().exprs().expr(1);
		IExpr lockAddress = (IExpr)lock.accept(visitor);
		IExpr val = (IExpr)value.accept(visitor);
		if(lockAddress != null) {
			visitor.programBuilder.addChild(visitor.threadCount, new Store(lockAddress, val, null));	
		}
	}
	
	private static void mutexLock(VisitorBoogie visitor, Call_cmdContext ctx) {
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null);
		IExpr lockAddress = (IExpr)ctx.call_params().exprs().accept(visitor);
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		if(lockAddress != null) {
	        LinkedList<Event> events = new LinkedList<>();
	        events.add(new Load(register, lockAddress, null));
	        events.add(new CondJump(new Atom(register, NEQ, new IConst(0)),label));
	        events.add(new Store(lockAddress, new IConst(1), null));
	        for(Event e : events) {
	        	e.addFilters(EType.LOCK, EType.RMW);
	        	visitor.programBuilder.addChild(visitor.threadCount, e);
	        }
		}
	}
	
	private static void mutexUnlock(VisitorBoogie visitor, Call_cmdContext ctx) {
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null);
		IExpr lockAddress = (IExpr)ctx.call_params().exprs().accept(visitor);
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		if(lockAddress != null) {
			LinkedList<Event> events = new LinkedList<>();
	        events.add(new Load(register, lockAddress, null));
	        events.add(new CondJump(new Atom(register, NEQ, new IConst(1)),label));
	        events.add(new Store(lockAddress, new IConst(0), null));
	        for(Event e : events) {
	        	e.addFilters(EType.LOCK, EType.RMW);
	        	visitor.programBuilder.addChild(visitor.threadCount, e);
	        }
		}
	}
}
