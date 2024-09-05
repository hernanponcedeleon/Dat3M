package com.dat3m.testgen.util;

public class ProgramEvent {
    
    public final String  type;
    public final Integer location;
    public final Integer value;
    public final Integer thread_id;
    public final Integer thread_row;
    public final Integer event_id;

    public ProgramEvent(
        final String  r_type,
        final Integer r_location,
        final Integer r_value,
        final Integer r_thread_id,
        final Integer r_thread_row,
        final Integer r_event_id
    ) {
        type       = r_type;
        location   = r_location;
        value      = r_value;
        thread_id  = r_thread_id;
        thread_row = r_thread_row;
        event_id   = r_event_id;
    }

    public String short_form()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( "(" + type + ", @" + location + ", " + value + ")" );
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
