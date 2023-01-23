package com.dat3m.dartagnan.configuration;

import java.util.Arrays;
import java.util.EnumSet;
import java.util.Optional;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import com.dat3m.dartagnan.wmm.axiom.Axiom;

public enum Property implements OptionInterface {
	PROGRAM_SPEC, 		// Litmus queries OR assertion safety in C-code
	LIVENESS,			// Liveness property
	CAT_SPEC,			// CAT-spec defined via flagged axioms in .cat file (~bug specification)
	DATARACEFREEDOM; 	// Special option for data-race detection in SVCOMP only

	public enum Type {
		SAFETY,
		REACHABILITY,
		MIXED
	}
	
	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
        	case PROGRAM_SPEC:
        		return "Program specification";
        	case DATARACEFREEDOM:
        		return "Data-race freedom (SVCOMP only)";
			case LIVENESS:
				return "Liveness";
			case CAT_SPEC:
				return "CAT specification";
			default:
				throw new UnsupportedOperationException("Unrecognized property: " + this);
        }
    }

	public static EnumSet<Property> getDefault() {
		return EnumSet.of(PROGRAM_SPEC);
	}

	// Used to decide the order shown by the selector in the UI
	public static Property[] orderedValues() {
		Property[] order = {PROGRAM_SPEC, LIVENESS, CAT_SPEC, DATARACEFREEDOM};
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}

	public Type getType(VerificationTask context) {
		if (this != PROGRAM_SPEC || context.getProgram().getSpecification().isSafetySpec()) {
			return Type.SAFETY;
		} else {
			return Type.REACHABILITY;
		}
	}

	public static Type getCombinedType(EnumSet<Property> properties, VerificationTask context) {
		return properties.stream().map(p -> p.getType(context))
				.reduce((x, y) -> x == y ? x : Type.MIXED)
				.orElse(Type.SAFETY); // In the odd case that the properties are empty, we consider it a safety spec
	}

	public BooleanFormula getSMTVariable(EncodingContext ctx) {
		return ctx.getBooleanFormulaManager().makeVariable(this.toString());
	}

	public BooleanFormula getSMTVariable(Axiom ax, EncodingContext ctx) {
		Preconditions.checkState(this == CAT_SPEC);
		return ctx.getBooleanFormulaManager()
				.makeVariable("Flag " + Optional.ofNullable(ax.getName()).orElse(ax.getRelation().getNameOrTerm()));
	}
}