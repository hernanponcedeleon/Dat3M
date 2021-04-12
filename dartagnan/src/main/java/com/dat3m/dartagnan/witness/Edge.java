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
	
	public String toXML() {
		StringBuilder str = new StringBuilder();
		str.append("  <edge source=\"" + source.toString() + "\" target=\"" + target.toString() + "\">\n");
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
