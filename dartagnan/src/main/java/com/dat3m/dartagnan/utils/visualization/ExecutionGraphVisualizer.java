package com.dat3m.dartagnan.utils.visualization;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.io.Writer;
import java.math.BigInteger;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

/*
    This is some rudimentary class to create graphs of executions
 */
public class ExecutionGraphVisualizer {

    private final Graphviz graphviz;
    private BiPredicate<EventData, EventData> rfFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> coFilter = (x, y) -> true;

    public ExecutionGraphVisualizer() {
        graphviz = new Graphviz();
    }

    public ExecutionGraphVisualizer setReadFromFilter(BiPredicate<EventData, EventData> filter) {
        this.rfFilter = filter;
        return this;
    }

    public ExecutionGraphVisualizer setCoherenceFilter(BiPredicate<EventData, EventData> filter) {
        this.coFilter = filter;
        return this;
    }

    public void generateGraphOfExecutionModel(Writer writer, String graphName, ExecutionModel model) {
        graphviz.begin(graphName);
        graphviz.append(String.format("label=\"%s\" \n", graphName));
        addAllThreads(model);
        addReadFrom(model);
        addCoherence(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private boolean ignore(EventData e) {
        return e.getEvent().getCLine() == -1 && !e.isInit();
    }


    private ExecutionGraphVisualizer addReadFrom(ExecutionModel model) {

        graphviz.beginSubgraph("ReadFrom");
        graphviz.setEdgeAttributes("color=green"/*, "constraint=false"*/);
        for (Map.Entry<EventData, EventData> rw : model.getReadWriteMap().entrySet()) {
            EventData r = rw.getKey();
            EventData w = rw.getValue();

            if (ignore(r) || ignore(w) || !rfFilter.test(w, r)) {
                continue;
            }

            appendEdge(w, r, model, "label=rf");
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addCoherence(ExecutionModel model) {

        Map<EventData, Set<EventData>> coMap = model.getCoherenceMap();
        DependencyGraph<EventData> coGraph = DependencyGraph.from(coMap.keySet(), coMap);

        List<EventData> events = coGraph.getSCCs().stream().map(scc -> scc.stream().findAny().get().getContent()).collect(Collectors.toList());
        Collections.reverse(events);


        graphviz.beginSubgraph("Coherence");
        graphviz.setEdgeAttributes("color=red"/*, "constraint=false"*/);

        for (BigInteger addr : model.getAddressWritesMap().keySet()) {
            List<EventData> sameAddrWrites = events.stream().filter(e -> e.getAccessedAddress().equals(addr)).collect(Collectors.toList());
            for (int i = 2; i < sameAddrWrites.size(); i++) {
                // We skip the init writes
                EventData w1 = sameAddrWrites.get(i - 1);
                EventData w2 = sameAddrWrites.get(i);
                if (ignore(w1) || ignore(w2) || !coFilter.test(w1, w2)) {
                    continue;
                }
                appendEdge(w1, w2, model, "label=co");
            }
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addAllThreads(ExecutionModel model) {
        for (Thread thread : model.getThreads()) {
            if (thread.getId() <= 1) {
                continue;
            }
            addThreadPo(thread, model);
        }
        return this;
    }

    private ExecutionGraphVisualizer addThreadPo(Thread thread, ExecutionModel model) {
        List<EventData> threadEvents = model.getThreadEventsMap().get(thread);
        if (threadEvents.size() <= 1) {
            return this;
        }

        // --- Subgraph start ---
        graphviz.beginSubgraph("T" + thread.getId());
        graphviz.setEdgeAttributes("weight=10");
        // --- Node list ---
        for (int i = 1; i < threadEvents.size(); i++) {
            EventData e1 = threadEvents.get(i - 1);
            EventData e2 = threadEvents.get(i);

            if (ignore(e1) || ignore(e2)) {
                continue;
            }

            if (e1.getEvent().getCLine() != e2.getEvent().getCLine()) {
                appendEdge(e1, e2, model, (String[]) null);
            }
        }

        // --- Subgraph end ---
        graphviz.end();

        return this;
    }



    private String eventToNode(EventData e, ExecutionModel model) {
        if (e.isInit()) {
            return "init";
        } else if (e.getEvent().getCLine() == -1) {
            // Special write of each thread
            int threadSize = model.getThreadEventsMap().get(e.getThread()).size();
            if (e.getLocalId() <= threadSize / 2) {
                return String.format("\"T%d:start\"", e.getThread().getId());
            } else {
                return String.format("\"T%d:end\"", e.getThread().getId());
            }
        }
        return String.format("\"T%d:%d\"", e.getThread().getId(), e.getEvent().getCLine());
    }

    private void appendEdge(EventData a, EventData b, ExecutionModel model, String... options) {
        graphviz.addEdge(eventToNode(a, model), eventToNode(b, model), options);
    }
}
