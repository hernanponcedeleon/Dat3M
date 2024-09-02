package com.dat3m.dartagnan.wmm.definition;

import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

//TODO: This relation may contain non-visible events. Is this reasonable?
public class SetIdentity extends Definition {

    private final Filter filter;

    public SetIdentity(Relation r0, Filter s1) {
        super(r0, "[" + s1 + "]");
        filter = s1;
    }

    public Filter getFilter() {
        return filter;
    }

    @Override
    public SetIdentity updateComponents(Wmm wmm, Object oldObj, Object newObj) {
        Filter newFilter = oldObj == filter ? (Filter) newObj : filter;
        if (newFilter != filter) {
            SetIdentity newSetIdentity = new SetIdentity(wmm.newRelation(), newFilter);
            wmm.addDefinition(newSetIdentity);
            return newSetIdentity;
        } else {
            return this;
        }
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitSetIdentity(this);
    }
}
