package com.dat3m.dartagnan.wmm.utils;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;

import com.google.common.collect.ImmutableSet;

public enum  Flag {
    ARM_UNPREDICTABLE_BEHAVIOUR,
    LINUX_UNBALANCED_RCU;

    // TODO: Add linux when implemented
    public static ImmutableSet<Flag> all = ImmutableSet.of(ARM_UNPREDICTABLE_BEHAVIOUR);

    public BooleanFormula repr(FormulaManager m){
    	return m.getBooleanFormulaManager().makeVariable(code());
    }

    @Override
    public String toString(){
        switch (this){
            case ARM_UNPREDICTABLE_BEHAVIOUR:
                return "ARM unpredictable behaviour";
            case LINUX_UNBALANCED_RCU:
                return "Linux unbalanced RCU lock-unlock";
        }
        throw new UnsupportedOperationException("Illegal flag type");
    }

    private String code(){
        switch (this){
            case ARM_UNPREDICTABLE_BEHAVIOUR:
                return "ARM_unpredictable_flag";
            case LINUX_UNBALANCED_RCU:
                return "Linux_unbalanced_RCU_flag";
        }
        throw new UnsupportedOperationException("Illegal flag type");
    }
}
