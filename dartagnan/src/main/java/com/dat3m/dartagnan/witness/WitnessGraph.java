package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.*;

import java.io.FileWriter;
import java.io.IOException;
import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.witness.EdgeAttributes.*;
import static com.dat3m.dartagnan.witness.GraphAttributes.PROGRAMFILE;

public class WitnessGraph extends ElemWithAttributes {

    private final SortedSet<Node> nodes = new TreeSet<>();
    // The order in which we add / traverse edges is important, thus a List
    private final List<Edge> edges = new ArrayList<>();

    public void addNode(String id) {
        nodes.add(new Node(id));
    }

    public boolean hasNode(String id) {
        return nodes.stream().anyMatch(n -> n.getId().equals(id));
    }

    public Node getNode(String id) {
        return nodes.stream().filter(n -> n.getId().equals(id)).findFirst().get();
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

    public BooleanFormula encode(EncodingContext context) {
        Program program = context.getTask().getProgram();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        FormulaManager fmgr = context.getFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        List<MemoryEvent> previous = new ArrayList<>();
        for (Edge edge : edges.stream().filter(Edge::hasCline).toList()) {
            List<MemoryEvent> events = getEventsFromEdge(program, edge);
            if (!previous.isEmpty() && !events.isEmpty()) {
                enc.add(bmgr.or(Lists.cartesianProduct(previous, events).stream()
                        .map(p -> context.edgeVariable("hb", p.get(0), p.get(1)))
                        .toArray(BooleanFormula[]::new)));
            }
            if (!events.isEmpty()) {
                previous = events;
            }
            // FIXME: The reliance on "globalId" for matching is very fragile (see comment
            // in WitnessBuilder)
            if (edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(LOADEDVALUE.toString())) {
                int id = Integer.parseInt(edge.getAttributed(EVENTID.toString()));
                Optional<Load> load = program.getThreadEvents(Load.class).stream().filter(e -> e.getGlobalId() == id)
                        .findFirst();
                if (load.isPresent()) {
                    String loadedValue = edge.getAttributed(LOADEDVALUE.toString());
                    enc.add(equalsParsedValue(context.result(load.get()), loadedValue, fmgr));
                }
            }
            if (edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(STOREDVALUE.toString())) {
                int id = Integer.parseInt(edge.getAttributed(EVENTID.toString()));
                Optional<Store> store = program.getThreadEvents(Store.class).stream().filter(e -> e.getGlobalId() == id)
                        .findFirst();
                if (store.isPresent()) {
                    String storedValue = edge.getAttributed(STOREDVALUE.toString());
                    enc.add(equalsParsedValue(context.value(store.get()), storedValue, fmgr));
                }
            }
        }
        return bmgr.and(enc);
    }

    private List<MemoryEvent> getEventsFromEdge(Program program, Edge edge) {
        Stream<MemoryEvent> res = Stream.empty();
        if (edge.hasAttributed(EVENTID.toString())) {
            res = program.getThreadEvents(MemoryEvent.class).stream()
                    .filter(e -> e.getGlobalId() == Integer.parseInt(edge.getAttributed(EVENTID.toString())));
        } else if (edge.hasCline()) {
            res = program.getThreadEvents(MemoryEvent.class).stream()
                    .filter(e -> e.hasMetadata(SourceLocation.class))
                    .filter(e -> e.getMetadata(SourceLocation.class).lineNumber() == edge.getCline());
        }
        return res.collect(Collectors.toList());
    }

    private <T1 extends Event, T2 extends Event> EventGraph getHbKnowledge(Program program, Class<T1> c1,
            Class<T2> c2) {
        EventGraph k = new EventGraph();
        MemoryEvent current = null;
        MemoryEvent last = null;
        List<MemoryEvent> currents;
        for (Edge e : getEdges()) {
            currents = getEventsFromEdge(program, e);
            current = currents.size() == 1 ? currents.get(0) : null;
            if (current != null && last != null && c1.isInstance(last) && c2.isInstance(current)
                    && !last.getThread().equals(current.getThread())) {
                k.add(last, current);
            }
            last = current;
        }
        return k;
    }

    public EventGraph getReadFromKnowledge(Program program) {
        return getHbKnowledge(program, Store.class, Load.class);
    }

    public EventGraph getCoherenceKnowledge(Program program) {
        return getHbKnowledge(program, Store.class, Store.class);
    }

    private static BooleanFormula equalsParsedValue(Formula operand, String value, FormulaManager formulaManager) {
        if (operand instanceof BooleanFormula bool) {
            return switch (value) {
                case "false", "0" -> formulaManager.getBooleanFormulaManager().not(bool);
                default -> bool;
            };
        }
        BigInteger integerValue = switch (value) {
            case "false" -> BigInteger.ZERO;
            case "true" -> BigInteger.ONE;
            default -> new BigInteger(value);
        };
        if (operand instanceof NumeralFormula.IntegerFormula integer) {
            IntegerFormulaManager imgr = formulaManager.getIntegerFormulaManager();
            return imgr.equal(integer, imgr.makeNumber(integerValue));
        }
        assert operand instanceof BitvectorFormula;
        BitvectorFormula bitvector = (BitvectorFormula) operand;
        BitvectorFormulaManager bvmgr = formulaManager.getBitvectorFormulaManager();
        return bvmgr.equal(bitvector, bvmgr.makeBitvector(bvmgr.getLength(bitvector), integerValue));
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
