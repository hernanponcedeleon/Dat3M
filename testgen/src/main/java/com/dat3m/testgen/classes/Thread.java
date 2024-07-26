package com.dat3m.testgen.classes;

import java.util.LinkedList;

public class Thread {
    
    public final int id;
    public LinkedList <Event> events;

    public Thread(
        final int r_id
    ) throws Exception {
        if( r_id < 0 )
            throw new Exception( "r_id of Thread must be non-negative." );
        this.id = r_id;
        events = new LinkedList<>();
    }

    public void add_event_front(
        Event event
    ) throws Exception {
        if( event == null ) throw new Exception( "Cannot add null event to thread." );
        if( event.parent_thread != null ) throw new Exception( "Event already belongs to another thread." );
        events.addFirst( event );
        event.parent_thread = this;
    }

    public void add_event(
        final Event parent_event,
        Event event
    ) throws Exception {
        if( event == null ) throw new Exception( "Event cannot be null." );
        if( parent_event == null ) throw new Exception( "Parent event cannot be null." );
        if( event == parent_event ) throw new Exception( "Event and Parent Event cannot be the same." );
        if( event.parent_thread != null ) throw new Exception( "Event already belongs a thread." );
        if( parent_event.parent_thread != this ) throw new Exception( "Parent event does not belong to this thread." );
        int parent_index = events.indexOf( parent_event );
        if( parent_index == -1 ) throw new Exception( "Parent event does not exist in thread." );
        events.add( events.indexOf( parent_event ) + 1, event );
        event.parent_thread = this;
    }

    public void remove_event(
        Event event
    ) throws Exception {
        if( event == null ) throw new Exception( "Event cannot be null." );
        if( event.parent_thread != this ) throw new Exception( "Event does not belong to this thread." );
        boolean action = events.remove( event );
        if( action == false ) throw new Exception( "Event not found in thread's event list." );
        event.parent_thread = null;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append( "Thread [tid:" + this.id + "]:\n" );
        for( final Event e : this.events ) {
            sb.append( "\t" + e + "\n" );
        }
        return sb.toString();
    }

}
