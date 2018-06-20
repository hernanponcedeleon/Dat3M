package porthosc.languages.syntax.wmodel.relations;

import com.google.common.collect.ImmutableMap;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;
import porthosc.languages.syntax.xgraph.events.XEvent;


public class WRelationReadFrom extends WRelationBase implements WRelationStatic {

    public WRelationReadFrom(Origin origin, ImmutableMap<XEvent, XEvent> values) {
        super(origin, "rf", false, values);
    }

    @Override
    public <T> T accept(WmodelVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
