package com.dat3m.testgen;

import com.dat3m.testgen.classes.Cycle;
import com.dat3m.testgen.classes.Relation.relation_t;

public class TestgenDriver {

    public static void main(String[] args) throws Exception {
        
        Cycle cycle = new Cycle( 4 );

        cycle.add_relation( 0, relation_t.po, 1 );
        cycle.add_relation( 1, relation_t.rf, 2 );
        cycle.add_relation( 2, relation_t.po, 3 );
        cycle.add_relation( 3, relation_t.rf, 0 );

        System.out.println( cycle );

    }

}