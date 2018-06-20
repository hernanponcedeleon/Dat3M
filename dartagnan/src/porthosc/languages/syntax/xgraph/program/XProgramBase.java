package porthosc.languages.syntax.xgraph.program;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.graph.FlowGraph;
import porthosc.languages.common.graph.FlowTree;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.barrier.XBarrierEvent;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.memory.*;
import porthosc.languages.syntax.xgraph.process.XProcess;
import porthosc.languages.syntax.xgraph.process.XProcessId;


public abstract class XProgramBase <P extends FlowGraph<XEvent>>
        extends FlowTree<XEvent, P> {

    //private final XPreProcess prelude;
    //private final XPostProcess postlude;

    // memoised subsets
    private ImmutableSet<XEvent> allEvents;
    private ImmutableSet<XEntryEvent> entryEvents;
    private ImmutableSet<XMemoryEvent> memoryEvents;
        private ImmutableSet<XSharedMemoryEvent> storeAndInitEvents;
        private ImmutableSet<XLocalMemoryEvent> localMemoryEvents;
        private ImmutableSet<XSharedMemoryEvent> sharedMemoryEvents;
            private ImmutableSet<XLoadMemoryEvent> loadMemoryEvents;
            private ImmutableSet<XStoreMemoryEvent> storeMemoryEvents;
    private ImmutableSet<XBarrierEvent> barrierEvents;
    private ImmutableSet<XComputationEvent> computationEvents;


    XProgramBase(ImmutableList<P> processes) {
        //this.prelude = prelude;
        //this.postlude = postlude;
        super(processes);
    }

    public ImmutableList<P> getProcesses() {
        return getGraphs();
    }

    // TODO
    //public ImmutableList<P> getProcess(XProcessId processId) {
    //    for (P process : getProcesses()) {
    //
    //    }
    //}

    public ImmutableSet<XEntryEvent> getEntryEvents() {
        // TODO: just collect source() events here
        ImmutableSet.Builder<XEntryEvent> builder = new ImmutableSet.Builder<>();
        for (P process : getProcesses()) {
            builder.add((XEntryEvent) process.source()); //TODO: after merging XProcess && XUnrolledProcess, remove this cast
        }
        return builder.build();
    }

    public ImmutableSet<XEvent> getAllEvents() {
        return allEvents != null
                ? allEvents
                : (allEvents = getAllNodesExceptSource(XEvent.class));
    }

    public ImmutableSet<XMemoryEvent> getMemoryEvents() {
        return memoryEvents != null
                ? memoryEvents
                : (memoryEvents = getAllNodesExceptSource(XMemoryEvent.class));
    }

    public ImmutableSet<XSharedMemoryEvent> getStoreAndInitEvents() {
        return storeAndInitEvents != null
                ? storeAndInitEvents
                : (storeAndInitEvents = buildStoreAndInitEvents());
    }

    public ImmutableSet<XSharedMemoryEvent> getSharedMemoryEvents() {
        return sharedMemoryEvents != null
                ? sharedMemoryEvents
                : (sharedMemoryEvents = getAllNodesExceptSource(XSharedMemoryEvent.class));
    }

    public ImmutableSet<XLocalMemoryEvent> getLocalMemoryEvents() {
        return localMemoryEvents != null
                ? localMemoryEvents
                : (localMemoryEvents = getAllNodesExceptSource(XLocalMemoryEvent.class));
    }

    public ImmutableSet<XLoadMemoryEvent> getLoadMemoryEvents() {
        return loadMemoryEvents != null
                ? loadMemoryEvents
                : (loadMemoryEvents = getAllNodesExceptSource(XLoadMemoryEvent.class));
    }

    public ImmutableSet<XStoreMemoryEvent> getStoreMemoryEvents() {
        return storeMemoryEvents != null
                ? storeMemoryEvents
                : (storeMemoryEvents = getAllNodesExceptSource(XStoreMemoryEvent.class));
    }

    public ImmutableSet<XComputationEvent> getComputationEvents() {
        return computationEvents != null
                ? computationEvents
                : (computationEvents = getAllNodesExceptSource(XComputationEvent.class));
    }

    public ImmutableSet<XBarrierEvent> getBarrierEvents() {
        return barrierEvents != null
                ? barrierEvents
                : (barrierEvents = getAllNodesExceptSource(XBarrierEvent.class));
    }

    public int getEdgesCount(boolean sign) {
        int result = 0;
        for (P process : getProcesses()) {
            result += process.getEdges(sign).size();
        }
        return result;
    }

    public int size() {
        int result = 0;
        for (P process : getProcesses()) {
            result += process.size();
        }
        return result;
    }

    private <S extends XEvent> ImmutableSet<S> getAllNodesExceptSource(Class<S> type) {
        ImmutableSet.Builder<S> builder = new ImmutableSet.Builder<>();
        for (P process : getProcesses()) {
            for (XEvent event : process.getAllNodesExceptSource()) {
                if (type.isInstance(event)) {
                    builder.add(type.cast(event));
                }
            }
        }
        return builder.build();
    }

    private ImmutableSet<XSharedMemoryEvent> buildStoreAndInitEvents() {
        ImmutableSet.Builder<XSharedMemoryEvent> builder = new ImmutableSet.Builder<>();
        for (P process : getProcesses()) {
            if (((XProcess) process).getId() == XProcessId.PreludeProcessId) {
                for (XEvent node : process.getAllNodesExceptSource()) {
                    if (node instanceof XSharedMemoryEvent) {
                        builder.add((XSharedMemoryEvent) node);
                    }
                }
            }
            else {
                for (XEvent event : process.getAllNodesExceptSource()) {
                    if (event instanceof XStoreMemoryEvent) {
                        builder.add((XStoreMemoryEvent) event);
                    }
                }
            }
        }
        return builder.build();
    }
}