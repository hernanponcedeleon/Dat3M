package com.dat3m.dartagnan.wmm.utils;

import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;

public enum  Flag {
    ARM_UNPREDICTABLE_BEHAVIOUR,
    LINUX_UNBALANCED_RCU;

    // TODO: Add linux when implemented
    public static final ImmutableSet<Flag> ALL = ImmutableSet.of(ARM_UNPREDICTABLE_BEHAVIOUR);

    public BooleanFormula repr(FormulaManager m){
    	return m.getBooleanFormulaManager().makeVariable(code());
    }

    @Override
    public String toString(){
        return switch (this) {
            case ARM_UNPREDICTABLE_BEHAVIOUR -> "ARM unpredictable behaviour";
            case LINUX_UNBALANCED_RCU -> "Linux unbalanced RCU lock-unlock";
        };
    }

    private String code(){
        return switch (this) {
            case ARM_UNPREDICTABLE_BEHAVIOUR -> "ARM_unpredictable_flag";
            case LINUX_UNBALANCED_RCU -> "Linux_unbalanced_RCU_flag";
        };
    }
}
