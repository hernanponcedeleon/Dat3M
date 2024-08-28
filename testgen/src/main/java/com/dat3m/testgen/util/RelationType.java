package com.dat3m.testgen.util;

public class RelationType {
    
    public enum base_relation {
        undefined,
        co,
        ext,
        po,
        rf,
        rmw,
    };

    public base_relation type;
    public boolean is_inverse;

    public RelationType(
        final base_relation r_type,
        final boolean r_is_inverse
    ) {
        type = r_type;
        is_inverse = r_is_inverse;
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
