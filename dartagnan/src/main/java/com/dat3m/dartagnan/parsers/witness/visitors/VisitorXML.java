package com.dat3m.dartagnan.parsers.witness.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.parsers.XMLParser.ElementContext;
import com.dat3m.dartagnan.parsers.XMLParserBaseVisitor;
import com.dat3m.dartagnan.witness.Edge;
import com.dat3m.dartagnan.witness.ElemWithAttributes;
import com.dat3m.dartagnan.witness.Node;
import com.dat3m.dartagnan.witness.WitnessGraph;

import static com.dat3m.dartagnan.witness.GraphAttributes.*;
import static com.dat3m.dartagnan.witness.NodeAttributes.*;

import java.util.stream.Collectors;

public class VisitorXML extends XMLParserBaseVisitor<Object> {

    private final WitnessGraph graph = new WitnessGraph();
    private ElemWithAttributes current = graph;

    @Override
    public WitnessGraph visitDocument(XMLParser.DocumentContext ctx) {
        visitChildren(ctx);
        if (!graph.hasAttributed(PRODUCER.toString())) {
            throw new ParsingException("The witness does not have a producer tag");
        }
        return graph;
    }

    @Override
    public Object visitElement(XMLParser.ElementContext ctx) {
        if (ctx.Name(0).getText().equals("data")) {
            String key = ctx.attribute(0).STRING().getText();
            key = key.substring(1, key.length() - 1);
            String value = ctx.content().getText();
            if (key.equals(WITNESSTYPE.toString()) && !value.equals("violation_witness")) {
                throw new ParsingException("Dartagnan can only validate violation witnesses");
            }
            current.addAttribute(key, value);
            return null;
        } else if (ctx.Name(0).getText().equals("node")) {
            String name = ctx.attribute(0).STRING().toString();
            name = name.substring(1, name.length() - 1);
            graph.addNode(name);
            current = graph.getNode(name);
            visitChildren(ctx);
            current = graph;
            return null;
        } else if (ctx.Name(0).getText().equals("edge")) {
            Edge edge = new Edge(getNode(ctx, "source"), getNode(ctx, "target"));
            graph.addEdge(edge);
            current = edge;
            visitChildren(ctx);
            current = graph;
            return null;
        }
        return visitChildren(ctx);
    }

    private Node getNode(ElementContext ctx, String vertex) {
        int idx = ctx.attribute().stream().map(a -> a.Name().toString()).collect(Collectors.toList()).indexOf(vertex);
        String name = ctx.attribute(idx).STRING().toString();
        name = name.substring(1, name.length() - 1);
        return graph.hasNode(name) ? graph.getNode(name) : new Node(name);
    }
}