package com.dat3m.testgen.generate;

import java.util.stream.*;

import org.sosy_lab.common.ShutdownNotifier;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.log.LogManager;
import org.sosy_lab.java_smt.SolverContextFactory;
import org.sosy_lab.java_smt.SolverContextFactory.Solvers;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.EnumerationFormula;
import org.sosy_lab.java_smt.api.EnumerationFormulaManager;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.FormulaType.EnumerationFormulaType;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import com.dat3m.testgen.util.Types;

class SMTHandler {
    
    Configuration config;
    LogManager logger;
    ShutdownNotifier shutdown;
    SolverContext context;
    FormulaManager fm;
    IntegerFormulaManager im;
    BooleanFormulaManager bm;
    EnumerationFormulaManager em;
    ProverEnvironment prover;
    
    EnumerationFormulaType instruction_type_enum;
    String[] instruction_type_str = {};

    EnumerationFormulaType memory_type_enum;
    String[] memory_type_str = {};

    SMTHandler()
    throws Exception {
        config   = Configuration.defaultConfiguration();
        logger   = LogManager.createNullLogManager();
        shutdown = ShutdownNotifier.createDummy();

        context = SolverContextFactory.createSolverContext(
            config, logger, shutdown, Solvers.Z3
        );

        fm = context.getFormulaManager();
        im = fm.getIntegerFormulaManager();
        bm = fm.getBooleanFormulaManager();
        em = fm.getEnumerationFormulaManager();

        prover = context.newProverEnvironment( ProverOptions.GENERATE_MODELS );
        instruction_type_str = Stream.of( Types.instruction.values() ).map( Types.instruction::name ).toArray( String[]::new );
        instruction_type_enum = em.declareEnumeration( "instruction_type", instruction_type_str );
        memory_type_str = Stream.of( Types.memory.values() ).map( Types.memory::name ).toArray( String[]::new );
        memory_type_enum = em.declareEnumeration( "memory_type", memory_type_str );
    }

    EnumerationFormula instruction(
        final String instruction
    ) throws Exception {
        for( String str : instruction_type_str ) {
            if( str.equals( instruction ) )
                return em.makeConstant( instruction, instruction_type_enum );
        }
        throw new Exception( "Instruction type not found!" );
    }

    EnumerationFormula memory(
        final String memory
    ) throws Exception {
        for( String str : memory_type_str ) {
            if( str.equals( memory ) )
                return em.makeConstant( memory, memory_type_enum );
        }
        throw new Exception( "Memory type not found!" );
    }

}
