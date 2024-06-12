package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.math.BigInteger;
import java.util.*;
import java.util.function.BiPredicate;

import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;

/*
    This is some rudimentary class to create graphs of executions.
    Currently, it just creates very special graphs.
 */
public class ExecutionGraphVisualizer {

    private static final Logger logger = LogManager.getLogger(ExecutionGraphVisualizer.class);

    private final Graphviz graphviz;
    private SyntacticContextAnalysis synContext = getEmptyInstance();
    // By default, we do not filter anything
    private BiPredicate<EventData, EventData> rfFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> frFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> coFilter = (x, y) -> true;
    private final LinkedHashMap<MemoryObject, BigInteger> objToAddrMap = new LinkedHashMap<>();

    public ExecutionGraphVisualizer() {
        this.graphviz = new Graphviz();
    }


    public ExecutionGraphVisualizer setSyntacticContext(SyntacticContextAnalysis synContext) {
        this.synContext = synContext;
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
        computeAddressMap(model);
        graphviz.beginDigraph(graphName);
        graphviz.append(String.format("label=\"%s\" \n", graphName));
        addAllThreadPos(model);
        addReadFrom(model);
        addFromRead(model);
        addCoherence(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private void computeAddressMap(ExecutionModel model) {
        final Map<MemoryObject, BigInteger> memLayout = model.getMemoryLayoutMap();
        final List<MemoryObject> objs = new ArrayList<>(memLayout.keySet());
        objs.sort(Comparator.comparing(memLayout::get));

        for (MemoryObject obj : objs) {
            objToAddrMap.put(obj, memLayout.get(obj));
        }
    }

    private boolean ignore(EventData e) {
        return false; // We ignore no events for now.
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

            appendEdge(w, r, "label=rf");
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
            if (co.indexOf(w) + 1 < co.size()) {
                EventData w2 = co.get(co.indexOf(w) + 1);
                if (!ignore(w2) && frFilter.test(r, w2)) {
                    appendEdge(r, w2, "label=fr");
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
                appendEdge(w1, w2, "label=co");
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
                .stream().filter(e -> e.hasTag(Tag.VISIBLE)).toList();
        if (threadEvents.size() <= 1) {
            // This skips init threads.
            return this;
        }

        // --- Subgraph start ---
        graphviz.beginSubgraph("T" + thread.getId());
        graphviz.setEdgeAttributes("weight=100");
        // --- Node list ---
        for (int i = 1; i < threadEvents.size(); i++) {
            EventData e1 = threadEvents.get(i - 1);
            EventData e2 = threadEvents.get(i);

            if (ignore(e1) || ignore(e2)) {
                continue;
            }

            appendEdge(e1, e2, (String[]) null);
        }

        // --- Subgraph end ---
        graphviz.end();

        return this;
    }

    private String getAddressString(BigInteger address) {
        MemoryObject obj = null;
        BigInteger objAddress = null;
        for (Map.Entry<MemoryObject, BigInteger> entry : objToAddrMap.entrySet()) {
            final BigInteger nextObjAddr = entry.getValue();
            if (nextObjAddr.compareTo(address) > 0) {
                break;
            }
            obj = entry.getKey();
            objAddress = nextObjAddr;
        }

        if (obj == null) {
            return address + " [OOB]";
        } else if (address.equals(objAddress)) {
            return obj.toString();
        } else {
            final boolean isOOB = address.compareTo(objAddress.add(BigInteger.valueOf(obj.size()))) >= 0;
            return String.format("%s + %s%s", obj, address.subtract(objAddress), isOOB ? " [OOB]" : "");
        }
    }

    private String eventToNode(EventData e) {
        if (e.isInit()) {
            return String.format("\"I(%s, %d)\"", getAddressString(e.getAccessedAddress()), e.getValue());
        }
        // We have MemEvent + Fence
        String tag = e.getEvent().toString();
        if (e.isMemoryEvent()) {
            String address = getAddressString(e.getAccessedAddress());
            BigInteger value = e.getValue();
            MemoryOrder mo = e.getEvent().getMetadata(MemoryOrder.class);
            String moString = mo == null ? "" : ", " + mo.value();
            tag = e.isWrite() ?
                    String.format("W(%s, %d%s)", address, value, moString) :
                    String.format("%s = R(%s%s)", value, address, moString);
        }
        final String callStack = makeContextString(
            synContext.getContextInfo(e.getEvent()).getContextOfType(CallContext.class), " -> \\n");
        final String nodeString = String.format("%s:T%s/E%s\\n%s%s\n%s",
                e.getThread().getName(),
                e.getThread().getId(),
                e.getEvent().getGlobalId(),
                callStack.isEmpty() ? callStack : callStack + " -> \\n",
                getSourceLocationString(e.getEvent()),
                tag)
                .replace("\"", "\\\""); // We need to escape quotes inside the string
        return "\"" + nodeString + "\"";
    }

    private void appendEdge(EventData a, EventData b, String... options) {
        graphviz.addEdge(eventToNode(a), eventToNode(b), options);
    }

    public static File generateGraphvizFile(ExecutionModel model, int iterationCount,
                                            BiPredicate<EventData, EventData> rfFilter, BiPredicate<EventData, EventData> frFilter,
                                            BiPredicate<EventData, EventData> coFilter, String directoryName, String fileNameBase,
                                            SyntacticContextAnalysis synContext,
                                            boolean convert) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            new ExecutionGraphVisualizer()
                    .setSyntacticContext(synContext)
                    .setReadFromFilter(rfFilter)
                    .setFromReadFilter(frFilter)
                    .setCoherenceFilter(coFilter)
                    .generateGraphOfExecutionModel(writer, "Iteration " + iterationCount, model);

            writer.flush();
            if (convert) {
                fileVio = Graphviz.convert(fileVio);
            }
            return fileVio;
        } catch (Exception e) {
            logger.error(e);
        }

        return null;
    }

    public static void generateGraphvizFile(ExecutionModel model, int iterationCount,
            BiPredicate<EventData, EventData> rfFilter, BiPredicate<EventData, EventData> frFilter,
            BiPredicate<EventData, EventData> coFilter, String directoryName, String fileNameBase,
            SyntacticContextAnalysis synContext) {
        generateGraphvizFile(model, iterationCount, rfFilter, frFilter, coFilter, directoryName, fileNameBase,
                synContext, true);
    }
}
