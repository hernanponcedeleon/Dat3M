package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.ExprsContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.program.event.pthread.Create;
import com.dat3m.dartagnan.program.event.pthread.Join;
import com.dat3m.dartagnan.program.event.pthread.Lock;
import com.dat3m.dartagnan.program.event.pthread.InitLock;
import com.dat3m.dartagnan.program.event.pthread.Unlock;
import com.dat3m.dartagnan.program.memory.Location;

public class PthreadsProcedures {
	
	public static List<String> PTHREADPROCEDURES = Arrays.asList( 
			"pthread_create", 
			"pthread_cond_init",
			"pthread_cond_wait",			
			"pthread_cond_signal",
			"pthread_cond_broadcast",
			"pthread_exit",
			"pthread_getspecific", 
			"pthread_join",
			"pthread_key_create", 
			"pthread_mutex_init",
			"pthread_mutex_destroy",
			"pthread_mutex_lock", 
			"pthread_mutex_unlock",
			"pthread_setspecific");

	public static void handlePthreadsFunctions(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		switch(name) {
		case "pthread_create":
			pthread_create(visitor, ctx);
			break;
		case "pthread_join":
			pthread_join(visitor, ctx);
			break;
		case "pthread_cond_init":
		case "pthread_cond_wait":
		case "pthread_cond_signal":
		case "pthread_cond_broadcast":
		case "pthread_exit":
		case "pthread_mutex_destroy":
			break;
		case "pthread_mutex_init":
			mutexInit(visitor, ctx);
			break;
		case "pthread_mutex_lock":
			mutexLock(visitor, ctx);
			break;
		case "pthread_mutex_unlock":
			mutexUnlock(visitor, ctx);
			break;
		default:
			throw new ParsingException(name + " cannot be handled");
		}
	}
	
	private static void pthread_create(VisitorBoogie visitor, Call_cmdContext ctx) {
		visitor.currentThread++;
		visitor.threadCallingValues.put(visitor.currentThread, new ArrayList<>());
		String namePtr = ctx.call_params().exprs().expr().get(0).getText();
		// This names are global so we don't use currentScope.getID(), but per thread.
		Register threadPtr = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, namePtr, -1);
		String threadName = ctx.call_params().exprs().expr().get(2).getText();
		ExprInterface callingValue = (ExprInterface)ctx.call_params().exprs().expr().get(3).accept(visitor);
		visitor.threadCallingValues.get(visitor.currentThread).add(callingValue);
		visitor.pool.add(threadPtr, threadName);
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		// We assume pthread_create always succeeds
		visitor.programBuilder.addChild(visitor.threadCount, new Local(reg, new IConst(BigInteger.ZERO, -1)));
		Location loc = visitor.programBuilder.getOrCreateLocation(threadPtr + "_active", -1);
		visitor.programBuilder.addChild(visitor.threadCount, new Create(threadPtr, threadName, loc.getAddress(), visitor.currentLine));
	}
	
	private static void pthread_join(VisitorBoogie visitor, Call_cmdContext ctx) {
		String namePtr = ctx.call_params().exprs().expr().get(0).getText();
		// This names are global so we don't use currentScope.getID(), but per thread.
		Register callReg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, namePtr, -1);
		if(visitor.pool.getPtrFromReg(callReg) == null) {
        	throw new UnsupportedOperationException("pthread_join cannot be handled");
		}
		Location loc = visitor.programBuilder.getOrCreateLocation(visitor.pool.getPtrFromReg(callReg) + "_active", -1);
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, -1);
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
       	visitor.programBuilder.addChild(visitor.threadCount, new Join(visitor.pool.getPtrFromReg(callReg), reg, loc.getAddress(), label));
	}

	private static void mutexInit(VisitorBoogie visitor, Call_cmdContext ctx) {
		ExprContext lock = ctx.call_params().exprs().expr(0);
		IExpr lockAddress = (IExpr)lock.accept(visitor);
		IExpr value = (IExpr)ctx.call_params().exprs().expr(1).accept(visitor);
		if(lockAddress != null) {
			visitor.programBuilder.addChild(visitor.threadCount, new InitLock(lock.getText(), lockAddress, value));	
		}
	}
	
	private static void mutexLock(VisitorBoogie visitor, Call_cmdContext ctx) {
		ExprsContext lock = ctx.call_params().exprs();
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, -1);
		IExpr lockAddress = (IExpr)lock.accept(visitor);
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		if(lockAddress != null) {
			visitor.programBuilder.addChild(visitor.threadCount, new Lock(lock.getText(), lockAddress, register, label));
		}
	}
	
	private static void mutexUnlock(VisitorBoogie visitor, Call_cmdContext ctx) {
		ExprsContext lock = ctx.call_params().exprs();
        Register register = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, null, -1);
		IExpr lockAddress = (IExpr)lock.accept(visitor);
       	Label label = visitor.programBuilder.getOrCreateLabel("END_OF_T" + visitor.threadCount);
		if(lockAddress != null) {
			visitor.programBuilder.addChild(visitor.threadCount, new Unlock(lock.getText(), lockAddress, register, label));
		}
	}
}
