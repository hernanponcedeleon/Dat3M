package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;

// A default implementation for any encoded set, e.g. base sets or non-base but cut sets.
public class DynamicDefaultWMMSet extends MaterializedWMMSet {

    private final Relation relation;

    public DynamicDefaultWMMSet(Relation predicate) {
        this.relation = Relation.checkIsSet(predicate);
    }

    @Override
    public void repopulate() {
        // Careful: The wrapped model <getModel> might get closed/disposed while ExecutionModel as a whole is
        // still in use. The caller should make sure that the underlying model is still alive right now.
        final EncodingContext ctx = model.getContext();
        final IREvaluator m = new IREvaluator(ctx, model.getModel());
        final EncodingContext.EdgeEncoder edge = ctx.edge(relation);
        final RelationAnalysis.Knowledge k = ctx.getAnalysisContext().get(RelationAnalysis.class).getKnowledge(relation);

        if (k.getMaySet().size() < domain.size()) {
            k.getMaySet().apply((e1, e2) -> {
                final EventData d1 = !e1.equals(e2) ? null : model.getData(e1).orElse(null);
                final Element e = d1 == null ? null : getElementFromEventData(edge, d1, m);
                if (e != null) {
                    simpleSet.add(e);
                }
            });
        } else {
            for (EventData e1 : model.getEventList()) {
                final Element e = getElementFromEventData(edge, e1, m);
                if (e != null) {
                    simpleSet.add(e);
                }
            }
        }
    }

    private Element getElementFromEventData(EncodingContext.EdgeEncoder edge, EventData e1, IREvaluator m) {
        return m.hasElement(edge, e1.getEvent()) ? new Element(e1.getId()) : null;
    }
}