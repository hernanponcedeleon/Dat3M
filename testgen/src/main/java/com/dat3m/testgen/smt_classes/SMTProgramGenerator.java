package com.dat3m.testgen.smt_classes;

public class SMTProgramGenerator {
    
    Cycle cycle;
    
    public SMTProgramGenerator(
        final Cycle r_cycle
    ) throws Exception {
        if( r_cycle == null ) throw new Exception();
        cycle = r_cycle;
    }

    public String generate_program()
    throws Exception {
        StringBuilder sb = new StringBuilder();

        for( final Relation relation : cycle.relations ) {
            switch( relation.type ) {
                case po:
                case rf:
                case co:
                case fr:
                    sb.append( relation + "\n" );
                    break;

                default:
                    throw new Exception( "Undefined relation type in cycle." );
            }
        }

        return sb.toString();
    }

}
