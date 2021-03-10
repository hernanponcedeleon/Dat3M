package com.dat3m.dartagnan.boogie;

import java.util.List;
import java.util.stream.IntStream;

import com.dat3m.dartagnan.parsers.BoogieParser.Var_exprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_or_typeContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;

public class FunctionCall {

	private final Function function;
	private final FunctionCall parent;
	private final List<Object> call;
    
	public FunctionCall(Function function, List<Object> call, FunctionCall caller) {
		if(!(function.getSignature().size() == call.size())) {
			throw new ParsingException("The number of parameters in the function call does not match " + function.getName() + "'s signature");
		}
		this.function = function;
		this.call = call;
		this.parent = caller;
	}

	public FunctionCall getParent() {
    	return parent;
    }

	public Function getFunction() {
    	return function;
    }

	public List<Object> getCallParam() {
    	return call;
    }

	public Object replaceVarsByExprs(Var_exprContext ctx) {
		List<Var_or_typeContext> signature = function.getSignature();
		FunctionCall caller = getParent();
		int pos = 0;
		boolean found = false;
		for(int index : IntStream.range(0, signature.size()).toArray()) {
			if(signature.get(index).Ident().getText().equals(ctx.getText())) {
				pos = index;
				found = true;
				break;
			}
		}
		if(!found) {
	        throw new ParsingException("Input " + ctx.getText() + " is not part of " + function.getName() + " signature");
		}
		Object exp = call.get(pos);
		while(caller != null) {
			exp = caller.getCallParam().get(pos);
			caller = caller.getParent();
		}
		return exp;
	}
}
