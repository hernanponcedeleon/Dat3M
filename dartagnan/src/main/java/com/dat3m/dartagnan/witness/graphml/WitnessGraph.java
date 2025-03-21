package com.dat3m.dartagnan.witness.graphml;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.witness.graphml.GraphAttributes.PRODUCER;
import static com.dat3m.dartagnan.witness.graphml.GraphAttributes.PROGRAMFILE;
import static com.dat3m.dartagnan.witness.graphml.NodeAttributes.ENTRY;
import static com.dat3m.dartagnan.witness.graphml.NodeAttributes.VIOLATION;

public class WitnessGraph extends ElemWithAttributes {

    private final SortedSet<Node> nodes = new TreeSet<>();
    // The order in which we add / traverse edges is important, thus a List
    private final List<Edge> edges = new ArrayList<>();

    public boolean isEmpty() {
        return edges.isEmpty();
    }

    public void addNode(String id) {
        nodes.add(new Node(id));
    }

    public boolean hasNode(String id) {
        return nodes.stream().anyMatch(n -> n.getId().equals(id));
    }

    public Node getNode(String id) {
        return nodes.stream().filter(n -> n.getId().equals(id)).findFirst().orElseThrow(() -> new RuntimeException("Witness graph does not contain node with id " + id));
    }

    public Node getEntryNode() {
        return nodes.stream().filter(n -> n.hasAttributed(ENTRY.toString())).findFirst().orElseThrow(() -> new RuntimeException("Witness graph does not contain entry node"));
    }

    public Node getViolationNode() {
        return nodes.stream().filter(n -> n.hasAttributed(VIOLATION.toString())).findAny().orElseThrow(() -> new RuntimeException("Witness graph does not contain violation node"));
    }

    public void addEdge(Edge e) {
        nodes.add(e.getSource());
        nodes.add(e.getTarget());
        edges.add(e);
    }

    public Set<Node> getNodes() {
        return nodes;
    }

    public List<Edge> getEdges() {
        return edges;
    }

    public List<Edge> getPathToViolation() {
        List<Edge> ret = new ArrayList<>();
        Node cur = getViolationNode();
        while(cur != getEntryNode()) {
            // Local variables in lambdas have to be final, thus the copy
            final Node copy = cur;
            Edge nextEdge = getEdges().stream().filter(e -> e.getTarget().equals(copy)).findAny().get();
            ret.add(nextEdge);
            cur = nextEdge.getSource();
        }
        // Return path from entry to violation
        Collections.reverse(ret);
        return ret;
    }

    public String getProgram() {
        return attributes.get(PROGRAMFILE.toString());
    }

    public String toXML() {
        StringBuilder str = new StringBuilder();
        str.append("<graph edgedefault=\"directed\">\n");
        for (String attr : attributes.keySet()) {
            str.append("  <data key=\"").append(attr).append("\">").append(attributes.get(attr)).append("</data>\n");
        }
        for (Node n : nodes) {
            str.append(n.toXML());
        }
        for (Edge e : edges) {
            str.append(e.toXML());
        }
        str.append("</graph>");
        return str.toString();
    }

    private List<MemoryCoreEvent> getEventsFromEdge(Program program, Edge edge) {
        return edge.hasCline() ?
            program.getThreadEvents(MemoryCoreEvent.class).stream()
                .filter(e -> e.hasMetadata(SourceLocation.class))
                .filter(e -> e.getMetadata(SourceLocation.class).lineNumber() == edge.getCline())
                .toList() :
            Collections.emptyList();
    }

    public BooleanFormula encode(EncodingContext context) {
        // If there is something to encode (i.e., edges is not empty),
        // then there must be a violation node.
        Preconditions.checkState(edges.isEmpty() || !getPathToViolation().isEmpty());
        Program program = context.getTask().getProgram();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        List<MemoryCoreEvent> previous = new ArrayList<>();
        for (Edge edge : edges.stream().filter(Edge::hasCline).toList()) {
            List<MemoryCoreEvent> events = getEventsFromEdge(program, edge);
            if (!previous.isEmpty() && !events.isEmpty()) {
                // This generates hb-constraints between events that might not be in the may-set.
                // However, this is required to obtain the desired ordering constraint between non-neighboring events.
                enc.add(bmgr.or(Lists.cartesianProduct(previous, events).stream()
                        .map(p -> context.edgeVariable("hb", p.get(0), p.get(1)))
                        .toArray(BooleanFormula[]::new)));
            }
            previous = events;
        }
        return bmgr.and(enc);
    }

    // FIXME: the code to generate RA knowledge from a violation witness is extremely fragile.
    // We should rewrite this code to extract knowledge about the hb relation (from which the
    // witness was actually generated) rather than rf and co. Then, the extended relation
    // analysis should propagate this knowledge top-down to reach the base relations.

    private boolean graphEdgeImpliesHbEdge() {
        return hasAttributed(PRODUCER.toString()) && getAttributed(PRODUCER.toString()).equals("Dartagnan");
    }

    public EventGraph getReadFromKnowledge(Program program, AliasAnalysis alias) {
        MutableEventGraph k = new MapEventGraph();
        MemoryCoreEvent current = null;
        MemoryCoreEvent last = null;
        List<MemoryCoreEvent> currents;
        for (Edge e : getPathToViolation()) {
            currents = getEventsFromEdge(program, e);
            current = currents.size() == 1 ? currents.get(0) : null;
            // If a graph edge implies a hb-relation, inter-thread communication guarantees
            // same address and thus rf.
            if (last instanceof Store && current instanceof Load
                    && ((graphEdgeImpliesHbEdge()
                            && !last.getThread().equals(current.getThread())
                            && alias.mayAlias(last, current))
                        || alias.mustAlias(last, current))) {
                k.add(last, current);
            }
            last = current;
        }
        return k;
    }

    public EventGraph getCoherenceKnowledge(Program program, AliasAnalysis alias) {
        MutableEventGraph k = new MapEventGraph();
        final List<Store> writes = getPathToViolation().stream()
            .filter(e -> getEventsFromEdge(program, e).size() == 1 && getEventsFromEdge(program, e).get(0) instanceof Store)
            .map(e -> (Store) getEventsFromEdge(program, e).get(0)).toList();
        
        for (int i = 0; i < writes.size() - 1; i++) {
            final Store w1 = writes.get(i);
            // Add co-edges to all later same-address writes.
            // Some tools create two edges for the same store (e.g. CPAChecker for pthread_create)
            // We avoid adding self loops.
            writes.subList(i + 1, writes.size()).stream()
                .filter(w2 -> alias.mustAlias(w1, w2) && w1 != w2)
                .forEach(w2 -> k.add(w1, w2));
            // Special case for cross-thread edges.
            final Store immSucc = writes.get(i+1);
            if(graphEdgeImpliesHbEdge() && !w1.getThread().equals(immSucc.getThread())
                && alias.mayAlias(w1, immSucc)) {
                k.add(w1, immSucc);
            }
        }
        return k;
    }

    public void write() {
        try (FileWriter fw = new FileWriter(String.format("%s/witness.graphml", getOrCreateOutputDirectory()))) {
            fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
            fw.write(
                    "<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
            for (GraphAttributes attr : GraphAttributes.values()) {
                fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"graph\" id=\"" + attr
                        + "\"/>\n");
            }
            for (NodeAttributes attr : NodeAttributes.values()) {
                fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"boolean\" for=\"node\" id=\"" + attr
                        + "\"/>\n");
            }
            for (EdgeAttributes attr : EdgeAttributes.values()) {
                fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"edge\" id=\"" + attr
                        + "\"/>\n");
            }
            fw.write(toXML());
            fw.write("</graphml>\n");
        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }
}
