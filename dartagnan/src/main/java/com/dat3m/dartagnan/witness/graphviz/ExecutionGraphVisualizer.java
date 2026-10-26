package com.dat3m.dartagnan.witness.graphviz;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.memory.ToMemoryCast;
import com.dat3m.dartagnan.model.Execution;
import com.dat3m.dartagnan.model.MemoryLayout;
import com.dat3m.dartagnan.model.ThreadExecution;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.definition.Coherence;
import com.dat3m.dartagnan.wmm.definition.ProgramOrder;
import com.dat3m.dartagnan.wmm.definition.SameInstruction;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.IOException;
import java.io.Writer;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.function.BiPredicate;

import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_SHOW;
import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

@Options
public class ExecutionGraphVisualizer {

    private static final Logger logger = LoggerFactory.getLogger(ExecutionGraphVisualizer.class);

    private final Graphviz graphviz;
    private final ColorMap colorMap;
    private SyntacticContextAnalysis synContext = getEmptyInstance();
    private final Map<String, BiPredicate<Event, Event>> filter = new HashMap<>();
    private final List<MemoryLayout.AllocatedObject> sortedMemoryObjects = new ArrayList<>();
    private static final Set<String> OPTIONAL_RELATIONS = Set.of(SI);
    private Set<String> relsToShow;
    private Execution execution;

    @Option(name=WITNESS_SHOW,
            description="Names of relations to show in the witness graph.",
            secure=true)
    private String relsToShowStr = String.format("%s,%s,%s,%s", PO, SI, CO, RF);

    public ExecutionGraphVisualizer() {
        this.graphviz = new Graphviz();
        this.colorMap = new ColorMap();

        relsToShow = Set.of(relsToShowStr.split(",\\s*"));
    }

    public ExecutionGraphVisualizer setSyntacticContext(SyntacticContextAnalysis synContext) {
        this.synContext = synContext;
        return this;
    }

    public ExecutionGraphVisualizer setFilter(String relationName, BiPredicate<Event, Event> filter) {
        this.filter.put(relationName, filter);
        return this;
    }

    public void generateGraphOfExecution(Writer writer, String graphName, Execution execution) throws IOException {
        this.execution = execution;
        computeAddressMap();
        graphviz.beginDigraph(graphName);
        graphviz.appendLine(String.format("label=\"%s\"", graphName));
        addEvents();
        addRelations();
        graphviz.end();
        graphviz.generateOutput(writer);
    }

    private void setRelationsToShow(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        relsToShow = Set.of(relsToShowStr.split(",\\s*"));
    }

    private BiPredicate<Event, Event> getFilter(String relationName) {
        return filter.getOrDefault(relationName, (x, y) -> true);
    }

    private void computeAddressMap() {
        sortedMemoryObjects.clear();
        execution.getMemoryLayout().getAllocatedObjects().stream()
                .sorted(Comparator.comparing(MemoryLayout.AllocatedObject::address))
                .forEach(sortedMemoryObjects::add);
    }

    private List<List<Event>> getEventsToShow(ThreadExecution thread) {
        final List<List<Event>> instructions = new ArrayList<>();
        final List<InstructionBoundary> markers = thread.getThread().getEvents(InstructionBoundary.class);
        int b = 0;
        List<Event> instruction = null;
        for (Event e : thread.getTrace()) {
            if (!isShown(e)) {
                continue;
            }
            boolean insideInstruction = instruction != null;
            while (b < markers.size() && markers.get(b).getGlobalId() < e.getGlobalId()) {
                b++;
                insideInstruction = !insideInstruction;
                instruction = null;
            }
            if (instruction == null) {
                instruction = new ArrayList<>();
                instructions.add(instruction);
            }
            instruction.add(e);
            if (!insideInstruction) {
                instruction = null;
            }
        }
        return instructions;
    }

    private boolean isShown(Event e) {
        return switch (e) {
            case MemoryCoreEvent _, GenericVisibleEvent _, Local _, Assert _ -> true;
            default -> false;
        };
    }

    private void addEvents() {
        for (ThreadExecution thread : execution.getThreads()) {

            if (IRHelper.isInitThread(thread.getThread()) || !thread.hasStarted()) {
                continue;
            }

            graphviz.beginSubgraph("T" + thread.getThread().getId());

            final List<List<Event>> instructions = getEventsToShow(thread);
            for (List<Event> instruction : instructions) {
                for (Event event : instruction) {
                    appendNode(event, nodeLabel(event));
                }
            }

            graphviz.end();
        }
    }

    private Optional<Integer> tryParseInt(String s) {
        try {
            int n = Integer.parseInt(s.substring(s.lastIndexOf("#") + 1));
            return Optional.of(n);
        } catch (NumberFormatException _) {
            return Optional.empty();
        }
    }

    // Getting the correct relation to show is tricky.
    // In the case of redefinition, we care about the one defined last.
    // If there is no redefinition, we simply return the original one.
    private Relation getRelation(String name) {
        final Wmm memoryModel = execution.getMemoryModel();
        // First check if the original definition is asked.
        if (name.endsWith("#0")) {
            String originalName = name.substring(0, name.lastIndexOf("#"));
            return memoryModel.getRelation(originalName);
        }

        int maxId = -1;
        for (Relation r : memoryModel.getRelations()) {
            int defIndex = -1;
            for (String n : r.getNames()) {
                if (n.startsWith(name + "#")) {
                    defIndex = tryParseInt(n).orElse(-1);
                    if (defIndex > -1) { break; }
                }
            }
            maxId = Math.max(maxId, defIndex);
        }
        return maxId != -1 ? memoryModel.getRelation(name + "#" + maxId) : memoryModel.getRelation(name);
    }

    private void addRelations() {
        for (String name : relsToShow) {
            final Relation relation = getRelation(name);
            if (relation == null) {
                if (!OPTIONAL_RELATIONS.contains(name)) {
                    logger.warn("Relation with the name {} does not exist", name);
                }
                continue;
            }
            // For PO and CO we do not show the transitive edges in witness.
            if (relation.getDefinition().getClass() == ProgramOrder.class) {
                addProgramOrder(name);
            } else if (relation.getDefinition().getClass() == Coherence.class) {
                addCoherence(relation, name);
            } else if (relation.getDefinition().getClass() == SameInstruction.class) {
                addSameInstruction(name);
            } else {
                addRelation(relation, name);
            }
        }
    }

    private void addRelation(Relation relation, String name) {
        graphviz.beginSubgraph(name);
        graphviz.setEdgeAttributes(String.format("color=%s, label=\"%s\"", colorMap.getColor(name), name));
        final BiPredicate<Event, Event> filter = getFilter(name);
        execution.getRelation(relation).apply((from, to) -> {
            // Edges between hidden events would create undeclared nodes.
            if (isShown(from) && isShown(to)) {
                appendEdge(filter, from, to);
            }
        });
        graphviz.end();
    }

    private void addProgramOrder(String name) {
        graphviz.beginSubgraph(name);
        graphviz.setEdgeAttributes(String.format("color=%s, weight=100, label=\"%s\"", colorMap.getColor(PO), name));
        final BiPredicate<Event, Event> filter = getFilter(PO);
        for (ThreadExecution thread : execution.getThreads()) {
            final List<List<Event>> instructions = getEventsToShow(thread);
            if (instructions.size() <= 1) { continue; }
            for (int i = 1; i < instructions.size(); i++) {
                final List<Event> fromList = instructions.get(i - 1);
                final List<Event> toList = instructions.get(i);
                for (Event from : fromList) {
                    for (Event to : toList) {
                        appendEdge(filter, from, to);
                    }
                }
            }
        }
        graphviz.end();
    }

    private void addCoherence(Relation relation, String name) {
        graphviz.beginSubgraph(name);
        graphviz.setEdgeAttributes(String.format("color=%s, label=\"%s\"", colorMap.getColor(CO), name));
        final BiPredicate<Event, Event> filter = getFilter(CO);

        final EventGraph co = execution.getRelation(relation);
        for (BigInteger address : execution.getAccessedAddresses()) {
            final List<Store> writes = execution.getAccesses(address).stream()
                    .filter(Store.class::isInstance).map(Store.class::cast).toList();
            final Map<Store, List<Store>> coEdges = new HashMap<>();
            for (Store w1 : writes) {
                coEdges.put(w1, writes.stream().filter(w2 -> co.contains(w1, w2)).toList());
            }
            final DependencyGraph<Store> depGraph = DependencyGraph.from(writes, coEdges);
            final List<Store> coSortedWrites = depGraph.getNodeContents().reversed();

            for (int i = 1; i < coSortedWrites.size(); i++) {
                appendEdge(filter, coSortedWrites.get(i - 1), coSortedWrites.get(i));
            }
        }
        graphviz.end();
    }

    private void addSameInstruction(String name) {
        graphviz.beginSubgraph(name);
        graphviz.setEdgeAttributes(String.format("color=%s, arrowhead=none", colorMap.getColor(name)));
        final BiPredicate<Event, Event> filter = getFilter(name);
        for (ThreadExecution thread : execution.getThreads()) {
            final List<List<Event>> instructions = getEventsToShow(thread);
            if (instructions.size() <= 1) { continue; }
            for (List<Event> instruction : instructions) {
                int end = instruction.size() - 1;
                for (int i = 0; i < end; i++) {
                    appendEdge(filter, instruction.get(i), instruction.get(i + 1));
                }
            }
        }
        graphviz.end();
    }

    private String getAddressString(MemoryCoreEvent e) {
        final BigInteger addrValue = execution.addressValue(e);
        final MemoryLayout.AllocatedObject accObj = sortedMemoryObjects.reversed().stream()
                .filter(o -> o.address().compareTo(addrValue) <= 0)
                .findFirst().orElse(null);

        if (accObj == null) {
            return addrValue + " [OOB]";
        } else {
            final boolean isOOB = !accObj.contains(addrValue);
            final BigInteger offset = addrValue.subtract(accObj.address());
            return String.format("%s[size=%s]%s%s", accObj.object(), accObj.size(),
                    !offset.equals(BigInteger.ZERO) ? " + " + offset : "",
                    isOOB ? " [OOB]" : ""
            );
        }
    }

    // Prints constants without their type, e.g., "1" instead of "bv64(1)".
    private static String valueString(Expression value) {
        return switch (value) {
            case IntLiteral lit -> lit.getValue().toString();
            case ToMemoryCast cast when cast.getOperand() instanceof IntLiteral lit -> lit.getValue().toString();
            default -> value.toString();
        };
    }

    private String eventToNode(Event e) {
        if (e instanceof Init init) {
            return String.format("\"I(%s, %s)\"", getAddressString(init), valueString(execution.value(init)));
        }
        return "e" + execution.getId(e);
    }

    private String nodeLabel(Event e) {
        // We have MemEvent + Fence + Local + Assert
        final String tag = switch (e) {
            case Load load -> String.format("%s = R(%s%s)",
                    valueString(execution.value(load)), getAddressString(load), memoryOrderString(load));
            case Store store -> String.format("W(%s, %s%s)",
                    getAddressString(store), valueString(execution.value(store)), memoryOrderString(store));
            case MemoryCoreEvent mem -> String.format("%s(%s)", mem.getClass().getSimpleName(), getAddressString(mem));
            case Local local -> String.format("%s(%s) <- %s",
                    local.getResultRegister(),
                    valueString(execution.result(local)),
                    local.getExpr()
            );
            case Assert assertion -> String.format("Assertion(%s)", !execution.assertionViolated(assertion));
            default -> e.toString();
        };
        final Thread thread = e.getThread();
        final String callStack = makeContextString(
            synContext.getContextInfo(e).getContextOfType(CallContext.class), " -> \\n");
        final String scope = thread.hasScope() ? "@" + thread.getScopeHierarchy() : "";
        final String nodeString = String.format("%s:T%s%s\\nE%s %s%s\\n%s",
                thread.getName(),
                thread.getId(),
                scope,
                e.getGlobalId(),
                callStack.isEmpty() ? callStack : callStack + " -> \\n",
                getSourceLocationString(e),
                tag)
                .replace("%", "\\%")
                .replace("\"", "\\\""); // We need to escape quotes inside the string
        return "label=\"" + nodeString + "\"";
    }

    private static String memoryOrderString(MemoryCoreEvent e) {
        final MemoryCoreEvent.MemoryOrder mo = e.getMetadata(MemoryCoreEvent.MemoryOrder.class);
        return mo == null ? "" : ", " + mo.value();
    }

    private void appendEdge(BiPredicate<Event, Event> filter, Event a, Event b) {
        if (filter.test(a, b)) {
            graphviz.addEdge(eventToNode(a), eventToNode(b), (String[]) null);
        }
    }

    private void appendNode(Event e, String... attributes) {
        graphviz.addNode(eventToNode(e), attributes);
    }

    public static Path generateGraphvizFile(Execution execution,
                                            String graphName,
                                            BiPredicate<Event, Event> rfFilter,
                                            BiPredicate<Event, Event> coFilter,
                                            Path dir,
                                            String fileNameBase,
                                            SyntacticContextAnalysis synContext,
                                            boolean convertToPNG,
                                            Configuration config) {
        Path fileVio = dir.resolve(fileNameBase + ".dot");
        try {
            Files.createDirectories(fileVio.getParent());
        } catch (IOException e) {
            logger.error(e.getMessage());
            return null;
        }

        try (Writer writer = Files.newBufferedWriter(fileVio)) {
            // Create .dot file
            ExecutionGraphVisualizer visualizer = new ExecutionGraphVisualizer();
            visualizer.setRelationsToShow(config);
            visualizer.setSyntacticContext(synContext)
                      .setFilter(RF, rfFilter)
                      .setFilter(CO, coFilter)
                      .generateGraphOfExecution(writer, graphName, execution);

            writer.flush();
            if (convertToPNG) {
                fileVio = Graphviz.convert(fileVio);
            }
            logger.info("Witness stored into {}.", fileVio);
            return fileVio;
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        return null;
    }
}
