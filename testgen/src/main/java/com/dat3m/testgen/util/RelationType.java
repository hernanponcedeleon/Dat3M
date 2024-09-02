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

    public RelationType(
        final base_relation r_type
    ) {
        type = r_type;
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( type );
        return sb.toString();
    }

}
