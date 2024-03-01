package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.SetIdentity;

// Add empty(UR;loc;[IW]) to enforce that initial writes are read if available.
public class AddInitReadHandling implements WmmProcessor {

    private AddInitReadHandling() {}

    public static AddInitReadHandling newInstance() {
        return new AddInitReadHandling();
    }

    @Override
    public void run(Wmm mm) {
        final Relation ur = mm.getOrCreatePredefinedRelation(RelationNameRepository.UR);
        final Relation loc = mm.getOrCreatePredefinedRelation(RelationNameRepository.LOC);
        final Relation iw = mm.addDefinition(new SetIdentity(mm.newRelation(), mm.getFilter(Tag.INIT)));
        final Relation lociw = mm.addDefinition(new Composition(mm.newRelation(), loc, iw));
        final Relation urlociw = mm.addDefinition(new Composition(mm.newRelation(), ur, lociw));
        mm.addConstraint(new Emptiness(urlociw));

    }
}
