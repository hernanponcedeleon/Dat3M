package com.dat3m.testgen.util;

public class RelationType {
    
    enum base_relation {
        undefined,
        co,
        ext,
        po,
        rf,
        rmw,
    };

    final base_relation type;
    final boolean is_inverse;

    public RelationType(
        final base_relation r_type,
        final boolean r_is_inverse
    ) {
        type = r_type;
        is_inverse = r_is_inverse;
    }

    public RelationType(
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
            case "rf_inv":
                type = base_relation.rf;
                is_inverse = str_relation.equals( "rf_inv" );
                break;
            case "ext":
                type = base_relation.ext;
                is_inverse = false;
                break;
            case "rmw":
                type = base_relation.rmw;
                is_inverse = false;
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
