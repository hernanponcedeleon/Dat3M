package porthosc.languages.syntax.wmodel.sets;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;
import porthosc.languages.syntax.xgraph.events.memory.XMemoryEvent;


public class WSetMemoryEvents extends WSetBase<XMemoryEvent> implements WSetAnnotableEvents {

    public WSetMemoryEvents(Origin origin, ImmutableSet<XMemoryEvent> values) {
        super(origin, values);
    }

    @Override
    public <S> S accept(WmodelVisitor<S> visitor) {
        return visitor.visit(this);
    }
}
