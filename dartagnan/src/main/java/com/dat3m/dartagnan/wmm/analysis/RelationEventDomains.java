package com.dat3m.dartagnan.wmm.analysis;

import com.dat3m.dartagnan.program.analysis.EventDomainRepository;
import com.dat3m.dartagnan.program.analysis.EventDomainRepository.DomainBound;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.filter.TagFilter;
import com.dat3m.dartagnan.utils.collections.IndexedDomain;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.wmm.Constraint;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.IndexedEventGraph;

import java.util.*;

import static com.dat3m.dartagnan.program.event.Tag.*;
import static java.util.Collections.disjoint;

// Estimates boundaries for the domains and ranges of relations.
// This analysis is used by NativeRelationAnalysis, where bit vectors are used as a compact representation.
// Because invisible events are sparsely used there, the bit vectors only index visible events.
// For the remaining sets, a different representation has to be used, e.g. HashSet.
// This analysis describes where that compact representation could not fit.
public final class RelationEventDomains {

    private final EventDomainRepository repository;
    private final Set<Relation> relationsWithInvisibleDomain = new HashSet<>();
    private final Set<Relation> relationsWithInvisibleRange = new HashSet<>();

    private RelationEventDomains(EventDomainRepository r) {
        repository = r;
    }

    public static RelationEventDomains newInstance(Wmm memoryModel, Context analyses) {
        final EventDomainRepository repository = analyses.requires(EventDomainRepository.class);
        final var analysis = new RelationEventDomains(repository);
        analysis.run(memoryModel);
        return analysis;
    }

    public IndexedEventGraph newGraph(Relation relation) {
        final DomainBound domainBound = getBound(relation, relationsWithInvisibleDomain);
        final DomainBound rangeBound = getBound(relation, relationsWithInvisibleRange);
        return new IndexedEventGraph(repository.getDomain(domainBound), repository.getDomain(rangeBound));
    }

    public IndexedDomain<Event> smallestDomain(Relation relation) {
        final DomainBound domainBound = getBound(relation, relationsWithInvisibleDomain);
        final DomainBound rangeBound = getBound(relation, relationsWithInvisibleRange);
        return repository.getDomain(domainBound.compareTo(rangeBound) > 0 ? domainBound : rangeBound);
    }

    private DomainBound getBound(Relation relation, Set<Relation> invisibleSet) {
        return invisibleSet.contains(relation) ? DomainBound.ALL : DomainBound.VISIBLE;
    }

    private void run(Wmm memoryModel) {
        DependencyGraph.from(memoryModel.getRelations()).getSCCs().forEach(this::run);
    }

    private void run(Set<DependencyGraph<Relation>.Node> scc) {
        boolean changed = true;
        while (changed) {
            changed = false;
            for (DependencyGraph<Relation>.Node node : scc) {
                final Relation relation = node.getContent();
                final Result result = relation.getDefinition().accept(new Inspector());
                changed |= ((result == Result.NY || result == Result.YY) && relationsWithInvisibleRange.add(relation));
                changed |= ((result == Result.YN || result == Result.YY) && relationsWithInvisibleDomain.add(relation));
            }
        }
    }

    private final class Inspector implements Constraint.Visitor<Result> {
        private Inspector() {}
        @Override
        public Result visitConstraint(Constraint constraint) { return Result.NN; }
        @Override
        public Result visitInternalDataDependency(DirectDataDependency idd) { return Result.YY; }
        @Override
        public Result visitAddressDependency(DirectAddressDependency addr) { return Result.YN; }
        @Override
        public Result visitControlDependency(DirectControlDependency ctrl) { return Result.YY; }
        @Override
        public Result visitProgramOrder(ProgramOrder po) {
            // This could be more accurate.
            return re(!(po.getFilter() instanceof TagFilter) || isInvisibleTag(po.getFilter().toString()));
        }
        @Override
        public Result visitProjection(Projection proj) {
            final Set<Relation> relations = switch (proj.getDimension()) {
                case DOMAIN -> relationsWithInvisibleDomain;
                case RANGE -> relationsWithInvisibleRange;
            };
            return re(relations.contains(proj.getOperand()));
        }
        @Override
        public Result visitTagSet(TagSet tag) {
            return re(isInvisibleTag(tag.getTag()));
        }
        @Override
        public Result visitSetIdentity(SetIdentity id) {
            // Sets / unary relations will be contained in both sets or none.
            return re(relationsWithInvisibleDomain.contains(id.getDomain()));
        }
        @Override
        public Result visitProduct(CartesianProduct prod) {
            final boolean invisibleDomain = relationsWithInvisibleDomain.contains(prod.getDomain());
            final boolean invisibleRange = relationsWithInvisibleDomain.contains(prod.getRange());
            return re(invisibleDomain, invisibleRange);
        }
        @Override
        public Result visitUnion(Union union) {
            final Collection<Relation> ops = union.getOperands();
            return re(!disjoint(relationsWithInvisibleDomain, ops), !disjoint(relationsWithInvisibleRange, ops));
        }
        @Override
        public Result visitIntersection(Intersection intersection) {
            final Collection<Relation> ops = intersection.getOperands();
            return re(relationsWithInvisibleDomain.containsAll(ops), relationsWithInvisibleRange.containsAll(ops));
        }
        @Override
        public Result visitComposition(Composition comp) {
            final boolean invisibleDomain = relationsWithInvisibleDomain.contains(comp.getLeftOperand());
            final boolean invisibleRange = relationsWithInvisibleRange.contains(comp.getRightOperand());
            return re(invisibleDomain, invisibleRange);
        }
        @Override
        public Result visitInverse(Inverse inv) {
            final Relation op = inv.getOperand();
            return re(relationsWithInvisibleRange.contains(op), relationsWithInvisibleDomain.contains(op));
        }
        @Override
        public Result visitTransitiveClosure(TransitiveClosure trans) {
            final Relation op = trans.getOperand();
            return re(relationsWithInvisibleDomain.contains(op), relationsWithInvisibleRange.contains(op));
        }
        private Result re(boolean invisibleDomainAndRange) {
            return invisibleDomainAndRange ? Result.YY : Result.NN;
        }
        private Result re(boolean invisibleDomain, boolean invisibleRange) {
            return invisibleDomain ? invisibleRange ? Result.YY : Result.YN : invisibleRange ? Result.NY : Result.NN;
        }
    }

    private enum Result { NN, NY, YN, YY }

    private boolean isInvisibleTag(String tag) {
        return switch (tag) {
            case VISIBLE, MEMORY, READ, WRITE, FENCE, INIT, Vulkan.CBAR, Vulkan.AVDEVICE, Vulkan.VISDEVICE -> false;
            default -> true;
        };
    }
}
