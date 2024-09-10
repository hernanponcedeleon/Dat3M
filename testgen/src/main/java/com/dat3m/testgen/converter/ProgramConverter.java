package com.dat3m.testgen.converter;

import java.math.BigInteger;
import java.util.*;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.testgen.util.ProgramEvent;

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
    throws Exception {
        program_builder = ProgramBuilder.forLanguage( Program.SourceLanguage.LITMUS );
        expressions = program_builder.getExpressionFactory();
        arch_type = program_builder.getTypeFactory().getArchType();

        for( List <ProgramEvent> thread : threads ) {
            for( ProgramEvent event : thread ) {
                process_event( event );
            }
        }

        return program_builder.build();
    }

    void process_event(
        final ProgramEvent event
    ) throws Exception {
        program_builder.getOrNewThread( event.thread_id );
        switch( event.type ) {
            case "R":
                program_builder.addChild( event.thread_id, EventFactory.newLoad( 
                    program_builder.getOrNewRegister(
                        event.thread_id,
                        "r" + event.event_id,
                        program_builder.getTypeFactory().getArchType()
                    ),
                    program_builder.getOrNewMemoryObject( "a" + event.location )
                ) );
                if( assert_expression == null ) {
                    assert_expression = expressions.makeEQ(
                        program_builder.getOrErrorRegister(
                            event.thread_id,
                            "r" + event.event_id
                        ),
                        expressions.makeValue(
                            BigInteger.valueOf( event.value ),
                            program_builder.getTypeFactory().getArchType()
                        )
                    );
                } else {
                    assert_expression = expressions.makeAnd(
                        assert_expression,
                        expressions.makeEQ(
                            program_builder.getOrErrorRegister(
                                event.thread_id,
                                "r" + event.event_id
                            ),
                            expressions.makeValue(
                                BigInteger.valueOf( event.value ),
                                program_builder.getTypeFactory().getArchType()
                            )
                        )
                    );
                }
                program_builder.setAssert(
                    Program.SpecificationType.EXISTS,
                    assert_expression
                );
            break;

            case "W":
                program_builder.addChild(
                    event.thread_id,
                    EventFactory.newStore(
                        program_builder.getOrNewMemoryObject( "a" + event.location ),
                        expressions.makeValue(
                            BigInteger.valueOf( event.value ),
                            program_builder.getTypeFactory().getArchType()
                        )
                    )
                );
            break;

            default:
                throw new Exception( "Undefined instruction type!" );
        }
    }

}
