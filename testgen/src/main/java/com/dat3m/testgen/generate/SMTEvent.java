package com.dat3m.testgen.generate;

import java.util.Arrays;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.EnumerationFormula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import com.dat3m.testgen.program.ProgramEvent;

class SMTEvent {
    
    final int self_id;
    EnumerationFormula instruction;
    IntegerFormula eid;
    SMTMemory mem;
    SMTThread thread;

    SMTEvent(
        final int r_self_id
    ) throws Exception {
        if( r_self_id <= 0 )
            throw new Exception( "Event id has to be greater than zero." );
        self_id = r_self_id;
        mem     = new SMTMemory();
        thread  = new SMTThread();
    }

    String name(
        final String suffix
    ) {
        return "e" + self_id + "_" + suffix;
    }

    void init(
        final SMTHandler smt,
        final int lower_bound,
        final int max_events
    ) throws Exception {
        instruction  = smt.em.makeVariable( name( "instruction" ), smt.instruction_type_enum );
        eid          = smt.im.makeVariable( name( "eid" ) );
        mem.type     = smt.em.makeVariable( name( "mem_type" ), smt.memory_type_enum );
        mem.location = smt.im.makeVariable( name( "mem_location" ) );
        mem.value    = smt.im.makeVariable( name( "mem_value" ) );
        mem.order    = smt.em.makeVariable( name( "mem_order" ), smt.order_type_enum );
        thread.tid   = smt.im.makeVariable( name( "thread_tid" ) );
        thread.row   = smt.im.makeVariable( name( "thread_row" ) );
        smt.prover.addConstraint( smt.bm.and(
            smt.im.greaterThan(  mem.location,   smt.im.makeNumber( 0 ) ),
            smt.im.lessOrEquals( mem.location,   smt.im.makeNumber( max_events ) ),
            smt.im.greaterThan(  mem.value,      smt.im.makeNumber( 0 ) ),
            smt.im.lessOrEquals( mem.value,      smt.im.makeNumber( max_events ) ),
            smt.im.greaterThan(  thread.tid,     smt.im.makeNumber( lower_bound ) ),
            smt.im.lessOrEquals( thread.tid,     smt.im.makeNumber( lower_bound + max_events ) ),
            smt.im.greaterThan(  thread.row,     smt.im.makeNumber( 0 ) ),
            smt.im.lessOrEquals( thread.row,     smt.im.makeNumber( max_events ) ),
            smt.im.greaterThan(  eid,            smt.im.makeNumber( lower_bound ) ),
            smt.im.lessOrEquals( eid,            smt.im.makeNumber( lower_bound + max_events ) )
        ) );
    }

    void finalize(
        final SMTHandler smt
    ) throws Exception {
        BooleanFormula assumption;
        assumption = smt.em.equivalence( instruction, smt.instruction( "UNDEFINED" ) );
        if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) ) {
            smt.prover.addConstraint( assumption );
        }
        assumption = smt.em.equivalence( mem.type, smt.memory( "ADDRESS" ) );
        if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) ) {
            smt.prover.addConstraint( assumption );
        }
        assumption = smt.em.equivalence( mem.order, smt.order( "NONE" ) );
        if( !smt.prover.isUnsatWithAssumptions( Arrays.asList( assumption ) ) ) {
            smt.prover.addConstraint( assumption );
        }
    }

    ProgramEvent generate_program_event(
        final Model model
    ) throws Exception {
        return new ProgramEvent(
            model.evaluate( instruction ),
            Integer.parseInt( model.evaluate( eid ).toString() ),
            model.evaluate( mem.type ),
            Integer.parseInt( model.evaluate( mem.location ).toString() ),
            Integer.parseInt( model.evaluate( mem.value ).toString() ),
            model.evaluate( mem.order ),
            Integer.parseInt( model.evaluate( thread.tid ).toString() ),
            Integer.parseInt( model.evaluate( thread.row ).toString() )
        );
    }

}

class SMTMemory {
    
    EnumerationFormula type;
    IntegerFormula value;
    IntegerFormula location;
    EnumerationFormula order;

}

class SMTThread {

    IntegerFormula tid;
    IntegerFormula row;
    
}
