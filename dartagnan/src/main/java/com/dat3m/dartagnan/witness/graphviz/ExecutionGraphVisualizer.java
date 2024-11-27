package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.relation.RelationModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.google.common.collect.Lists;
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
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

/*
    This is some rudimentary class to create graphs of executions.
    Currently, it just creates very special graphs.
 */
public class ExecutionGraphVisualizer {

    private static final Logger logger = LogManager.getLogger(ExecutionGraphVisualizer.class);

    private final Graphviz graphviz;
    private final ColorMap colorMap;
    private SyntacticContextAnalysis synContext = getEmptyInstance();
    // By default, we do not filter anything
    private BiPredicate<EventModel, EventModel> rfFilter = (x, y) -> true;
    private BiPredicate<EventModel, EventModel> frFilter = (x, y) -> true;
    private BiPredicate<EventModel, EventModel> coFilter = (x, y) -> true;
    private final List<MemoryObjectModel> sortedMemoryObjects = new ArrayList<>();

    public ExecutionGraphVisualizer() {
        this.graphviz = new Graphviz();
        this.colorMap = new ColorMap();
    }

    public ExecutionGraphVisualizer setSyntacticContext(SyntacticContextAnalysis synContext) {
        this.synContext = synContext;
        return this;
    }

    public ExecutionGraphVisualizer setReadFromFilter(BiPredicate<EventModel, EventModel> filter) {
        this.rfFilter = filter;
        return this;
    }

    public ExecutionGraphVisualizer setFromReadFilter(BiPredicate<EventModel, EventModel> filter) {
        this.frFilter = filter;
        return this;
    }

    public ExecutionGraphVisualizer setCoherenceFilter(BiPredicate<EventModel, EventModel> filter) {
        this.coFilter = filter;
        return this;
    }

    public void generateGraphOfExecutionModel(Writer writer, String graphName, ExecutionModelNext model) throws IOException {
        computeAddressMap(model);
        graphviz.beginDigraph(graphName);
        graphviz.append(String.format("label=\"%s\" \n", graphName));
        addAllThreadPos(model);
        addRelations(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private BiPredicate<EventModel, EventModel> getFilter(String relationName) {
        return (x, y) -> true;
    }

    private void computeAddressMap(ExecutionModelNext model) {
        model.getMemoryLayoutMap().entrySet().stream()
             .sorted(Comparator.comparing(entry -> entry.getValue().address()))
             .forEach(entry -> sortedMemoryObjects.add(entry.getValue()));
    }

    private boolean ignore(EventModel e) {
        return false; // We ignore no events for now.
    }

    private ExecutionGraphVisualizer addRelations(ExecutionModelNext model) {
        for (RelationModel rm : model.getRelationModels()) {
            if (rm.hasName(PO)) {
                addProgramOrder(model);
            } else {
                addRelation(model, rm);
            }
        }
        return this;
    }

    private ExecutionGraphVisualizer addRelation(ExecutionModelNext model, RelationModel rm) {
        String name = rm.getName();
        graphviz.beginSubgraph(name);
        String attributes = String.format("color=%s", colorMap.getColor(name));
        graphviz.setEdgeAttributes(attributes);
        String label = String.format("label=\"%s\"", name);
        BiPredicate<EventModel, EventModel> filter;
        if (name.equals(CO)) {
            filter = coFilter;
        } else if (name.equals(RF)) {
            filter = rfFilter;
        } else if (name.equals("fr")) {
            filter = frFilter;
        } else { filter = getFilter(name); }
        for (RelationModel.EdgeModel edge : rm.getEdgeModels()) {
            EventModel from = edge.getFrom();
            EventModel to = edge.getTo();

            if (ignore(from) || ignore(to) || !filter.test(from, to)) { continue; }

            appendEdge(from, to, label);
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addProgramOrder(ExecutionModelNext model) {
        graphviz.beginSubgraph(PO);
        String attributes = String.format("color=%s, weight=100", colorMap.getColor(PO));
        graphviz.setEdgeAttributes(attributes);
        BiPredicate<EventModel, EventModel> filter = getFilter(PO);
        for (ThreadModel tm : model.getThreadList()) {
            List<EventModel> eventsToShow = tm.getEventModelsToShow();
            if (eventsToShow.size() <= 1) { continue; }
            for (int i = 1; i < eventsToShow.size(); i++) {
                EventModel from = eventsToShow.get(i - 1);
                EventModel to = eventsToShow.get(i);

                if (ignore(from) || ignore(to) || !filter.test(from, to)) { continue; }

                appendEdge(from, to, "label=po");
            }
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addAllThreadPos(ExecutionModelNext model) {
        for (ThreadModel tm : model.getThreadList()) {
            addThreadPo(tm, model);
        }
        return this;
    }

    private ExecutionGraphVisualizer addThreadPo(ThreadModel tm, ExecutionModelNext model) {
        List<EventModel> threadEvents = tm.getEventModelsToShow();
        if (threadEvents.size() <= 1) {
            // This skips init threads.
            return this;
        }

        // --- Subgraph start ---
        graphviz.beginSubgraph("T" + tm.getId());

        for (EventModel e : threadEvents) {
            appendNode(e, (String[]) null);
        }

        // --- Subgraph end ---
        graphviz.end();

        return this;
    }

    private String getAddressString(BigInteger address) {
        final MemoryObjectModel accObj = Lists.reverse(sortedMemoryObjects).stream()
                .filter(o -> o.address().compareTo(address) <= 0)
                .findFirst().orElse(null);

        if (accObj == null) {
            return address + " [OOB]";
        } else {
            final boolean isOOB = address.compareTo(accObj.address().add(accObj.size())) >= 0;
            final BigInteger offset = address.subtract(accObj.address());
            return String.format("%s[size=%s]%s%s", accObj.object(), accObj.size(),
                    !offset.equals(BigInteger.ZERO) ? " + " + offset : "",
                    isOOB ? " [OOB]" : ""
            );
        }
    }

    private String eventToNode(EventModel e) {
        if (e.isInit()) {
            return String.format("\"I(%s, %d)\"", getAddressString(
                ((StoreModel) e).getAccessedAddress()), ((StoreModel) e).getValue());
        }
        // We have MemEvent + Fence + Local + Assert
        String tag = e.getEvent().toString();
        if (e.isMemoryEvent()) {
            String address = getAddressString(((MemoryEventModel) e).getAccessedAddress());
            BigInteger value = ((MemoryEventModel) e).getValue();
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
                .replace("%", "\\%")
                .replace("\"", "\\\""); // We need to escape quotes inside the string
        return "\"" + nodeString + "\"";
    }

    private void appendEdge(EventModel a, EventModel b, String... options) {
        graphviz.addEdge(eventToNode(a), eventToNode(b), options);
    }

    private void appendNode(EventModel e, String... attributes) {
        graphviz.addNode(eventToNode(e), attributes);
    }

    public static File generateGraphvizFile(ExecutionModelNext model, int iterationCount,
                                            BiPredicate<EventModel, EventModel> rfFilter,
                                            BiPredicate<EventModel, EventModel> frFilter,
                                            BiPredicate<EventModel, EventModel> coFilter, String directoryName, String fileNameBase,
                                            SyntacticContextAnalysis synContext,
                                            boolean convert) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            ExecutionGraphVisualizer visualizer = new ExecutionGraphVisualizer();
            visualizer.setSyntacticContext(synContext)
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

    public static void generateGraphvizFile(ExecutionModelNext model, int iterationCount,
            BiPredicate<EventModel, EventModel> rfFilter, BiPredicate<EventModel, EventModel> frFilter,
            BiPredicate<EventModel, EventModel> coFilter, String directoryName, String fileNameBase,
            SyntacticContextAnalysis synContext) {
        generateGraphvizFile(model, iterationCount, rfFilter, frFilter, coFilter, directoryName, fileNameBase,
                synContext, true);
    }
}
