package com.dat3m.testgen.old.cycle_gen;

/**
 * Represents information regarding all the possible relations between events.
 */
public class GrammarRelationType {
    
    public enum base_relation {
        undefined,
        po,
        rf,
        co
    };

    public final base_relation type;
    public final boolean is_inverse;

    public GrammarRelationType(
        final base_relation r_type,
        final boolean r_is_inverse
    ) {
        type = r_type;
        is_inverse = r_is_inverse;
    }

    public GrammarRelationType(
        final String str_relation
    ) throws Exception {
        switch( str_relation ) {
            case "po":
                type = base_relation.po;
                is_inverse = false;
                break;
            
            case "co":
                type = base_relation.co;
                is_inverse = false;
                break;

            case "rf":
                type = base_relation.rf;
                is_inverse = false;
                break;

            case "rf_inv":
                type = base_relation.rf;
                is_inverse = true;
                break;

            default:
                throw new Exception( "Unknown relation string type generated from Grammar class." );
        }
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( type );
        if( is_inverse )
            sb.append( "^(-1)" );
        return sb.toString();
    }

}
