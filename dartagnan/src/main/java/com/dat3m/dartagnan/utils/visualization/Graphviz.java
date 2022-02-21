package com.dat3m.dartagnan.utils.visualization;


import java.io.IOException;
import java.io.Writer;

/*
    A simple class that allows creation of .dot files
    that can be visualized via Graphviz (e.g. "dot -Tpdf input.dot -o output.pdf")
 */
public class Graphviz {
    private StringBuilder text;

    public Graphviz() { }

    public Graphviz begin(String graphName) {
        text = new StringBuilder();
        text.append(String.format("digraph \"%s\" { \n", graphName));
        text.append("init\n");
        return this;
    }

    public Graphviz beginSubgraph(String subGraphName) {
        text.append(String.format("subgraph %s { \n", subGraphName));
        return this;
    }

    public Graphviz end() {
        text.append("\n").append("}");
        return this;
    }

    public Graphviz setNodeAttributes(String... attributes) {
        text.append(String.format("node [%s] \n", String.join(", ", attributes)));
        return this;
    }

    public Graphviz setEdgeAttributes(String... attributes) {
        text.append(String.format("edge [%s] \n", String.join(", ", attributes)));
        return this;
    }

    public Graphviz append(String text) {
        this.text.append(text);
        return this;
    }

    public Graphviz appendLine(String text) {
        this.text.append(text).append("\n");
        return this;
    }

    public Graphviz addEdge(String node1, String node2, String... options) {
        if (options == null) {
            text.append(String.format("%s -> %s \n", node1, node2));
        } else {
            text.append(String.format("%s -> %s [%s] \n", node1, node2, String.join(", ", options)));
        }
        return this;
    }

    public void generateOutput(Writer writer) throws IOException {
        writer.write(text.toString());
    }

}
