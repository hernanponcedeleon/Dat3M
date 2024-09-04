package com.dat3m.testgen.util;

import com.dat3m.dartagnan.wmm.Relation;

public class RelationEdge {
    
    public final int eid_L;
    public final Relation relation;
    public final int eid_R;
    public final BaseRelations.type base;

    public RelationEdge(
        final int r_event_id_left,
        final Relation r_dat3m_relation,
        final int r_event_id_right,
        final BaseRelations.type r_base_relation
    ) {
        eid_L    = r_event_id_left;
        relation = r_dat3m_relation;
        eid_R    = r_event_id_right;
        base     = r_base_relation;
    }

    @Override
    public String toString()
    {
        StringBuilder sb = new StringBuilder();
        sb.append( eid_L + " --" + base + "-> " + eid_R );
        return sb.toString();
    }

}
