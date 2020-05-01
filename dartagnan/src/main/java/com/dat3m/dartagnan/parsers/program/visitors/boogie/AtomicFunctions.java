package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.intToMo;

import java.util.Arrays;
import java.util.List;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.atomic.event.AtomicLoadExplicit;
import com.dat3m.dartagnan.program.atomic.event.AtomicStoreExplicit;
import com.dat3m.dartagnan.program.atomic.event.AtomicThreadFence;
import com.dat3m.dartagnan.program.memory.Address;

public class AtomicFunctions {

	public static List<String> ATOMICFUNCTIONS = Arrays.asList(
			"atomic_store_explicit",
			"atomic_load_explicit",
			"atomic_thread_fence");
	
	public static void handleAtomicFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		if(name.contains("atomic_store_explicit")) {
			atomicStoreExplicit(visitor, ctx);
			return;
		}			
		if(name.contains("atomic_load_explicit")) {
			atomicLoadExplicit(visitor, ctx);
			return;
		}			
		if(name.contains("atomic_thread_fence")) {
			atomicThreadFence(visitor, ctx);
			return;
		}	
        throw new UnsupportedOperationException(name + " funcition is not part of ATOMICFUNCTIONS");
	}
	
	private static void atomicStoreExplicit(VisitorBoogie visitor, Call_cmdContext ctx) {
		Address add = (Address)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValue());
		visitor.programBuilder.addChild(visitor.threadCount, new AtomicStoreExplicit(add, value, mo));
	}

	private static void atomicLoadExplicit(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText());
		Address add = (Address)ctx.call_params().exprs().expr().get(0).accept(visitor);
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(1).accept(visitor)).getValue());
		visitor.programBuilder.addChild(visitor.threadCount, new AtomicLoadExplicit(reg, add, mo));
	}

	private static void atomicThreadFence(VisitorBoogie visitor, Call_cmdContext ctx) {
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(0).accept(visitor)).getValue());
		visitor.programBuilder.addChild(visitor.threadCount, new AtomicThreadFence(mo));
	}
}
