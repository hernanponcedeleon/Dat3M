package com.dat3m.testgen.program;

import java.util.*;

public class Program {
    
    List < List <ProgramEvent> > threads;
    List <ProgramEvent> events;

    public Program(
        List <ProgramEvent> r_events
    ) {
        events = new ArrayList<>( r_events );
        threads = new ArrayList<>();
        for( int i = 0 ; i < events.size() ; i++ )
            threads.add( new ArrayList<>() );
    }

    public String print_program()
    {
        StringBuilder sb = new StringBuilder();
        Set <Integer> event_id_set = new HashSet<>();
        
        List <ProgramEvent> filtered_events = new ArrayList<>();

        for( ProgramEvent event : events ) {
            if( event.type == null || event.type.equals( "UNDEFINED" ) || event_id_set.contains( event.event_id ) )
                continue;
            filtered_events.add( event );
            event_id_set.add( event.event_id );
        }

        events = filtered_events;

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

        for( List <ProgramEvent> thread : threads ) {
            if( thread.isEmpty() )
                continue;
            
            sb.append( "T" + thread.get(0).thread_id + ":\n" );
            int last_row = -1;
            for( ProgramEvent event : thread ) {
                if( last_row != -1 && event.thread_row != last_row )
                    sb.append( "--- --- --- ---\n" );
                last_row = event.thread_row;
                sb.append( "  " + event.short_form() + "\n" );
            }
            sb.append( "\n\n" );
        }

        return sb.toString();
    }

}
