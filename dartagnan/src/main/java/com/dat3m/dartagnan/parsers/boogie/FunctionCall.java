package com.dat3m.dartagnan.parsers.boogie;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import com.dat3m.dartagnan.parsers.BoogieParser.ExprContext;
import com.dat3m.dartagnan.parsers.BoogieParser.Var_or_typeContext;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;

public class FunctionCall {

	private Function function;
	private FunctionCall parent;
	private List<ExprContext> callParams;
    
	public FunctionCall(Function function, List<ExprContext> callParams, FunctionCall caller) {
		if(!(function.getSignature().size() == callParams.size())) {
			throw new ParsingException("The number of parameters in the function call does not match the function signature");
		}
		this.function = function;
		this.callParams = callParams;
		this.parent = caller;
	}

	public FunctionCall getParent() {
    	return parent;
    }

    public Map<String, String> getMap() {
    	Map<String, String> map = new HashMap<>();   	
		List<Var_or_typeContext> signature = function.getSignature();

		for(int index : IntStream.range(0, signature.size()).toArray()) {
			String input = signature.get(index).Ident().getText();
			String call = callParams.get(index).getText();
			FunctionCall caller = getParent();
			while(caller != null) {
				call = caller.getMap().get(call);
				caller = caller.getParent();
			}
			map.put(input, call);
		}

		return map;
    }
}
