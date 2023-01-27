package com.dat3m.dartagnan.configuration;

import java.util.Arrays;
import java.util.EnumSet;
import java.util.Optional;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.dartagnan.wmm.axiom.Axiom;

public enum Property implements OptionInterface {
	REACHABILITY, RACES, LIVENESS, CAT;
	
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
			case CAT:
				return "CAT properties";
			default:
				throw new UnsupportedOperationException("Unrecognized property: " + this);
        }
    }

	public static EnumSet<Property> getDefault() {
		return EnumSet.of(REACHABILITY, CAT);
	}

	// Used to decide the order shown by the selector in the UI
	public static Property[] orderedValues() {
		Property[] order = { REACHABILITY, RACES, LIVENESS, CAT };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}

	public BooleanFormula getSMTVariable(EncodingContext ctx) {
		return ctx.getBooleanFormulaManager().makeVariable(this.toString());
	}

	public BooleanFormula getSMTVariable(Axiom ax, EncodingContext ctx) {
		Preconditions.checkState(this == CAT);
		return ctx.getBooleanFormulaManager()
				.makeVariable("Flag " + Optional.ofNullable(ax.getName()).orElse(ax.getRelation().getNameOrTerm()));
	}
}