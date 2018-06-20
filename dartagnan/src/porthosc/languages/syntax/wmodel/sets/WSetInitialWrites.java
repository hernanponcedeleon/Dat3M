package porthosc.languages.syntax.wmodel.sets;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;
import porthosc.languages.syntax.xgraph.events.memory.XInitialWriteEvent;


public class WSetInitialWrites extends WSetBase<XInitialWriteEvent> {

    public WSetInitialWrites(Origin origin, ImmutableSet<XInitialWriteEvent> values) {
        super(origin, values);
    }

    @Override
    public <S> S accept(WmodelVisitor<S> visitor) {
        return visitor.visit(this);
    }
}
