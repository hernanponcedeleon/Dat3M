package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.google.common.collect.Lists;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.utils.EType.*;
import static com.dat3m.dartagnan.program.utils.Utils.convertToIntegerFormula;
import static com.dat3m.dartagnan.witness.GraphAttributes.*;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;

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
	
	public BooleanFormula encode(Program program, SolverContext ctx) {
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
		
		BooleanFormula enc = bmgr.makeTrue();
		List<Event> previous = new ArrayList<>();
		for(Edge edge : edges.stream().filter(Edge::hasCline).collect(Collectors.toList())) {
			List<Event> events = program.getCache().getEvents(FilterBasic.get(MEMORY)).stream().filter(e -> e.getCLine() == edge.getCline()).collect(Collectors.toList());
			if(!previous.isEmpty() && !events.isEmpty()) {
				enc = bmgr.and(enc, bmgr.or(Lists.cartesianProduct(previous, events).stream().map(p -> imgr.lessThan(intVar("hb", p.get(0), ctx), intVar("hb", p.get(1), ctx))).collect(Collectors.toList()).toArray(BooleanFormula[]::new)));
			}
			if(!events.isEmpty()) {
				previous = events;				
			}
			if(edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(LOADEDVALUE.toString())) {
				int id = Integer.parseInt(edge.getAttributed(EVENTID.toString()));
				Load load = (Load)program.getCache().getEvents(FilterBasic.get(READ)).stream().filter(e -> e.getUId() == id).findFirst().get();
				BigInteger value = new BigInteger(edge.getAttributed(LOADEDVALUE.toString()));
				enc = bmgr.and(enc, imgr.equal(convertToIntegerFormula(load.getResultRegisterExpr(), ctx), imgr.makeNumber(value)));
			}
			if(edge.hasAttributed(EVENTID.toString()) && edge.hasAttributed(STOREDVALUE.toString())) {
				int id = Integer.parseInt(edge.getAttributed(EVENTID.toString()));
				Store store = (Store)program.getCache().getEvents(FilterBasic.get(WRITE)).stream().filter(e -> e.getUId() == id).findFirst().get();
				BigInteger value = new BigInteger(edge.getAttributed(STOREDVALUE.toString()));
				enc = bmgr.and(enc, imgr.equal(convertToIntegerFormula(store.getMemValueExpr(), ctx), imgr.makeNumber(value)));
			}
		}
		return enc;
	}
}
