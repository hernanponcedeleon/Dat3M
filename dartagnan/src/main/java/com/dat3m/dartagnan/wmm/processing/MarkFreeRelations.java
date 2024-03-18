package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.Free;

/*
    This pass makes sure that differently freely defined relations have different names, in particular,
    unnamed relations will get a dummy name.
    This makes sure that we generate different encoding variables for different relations
    (there is no name collision).

    NOTE: We could generalize this pass to give distinguishing names to any pair of different relations
    if they are unnamed but have the same term. However, this is should only happen to free relations right now.
 */
public class MarkFreeRelations implements WmmProcessor {

    private MarkFreeRelations() {
    }

    public static MarkFreeRelations newInstance() {
        return new MarkFreeRelations();
    }

    @Override
    public void run(Wmm wmm) {
        int counter = 0;
        for (Relation rel : wmm.getRelations()) {
            if (rel.getDefinition() instanceof Free && !rel.hasName()) {
                wmm.addAlias("free#" + counter, rel);
                counter++;
            }
        }
    }
}
