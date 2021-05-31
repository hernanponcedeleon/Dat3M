package com.dat3m.dartagnan.witness;

import static com.dat3m.dartagnan.program.utils.EType.MEMORY;
import static com.dat3m.dartagnan.witness.EdgeAttributes.EVENTID;
import static com.dat3m.dartagnan.witness.EdgeAttributes.HBPOS;
import static com.dat3m.dartagnan.witness.GraphAttributes.PRODUCER;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static java.lang.Integer.parseInt;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.google.common.collect.Lists;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class WitnessGraph extends ElemWithAttributes {

	private SortedSet<Node> nodes = new TreeSet<>();
	// The order in which we add / traverse edges is important, thus a List
	private List<Edge> edges = new ArrayList<>();
	
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
		return attributes.get("programfile");
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
	
	public BoolExpr encode(Program program, Context ctx) {
		BoolExpr enc = ctx.mkTrue();
		List<Event> previous = new ArrayList<>();
		for(Edge edge : edges.stream().filter(Edge::hasCline).collect(Collectors.toList())) {
			if(getAttributed(PRODUCER.toString()).equals("Dartagnan") 
					&& edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(HBPOS.toString())) {
				Event ev = program.getEvents().stream().filter(e -> e.getCId() == parseInt(edge.getAttributed(EVENTID.toString()))).findFirst().get();
				enc = ctx.mkAnd(enc, ctx.mkEq(intVar("hb", ev, ctx), ctx.mkInt(parseInt(edge.getAttributed(HBPOS.toString())))));
			} 
			List<Event> events = program.getCache().getEvents(FilterBasic.get(MEMORY)).stream().filter(e -> e.getCLine() == edge.getCline()).collect(Collectors.toList());
			if(!previous.isEmpty() && !events.isEmpty()) {
				enc = ctx.mkAnd(enc, ctx.mkOr(Lists.cartesianProduct(previous, events).stream().map(p -> ctx.mkLe(intVar("hb", p.get(0), ctx), intVar("hb", p.get(1), ctx))).collect(Collectors.toList()).toArray(BoolExpr[]::new)));
			}
			if(!events.isEmpty()) {
				previous = events;				
			}				
		}
		return enc;
	}
}
