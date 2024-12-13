package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.event.*;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.RelationModel.EdgeModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;
import com.dat3m.dartagnan.wmm.definition.Coherence;
import com.dat3m.dartagnan.wmm.definition.ProgramOrder;
import com.dat3m.dartagnan.wmm.definition.ReadFrom;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

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

    public void generateGraphOfExecutionModel(Writer writer, String graphName, ExecutionModelNext model) throws IOException {
        computeAddressMap(model);
        graphviz.beginDigraph(graphName);
        graphviz.append(String.format("label=\"%s\" \n", graphName));
        addEvents(model);
        addRelations(model);
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private void setRelationsToShow(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        relsToShow = Arrays.asList(relsToShowStr.split(",\\s*"));
    }

    private BiPredicate<EventModel, EventModel> getFilter(String relationName) {
        return (x, y) -> true;
    }

    private void computeAddressMap(ExecutionModelNext model) {
        model.getMemoryLayoutMap().entrySet().stream()
             .sorted(Comparator.comparing(entry -> (BigInteger) entry.getValue().address().getValue()))
             .forEach(entry -> sortedMemoryObjects.add(entry.getValue()));
    }

    private List<EventModel> getEventModelsToShow(ThreadModel tm) {
        return tm.getEventModels()
                 .stream()
                 .filter(e -> e instanceof MemoryEventModel
                              || e instanceof GenericVisibleEventModel
                              || e instanceof LocalModel
                              || e instanceof AssertModel)
                 .toList();
    }

    private ExecutionGraphVisualizer addEvents(ExecutionModelNext model) {
        for (ThreadModel tm : model.getThreadModels()) {
            List<EventModel> threadEvents = getEventModelsToShow(tm);
            if (threadEvents.size() <= 1) {
                // This skips init threads.
                return this;
            }

            graphviz.beginSubgraph("T" + tm.getId());

            for (EventModel e : threadEvents) {
                appendNode(e, (String[]) null);
            }

            graphviz.end();
        }
        return this;
    }

    private Optional<Integer> tryParseInt(String s) {
        try {
            int n = Integer.parseInt(s.substring(s.lastIndexOf("#") + 1));
            return Optional.of(n);
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }

    private RelationModel getRelationModelByName(ExecutionModelNext model, String name) {
        return model.getRelationModels().stream()
                    .filter(rm -> rm.getRelation().hasName(name))
                    .findFirst().orElse(null);
    }

    // Getting the correct relation to show is tricky.
    // In the case of redefinition, we care about the one defined last.
    // If there is no redefinition, we simply return the original one.
    private RelationModel getRelationModel(ExecutionModelNext model, String name) {
        // First check if the original definition is asked.
        if (name.endsWith("#0")) {
            String originalName = name.substring(0, name.lastIndexOf("#"));
            return getRelationModelByName(model, originalName);
        }

        int maxId = -1;
        for (RelationModel rm : model.getRelationModels()) {
            int defIndex = -1;
            for (String n : rm.getRelation().getNames()) {
                if (n.startsWith(name + "#")) {
                    defIndex = tryParseInt(n).orElse(-1);
                    if (defIndex > -1) { break; }
                }
            }
            maxId = Math.max(maxId, defIndex);
        }
        return maxId != -1 ? getRelationModelByName(model, name + "#" + maxId)
                           : getRelationModelByName(model, name);
    }

    private ExecutionGraphVisualizer addRelations(ExecutionModelNext model) {
        for (String name : relsToShow) {
            RelationModel rm = getRelationModel(model, name);
            if (rm == null) {
                logger.warn("Relation with the name {} does not exist", name);
                continue;
            }
            // For PO and CO we do not show the transitive edges in witness.
            if (rm.getRelation().getDefinition().getClass() == ProgramOrder.class) {
                addProgramOrder(model, name);
            } else if (rm.getRelation().getDefinition().getClass() == Coherence.class) {
                addCoherence(rm, model, name);
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
        for (EdgeModel edge : rm.getEdgeModels()) {
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
            List<EventModel> eventsToShow = getEventModelsToShow(tm);
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

    private ExecutionGraphVisualizer addCoherence(RelationModel rm, ExecutionModelNext model, String name) {
        graphviz.beginSubgraph(name);
        String attributes = String.format("color=%s", colorMap.getColor(CO));
        graphviz.setEdgeAttributes(attributes);
        String label = String.format("label=\"%s\"", name);
        BiPredicate<EventModel, EventModel> filter = getFilter(CO);

        Set<EdgeModel> coModels = rm.getEdgeModels();
        for (Set<StoreModel> writes : model.getAddressWritesMap().values()) {
            List<StoreModel> coSortedWrites;
            Map<StoreModel, List<StoreModel>> coEdges = new HashMap<>();
            for (StoreModel w1 : writes) {
                coEdges.put(w1, new ArrayList<>());
                for (StoreModel w2 : writes) {
                    if (coModels.contains(new EdgeModel(w1, w2))) {
                        coEdges.get(w1).add(w2);
                    }
                }
            }
            DependencyGraph<StoreModel> depGraph = DependencyGraph.from(writes, coEdges);
            coSortedWrites = new ArrayList<>(Lists.reverse(depGraph.getNodeContents()));

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

    private String getAddressString(ValueModel address) {
        final BigInteger addrValue = (BigInteger) address.getValue();
        final MemoryObjectModel accObj = Lists.reverse(sortedMemoryObjects).stream()
                .filter(o -> ((BigInteger) o.address().getValue()).compareTo(addrValue) <= 0)
                .findFirst().orElse(null);

        if (accObj == null) {
            return addrValue + " [OOB]";
        } else {
            final boolean isOOB = addrValue.compareTo(((BigInteger) accObj.address().getValue()).add(accObj.size())) >= 0;
            final BigInteger offset = addrValue.subtract((BigInteger) accObj.address().getValue());
            return String.format("%s[size=%s]%s%s", accObj.object(), accObj.size(),
                    !offset.equals(BigInteger.ZERO) ? " + " + offset : "",
                    isOOB ? " [OOB]" : ""
            );
        }
    }

    private String eventToNode(EventModel e) {
        if (e instanceof StoreModel sm && e.getEvent() instanceof Init) {
            return String.format("\"I(%s, %s)\"", getAddressString(
                sm.getAccessedAddress()), sm.getValue()
            );
        }
        // We have MemEvent + Fence + Local + Assert
        String tag = e.getEvent().toString();
        if (e instanceof MemoryEventModel mem) {
            String address = getAddressString(mem.getAccessedAddress());
            ValueModel value = mem.getValue();
            MemoryOrder mo = mem.getEvent().getMetadata(MemoryOrder.class);
            String moString = mo == null ? "" : ", " + mo.value();
            tag = mem instanceof StoreModel ?
                    String.format("W(%s, %s%s)", address, value, moString) :
                    String.format("%s = R(%s%s)", value, address, moString);
        } else if (e instanceof LocalModel lm) {
            tag = String.format("%s(%s) <- %s",
                lm.getEvent().getResultRegister(),
                lm.getValue(),
                lm.getEvent().getExpr()
            );
        } else if (e instanceof AssertModel am) {
            tag = String.format("Assertion(%s)", am.getResult());
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
                                            int iterationCount,
                                            BiPredicate<EventModel, EventModel> rfFilter,
                                            BiPredicate<EventModel, EventModel> coFilter,
                                            String directoryName,
                                            String fileNameBase,
                                            SyntacticContextAnalysis synContext,
                                            boolean convert,
                                            Configuration config) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            ExecutionGraphVisualizer visualizer = new ExecutionGraphVisualizer();
            if (config != null) { visualizer.setRelationsToShow(config); }
            visualizer.setSyntacticContext(synContext)
                      .setReadFromFilter(rfFilter)
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

    public static void generateGraphvizFile(ExecutionModelNext model,
                                            int iterationCount,
                                            BiPredicate<EventModel, EventModel> rfFilter,
                                            BiPredicate<EventModel, EventModel> coFilter,
                                            String directoryName,
                                            String fileNameBase,
                                            SyntacticContextAnalysis synContext) {
        generateGraphvizFile(model,
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
