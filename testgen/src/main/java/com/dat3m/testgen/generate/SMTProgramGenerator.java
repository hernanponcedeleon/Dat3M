package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.Model;

import com.dat3m.testgen.program.ProgramEdge;
import com.dat3m.testgen.program.ProgramEvent;
import com.dat3m.testgen.program.ProgramGraph;

import java.util.*;

public class SMTProgramGenerator {
    
    final ProgramGraph graph;
    final int max_events;
    final SMTEvent[] events;
    final SMTEvent[] observers;
    final SMTHandler smt;

    public SMTProgramGenerator(
        final ProgramGraph r_graph,
        final int r_max_events
    ) throws Exception {
        graph      = r_graph;
        max_events = r_max_events;
        smt        = new SMTHandler();
        events     = new SMTEvent[ max_events ];
        observers  = new SMTEvent[ max_events ];
        
        for( int i = 0 ; i < max_events ; i++ ) {
            events[i]    = new SMTEvent( i+1 );
            observers[i] = new SMTEvent( max_events+i+1 );
        }
    }

    public List <ProgramEvent> generate_program()
    throws Exception {
        initialize_events();
        process_relations();
        apply_heuristics();
        finalize_events();
        return prove_program();
    }

    void initialize_events()
    throws Exception {
        for( SMTEvent event : events )
            event.init( smt, 0, max_events );
        for( SMTEvent event : observers )
            event.init( smt, max_events, max_events );
    }

    void process_relations()
    throws Exception {
        for( ProgramEdge relation : graph.edges )
            smt.prover.addConstraint( SMTBaseRelationHandler.handle_relation(
                smt,
                events[ relation.eid_L ], events[ relation.eid_R ],
                observers[ relation.eid_L ], observers[ relation.eid_R ],
                relation.base
            ) );
    }

    void apply_heuristics()
    throws Exception {
        SMTHeuristicsHandler event_h = new SMTHeuristicsHandler( smt, events );
        SMTHeuristicsHandler observer_h = new SMTHeuristicsHandler( smt, observers );
        event_h.apply_heuristics( "equivalence", "memory_distinction", "row_maximization", "thread_maximization", "memory_maximization" );
        observer_h.apply_heuristics( "equivalence", "row_maximization", "thread_maximization" );
    }

    void finalize_events()
    throws Exception {
        for( SMTEvent event : events )
            event.finalize( smt );
        for( SMTEvent event : observers )
            event.finalize( smt );
    }

    List <ProgramEvent> prove_program()
    throws Exception {
        if( smt.prover.isUnsat() ) {
            return null;
        }
        List <ProgramEvent> event_list = new ArrayList<>();
        Model model = smt.prover.getModel();
        for( SMTEvent event : events )
            event_list.add( event.generate_program_event( model ) );
        for( SMTEvent event : observers )
            event_list.add( event.generate_program_event( model ) );
        return event_list;
    }

}
