package com.dat3m.dartagnan.witness;

import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

public class WitnessGraph extends ElemWithAttributes {

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

	public Set<Edge> getEdges() {
		return edges;
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
}
