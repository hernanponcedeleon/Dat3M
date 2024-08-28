package com.dat3m.testgen.generate;

import org.sosy_lab.java_smt.api.Model;

import com.dat3m.testgen.util.Graph;
import com.dat3m.testgen.util.RelationEdge;
import com.dat3m.testgen.program.Program;
import com.dat3m.testgen.program.ProgramEvent;

import java.util.*;

public class ProgramGenerator {
    
    final static int MAX_EVENTS = 7;
    final Graph cycle;
    final SMTEvent[] events;
    final SMTEvent[] observers;
    final SMTHandler smt;

    public ProgramGenerator(
        final Graph r_cycle
    ) throws Exception {
        cycle     = r_cycle;
        smt       = new SMTHandler();
        events    = new SMTEvent[ MAX_EVENTS ];
        observers = new SMTEvent[ MAX_EVENTS ];
        
        for( int i = 0 ; i < MAX_EVENTS ; i++ ) {
            events[i]    = new SMTEvent( i+1 );
            observers[i] = new SMTEvent( MAX_EVENTS+i+1 );
        }
        
        initialize();
        process_relations();
        heuristics();
        prove();
    }

    void initialize()
    throws Exception {
        for( SMTEvent event : events )
            event.init( smt, 0 );
        for( SMTEvent event : observers )
            event.init( smt, MAX_EVENTS );
    }

    void process_relations()
    throws Exception {
        for( final RelationEdge relation : cycle.relations )
            SMTRelationHandler.handle_relation(
                smt,
                events[ relation.event_id_left ],
                events[ relation.event_id_right ],
                observers[ relation.event_id_left ],
                observers[ relation.event_id_right ],
                relation.base_relation
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
        Program program = new Program( event_list );
        System.out.println( program.print_program() );
    }

}
