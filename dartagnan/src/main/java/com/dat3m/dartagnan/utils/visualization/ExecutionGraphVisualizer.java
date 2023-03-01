package com.dat3m.dartagnan.utils.visualization;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

/*
    This is some rudimentary class to create graphs of executions.
    Currently, it just creates very special graphs.
 */
public class ExecutionGraphVisualizer {

    private static final Logger logger = LogManager.getLogger(ExecutionGraphVisualizer.class);
	
    private final Graphviz graphviz;
    private Map<Event, String> callStackMapping;
    // By default we do not filter anything
    private BiPredicate<EventData, EventData> rfFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> frFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> coFilter = (x, y) -> true;
    private Map<BigInteger, IExpr> addresses = new HashMap<BigInteger, IExpr>();

    public ExecutionGraphVisualizer() {
        this.graphviz = new Graphviz();
    }

    public ExecutionGraphVisualizer setCallStackMapping(Map<Event, String> callStackMapping) {
        this.callStackMapping = callStackMapping;
        return this;
    }

    public ExecutionGraphVisualizer setReadFromFilter(BiPredicate<EventData, EventData> filter) {
        this.rfFilter = filter;
        return this;
    }

    public ExecutionGraphVisualizer setFromReadFilter(BiPredicate<EventData, EventData> filter) {
        this.frFilter = filter;
        return this;
    }

    public ExecutionGraphVisualizer setCoherenceFilter(BiPredicate<EventData, EventData> filter) {
        this.coFilter = filter;
        return this;
    }

    public void generateGraphOfExecutionModel(Writer writer, String graphName, ExecutionModel model) throws IOException {
        for(EventData data : model.getThreadEventsMap().values().stream()
                .collect(ArrayList<EventData>::new, List::addAll, List::addAll)) {
        	if(data.isMemoryEvent()) {
        		MemEvent m = (MemEvent)data.getEvent();
        		if(!(m.getAddress() instanceof Register)) {
                	addresses.putIfAbsent(data.getAccessedAddress(), m.getAddress());            			
        		}
        	}
        }
        graphviz.begin(graphName);
        graphviz.append(String.format("label=\"%s\" \n", graphName));
        addAllThreadPos(model);
        addReadFrom(model);
        addFromRead(model);
        addCoherence(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private boolean ignore(EventData e) {
        return e.getEvent().getCLine() == -1 && !e.isInit();
    }


    private ExecutionGraphVisualizer addReadFrom(ExecutionModel model) {

        graphviz.beginSubgraph("ReadFrom");
        graphviz.setEdgeAttributes("color=green");
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

    private ExecutionGraphVisualizer addFromRead(ExecutionModel model) {

        graphviz.beginSubgraph("FromRead");
        graphviz.setEdgeAttributes("color=orange");
        for (Map.Entry<EventData, EventData> rw : model.getReadWriteMap().entrySet()) {
            EventData r = rw.getKey();
            EventData w = rw.getValue();

            if (ignore(r) || ignore(w)) {
                continue;
            }

            List<EventData> co = model.getCoherenceMap().get(w.getAccessedAddress());
            // Check if exists w2 : co(w, w2)
            if(co.indexOf(w) + 1 < co.size()) {
                EventData w2 = co.get(co.indexOf(w) + 1);
                if (!ignore(w2) && frFilter.test(r, w2)) {
                    appendEdge(r, w2, model, "label=fr");
                }
            }
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addCoherence(ExecutionModel model) {

        graphviz.beginSubgraph("Coherence");
        graphviz.setEdgeAttributes("color=red");

        for (List<EventData> co : model.getCoherenceMap().values()) {
            for (int i = 2; i < co.size(); i++) {
                // We skip the init writes
                EventData w1 = co.get(i - 1);
                EventData w2 = co.get(i);
                if (ignore(w1) || ignore(w2) || !coFilter.test(w1, w2)) {
                    continue;
                }
                appendEdge(w1, w2, model, "label=co");
            }
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addAllThreadPos(ExecutionModel model) {
        for (Thread thread : model.getThreads()) {
            addThreadPo(thread, model);
        }
        return this;
    }

    private ExecutionGraphVisualizer addThreadPo(Thread thread, ExecutionModel model) {
        List<EventData> threadEvents = model.getThreadEventsMap().get(thread)
            .stream().filter(e -> e.is(Tag.VISIBLE)).collect(Collectors.toList());
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

            appendEdge(e1, e2, model, (String[]) null);
        }

        // --- Subgraph end ---
        graphviz.end();

        return this;
    }



    private String eventToNode(EventData e, ExecutionModel model) {
        if (e.isInit()) {
            return String.format("\"I(%s, %d)\"", addresses.get(e.getAccessedAddress()), e.getValue());
        } else if (e.getEvent().getCLine() == -1) {
            // Special write of each thread
            int threadSize = model.getThreadEventsMap().get(e.getThread()).size();
            if (e.getLocalId() <= threadSize / 2) {
                return String.format("\"T%d:start\"", e.getThread().getId());
            } else {
                return String.format("\"T%d:end\"", e.getThread().getId());
            }
        }
        // We have MemEvent + Fence
        String tag = e.getEvent().toString();
        if(e.isMemoryEvent()) {
            Object address = addresses.get(e.getAccessedAddress());
            BigInteger value = e.getValue();
        	String mo = ((MemEvent)e.getEvent()).getMo();
            mo = mo.isEmpty() ? mo : ", " + mo;
            tag = e.isWrite() ?
            		String.format("W(%s, %d%s)", address, value, mo) :
            		String.format("%d = R(%s%s)", value, address, mo);
        }
        return String.format("\"T%d:E%s (%s:L%d)\\n%s%s\"", 
        				e.getThread().getId(), 
        				e.getEvent().getGlobalId(),
        				e.getEvent().getSourceCodeFile(), 
        				e.getEvent().getCLine(),
                        callStackMapping.containsKey(e.getEvent()) ? callStackMapping.get(e.getEvent()) + "\\n" : "", 
        				tag);
    }

    private void appendEdge(EventData a, EventData b, ExecutionModel model, String... options) {
        graphviz.addEdge(eventToNode(a, model), eventToNode(b, model), options);
    }
    
    public static void generateGraphvizFile(ExecutionModel model, int iterationCount,
            BiPredicate<EventData, EventData> rfFilter, BiPredicate<EventData, EventData> frFilter,
            BiPredicate<EventData, EventData> coFilter, String directoryName, String fileNameBase,
            Map<Event, String> callStackMapping) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            new ExecutionGraphVisualizer()
                    .setCallStackMapping(callStackMapping)
                    .setReadFromFilter(rfFilter)
                    .setFromReadFilter(frFilter)
                    .setCoherenceFilter(coFilter)
                    .generateGraphOfExecutionModel(writer, "Iteration " + iterationCount, model);

            writer.flush();
            // Convert .dot file to pdf
            Process p = new ProcessBuilder()
                    .directory(new File(directoryName))
                    .command("dot", "-Tpng", fileNameBase + ".dot", "-o", fileNameBase + ".png")
                    .start();
            p.waitFor(1000, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            logger.error(e);
        }
    }
}
