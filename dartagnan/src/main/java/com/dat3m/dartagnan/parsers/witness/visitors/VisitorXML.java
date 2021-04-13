package com.dat3m.dartagnan.parsers.witness.visitors;

import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.parsers.XMLParser.ElementContext;
import com.dat3m.dartagnan.parsers.XMLParserBaseVisitor;
import com.dat3m.dartagnan.parsers.XMLParserVisitor;
import com.dat3m.dartagnan.witness.Edge;
import com.dat3m.dartagnan.witness.Graph;
import com.dat3m.dartagnan.witness.Node;

public class VisitorXML extends XMLParserBaseVisitor<Object> implements XMLParserVisitor<Object> {
	
	private Graph graph = new Graph();
	
	@Override
	public Graph visitDocument(XMLParser.DocumentContext ctx) {
		visitChildren(ctx);
		return graph;
	}

	@Override 
	public Object visitElement(XMLParser.ElementContext ctx) {
		if(ctx.content() != null) {
			if(ctx.Name(0).getText().equals("node")) {
				String name = ctx.attribute(0).STRING().toString();
				name = name.substring(1, name.length()-1);
				graph.addNode(name);
			}
			if(ctx.Name(0).getText().equals("edge")) {
				String name = ctx.attribute(0).STRING().toString();
				name = name.substring(1, name.length()-1);
				Node v0 = graph.hasNode(name) ? graph.getNode(name) : new Node(name);
				name = ctx.attribute(1).STRING().toString();
				name = name.substring(1, name.length()-1);
				Node v1 = graph.hasNode(name) ? graph.getNode(name) : new Node(name);
				Edge edge = new Edge(v0, v1);
				if(ctx.content() != null) {
					for(ElementContext elem : ctx.content().element()) {
						String key = elem.attribute(0).STRING().getText();
						key = key.substring(1, key.length()-1);
						String value = elem.content().getText();
						edge.addAttribute(key, value);
					}
				}
				graph.addEdge(edge);
			}
		}
		return visitChildren(ctx);
	}		
}