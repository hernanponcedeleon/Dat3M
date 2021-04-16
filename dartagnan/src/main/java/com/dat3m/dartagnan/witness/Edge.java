package com.dat3m.dartagnan.witness;

public class Edge extends ElemWithAttributes implements Comparable<Edge> {

	private Node source;
	private Node target;
	
	public Edge(Node s, Node t) {
		this.source = s;
		this.target= t;
	}
	
	public Node getSource() {
		return source;
	}
	
	public Node getTarget() {
		return target;
	}
	
	public boolean hasCline() {
		return attributes.keySet().contains("startline");
	}
	
	public Integer getCline() {
		return Integer.parseInt(attributes.get("startline"));
	}
	
	@Override
	public String toString() {
		return source.getId() + " -> " + target.getId();
	}
	
	public String toXML() {
		StringBuilder str = new StringBuilder();
		str.append("  <edge source=\"" + source.getId() + "\" target=\"" + target.getId() + "\">\n");
		for(String attr : attributes.keySet()) {
			str.append("    <data key=\"" + attr + "\">" + attributes.get(attr) + "</data>\n");
		}
		str.append("  </edge>\n");
		return str.toString();
	}
	
	@Override
	public int compareTo(Edge other) {
		if(source.compareTo(other.source) == 0) {
			return target.compareTo(other.target);
		}
		return source.compareTo(other.source);
	}
}
