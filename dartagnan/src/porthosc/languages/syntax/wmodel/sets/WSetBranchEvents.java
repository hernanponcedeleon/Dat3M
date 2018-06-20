package porthosc.languages.syntax.wmodel.sets;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;


public class WSetBranchEvents extends WSetBase<XComputationEvent> implements WSetAnnotableEvents {

    public WSetBranchEvents(Origin origin, ImmutableSet<XComputationEvent> values) {
        super(origin, values);
    }

    @Override
    public <S> S accept(WmodelVisitor<S> visitor) {
        return visitor.visit(this);
    }
}
