package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Difference;
import com.dat3m.dartagnan.wmm.definition.RangeIdentity;
import com.dat3m.dartagnan.wmm.definition.SetIdentity;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.LOC;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;


// Add empty (([R] \ [range(rf)]);loc;[IW]) to enforce that reads from uninitialized memory
// are impossible if an init write exists.
public class AddInitReadHandling implements WmmProcessor {

    private AddInitReadHandling() {}

    public static AddInitReadHandling newInstance() {
        return new AddInitReadHandling();
    }

    @Override
    public void run(Wmm mm) {
        final Relation reads = mm.addDefinition(new SetIdentity(mm.newRelation(), mm.getFilter(Tag.READ)));
        final Relation rfRange = mm.addDefinition(new RangeIdentity(mm.newRelation(), mm.getOrCreatePredefinedRelation(RF)));
        final Relation loc = mm.getOrCreatePredefinedRelation(LOC);
        final Relation iw = mm.addDefinition(new SetIdentity(mm.newRelation(), mm.getFilter(Tag.INIT)));
        final Relation ur = mm.addDefinition(new Difference(mm.newRelation(), reads, rfRange));
        final Relation urloc = mm.addDefinition(new Composition(mm.newRelation(), ur, loc));
        final Relation urlociw = mm.addDefinition(new Composition(mm.newRelation(), urloc, iw));

        mm.addConstraint(new Emptiness(urlociw));
    }
}
