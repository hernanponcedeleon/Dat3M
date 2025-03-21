package com.dat3m.dartagnan.parsers.witness.visitors;

import static com.dat3m.dartagnan.witness.graphml.GraphAttributes.PRODUCER;
import static com.dat3m.dartagnan.witness.graphml.GraphAttributes.WITNESSTYPE;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.XMLParser;
import com.dat3m.dartagnan.parsers.XMLParser.ElementContext;
import com.dat3m.dartagnan.witness.graphml.Edge;
import com.dat3m.dartagnan.witness.graphml.ElemWithAttributes;
import com.dat3m.dartagnan.witness.graphml.Node;
import com.dat3m.dartagnan.witness.graphml.WitnessGraph;
import com.dat3m.dartagnan.parsers.XMLParserBaseVisitor;

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
        final String elementType = ctx.Name(0).getText();
        return switch (elementType) {
            case "data" -> {
                final String key = getAttributeString(ctx, 0);
                final String value = ctx.content().getText();
                if (key.equals(WITNESSTYPE.toString()) && !value.equals("violation_witness")) {
                    throw new ParsingException("Dartagnan can only validate violation witnesses");
                }
                current.addAttribute(key, value);
                yield null;
            }
            case "node" -> {
                final String name = getAttributeString(ctx, 0);
                graph.addNode(name);
                current = graph.getNode(name);
                visitChildren(ctx);
                current = graph;
                yield null;
            }
            case "edge" -> {
                final Edge edge = new Edge(getNode(ctx, "source"), getNode(ctx, "target"));
                graph.addEdge(edge);
                current = edge;
                visitChildren(ctx);
                current = graph;
                yield null;
            }
            default -> visitChildren(ctx);
        };
    }

    private Node getNode(ElementContext ctx, String vertex) {
        final int idx = ctx.attribute().stream().map(a -> a.Name().toString()).toList().indexOf(vertex);
        final String name = getAttributeString(ctx, idx);
        return graph.hasNode(name) ? graph.getNode(name) : new Node(name);
    }

    private String getAttributeString(ElementContext ctx, int index) {
        final String attributeStr = ctx.attribute(index).STRING().toString();
        return attributeStr.substring(1, attributeStr.length() - 1);
    }
}