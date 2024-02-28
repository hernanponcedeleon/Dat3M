package com.dat3m.dartagnan.wmm.processing;

import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

// A relation is considered "dead" if it does not (directly or indirectly) contribute to a
// non-defining constraint. Such relations (and their defining constraints) can safely be deleted
// without changing the semantics of the memory model.
public class RemoveDeadRelations implements WmmProcessor {

    private RemoveDeadRelations() {

    }
    public static RemoveDeadRelations newInstance() {
        return new RemoveDeadRelations();
    }

    @Override
    public void run(Wmm memoryModel) {
        final List<Constraint> constraints = List.copyOf(memoryModel.getConstraints());
        final DependencyCollector collector = new DependencyCollector();
        constraints.stream().filter(c -> !(c instanceof Definition)).forEach(c -> c.accept(collector));
        final Set<Relation> relevantRelations = new HashSet<>(collector.collectedRelations);
        Wmm.ANARCHIC_CORE_RELATIONS.forEach(n -> relevantRelations.add(memoryModel.getRelation(n)));

        constraints.stream()
                .filter(c -> !relevantRelations.containsAll(c.getConstrainedRelations()))
                .forEach(memoryModel::removeConstraint);
        List.copyOf(memoryModel.getRelations())
                .stream().filter(r -> !relevantRelations.contains(r))
                .forEach(memoryModel::deleteRelation);
    }

    private final static class DependencyCollector implements Constraint.Visitor<Void> {
        private final Set<Relation> collectedRelations = new HashSet<>();
        @Override
        public Void visitConstraint(Constraint constraint) {
            for (Relation rel : constraint.getConstrainedRelations()) {
                if (collectedRelations.add(rel)) {
                    rel.getDefinition().accept(this);
                }
            }
            return null;
        }
    }
}
