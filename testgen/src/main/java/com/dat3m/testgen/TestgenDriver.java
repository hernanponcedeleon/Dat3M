package com.dat3m.testgen;

import com.dat3m.testgen.classes.Event;
import com.dat3m.testgen.classes.Thread;
import com.dat3m.testgen.classes.Relation;

public class TestgenDriver {

    public static void main(String[] args) throws Exception {
        
        Thread thread_1 = new Thread( 1 );
        Thread thread_2 = new Thread( 2 );
        Event event_1 = new Event( 1 );
        Event event_2 = new Event( 2 );
        Event event_3 = new Event( 3 );

        thread_1.add_event_front( event_1 );
        thread_2.add_event_front( event_2 );
        thread_1.add_event( event_1, event_3 );

        System.out.println( thread_1 + "\n" + thread_2 );

        Relation relation = new Relation( event_1, Relation.relation_t.po, event_3 );

        System.out.println( relation );

    }

}