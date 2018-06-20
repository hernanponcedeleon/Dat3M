package porthosc.languages.syntax.xgraph.events.memory;

import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.memories.XMemoryUnit;


public interface XMemoryEvent extends XEvent {

    XMemoryUnit getSource();

    XMemoryUnit getDestination();

    //XLocalMemoryUnit getReg();
}
