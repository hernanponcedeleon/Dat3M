package porthosc.languages.syntax.wmodel.relations;

import com.google.common.collect.ImmutableMap;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;
import porthosc.languages.syntax.xgraph.events.XEvent;


public class WRelationProgramOrder extends WRelationBase implements WRelationStatic {

    public WRelationProgramOrder(Origin origin, ImmutableMap<XEvent, XEvent> values) {
        super(origin, "po", false, values);
    }

    @Override
    public <T> T accept(WmodelVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
