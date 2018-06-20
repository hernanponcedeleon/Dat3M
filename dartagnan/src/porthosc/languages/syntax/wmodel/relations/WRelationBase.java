package porthosc.languages.syntax.wmodel.relations;

import com.google.common.collect.ImmutableMap;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.WElementBase;
import porthosc.languages.syntax.xgraph.events.XEvent;


public abstract class WRelationBase extends WElementBase {

    private final ImmutableMap<XEvent, XEvent> values;

    WRelationBase(Origin origin,
                  String name,
                  boolean containsRecursion,
                  ImmutableMap<XEvent, XEvent> values) {
        super(origin, containsRecursion);
        this.values = values;
    }

    public ImmutableMap<XEvent, XEvent> getValues() {
        return values;
    }
}
