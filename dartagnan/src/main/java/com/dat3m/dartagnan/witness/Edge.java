package com.dat3m.dartagnan.witness;

public class Edge extends ElemWithAttributes implements Comparable<Edge> {

	private final Node source;
	private final Node target;
	
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
		return attributes.containsKey("startline");
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
		str.append("  <edge source=\"").append(source.getId()).append("\" target=\"").append(target.getId()).append("\">\n");
		for(String attr : attributes.keySet()) {
			str.append("    <data key=\"").append(attr).append("\">").append(attributes.get(attr)).append("</data>\n");
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
