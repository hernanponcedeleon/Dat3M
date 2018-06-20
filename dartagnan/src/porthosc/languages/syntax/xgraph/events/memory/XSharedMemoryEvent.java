package porthosc.languages.syntax.xgraph.events.memory;


import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;


public interface XSharedMemoryEvent extends XMemoryEvent {

    XSharedLvalueMemoryUnit getLoc();

    //@Override
    XLocalMemoryUnit getReg();
}
