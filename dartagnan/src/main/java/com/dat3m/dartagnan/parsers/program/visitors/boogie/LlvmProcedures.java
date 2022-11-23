package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IfExpr;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventFactory.Llvm;
import com.dat3m.dartagnan.program.event.Tag.C11;
import java.util.Arrays;
import java.util.List;

public class LlvmProcedures {

	public static List<String> LLVMPROCEDURES = Arrays.asList(
			// Atomic operations
			"__llvm_atomic32_load",
			"__llvm_atomic64_load",
			"__llvm_atomic32_store",
			"__llvm_atomic64_store",
			"__llvm_atomic32_cmpxchg",
			"__llvm_atomic64_cmpxchg",
			"__llvm_atomic32_rmw",
			"__llvm_atomic64_rmw",
			"__llvm_atomic_fence",
			// Intrinsics 
			"llvm.smax.i32",
			"llvm.smax.i64",
			"llvm.smin.i32",
			"llvm.smin.i64"
			);

	public static void handleLlvmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();

		String regName = visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText();
		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, regName, GlobalSettings.ARCH_PRECISION);
		
		Object p0 = params.get(0).accept(visitor);
		Object p1 = params.size() > 1 ? params.get(1).accept(visitor) : null;
		Object p2 = params.size() > 2 ? params.get(2).accept(visitor) : null;
		Object p3 = params.size() > 3 ? params.get(3).accept(visitor) : null;
		
		String mo;
		
		// For intrinsics
		IExpr i1;
		IExpr i2;
		Atom cond;

		switch (name) {
			case "__llvm_atomic32_load":
			case "__llvm_atomic64_load":
				mo = C11.intToMo(((IConst) p1).getValueAsInt());
				visitor.programBuilder.addChild(visitor.threadCount, Llvm.newLoad(reg, (IExpr) p0, mo))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
	        	return;
			case "__llvm_atomic32_store":
			case "__llvm_atomic64_store":
				mo = C11.intToMo(((IConst) p2).getValueAsInt());
				visitor.programBuilder.addChild(visitor.threadCount, Llvm.newStore((IExpr) p0, (ExprInterface) p1, mo))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
				return;
			case "__llvm_atomic_fence":
				mo = C11.intToMo(((IConst) p0).getValueAsInt());
				visitor.programBuilder.addChild(visitor.threadCount, Llvm.newFence(mo))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
	        	return;
			case "__llvm_atomic32_cmpxchg":
			case "__llvm_atomic64_cmpxchg":
				// Since we don't support struct types, we instead model each member as a register.
				// It is the responsibility of each LLVM istruction creating a structure to create such registers,
				// then when calling "extractvalue" we can check if the member was properly initialized 
				Register oldValueRegister = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, regName + "(0)", GlobalSettings.ARCH_PRECISION);
				Register cmpRegister = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, regName + "(1)", GlobalSettings.ARCH_PRECISION);
				// The compilation of Llvm.newCompareExchange will 
				// assign the correct values to the registers above
				mo = C11.intToMo(((IConst) p3).getValueAsInt());
				visitor.programBuilder.addChild(visitor.threadCount, Llvm.newCompareExchange(oldValueRegister, cmpRegister, (IExpr) p0, (IExpr) p1, (IExpr) p2, mo, true))
	        		.setCLine(visitor.currentLine)
	        		.setSourceCodeFile(visitor.sourceCodeFile);
				return;		
			case "__llvm_atomic32_rmw":
			case "__llvm_atomic64_rmw":
				mo = C11.intToMo(((IConst) p2).getValueAsInt());
				IOpBin op;
				switch (((IConst) p3).getValueAsInt()) {
					case 0:
						visitor.programBuilder.addChild(visitor.threadCount, Llvm.newExchange(reg, (IExpr) p0, (IExpr) p1, mo))
							.setCLine(visitor.currentLine)
							.setSourceCodeFile(visitor.sourceCodeFile);
						return;
					case 1:
						op = IOpBin.PLUS;
						break;
					case 2:
						op = IOpBin.MINUS;
						break;
					case 3:
						op = IOpBin.AND;
						break;
					case 4:
						op = IOpBin.OR;
						break;
					case 5:
						op = IOpBin.XOR;
						break;
					default:
                	    throw new UnsupportedOperationException("Operation " + params.get(3).getText() + " is not recognized.");
				}
				visitor.programBuilder.addChild(visitor.threadCount, Llvm.newRMW(reg, (IExpr) p0, (IExpr) p1, op, mo))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
				return;
			case "llvm.smax.i32":
			case "llvm.smax.i64":
			case "llvm.smin.i32":
			case "llvm.smin.i64":
				i1 = (IExpr)p0;
				i2 = (IExpr)p1;
				cond = name.contains("max") ? new Atom(i1, COpBin.GTE, i2) : new Atom(i1, COpBin.LTE, i2);
				visitor.programBuilder.addChild(visitor.threadCount, EventFactory.newLocal(reg, new IfExpr(cond, i1, i2)))
					.setCLine(visitor.currentLine)
					.setSourceCodeFile(visitor.sourceCodeFile);
				return;
			default:
				throw new UnsupportedOperationException(name + " procedure is not part of LLVMPROCEDURES");
		}
	}
}
