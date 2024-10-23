package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
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
    private BiPredicate<EventData, EventData> rfFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> frFilter = (x, y) -> true;
    private BiPredicate<EventData, EventData> coFilter = (x, y) -> true;
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
        addRelations(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private ExecutionGraphVisualizer setRelationsToShow(ExecutionModel model)
            throws InvalidConfigurationException {
        model.getContext().getTask().getConfig().inject(this);
        if (relToShowStr.equals("default")) {
            relToShow = new HashSet<>(Set.of(PO, RF, CO, "fr"));
        }
        else {
            relToShow = new HashSet<>(Arrays.asList(relToShowStr.split(",\\s*")));
        }
        return this;
    }

    private BiPredicate<EventData, EventData> getFilter(String relationName) {
        return (x, y) -> true;
    }

    private void computeAddressMap(ExecutionModel model) {
        model.getMemoryLayoutMap().entrySet().stream()
                .sorted(Comparator.comparing(entry -> entry.getValue().address()))
                .forEach(entry -> sortedMemoryObjects.add(entry.getValue()));
    }

    private boolean ignore(EventData e) {
        return false; // We ignore no events for now.
    }

    private ExecutionGraphVisualizer addRelations(ExecutionModel model) {
        model.getManager().extractRelations(new ArrayList<>(relToShow));
        for (String relationName : relToShow) {
            addRelation(model, relationName);
        }
        return this;
    }

    private ExecutionGraphVisualizer addRelation(ExecutionModel model, String relationName) {
        graphviz.beginSubgraph(relationName);
        String attributes = String.format("color=%s", colorMap.getColor(relationName));
        if (relationName.equals(PO)) {
            attributes += ", weight=100";
        }
        graphviz.setEdgeAttributes(attributes);
        String label = "label=" + relationName.replace("-", "");
        BiPredicate<EventData, EventData> filter = getFilter(relationName);
        RelationModel rm = model.getRelationModel(relationName);
        for (RelationModel.EdgeModel edge : rm.getEdges()) {
            EventData predecessor = edge.getPredecessor();
            EventData successor = edge.getSuccessor();

            if (ignore(predecessor) || ignore(successor) || !filter.test(predecessor, successor)) {
                continue;
            }

            appendEdge(predecessor, successor, label);
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
                .stream().filter(e -> e.hasTag(Tag.VISIBLE) || e.isLocal() || e.isAssert()).toList();
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

        for (EventData e : threadEvents) {
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
                .replace("%", "\\%")
                .replace("\"", "\\\""); // We need to escape quotes inside the string
        return "\"" + nodeString + "\"";
    }

    private void appendEdge(EventData a, EventData b, String... options) {
        graphviz.addEdge(eventToNode(a), eventToNode(b), options);
    }

    private void appendNode(EventData e, String... attributes) {
        graphviz.addNode(eventToNode(e), attributes);
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
                    .setRelationsToShow(model)
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
