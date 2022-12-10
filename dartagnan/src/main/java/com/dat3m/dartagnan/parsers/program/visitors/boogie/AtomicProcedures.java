package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;

import java.util.Arrays;
import java.util.List;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.program.event.EventFactory.Atomic;
import static com.dat3m.dartagnan.program.event.EventFactory.newStore;
import static com.dat3m.dartagnan.program.event.Tag.C11.intToMo;

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
		visitor.programBuilder.addChild(visitor.threadCount, newStore(add, value, ""))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}

	private static void atomicStore(VisitorBoogie visitor, Call_cmdContext ctx) {
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		ExprInterface value = (ExprInterface)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = "";
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValueAsInt());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newStore(add, value, mo))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}

	private static void atomicLoad(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), ARCH_PRECISION);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		String mo = "";
		if(ctx.call_params().exprs().expr().size() > 1) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(1).accept(visitor)).getValueAsInt());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newLoad(reg, add, mo))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}

	private static void atomicFetchOp(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), ARCH_PRECISION);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		IExpr value = (IExpr)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = "";
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
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValueAsInt());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newFetchOp(reg, add, value, op, mo))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}

	private static void atomicXchg(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), ARCH_PRECISION);
		IExpr add = (IExpr)ctx.call_params().exprs().expr().get(0).accept(visitor);
		IExpr value = (IExpr)ctx.call_params().exprs().expr().get(1).accept(visitor);
		String mo = "";
		if(ctx.call_params().exprs().expr().size() > 2) {
			mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(2).accept(visitor)).getValueAsInt());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newExchange(reg, add, value, mo))
			.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}

	private static void DAT3M_CAS(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), ARCH_PRECISION);
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
		IExpr addr = (IExpr) params.get(0).accept(visitor);
		IExpr expectedVal = (IExpr) params.get(1).accept(visitor);
		IExpr desiredVal = (IExpr) params.get(2).accept(visitor);
		String mo = "";
		if(params.size() > 3) {
			mo = intToMo(((IConst) params.get(3).accept(visitor)).getValueAsInt());
		}
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newDat3mCAS(reg, addr, expectedVal, desiredVal, mo))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}

	private static void atomicThreadFence(VisitorBoogie visitor, Call_cmdContext ctx) {
		String mo = intToMo(((IConst)ctx.call_params().exprs().expr().get(0).accept(visitor)).getValueAsInt());
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newFence(mo))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}
	
	private static void atomicCmpXchg(VisitorBoogie visitor, Call_cmdContext ctx) {
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), ARCH_PRECISION);
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();
		IExpr addr = (IExpr) params.get(0).accept(visitor);
		IExpr expectedAddr = (IExpr) params.get(1).accept(visitor); // NOTE: We assume a register here
		IExpr desiredVal = (IExpr) params.get(2).accept(visitor);
		String mo = "";
		boolean strong = ctx.getText().contains("strong");
		if(params.size() > 3) {
			mo = intToMo(((IConst) params.get(3).accept(visitor)).getValueAsInt());
			// NOTE: We forget about the 5th parameter (MO on fail) because it is never used
			// (see issue #123 for an explanation)
		}
		visitor.programBuilder.addChild(visitor.threadCount, Atomic.newCompareExchange(reg, addr, expectedAddr, desiredVal, mo, strong))
				.setCFileInformation(visitor.currentLine, visitor.sourceCodeFile);
	}
}
