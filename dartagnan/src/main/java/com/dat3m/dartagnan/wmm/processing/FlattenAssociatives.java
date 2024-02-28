package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.Intersection;
import com.dat3m.dartagnan.wmm.definition.Union;

import java.util.List;
import java.util.function.BiFunction;
import java.util.stream.Stream;

// Flattens nested binary unions/intersections into n-ary ones.
public class FlattenAssociatives implements WmmProcessor {

    private FlattenAssociatives() {
    }

    public static FlattenAssociatives newInstance() {
        return new FlattenAssociatives();
    }

    @Override
    public void run(Wmm wmm) {
        flattenAssociatives(wmm, Union.class, Union::new);
        flattenAssociatives(wmm, Intersection.class, Intersection::new);
    }

    private void flattenAssociatives(Wmm wmm,
                                     Class<? extends Definition> cls,
                                     BiFunction<Relation, Relation[], Definition> constructor
    ) {
        final List<Relation> relations = List.copyOf(wmm.getRelations());
        final List<Constraint> constraints = wmm.getConstraints().stream()
                .filter(c -> !(c instanceof Definition)).toList();

        for (Relation r : relations) {
            if (r.hasName() || !cls.isInstance(r.getDefinition())
                    || constraints.stream().anyMatch(c -> c.getConstrainedRelations().contains(r))) {
                continue;
            }
            final List<Relation> dependents = relations.stream().filter(x -> x.getDependencies().contains(r)).toList();
            final Relation p = (dependents.size() == 1 ? dependents.get(0) : null);
            if (p != null && cls.isInstance(p.getDefinition())) {
                final Relation[] o = Stream.of(r, p)
                        .flatMap(x -> x.getDependencies().stream())
                        .filter(x -> !r.equals(x))
                        .distinct()
                        .toArray(Relation[]::new);
                wmm.removeDefinition(p);
                wmm.addDefinition(constructor.apply(p, o));
                wmm.removeDefinition(r);
                wmm.deleteRelation(r);
            }
        }
    }

}
