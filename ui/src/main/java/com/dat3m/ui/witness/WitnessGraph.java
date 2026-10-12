package com.dat3m.ui.witness;

import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.verification.VerificationResult;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.RelationModel.EdgeModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;
import com.dat3m.dartagnan.verification.model.event.AssertModel;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.verification.model.event.GenericVisibleEventModel;
import com.dat3m.dartagnan.verification.model.event.LocalModel;
import com.dat3m.dartagnan.verification.model.event.MemoryEventModel;
import com.dat3m.dartagnan.verification.model.event.StoreModel;
import com.dat3m.dartagnan.wmm.axiom.Axiom;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.UnaryOperator;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis.getSourceLocationString;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.PO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

/*
    A snapshot of a witness execution that is independent of the solver, so that it can be shown after
    the solver has been closed.
    Nodes are arranged in columns (one for the initial writes and one per thread) and rows (program order).
 */
public record WitnessGraph(List<String> columns, List<Node> nodes, List<Edge> edges,
                           List<AxiomInfo> axioms, List<MemoryValue> finalMemory) {

    public static final String FR = "fr";
    private static final String INIT_COLUMN = "Init";
    private static final String UNKNOWN_LOCATION = "@unknown";

    public record Node(int id, int column, int row, String label, String sublabel, boolean isInit,
                       Map<String, String> details) {
    }

    public record Edge(String relation, int from, int to) {
    }

    public record AxiomInfo(String term, String status, boolean isViolated) {
    }

    public record MemoryValue(String address, String value) {
    }

    // Applies the function to all texts that may mention the source file, e.g., to replace the name of the file.
    public WitnessGraph mapSourceTexts(UnaryOperator<String> function) {
        final List<Node> mappedNodes = nodes.stream().map(node -> {
            final Map<String, String> details = new LinkedHashMap<>();
            node.details().forEach((key, value) -> details.put(key, function.apply(value)));
            return new Node(node.id(), node.column(), node.row(), node.label(), function.apply(node.sublabel()),
                    node.isInit(), Collections.unmodifiableMap(details));
        }).toList();
        return new WitnessGraph(columns, mappedNodes, edges, axioms, finalMemory);
    }

    public List<String> relations() {
        return edges.stream().map(Edge::relation).distinct().toList();
    }

    // Must be called while the solver that produced the result is still open.
    public static WitnessGraph from(VerificationResult result) {
        return new Builder(ExecutionModelManager.fromIREvaluator(result.getModel()), result).build();
    }

    private static final class Builder {

        private record RawEdge(String relation, EventModel from, EventModel to) {
        }

        private final ExecutionModelNext model;
        private final VerificationResult result;
        private final List<MemoryObjectModel> sortedMemoryObjects;

        private Builder(ExecutionModelNext model, VerificationResult result) {
            this.model = model;
            this.result = result;
            this.sortedMemoryObjects = model.getMemoryLayoutMap().values().stream()
                    .sorted(Comparator.comparing(object -> (BigInteger) object.address().value()))
                    .toList();
        }

        private WitnessGraph build() {
            // ----- Events of the program threads -----
            final Map<ThreadModel, List<EventModel>> shownEvents = new LinkedHashMap<>();
            for (ThreadModel thread : model.getThreadModels()) {
                if (IRHelper.isInitThread(thread.getThread())) {
                    continue;
                }
                final List<EventModel> events = thread.getEventModels().stream().filter(Builder::isShown).toList();
                if (!events.isEmpty()) {
                    shownEvents.put(thread, events);
                }
            }
            final Set<EventModel> shown = shownEvents.values().stream().flatMap(List::stream).collect(Collectors.toSet());

            // ----- Edges -----
            final List<RawEdge> rawEdges = new ArrayList<>();
            for (List<EventModel> events : shownEvents.values()) {
                for (int i = 1; i < events.size(); i++) {
                    rawEdges.add(new RawEdge(PO, events.get(i - 1), events.get(i)));
                }
            }
            final Set<EdgeModel> coEdges = getEdges(CO);
            getEdges(RF).forEach(edge -> rawEdges.add(new RawEdge(RF, edge.from(), edge.to())));
            // Like in the graphical witnesses, coherence edges within a thread are omitted because they follow from po.
            getImmediateCoherence(coEdges).stream()
                    .filter(edge -> !edge.from().getThreadModel().equals(edge.to().getThreadModel()))
                    .forEach(edge -> rawEdges.add(new RawEdge(CO, edge.from(), edge.to())));
            getImmediateFromRead(getEdges(FR), coEdges)
                    .forEach(edge -> rawEdges.add(new RawEdge(FR, edge.from(), edge.to())));
            rawEdges.removeIf(edge -> !(shown.contains(edge.from()) || isInitWrite(edge.from()))
                    || !(shown.contains(edge.to()) || isInitWrite(edge.to())));

            // ----- Nodes -----
            final List<StoreModel> initWrites = rawEdges.stream()
                    .flatMap(edge -> Stream.of(edge.from(), edge.to()))
                    .filter(Builder::isInitWrite)
                    .map(StoreModel.class::cast)
                    .distinct()
                    .sorted(Comparator.comparing(write -> (BigInteger) write.getAccessedAddress().value()))
                    .toList();

            final List<String> columns = new ArrayList<>();
            final List<Node> nodes = new ArrayList<>();
            final Map<EventModel, Integer> ids = new HashMap<>();
            if (!initWrites.isEmpty()) {
                columns.add(INIT_COLUMN);
                for (StoreModel write : initWrites) {
                    ids.put(write, nodes.size());
                    nodes.add(toNode(nodes.size(), 0, nodes.size(), write, INIT_COLUMN));
                }
            }
            for (Map.Entry<ThreadModel, List<EventModel>> entry : shownEvents.entrySet()) {
                final String threadName = "%s (T%d)".formatted(entry.getKey().getName(), entry.getKey().getId());
                final int column = columns.size();
                columns.add(threadName);
                int row = 0;
                for (EventModel event : entry.getValue()) {
                    ids.put(event, nodes.size());
                    nodes.add(toNode(nodes.size(), column, row++, event, threadName));
                }
            }

            final Set<Edge> edges = new LinkedHashSet<>();
            rawEdges.forEach(edge -> edges.add(new Edge(edge.relation(), ids.get(edge.from()), ids.get(edge.to()))));

            return new WitnessGraph(List.copyOf(columns), List.copyOf(nodes), List.copyOf(edges),
                    getAxioms(), getFinalMemory(coEdges));
        }

        private static boolean isShown(EventModel event) {
            return event instanceof MemoryEventModel
                    || event instanceof GenericVisibleEventModel
                    || event instanceof LocalModel
                    || event instanceof AssertModel;
        }

        private static boolean isInitWrite(EventModel event) {
            return event instanceof StoreModel && event.getEvent() instanceof Init;
        }

        private Set<EdgeModel> getEdges(String relationName) {
            return model.getRelationModels().stream()
                    .filter(relation -> relation.getRelation().hasName(relationName))
                    .findFirst()
                    .map(RelationModel::getEdgeModels)
                    .orElse(Set.of());
        }

        // Removes the edges of co that are implied by transitivity.
        private List<EdgeModel> getImmediateCoherence(Set<EdgeModel> coEdges) {
            final List<EdgeModel> immediate = new ArrayList<>();
            for (Set<StoreModel> writes : model.getAddressWritesMap().values()) {
                for (StoreModel first : writes) {
                    for (StoreModel second : writes) {
                        if (!coEdges.contains(new EdgeModel(first, second))) {
                            continue;
                        }
                        final boolean hasIntermediate = writes.stream().anyMatch(middle ->
                                coEdges.contains(new EdgeModel(first, middle)) && coEdges.contains(new EdgeModel(middle, second)));
                        if (!hasIntermediate) {
                            immediate.add(new EdgeModel(first, second));
                        }
                    }
                }
            }
            return immediate;
        }

        // Keeps only the edges from a read to the co-earliest writes that overwrite the value it read.
        private List<EdgeModel> getImmediateFromRead(Set<EdgeModel> frEdges, Set<EdgeModel> coEdges) {
            final Map<EventModel, List<EventModel>> targets = new LinkedHashMap<>();
            frEdges.forEach(edge -> targets.computeIfAbsent(edge.from(), key -> new ArrayList<>()).add(edge.to()));
            final List<EdgeModel> immediate = new ArrayList<>();
            targets.forEach((read, writes) -> {
                for (EventModel write : writes) {
                    if (writes.stream().noneMatch(earlier -> coEdges.contains(new EdgeModel(earlier, write)))) {
                        immediate.add(new EdgeModel(read, write));
                    }
                }
            });
            return immediate;
        }

        private Node toNode(int id, int column, int row, EventModel event, String threadName) {
            final Map<String, String> details = new LinkedHashMap<>();
            details.put("Thread", threadName);
            details.put("Event", "E" + event.getEvent().getGlobalId());
            String label = event.getEvent().toString();
            if (event instanceof MemoryEventModel memoryEvent) {
                final String address = getAddressString(memoryEvent.getAccessedAddress());
                final String value = String.valueOf(memoryEvent.getValue());
                final boolean isWrite = event instanceof StoreModel;
                label = "%s(%s, %s)".formatted(isWrite ? "W" : "R", address, value);
                details.put("Kind", isWrite ? "Write" : "Read");
                details.put("Address", address);
                details.put(isWrite ? "Value written" : "Value read", value);
            } else if (event instanceof LocalModel local) {
                label = "%s <- %s".formatted(local.getEvent().getResultRegister(), local.getValue());
                details.put("Kind", "Local computation");
                details.put("Value", String.valueOf(local.getValue()));
            } else if (event instanceof AssertModel assertion) {
                label = "Assertion(%s)".formatted(assertion.getResult());
                details.put("Kind", "Assertion");
                details.put("Holds", String.valueOf(assertion.getResult()));
            }
            final String location = getSourceLocationString(event.getEvent());
            final String sourceLocation = location.equals(UNKNOWN_LOCATION) ? "" : location;
            if (!sourceLocation.isBlank()) {
                details.put("Source", sourceLocation);
            }
            details.put("Instruction", event.getEvent().toString());
            final boolean isInit = isInitWrite(event);
            final String sublabel = isInit ? "initial value"
                    : !sourceLocation.isBlank() ? sourceLocation
                    : event.getEvent().toString();
            return new Node(id, column, row, label, sublabel, isInit, Collections.unmodifiableMap(details));
        }

        private String getAddressString(ValueModel address) {
            if (!(address.value() instanceof BigInteger addressValue)) {
                return String.valueOf(address);
            }
            MemoryObjectModel accessed = null;
            for (MemoryObjectModel object : sortedMemoryObjects) {
                if (((BigInteger) object.address().value()).compareTo(addressValue) <= 0) {
                    accessed = object;
                }
            }
            if (accessed == null) {
                return addressValue + " [OOB]";
            }
            final BigInteger offset = addressValue.subtract((BigInteger) accessed.address().value());
            final boolean isOutOfBounds = offset.compareTo(accessed.size()) >= 0;
            return accessed.object()
                    + (offset.signum() != 0 ? " + " + offset : "")
                    + (isOutOfBounds ? " [OOB]" : "");
        }

        private List<AxiomInfo> getAxioms() {
            final Set<Axiom> violated = new HashSet<>(model.getFlaggedAxioms());
            final List<AxiomInfo> axioms = new ArrayList<>();
            for (Axiom axiom : result.getTask().getMemoryModel().getAxioms()) {
                final boolean isViolated = violated.contains(axiom);
                final String status = !axiom.isFlagged() ? "holds" : isViolated ? "flag raised" : "no flag";
                axioms.add(new AxiomInfo(axiom.toString(), status, isViolated));
            }
            return List.copyOf(axioms);
        }

        // The final value of an address is the value of its co-last write.
        private List<MemoryValue> getFinalMemory(Set<EdgeModel> coEdges) {
            final List<MemoryValue> memory = new ArrayList<>();
            model.getAddressWritesMap().entrySet().stream()
                    .filter(entry -> entry.getKey().value() instanceof BigInteger)
                    // Memory that is only initialized is omitted to keep the list short.
                    .filter(entry -> entry.getValue().stream().anyMatch(write -> !isInitWrite(write)))
                    .sorted(Comparator.comparing(entry -> (BigInteger) entry.getKey().value()))
                    .forEach(entry -> {
                        final Set<StoreModel> writes = entry.getValue();
                        final String values = writes.stream()
                                .filter(write -> writes.stream().noneMatch(later -> coEdges.contains(new EdgeModel(write, later))))
                                .map(write -> String.valueOf(write.getValue()))
                                .distinct()
                                .collect(Collectors.joining(" or "));
                        memory.add(new MemoryValue(getAddressString(entry.getKey()), values));
                    });
            return List.copyOf(memory);
        }
    }
}
