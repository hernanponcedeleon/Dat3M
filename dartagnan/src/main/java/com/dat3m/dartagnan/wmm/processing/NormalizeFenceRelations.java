package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.Composition;
import com.dat3m.dartagnan.wmm.definition.Fences;
import com.dat3m.dartagnan.wmm.definition.SetIdentity;

import java.util.List;

/*
    This pass replaces "fencerel(F)" by "po;[F];po"
 */
public class NormalizeFenceRelations implements WmmProcessor {

    private NormalizeFenceRelations() {
    }

    public static NormalizeFenceRelations newInstance() {
        return new NormalizeFenceRelations();
    }

    @Override
    public void run(Wmm wmm) {
        final Relation po = wmm.getRelation(RelationNameRepository.PO);

        for (Relation rel : List.copyOf(wmm.getRelations())) {
            if (rel.getDefinition() instanceof Fences fence) {
                final Relation fenceId = wmm.addDefinition(new SetIdentity(wmm.newRelation(), fence.getFilter()));
                final Relation intermediate = wmm.addDefinition(new Composition(wmm.newRelation(), po, fenceId));
                wmm.removeDefinition(rel);
                wmm.addDefinition(new Composition(rel, intermediate, po));
            }
        }
    }
}
