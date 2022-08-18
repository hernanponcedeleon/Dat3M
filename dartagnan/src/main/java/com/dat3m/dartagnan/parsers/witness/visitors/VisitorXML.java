package com.dat3m.dartagnan.parsers.witness.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.parsers.XMLParser.ElementContext;
import com.dat3m.dartagnan.parsers.XMLParserBaseVisitor;
import com.dat3m.dartagnan.witness.Edge;
import com.dat3m.dartagnan.witness.Node;
import com.dat3m.dartagnan.witness.WitnessGraph;

import static com.dat3m.dartagnan.witness.GraphAttributes.*;

import java.util.stream.Collectors;

public class VisitorXML extends XMLParserBaseVisitor<Object> {
	
	private final WitnessGraph graph = new WitnessGraph();
	
	@Override
	public WitnessGraph visitDocument(XMLParser.DocumentContext ctx) {
		visitChildren(ctx);
		if(!graph.hasAttributed(PRODUCER.toString())) {
			throw new ParsingException("The witness does not have a producer tag");
		}
		return graph;
	}

	@Override 
	public Object visitElement(XMLParser.ElementContext ctx) {
		if(ctx.content() != null) {
			if(ctx.Name(0).getText().equals("data")) {
				if(ctx.content() != null) {
					String key = ctx.attribute(0).STRING().getText();
					key = key.substring(1, key.length()-1);
					String value = ctx.content().getText();
					if(key.equals(PROGRAMFILE.toString())) {
						graph.addAttribute(key, value);	
					}
					if(key.equals(PRODUCER.toString())) {
						graph.addAttribute(key, value);	
					}
					if(key.equals(UNROLLBOUND.toString())) {
						graph.addAttribute(key, value);	
					}
				}
			}
			if(ctx.Name(0).getText().equals("node")) {
				String name = ctx.attribute(0).STRING().toString();
				name = name.substring(1, name.length()-1);
				graph.addNode(name);
			}
			if(ctx.Name(0).getText().equals("edge")) {
				int idx = ctx.attribute().stream().map(a -> a.Name().toString()).collect(Collectors.toList()).indexOf("source");
				String name = ctx.attribute(idx).STRING().toString();
				name = name.substring(1, name.length()-1);
				Node v0 = graph.hasNode(name) ? graph.getNode(name) : new Node(name);
				idx = ctx.attribute().stream().map(a -> a.Name().toString()).collect(Collectors.toList()).indexOf("target");
				name = ctx.attribute(idx).STRING().toString();
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