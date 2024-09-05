package com.dat3m.testgen.converter;

import java.util.*;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.testgen.util.ProgramEvent;

public class ProgramConverter {
    
    final List <List <ProgramEvent>> threads;
    final List <ProgramEvent> events;

    public ProgramConverter(
        final List <ProgramEvent> r_events
    ) throws Exception {
        if( r_events == null )
            throw new Exception( "List of events is empty." );
        
        events  = new ArrayList<>();
        threads = new ArrayList<>();
        for( int i = 0 ; i < r_events.size() ; i++ )
            threads.add( new ArrayList<>() );
        
        Set <Integer> event_id_set = new HashSet<>();

        for( ProgramEvent event : r_events ) {
            if( event.type == null ||
                event.type.equals( "UNDEFINED" ) ||
                event_id_set.contains( event.event_id )
            ) {
                continue;
            }
            events.add( event );
            event_id_set.add( event.event_id );
        }

        for( ProgramEvent event : events ) {
            threads.get( event.thread_id ).add( event );
        }

        for( List <ProgramEvent> thread : threads ) {
            for( int i = 0 ; i < thread.size() ; i++ ) {
                for( int j = 1 ; j < thread.size() ; j++ ) {
                    if( thread.get( j-1 ).thread_row > thread.get( j ).thread_row ) {
                        ProgramEvent temp = thread.get( j-1 );
                        thread.set( j-1, thread.get( j ) );
                        thread.set( j, temp );
                    } 
                }
            }
        }
    }

    public String print_program()
    {
        StringBuilder sb = new StringBuilder();
        List <String> read_constraints = new ArrayList<>();

        for( List <ProgramEvent> thread : threads ) {
            if( thread.isEmpty() )
                continue;
            sb.append( "T" + thread.get(0).thread_id + ":\n" );
            for( ProgramEvent event : thread ) {
                if( event.type.equals( "R" ) ) {
                    read_constraints.add( "r" + event.event_id + " == " + event.value );
                    sb.append( "  r" + event.event_id + " = " + event.short_form() + "\n" );
                } else {
                    sb.append( "  " + event.short_form() + "\n" );
                }
            }
            sb.append( "\n" );
        }

        sb.append( "assert( true" );
        for( String constraint : read_constraints ) {
            sb.append( "\n  && " + constraint );
        }
        sb.append( "\n)\n\n" );

        return sb.toString();
    }

    public Program to_dat3m_program()
    {
        return null;
    }

}
