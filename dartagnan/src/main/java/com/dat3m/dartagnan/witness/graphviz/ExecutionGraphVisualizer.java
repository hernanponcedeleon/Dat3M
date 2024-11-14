package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.relation.RelationModel;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
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
import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_RELATIONS_TO_SHOW;

/*
    This is some rudimentary class to create graphs of executions.
    Currently, it just creates very special graphs.
 */
@Options
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
    private Set<String> relToShow;

    @Option(name=WITNESS_RELATIONS_TO_SHOW,
            description="Names of relations to show in the witness graph.",
            secure=true)
    private String relToShowStr = "default";

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
        // addReadFrom(model);
        // addFromRead(model);
        // addCoherence(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private ExecutionGraphVisualizer setRelationsToShow(ExecutionModelNext model)
        throws InvalidConfigurationException
    {
        model.getEncodingContext().getTask().getConfig().inject(this);
        if (relToShowStr.equals("default")) {
            relToShow = new HashSet<>(Set.of(PO, RF, CO, "fr"));
        }
        else {
            relToShow = new HashSet<>(Arrays.asList(relToShowStr.split(",\\s*")));
        }
        return this;
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
        model.getManager().extractRelations(new ArrayList<>(relToShow));
        for (String relationName : relToShow) {
            if (relationName.equals(PO)) {
                addProgramOrder(model);
            } else {
                addRelation(model, relationName);
            }
        }
        return this;
    }

    private ExecutionGraphVisualizer addRelation(ExecutionModelNext model, String name) {
        RelationModel rm = model.getRelationModel(name);
        if (rm == null) {
            logger.warn("Relation with the name {} does not exist", name);
            return this;
        }
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
        for (Thread t : model.getThreads()) {
            List<EventModel> eventsToShow = model.getEventModelsToShow(t);
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

    // private ExecutionGraphVisualizer addReadFrom(ExecutionModel model) {

    //     graphviz.beginSubgraph("ReadFrom");
    //     graphviz.setEdgeAttributes("color=green");
    //     for (Map.Entry<EventData, EventData> rw : model.getReadWriteMap().entrySet()) {
    //         EventData r = rw.getKey();
    //         EventData w = rw.getValue();

    //         if (ignore(r) || ignore(w) || !rfFilter.test(w, r)) {
    //             continue;
    //         }

    //         appendEdge(w, r, "label=rf");
    //     }
    //     graphviz.end();
    //     return this;
    // }

    // private ExecutionGraphVisualizer addFromRead(ExecutionModel model) {

    //     graphviz.beginSubgraph("FromRead");
    //     graphviz.setEdgeAttributes("color=orange");
    //     for (Map.Entry<EventData, EventData> rw : model.getReadWriteMap().entrySet()) {
    //         EventData r = rw.getKey();
    //         EventData w = rw.getValue();

    //         if (ignore(r) || ignore(w)) {
    //             continue;
    //         }

    //         List<EventData> co = model.getCoherenceMap().get(w.getAccessedAddress());
    //         // Check if exists w2 : co(w, w2)
    //         if (co.indexOf(w) + 1 < co.size()) {
    //             EventData w2 = co.get(co.indexOf(w) + 1);
    //             if (!ignore(w2) && frFilter.test(r, w2)) {
    //                 appendEdge(r, w2, "label=fr");
    //             }
    //         }
    //     }
    //     graphviz.end();
    //     return this;
    // }

    // private ExecutionGraphVisualizer addCoherence(ExecutionModel model) {

    //     graphviz.beginSubgraph("Coherence");
    //     graphviz.setEdgeAttributes("color=red");

    //     for (List<EventData> co : model.getCoherenceMap().values()) {
    //         for (int i = 2; i < co.size(); i++) {
    //             // We skip the init writes
    //             EventData w1 = co.get(i - 1);
    //             EventData w2 = co.get(i);
    //             if (ignore(w1) || ignore(w2) || !coFilter.test(w1, w2)) {
    //                 continue;
    //             }
    //             appendEdge(w1, w2, "label=co");
    //         }
    //     }
    //     graphviz.end();
    //     return this;
    // }

    private ExecutionGraphVisualizer addAllThreadPos(ExecutionModelNext model) {
        for (Thread thread : model.getThreads()) {
            addThreadPo(thread, model);
        }
        return this;
    }

    private ExecutionGraphVisualizer addThreadPo(Thread thread, ExecutionModelNext model) {
        List<EventModel> threadEvents = model.getEventModelsToShow(thread);
        if (threadEvents.size() <= 1) {
            // This skips init threads.
            return this;
        }

        // --- Subgraph start ---
        graphviz.beginSubgraph("T" + thread.getId());
        // graphviz.setEdgeAttributes("weight=100");
        // // --- Node list ---
        // for (int i = 1; i < threadEvents.size(); i++) {
        //     EventData e1 = threadEvents.get(i - 1);
        //     EventData e2 = threadEvents.get(i);

        //     if (ignore(e1) || ignore(e2)) {
        //         continue;
        //     }

        //     appendEdge(e1, e2, (String[]) null);
        // }
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
        // We have MemEvent + Fence
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
                                            boolean convert, boolean usedByRefinementSolver) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            ExecutionGraphVisualizer visualizer = new ExecutionGraphVisualizer();
            if (!usedByRefinementSolver) { visualizer.setRelationsToShow(model); }
            visualizer.setRelationsToShow(model)
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

    public static void generateGraphvizFile(ExecutionModelNext model, int iterationCount,
            BiPredicate<EventModel, EventModel> rfFilter, BiPredicate<EventModel, EventModel> frFilter,
            BiPredicate<EventModel, EventModel> coFilter, String directoryName, String fileNameBase,
            SyntacticContextAnalysis synContext) {
        generateGraphvizFile(model, iterationCount, rfFilter, frFilter, coFilter, directoryName, fileNameBase,
                synContext, true, true);
    }
}
