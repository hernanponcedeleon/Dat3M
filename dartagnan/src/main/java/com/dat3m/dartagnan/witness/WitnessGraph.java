package com.dat3m.dartagnan.witness;

import static com.dat3m.dartagnan.program.utils.EType.MEMORY;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.utils.Utils;
import com.google.common.collect.Lists;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class WitnessGraph extends ElemWithAttributes {

	private static final Logger logger = LogManager.getLogger(WitnessGraph.class);  

	private SortedSet<Node> nodes = new TreeSet<Node>();
	private SortedSet<Edge> edges = new TreeSet<Edge>();
	
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

	public String getProgram() {
		return attributes.get("programfile");
	}
	
	public String toXML() {
		StringBuilder str = new StringBuilder();
		str.append("<graph edgedefault=\"directed\">\n");
		for(String attr : attributes.keySet()) {
			str.append("  <data key=\"" + attr + "\">" + attributes.get(attr) + "</data>\n");
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
		logger.info("Encoding witness graph for program " + getProgram());
		BoolExpr enc = ctx.mkTrue();
		List<Event> previous = new ArrayList<Event>();
		int count = 0;
		for(Edge e : edges) {
			if(e.hasCline()) {
				List<Event> events = program.getEvents().stream().filter(f -> f.hasFilter(MEMORY) && f.getCLine() == e.getCline()).collect(Collectors.toList());
				if(!previous.isEmpty() && !events.isEmpty() && previous.get(0).getCLine() != e.getCline()) {
					count++;
					logger.info("Adding hb edge from line " + previous.get(0).getCLine() + " to line " + e.getCline());
					enc = ctx.mkAnd(enc, ctx.mkOr(Lists.cartesianProduct(previous, events).stream().map(p -> Utils.edge("hb", p.get(0), p.get(1), ctx)).collect(Collectors.toList()).toArray(BoolExpr[]::new)));
				}
				previous = events;
			}
		}
        logger.info("Number of hb edges added: " + count);
		return enc;
	}
}
