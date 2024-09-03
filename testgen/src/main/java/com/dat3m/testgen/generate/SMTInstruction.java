package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.EnumerationFormula;
import org.sosy_lab.java_smt.api.FormulaType.EnumerationFormulaType;

public class SMTInstruction {
    
    public static EnumerationFormulaType enum_type;
    public final static String[] instruction_types = { "UNDEFINED", "R", "W" };

    static EnumerationFormula get(
        final SMTHandler smt,
        final String instruction
    ) throws Exception {
        for( String str : instruction_types ) {
            if( str.equals( instruction ) )
                return smt.em.makeConstant( instruction, enum_type );
        }
        throw new Exception( "Instruction type not found!" );
    }

}
