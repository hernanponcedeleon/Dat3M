package com.dat3m.testgen.program_out;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ProgramParser {

    public String program_str;
    public List < List <Event> > threads;
    public List <Event> events;

    public ProgramParser(
        String r_program_str
    ) {
        program_str = r_program_str;
        events = new ArrayList<>();
    }

    public String print_program()
    {
        if( program_str.equals( "Program cannot exist!" ) )
            return "Program cannot exist!";

        System.out.println( program_str );
        
        StringBuilder sb = new StringBuilder();
        Set <Integer> event_id_set = new HashSet<>();
        
        int threads_needed = 0;

        for( String event_str : program_str.split("\n") ) {
            Event event = new Event( event_str );
            if( event.type.equals( "Undefined" ) || event_id_set.contains( event.event_id ) )
                continue;
            events.add( event );
            event_id_set.add( event.event_id );
            threads_needed = Math.max( threads_needed, event.thread_id + 1 );
        }

        threads = new ArrayList<>();
        for( int i = 0 ; i < threads_needed ; i++ )
            threads.add( new ArrayList<>() );
        
        for( Event event : events ) {
            threads.get( event.thread_id ).add( event );
        }

        for( List <Event> thread : threads ) {
            for( int i = 0 ; i < thread.size() ; i++ ) {
                for( int j = 1 ; j < thread.size() ; j++ ) {
                    if( thread.get( j-1 ).thread_row > thread.get( j ).thread_row ) {
                        Event temp = thread.get( j-1 );
                        thread.set( j-1, thread.get( j ) );
                        thread.set( j, temp );
                    } 
                }
            }
        }

        for( List <Event> thread : threads ) {
            if( thread.isEmpty() )
                continue;
            
            sb.append( "T" + thread.get(0).thread_id + ":\n" );
            int last_row = -1;
            for( Event event : thread ) {
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
