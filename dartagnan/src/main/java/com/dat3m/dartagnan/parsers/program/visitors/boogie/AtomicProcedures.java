package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Events;
import com.dat3m.dartagnan.program.Register;

import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.intToMo;

public class AtomicProcedures {

	public static List<String> ATOMICPROCEDURES = Arrays.asList(
			"atomic_init",
			"atomic_store",
			"atomic_load",
			"atomic_fetch",
			"atomic_exchange",
			"atomic_compare_exchange",
			"atomic_thread_fence",
			"__DAT3M_CAS");
	
	public static void handleAtomicFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		// In the way we compile the code, smack generated empty functions for atomic operations with 
		// prefixes like ".i32" thus we need to check "startswith" and we cannot pattern match by name
		if(name.startsWith("atomic_init")) {
			atomicInit(visitor, ctx);
			return;
		}
		if(name.startsWith("atomic_store")) {
			atomicStore(visitor, ctx);
			return;
		}
		if(name.startsWith("atomic_load")) {
			atomicLoad(visitor, ctx);
			return;
		}
		if(name.startsWith("atomic_fetch")) {
			atomicFetchOp(visitor, ctx);
			return;
		}
		if(name.startsWith("atomic_exchange")) {
			atomicXchg(visitor, ctx);
			return;
		}
		if (name.startsWith("atomic_compare_exchange")) {
			atomicCmpXchg(visitor, ctx);
			return;
		}
		if(name.startsWith("atomic_thread_fence")) {
			atomicThreadFence(visitor, ctx);
			return;
		}		
		if(name.startsWith("__DAT3M_CAS")) {
			DAT3M_CAS(visitor, ctx);
			return;
		}
		
		throw new UnsupportedOperationException(name + " procedure is not part of ATOMICPROCEDURES");		
	}
	
	private static void atomicInit(VisitorBoogie visitor, Call_cmdContext ctx) {
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		visitor.programBuilder.addChild(visitor.threadCount, Events.newStore(add, value, null, visitor.currentLine));
	}

	private static void atomicStore(VisitorBoogie visitor, Call_cmdContext ctx) {
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = null;
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getIntValue().intValue());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newStore(add, value, mo));
	}

	private static void atomicLoad(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		String mo = null;
		if(ctx.call_params().exprs().expr().size() > 1) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(1).accept(visitor)).getIntValue().intValue());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newLoad(reg, add, mo));
	}

	private static void atomicFetchOp(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (IExpr)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = null;
		IOpBin op;
		if(ctx.getText().contains("_add")) {
			op = IOpBin.PLUS;
		} else if(ctx.getText().contains("_sub")) {
			op = IOpBin.MINUS;
		} else if(ctx.getText().contains("_and")) {
			op = IOpBin.AND;
		} else if(ctx.getText().contains("_or")) {
			op = IOpBin.OR;
		} else if(ctx.getText().contains("_xor")) {
			op = IOpBin.XOR;
		} else {
			throw new RuntimeException("AtomicFetchOp operation cannot be handled");
		}
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getIntValue().intValue());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newFetchOp(reg, add, value, op, mo));
	}

	private static void atomicXchg(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = null;
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getIntValue().intValue());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newExchange(reg, add, value, mo));
	}

	private static void DAT3M_CAS(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
		IExpr add = (IExpr) params.get(0).accept(visitor);
		Register expected = (Register) params.get(1).accept(visitor);
		ExprInterface desired = (ExprInterface) params.get(2).accept(visitor);
		String mo = null;
		if(params.size() > 3) {
			mo = intToMo(((IConst) params.get(3).accept(visitor)).getIntValue().intValue());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newDat3mCAS(reg, add, expected, desired, mo));
	}

	private static void atomicThreadFence(VisitorBoogie visitor, Call_cmdContext ctx) {
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(0).accept(visitor)).getIntValue().intValue());
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newFence(mo));
	}
	
	private static void atomicCmpXchg(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), -1);
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
		IExpr add = (IExpr) params.get(0).accept(visitor);
		Register expectedAdd = (Register) params.get(1).accept(visitor); // NOTE: We assume a register here
		Register expected = new Register(null, reg.getThreadId(), reg.getPrecision());
		ExprInterface desired = (ExprInterface) params.get(2).accept(visitor);
		String mo = null;
		boolean strong = ctx.getText().contains("strong");
		if(params.size() > 3) {
			mo = intToMo(((IConst) params.get(3).accept(visitor)).getIntValue().intValue());
			// NOTE: We forget about the 5th parameter (MO on fail) for now!
		}
		visitor.programBuilder.addChild(visitor.threadCount, Events.newLoad(expected, expectedAdd, mo));
		visitor.programBuilder.addChild(visitor.threadCount, Events.Atomic.newCompareExchange(reg, add, expected, desired, mo, strong));
	}
}
