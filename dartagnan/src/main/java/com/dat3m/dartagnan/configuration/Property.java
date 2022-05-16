package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public enum Property implements OptionInterface {
	REACHABILITY, RACES, LIVENESS;
	
	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
        	case REACHABILITY:
        		return "Reachability";
        	case RACES:
        		return "Races";
			case LIVENESS:
				return "Liveness";
			default:
				throw new UnsupportedOperationException("Unrecognized property: " + this);
        }
    }

	public static Property getDefault() {
		return REACHABILITY;
	}

	// Used to decide the order shown by the selector in the UI
	public static Property[] orderedValues() {
		Property[] order = { REACHABILITY, RACES, LIVENESS };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
	
	public BooleanFormula getSMTVariable(SolverContext ctx) {
        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        return bmgr.makeVariable(this.toString());
	}
}