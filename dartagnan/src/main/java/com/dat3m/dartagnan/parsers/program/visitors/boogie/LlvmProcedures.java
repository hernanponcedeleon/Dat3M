package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.BoogieParser;
import com.dat3m.dartagnan.parsers.BoogieParser.Call_cmdContext;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory.Llvm;
import com.dat3m.dartagnan.program.event.Tag.C11;
import java.util.Arrays;
import java.util.List;

public class LlvmProcedures {

	public static List<String> LLVMPROCEDURES = Arrays.asList(
			"__llvm_atomic32_load",
			"__llvm_atomic64_load",
			"__llvm_atomic32_store",
			"__llvm_atomic64_store",
			"__llvm_atomic32_cmpxchg",
			"__llvm_atomic64_cmpxchg",
			"__llvm_atomic32_rmw",
			"__llvm_atomic64_rmw");

	public static void handleLlvmFunction(VisitorBoogie visitor, Call_cmdContext ctx) {
		String name = ctx.call_params().Define() == null ? ctx.call_params().Ident(0).getText() : ctx.call_params().Ident(1).getText();
		List<BoogieParser.ExprContext> params = ctx.call_params().exprs().expr();

		Register reg = visitor.programBuilder.getOrCreateRegister(visitor.threadCount, visitor.currentScope.getID() + ":" + ctx.call_params().Ident(0).getText(), GlobalSettings.ARCH_PRECISION);
		
		Object p0 = params.get(0).accept(visitor);
		Object p1 = params.size() > 1 ? params.get(1).accept(visitor) : null;
		Object p2 = params.size() > 2 ? params.get(2).accept(visitor) : null;
		Object p3 = params.size() > 3 ? params.get(3).accept(visitor) : null;
		
		String mo;
		
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
			case "__llvm_atomic32_cmpxchg":
			case "__llvm_atomic64_cmpxchg":
				mo = C11.intToMo(((IConst) p3).getValueAsInt());
				visitor.programBuilder.addChild(visitor.threadCount, Llvm.newCompareExchange(reg, (IExpr) p0, (IExpr) p1, (IExpr) p2, mo, true))
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
		default:
			throw new UnsupportedOperationException(name + " procedure is not part of LKMMPROCEDURES");
		}
	}
}
