package com.dat3m.testgen.classes;

import java.util.*;

import scala.collection.mutable.StringBuilder;

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

    public Event( int r_id ) {
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
        return sb.toString();
    }

}
