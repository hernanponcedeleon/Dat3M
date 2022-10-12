package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.google.common.collect.Lists;
import com.google.common.io.Files;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;

import java.io.FileWriter;
import java.io.IOException;
import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.Tag.*;
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
		for(String attr : attributes.keySet()) {
			str.append("  <data key=\"").append(attr).append("\">").append(attributes.get(attr)).append("</data>\n");
		}
		for(Node n : nodes) {
			str.append(n.toXML());
		}
		for(Edge e : edges) {
			str.append(e.toXML());
		}
		str.append("</graph>");
		return str.toString();
	}
	
	public BooleanFormula encode(EncodingContext context) {
		Program program = context.getTask().getProgram();
		BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
		IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
		
		BooleanFormula enc = bmgr.makeTrue();
		List<Event> previous = new ArrayList<>();
		for(Edge edge : edges.stream().filter(Edge::hasCline).collect(Collectors.toList())) {
			List<Event> events = program.getCache().getEvents(FilterBasic.get(MEMORY)).stream()
					.filter(e -> e.getCLine() == edge.getCline())
					.collect(Collectors.toList());
			if(!previous.isEmpty() && !events.isEmpty()) {
				enc = bmgr.and(enc, bmgr.or(Lists.cartesianProduct(previous, events).stream()
						.map(p -> context.edgeVariable("hb", p.get(0), p.get(1)))
						.toArray(BooleanFormula[]::new)));
			}
			if(!events.isEmpty()) {
				previous = events;				
			}
			if(edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(LOADEDVALUE.toString())) {
				int id = Integer.parseInt(edge.getAttributed(EVENTID.toString()));
				if(program.getCache().getEvents(FilterBasic.get(READ)).stream().anyMatch(e -> e.getUId() == id)) {
					Load load = (Load)program.getCache().getEvents(FilterBasic.get(READ)).stream().filter(e -> e.getUId() == id).findFirst().get();
					BigInteger value = new BigInteger(edge.getAttributed(LOADEDVALUE.toString()));
					enc = bmgr.and(enc, context.equal(context.result(load), imgr.makeNumber(value)));
				}
			}
			if(edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(STOREDVALUE.toString())) {
				int id = Integer.parseInt(edge.getAttributed(EVENTID.toString()));
				if(program.getCache().getEvents(FilterBasic.get(WRITE)).stream().anyMatch(e -> e.getUId() == id)) {
					Store store = (Store)program.getCache().getEvents(FilterBasic.get(WRITE)).stream().filter(e -> e.getUId() == id).findFirst().get();
					BigInteger value = new BigInteger(edge.getAttributed(STOREDVALUE.toString()));
					enc = bmgr.and(enc, context.equal(context.value(store), imgr.makeNumber(value)));
				}
			}
		}
		return enc;
	}
	
	public void write() {
		try (FileWriter fw = new FileWriter(String.format("%s/%s.graphml", 
				System.getenv("DAT3M_OUTPUT"), Files.getNameWithoutExtension(getProgram())))) {
			fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n");
			fw.write("<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n");
			for(GraphAttributes attr : GraphAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"graph\" id=\"" + attr + "\"/>\n");}
			for(NodeAttributes attr : NodeAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"boolean\" for=\"node\" id=\"" + attr + "\"/>\n");}
			for(EdgeAttributes attr : EdgeAttributes.values()) {fw.write("<key attr.name=\"" + attr.toString() + "\" attr.type=\"string\" for=\"edge\" id=\"" + attr + "\"/>\n");}
			fw.write(toXML());
			fw.write("</graphml>\n");
		} catch (IOException e1) {
			e1.printStackTrace();
		}		
	}
}
