package com.dat3m.testgen;

import com.dat3m.testgen.smt_classes.Cycle;
import com.dat3m.testgen.smt_classes.Relation;
import com.dat3m.testgen.smt_classes.SMTProgramGenerator;

public class TestgenDriver {

    public static void main(String[] args) throws Exception {
        
        Cycle cycle;
        
        /*
        cycle = new Cycle( 4 );
        cycle.create_relation( 0, Relation.relation_t.po, 1 );
        cycle.create_relation( 1, Relation.relation_t.rf, 2 );
        cycle.create_relation( 2, Relation.relation_t.po, 3 );
        cycle.create_relation( 3, Relation.relation_t.rf, 0 ); // */

        /*
        cycle = new Cycle( 4 );
        cycle.create_relation( 0, Relation.relation_t.po, 1 );
        cycle.create_relation( 1, Relation.relation_t.co, 2 );
        cycle.create_relation( 2, Relation.relation_t.po, 3 );
        cycle.create_relation( 3, Relation.relation_t.co, 0 ); // */

        /*
        cycle = new Cycle( 4 );
        cycle.create_relation( 0, Relation.relation_t.co, 1 );
        cycle.create_relation( 1, Relation.relation_t.po, 2 );
        cycle.create_relation( 2, Relation.relation_t.rf, 3 );
        cycle.create_relation( 2, Relation.relation_t.co, 0 );
        // */

        // /*
        cycle = new Cycle( 4 );
        cycle.create_relation( 0, Relation.relation_t.co, 1 );
        cycle.create_relation( 1, Relation.relation_t.po, 2 );
        cycle.create_relation( 2, Relation.relation_t.rf, 3 );
        cycle.create_relation( 3, Relation.relation_t.rf_inv, 2 );
        cycle.create_relation( 2, Relation.relation_t.co, 0 );
        // */

        SMTProgramGenerator prog_gen = new SMTProgramGenerator( cycle );

        System.out.println( prog_gen.generate_program() );

    }

}