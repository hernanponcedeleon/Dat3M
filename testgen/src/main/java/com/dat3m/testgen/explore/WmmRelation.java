package com.dat3m.testgen.explore;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.testgen.util.RelationType;

public class WmmRelation {
    
    final int event_id_left;
    final Relation dat3m_relation;
    final int event_id_right;
    final boolean is_base_relation;
    final RelationType base_relation;

    WmmRelation(
        final int r_event_id_left,
        final Relation r_dat3m_relation,
        final int r_event_id_right,
        final boolean r_is_base_relation,
        final RelationType r_base_relation
    ) {
        event_id_left    = r_event_id_left;
        dat3m_relation   = r_dat3m_relation;
        event_id_right   = r_event_id_right;
        is_base_relation = r_is_base_relation;
        base_relation    = r_base_relation;
    }

    @Override
    public String toString()
    {
        final StringBuilder sb = new StringBuilder();
        sb.append( event_id_left + " --" + base_relation + "-> " + event_id_right );
        return sb.toString();
    }

    String toStringDetailed()
    {
        final StringBuilder sb = new StringBuilder();
        sb.append( event_id_left + " --" + dat3m_relation.getDefinition() + "-> " + event_id_right );
        if( is_base_relation )
            sb.append( " [" + base_relation + "]" );
        return sb.toString();
    }

}
