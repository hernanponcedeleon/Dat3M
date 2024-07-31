package com.dat3m.testgen;

import com.dat3m.testgen.smt_classes.CNF;
import com.dat3m.testgen.smt_classes.Cycle;
import com.dat3m.testgen.smt_classes.Relation;
import com.dat3m.testgen.smt_classes.SMTProgramGenerator;

public class TestgenDriver {

    public static void main(String[] args) throws Exception {
        
        CNF cnf = new CNF( "HB_SC" );

        cnf.add_non_terminal( "FR" );

        cnf.add_terminal( "po" );
        cnf.add_terminal( "rf" );
        cnf.add_terminal( "co" );
        cnf.add_terminal( "rf_inv" );

        cnf.add_rule( "HB_SC", "po" );
        cnf.add_rule( "HB_SC", "rf" );
        cnf.add_rule( "HB_SC", "co" );
        cnf.add_rule( "HB_SC", "FR" );
        cnf.add_rule( "FR", "rf_inv;co" );

        cnf.to_normal_form();

        System.out.println( cnf );

    }

}