package com.dat3m.testgen.program_out;

public class Event {

    final int event_id;
    final String type;
    final int location;
    final int value;
    final int thread_id;
    final int thread_row;

    public Event(
        final String line
    ) {
        String[] info = line.split( "," );
        event_id = Integer.parseInt( info[0] );
        type = type_to_str( Integer.parseInt( info[1] ) );
        location = Integer.parseInt( info[2] );
        value = Integer.parseInt( info[3] );
        thread_id = Integer.parseInt( info[4] );
        thread_row = Integer.parseInt( info[5] );
    }

    public String type_to_str(
        final int type_int
    ) {
        switch( type_int ) {
            case 1:
                return "Read";
            case 2:
                return "Write";
            case 3:
                return "Observer";
            default:
                return "Undefined";
        }
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
        sb.append(
            "\n[Event_id: " + event_id + "]: " +
            "\n\ttype: " + type +
            "\n\tlocation: " + location +
            "\n\tvalue: " + value +
            "\n\tthread_id: " + thread_id +
            "\n\tthread_row:" + thread_row + "\n"
        );
        return sb.toString();
    }

}
