package porthosc.languages.syntax.wmodel.sets;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.syntax.wmodel.WElement;
import porthosc.languages.syntax.xgraph.events.XEvent;


public interface WSet<T extends XEvent> extends WElement {

    ImmutableSet<T> getValues();
}
