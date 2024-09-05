package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.Model;

import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationEdge;
import com.dat3m.testgen.program.Program;
import com.dat3m.testgen.program.ProgramEvent;

import java.util.*;

public class ProgramGenerator {
    
    final int max_events;
    final Graph cycle;
    final SMTEvent[] events;
    final SMTEvent[] observers;
    final SMTHandler smt;

    public ProgramGenerator(
        final Graph r_cycle,
        final int r_max_events
    ) throws Exception {
        cycle      = r_cycle;
        max_events = r_max_events;
        smt        = new SMTHandler();
        events     = new SMTEvent[ max_events ];
        observers  = new SMTEvent[ max_events ];
        
        for( int i = 0 ; i < max_events ; i++ ) {
            events[i]    = new SMTEvent( i+1 );
            observers[i] = new SMTEvent( max_events+i+1 );
        }
        
        initialize();
        process_relations();
        heuristics();
        prove();
    }

    void initialize()
    throws Exception {
        for( SMTEvent event : events )
            event.init( smt, 0, max_events );
        for( SMTEvent event : observers )
            event.init( smt, max_events, max_events );
    }

    void process_relations()
    throws Exception {
        for( final RelationEdge relation : cycle.edges )
            SMTRelationHandler.handle_relation(
                smt,
                events[ relation.eid_L ],
                events[ relation.eid_R ],
                observers[ relation.eid_L ],
                observers[ relation.eid_R ],
                relation.base
            );
    }

    void heuristics()
    throws Exception {
        SMTHeuristicsHandler.equivalence_h( smt, events );
        SMTHeuristicsHandler.equivalence_h( smt, observers );
        SMTHeuristicsHandler.memory_distinction( smt, events );
        SMTHeuristicsHandler.thread_maximisation( smt, events );
        SMTHeuristicsHandler.thread_maximisation( smt, observers );
        SMTHeuristicsHandler.memory_maximisation( smt, events );
        SMTHeuristicsHandler.event_minimization( smt, events );
        SMTHeuristicsHandler.event_minimization( smt, observers );
        SMTHeuristicsHandler.row_maximization( smt, events );
        SMTHeuristicsHandler.row_maximization( smt, observers );
    }

    void prove()
    throws Exception {
        System.out.println( "Cycle: \n" + cycle );
        if( smt.prover.isUnsat() ) {
            System.out.println( "Program cannot exist !\n" );
            return;
        }
        List <ProgramEvent> event_list = new ArrayList<>();
        Model model = smt.prover.getModel();
        for( SMTEvent event : events )
            event_list.add( new ProgramEvent( model, event ) );
        for( SMTEvent event : observers )
            event_list.add( new ProgramEvent( model, event ) );
            /* TODO: Use Dat3m Program class */
        Program program = new Program( event_list );
        System.out.println( program.print_program() );
    }

}
