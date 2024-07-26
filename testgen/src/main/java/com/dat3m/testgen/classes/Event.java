package com.dat3m.testgen.classes;

import scala.collection.mutable.StringBuilder;
import java.lang.Exception;

public class Event {

    enum event_operation_t {
        undefined,
        read,
        write
    };

    public final int id;
    public event_operation_t type;
    public int location;
    public int value;
    public Thread parent_thread;

    public Event(
        final int r_id
    ) throws Exception {
        if( r_id <= 0 )
            throw new Exception( "r_id of Event must be greater than zero." );
        this.id = r_id;
        type = event_operation_t.undefined;
        location = -1;
        value = -1;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(
            "Event [eid:" + this.id + "]: " +
            "[type:" + this.type + "], " +
            "[location:" + this.location + "], " +
            "[value:" + this.value + "]"
        );
        if( this.parent_thread != null )
            sb.append( ", [parent_thread_tid: " + this.parent_thread.id + "]" );
        return sb.toString();
    }

}
