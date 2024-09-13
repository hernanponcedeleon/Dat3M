package com.dat3m.testgen.program;

public class ProgramEvent {
    
    public String  instruction;
    public Integer event_id;
    public String  mem_type;
    public Integer mem_location;
    public Integer mem_value;
    public Integer thread_id;
    public Integer thread_row;

    public ProgramEvent(
        final String  r_instruction,
        final Integer r_event_id,
        final String  r_mem_type,
        final Integer r_mem_location,
        final Integer r_mem_value,
        final Integer r_thread_id,
        final Integer r_thread_row
    ) {
        instruction  = r_instruction;
        event_id     = r_event_id;
        mem_type     = r_mem_type;
        mem_location = r_mem_location;
        mem_value    = r_mem_value;
        thread_id    = r_thread_id;
        thread_row   = r_thread_row;
    }

    public String short_form()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( "(" + instruction + ", @" + mem_location + ", " + mem_value + ")" );
        return sb.toString();
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( "[E-id: " + event_id + "] : (" + instruction + ", @" + mem_location + ", " + mem_value + "), [Tid: " + thread_id + ", Trow: " + thread_row + "]" );
        return sb.toString();
    }

}
