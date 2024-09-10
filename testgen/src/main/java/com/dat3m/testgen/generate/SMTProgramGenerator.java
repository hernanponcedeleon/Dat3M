package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.Model;

import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.ProgramEvent;
import com.dat3m.testgen.util.RelationEdge;

import java.util.*;

public class SMTProgramGenerator {
    
    final Graph graph;
    final int max_events;
    final SMTEvent[] events;
    final SMTEvent[] observers;
    final SMTHandler smt;

    public SMTProgramGenerator(
        final Graph r_graph,
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
        for( final RelationEdge relation : graph.edges )
            smt.prover.addConstraint( SMTRelationHandler.handle_relation(
                smt,
                events[ relation.eid_L ], events[ relation.eid_R ],
                observers[ relation.eid_L ], observers[ relation.eid_R ],
                relation.base
            ) );
    }

    void apply_heuristics()
    throws Exception {
        SMTHeuristics.equivalence_h( smt, events );
        SMTHeuristics.equivalence_h( smt, observers );
        SMTHeuristics.memory_distinction( smt, events );
        SMTHeuristics.row_maximization( smt, events );
        SMTHeuristics.row_maximization( smt, observers );
        SMTHeuristics.thread_maximisation( smt, events );
        SMTHeuristics.thread_maximisation( smt, observers );
        SMTHeuristics.memory_maximisation( smt, events );
        SMTHeuristics.event_minimization( smt, events );
        SMTHeuristics.event_minimization( smt, observers );
    }

    List <ProgramEvent> prove_program()
    throws Exception {
        if( smt.prover.isUnsat() ) {
            return null;
        }
        List <ProgramEvent> event_list = new ArrayList<>();
        Model model = smt.prover.getModel();
        for( SMTEvent event : events )
            event_list.add( generate_program_event( model, event ) );
        for( SMTEvent event : observers )
            event_list.add( generate_program_event( model, event ) );
        return event_list;
    }

    ProgramEvent generate_program_event(
        final Model model,
        final SMTEvent event
    ) throws Exception {
        return new ProgramEvent(
            model.evaluate( event.type ),
            Integer.parseInt( model.evaluate( event.location ).toString() ),
            Integer.parseInt( model.evaluate( event.value ).toString() ),
            Integer.parseInt( model.evaluate( event.thread_id ).toString() ),
            Integer.parseInt( model.evaluate( event.thread_row ).toString() ),
            Integer.parseInt( model.evaluate( event.event_id ).toString() )
        );
    }

}
