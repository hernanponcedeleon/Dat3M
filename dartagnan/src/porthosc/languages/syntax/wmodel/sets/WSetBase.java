package porthosc.languages.syntax.wmodel.sets;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.WElementBase;
import porthosc.languages.syntax.xgraph.events.XEvent;


public abstract class WSetBase<T extends XEvent> extends WElementBase implements WSet<T> {

    private final ImmutableSet<T> values;

    WSetBase(Origin origin, ImmutableSet<T> values) {
        super(origin, false);
        this.values = values;
    }

    @Override
    public ImmutableSet<T> getValues() {
        return values;
    }
}
