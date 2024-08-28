package com.dat3m.testgen.program;

import org.sosy_lab.java_smt.api.Model;

import com.dat3m.testgen.generate.SMTEvent;

public class ProgramEvent {
    
    String type;
    Integer location;
    Integer value;
    Integer thread_id;
    Integer thread_row;
    Integer event_id;

    public ProgramEvent(
        final Model model,
        final SMTEvent event
    ) {
       type       = model.evaluate( event.type ); 
       location   = Integer.parseInt( model.evaluate( event.location ).toString() );
       value      = Integer.parseInt( model.evaluate( event.value ).toString() );
       thread_id  = Integer.parseInt( model.evaluate( event.thread_id ).toString() );
       thread_row = Integer.parseInt( model.evaluate( event.thread_row ).toString() );
       event_id   = Integer.parseInt( model.evaluate( event.event_id ).toString() );
    }

    public String short_form()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( "(" + type.charAt(0) + ", @" + location + ", " + value + ")" );
        return sb.toString();
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( "[E-id: " + event_id + "] : (" + type + ", @" + location + ", " + value + "), [Tid: " + thread_id + ", Trow: " + thread_row + "]" );
        return sb.toString();
    }

}
