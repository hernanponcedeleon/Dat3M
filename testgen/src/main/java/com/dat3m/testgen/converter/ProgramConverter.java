package com.dat3m.testgen.converter;

import java.util.*;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.testgen.program.ProgramEvent;

public class ProgramConverter {
    
    final List <List <ProgramEvent>> threads;
    final List <ProgramEvent> events;

    ProgramBuilder program_builder;
    ExpressionFactory expressions;
    IntegerType arch_type;
    
    Expression assert_expression;

    public ProgramConverter(
        final List <ProgramEvent> r_events
    ) throws Exception {
        events  = new ArrayList<>();
        threads = new ArrayList<>();
        for( int i = 0 ; i < r_events.size() ; i++ )
            threads.add( new ArrayList<>() );
        
        Set <Integer> event_id_set = new HashSet<>();

        for( ProgramEvent event : r_events ) {
            if( event.instruction == null ||
                event.instruction.equals( "UNDEFINED" ) ||
                event_id_set.contains( event.event_id )
            ) {
                continue;
            }
            events.add( event );
            event_id_set.add( event.event_id );
        }

        for( ProgramEvent event : events )
            threads.get( event.thread_id ).add( event );

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

        int next_actual_tid = 0;
        for( List <ProgramEvent> thread : threads ) {
            if( thread.isEmpty() )
                continue;
            for( int i = 0 ; i < thread.size() ; i++ ) {
                ProgramEvent event = thread.get( i );
                int index_of = events.indexOf( event );
                event.thread_id = next_actual_tid;
                thread.set( i, event );
                events.set( index_of, event );
            }
            next_actual_tid++;
        }
    }

    public String print_program(
        String graph_str
    ) throws Exception {
        StringBuilder sb = new StringBuilder();
        List <String> read_constraints = new ArrayList<>();

        sb.append( "C Dat3M Testgen Litmus\n\"\n" + graph_str + "\"\n{" );

        Set <Integer> global_memory_addresses = new HashSet<>();
        StringBuilder tsb = new StringBuilder();

        for( ProgramEvent event : events )
            global_memory_addresses.add( event.mem_location );

        boolean first_run = true;
        for( Integer addr : global_memory_addresses ) {
            tsb.append( ( first_run ? "( " : ", " ) + "atomic_int *a" + addr );
            first_run = false;
            sb.append( " [a" + addr + "]=0;" );
        }

        for( ProgramEvent event : events )
            if( event.instruction.equals( "R" ) )
                sb.append( " " + event.thread_id + ":r" + event.event_id + "=0;" );

        sb.append( " }\n\n" );
        tsb.append( " ) " );
        String thread_signature = tsb.toString();

        for( List <ProgramEvent> thread : threads ) {
            if( thread.isEmpty() )
                continue;
            sb.append( "P" + thread.get(0).thread_id + thread_signature + " {\n" );
            for( ProgramEvent event : thread ) {
                char memory_tag;
                switch( event.mem_type ) {
                    case "ADDRESS":
                        memory_tag = 'a';
                    break;
                    
                    case "REGISTER":
                        memory_tag = 'r';
                    break;

                    default:
                        System.out.println( "[ERROR] " + event.mem_type );
                        throw new Exception( "Undefined memory location type." );
                }
                if( event.instruction.equals( "R" ) ) {
                    read_constraints.add( event.thread_id + ":r" + event.event_id + " = " + event.mem_value );
                    sb.append( "  r" + event.event_id + " = atomic_load_explicit(" + memory_tag + event.mem_location +", memory_order_seq_cst);" + "\n" );
                } else {
                    sb.append( "  atomic_store_explicit(" + memory_tag + event.mem_location + ", " + event.mem_value + ", memory_order_seq_cst);" + "\n" );
                }
            }
            sb.append( "}\n\n" );
        }

        first_run = true;
        for( String constraint : read_constraints ) {
            sb.append( ( first_run ? "exists ( " : " /\\ " ) + constraint );
            first_run = false;
        }
        sb.append( " )\n" );

        return sb.toString();
    }

}
