package porthosc.languages.syntax.xgraph.events.computation;

import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XRvalueMemoryUnit;


public interface XComputationEvent extends XEvent, XLocalMemoryUnit, XRvalueMemoryUnit {

}
