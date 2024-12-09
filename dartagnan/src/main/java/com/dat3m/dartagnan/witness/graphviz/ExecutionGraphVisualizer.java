package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.wmm.definition.Coherence;
import com.dat3m.dartagnan.wmm.definition.ProgramOrder;
import com.dat3m.dartagnan.wmm.definition.ReadFrom;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.Model;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.math.BigInteger;
import java.util.*;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_SHOW;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

@Options
public class ExecutionGraphVisualizer {

    private static final Logger logger = LogManager.getLogger(ExecutionGraphVisualizer.class);

    private final Graphviz graphviz;
    private final ColorMap colorMap;
    private SyntacticContextAnalysis synContext = getEmptyInstance();
    // By default, we do not filter anything
    private BiPredicate<EventModel, EventModel> rfFilter = (x, y) -> true;
    private BiPredicate<EventModel, EventModel> coFilter = (x, y) -> true;
    private final List<MemoryObjectModel> sortedMemoryObjects = new ArrayList<>();
    private List<String> relsToShow;

    @Option(name=WITNESS_SHOW,
            description="Names of relations to show in the witness graph.",
            secure=true)
    private String relsToShowStr = String.format("%s,%s,%s", PO, CO, RF);

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

    public ExecutionGraphVisualizer setCoherenceFilter(BiPredicate<EventModel, EventModel> filter) {
        this.coFilter = filter;
        return this;
    }

    public void generateGraphOfExecutionModel(
        Writer writer, String graphName, ExecutionModelNext model, EncodingContext context, Model smtModel
    ) throws IOException {
        computeAddressMap(model);
        graphviz.beginDigraph(graphName);
        graphviz.append(String.format("label=\"%s\" \n", graphName));
        addAllThreadPos(model);
        addRelations(model, context, smtModel);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private List<String> setRelationsToShow(EncodingContext context) throws InvalidConfigurationException {
        context.getTask().getConfig().inject(this);
        relsToShow = Arrays.asList(relsToShowStr.split(",\\s*"));
        return relsToShow;
    }

    private BiPredicate<EventModel, EventModel> getFilter(String relationName) {
        return (x, y) -> true;
    }

    private void computeAddressMap(ExecutionModelNext model) {
        model.getMemoryLayoutMap().entrySet().stream()
             .sorted(Comparator.comparing(entry -> entry.getValue().address()))
             .forEach(entry -> sortedMemoryObjects.add(entry.getValue()));
    }

    private RelationModel getRelationModelByName(ExecutionModelNext model, String name) {
        for (RelationModel rm : model.getRelationModels()) {
            Relation r = rm.getRelation();
            if (r.hasName(name)
                || r.getNames().stream().anyMatch(n -> n.startsWith(name + "#"))
                || (name.endsWith("#0") && r.hasName(name.substring(0, name.lastIndexOf("#"))))) {
                return rm;
            }
        }
        return null;
    }

    private ExecutionGraphVisualizer addRelations(
            ExecutionModelNext model, EncodingContext context, Model smtModel) {
        for (String name : relsToShow) {
            RelationModel rm = getRelationModelByName(model, name);
            if (rm == null) {
                logger.warn("Relation with the name {} does not exist", name);
                continue;
            }
            // For PO and CO we do not show the transitive edges in witness.
            if (rm.getRelation().getDefinition().getClass() == ProgramOrder.class) {
                addProgramOrder(model, name);
            } else if (rm.getRelation().getDefinition().getClass() == Coherence.class) {
                addCoherence(rm, model, name, context, smtModel);
            } else {
                addRelation(rm, name);
            }
        }
        return this;
    }

    private ExecutionGraphVisualizer addRelation(RelationModel rm, String name) {
        graphviz.beginSubgraph(name);
        String attributes = String.format("color=%s", colorMap.getColor(name));
        graphviz.setEdgeAttributes(attributes);
        String label = String.format("label=\"%s\"", name);
        BiPredicate<EventModel, EventModel> filter = rm.getRelation().getDefinition().getClass() == ReadFrom.class ?
            rfFilter : getFilter(name);
        for (RelationModel.EdgeModel edge : rm.getEdgeModels()) {
            EventModel from = edge.getFrom();
            EventModel to = edge.getTo();

            if (!filter.test(from, to)) { continue; }

            appendEdge(from, to, label);
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addProgramOrder(ExecutionModelNext model, String name) {
        graphviz.beginSubgraph(name);
        String attributes = String.format("color=%s, weight=100", colorMap.getColor(PO));
        graphviz.setEdgeAttributes(attributes);
        String label = String.format("label=\"%s\"", name);
        BiPredicate<EventModel, EventModel> filter = getFilter(PO);
        for (ThreadModel tm : model.getThreadModels()) {
            List<EventModel> eventsToShow = tm.getEventModels()
                                              .stream()
                                              .filter(e -> e.isVisible() || e.isLocal() || e.isAssert())
                                              .toList();
            if (eventsToShow.size() <= 1) { continue; }
            for (int i = 1; i < eventsToShow.size(); i++) {
                EventModel from = eventsToShow.get(i - 1);
                EventModel to = eventsToShow.get(i);

                if (!filter.test(from, to)) { continue; }

                appendEdge(from, to, label);
            }
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addCoherence(
            RelationModel rm, ExecutionModelNext model, String name, EncodingContext context, Model smtModel) {
        graphviz.beginSubgraph(name);
        String attributes = String.format("color=%s", colorMap.getColor(CO));
        graphviz.setEdgeAttributes(attributes);
        String label = String.format("label=\"%s\"", name);
        BiPredicate<EventModel, EventModel> filter = getFilter(CO);

        EncodingContext.EdgeEncoder co = context.edge(rm.getRelation());
        for (Set<StoreModel> writes : model.getAddressWritesMap().values()) {
            List<StoreModel> coSortedWrites;
            if (context.usesSATEncoding()) {
                Map<StoreModel, List<StoreModel>> coEdges = new HashMap<>();
                for (StoreModel w1 : writes) {
                    coEdges.put(w1, new ArrayList<>());
                    for (StoreModel w2 : writes) {
                        if (Boolean.TRUE.equals(smtModel.evaluate(co.encode(w1.getEvent(), w2.getEvent())))) {
                            coEdges.get(w1).add(w2);
                        }
                    }
                }
                DependencyGraph<StoreModel> depGraph = DependencyGraph.from(writes, coEdges);
                coSortedWrites = new ArrayList<>(Lists.reverse(depGraph.getNodeContents()));
            } else {
                Map<StoreModel, BigInteger> writeClockMap = new HashMap<>(
                    writes.size() * 4 / 3, 0.75f
                );
                for (StoreModel w : writes) {
                    writeClockMap.put(w, (BigInteger) smtModel.evaluate(
                        context.memoryOrderClock(w.getEvent())
                    ));
                }
                coSortedWrites = writes.stream()
                                       .sorted(Comparator.comparing(writeClockMap::get))
                                       .collect(Collectors.toList());
            }

            for (int i = 0; i < coSortedWrites.size(); i++) {
                if (i >= 1) {
                    EventModel w1 = (EventModel) coSortedWrites.get(i - 1);
                    EventModel w2 = (EventModel) coSortedWrites.get(i);

                    if (!filter.test(w1, w2)) { continue; }

                    appendEdge(w1, w2, label);
                }
            }
        }
        graphviz.end();
        return this;
    }

    private ExecutionGraphVisualizer addAllThreadPos(ExecutionModelNext model) {
        for (ThreadModel tm : model.getThreadModels()) {
            addThreadPo(tm, model);
        }
        return this;
    }

    private ExecutionGraphVisualizer addThreadPo(ThreadModel tm, ExecutionModelNext model) {
        List<EventModel> threadEvents = tm.getEventModels()
                                          .stream()
                                          .filter(e -> e.isVisible() || e.isLocal() || e.isAssert())
                                          .toList();
        if (threadEvents.size() <= 1) {
            // This skips init threads.
            return this;
        }

        graphviz.beginSubgraph("T" + tm.getId());

        for (EventModel e : threadEvents) {
            appendNode(e, (String[]) null);
        }

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
                e.getThreadModel().getName(),
                e.getThreadModel().getId(),
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

    public static File generateGraphvizFile(ExecutionModelNext model,
                                            EncodingContext context,
                                            Model smtModel,
                                            int iterationCount,
                                            BiPredicate<EventModel, EventModel> rfFilter,
                                            BiPredicate<EventModel, EventModel> coFilter,
                                            String directoryName,
                                            String fileNameBase,
                                            SyntacticContextAnalysis synContext,
                                            boolean convert,
                                            ExecutionGraphVisualizer visualizer) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            if (visualizer == null) { visualizer = new ExecutionGraphVisualizer(); }
            visualizer.setSyntacticContext(synContext)
                      .setReadFromFilter(rfFilter)
                      .setCoherenceFilter(coFilter)
                      .generateGraphOfExecutionModel(writer, "Iteration " + iterationCount, model, context, smtModel);

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

    public static File generateGraphvizFile(EncodingContext context,
                                            Model smtModel,
                                            int iterationCount,
                                            BiPredicate<EventModel, EventModel> rfFilter,
                                            BiPredicate<EventModel, EventModel> coFilter,
                                            String directoryName,
                                            String fileNameBase,
                                            SyntacticContextAnalysis synContext,
                                            boolean convert) throws InvalidConfigurationException {
        ExecutionGraphVisualizer visualizer = new ExecutionGraphVisualizer();
        ExecutionModelNext model = new ExecutionModelManager().setRelationsToExtract(visualizer.setRelationsToShow(context))
                                                              .buildExecutionModel(context, smtModel);
        return generateGraphvizFile(model,
                                    context,
                                    smtModel,
                                    iterationCount,
                                    rfFilter,
                                    coFilter,
                                    directoryName,
                                    fileNameBase,
                                    synContext,
                                    convert,
                                    visualizer);
    }

    public static void generateGraphvizFile(ExecutionModelNext model,
                                            EncodingContext context,
                                            Model smtModel,
                                            int iterationCount,
                                            BiPredicate<EventModel, EventModel> rfFilter,
                                            BiPredicate<EventModel, EventModel> coFilter,
                                            String directoryName,
                                            String fileNameBase,
                                            SyntacticContextAnalysis synContext) {
        generateGraphvizFile(model,
                             context,
                             smtModel,
                             iterationCount,
                             rfFilter,
                             coFilter,
                             directoryName,
                             fileNameBase,
                             synContext,
                             true,
                             null);
    }
}
