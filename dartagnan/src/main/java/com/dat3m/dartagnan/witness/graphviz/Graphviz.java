package com.dat3m.dartagnan.witness.graphviz;


import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/*
    A simple class that allows creation of .dot files
    that can be visualized via Graphviz (e.g. "dot -Tpdf input.dot -o output.pdf")
 */
public class Graphviz {

    private final StringBuilder text = new StringBuilder();
    private boolean directed;

    public Graphviz() { }

    public Graphviz beginDigraph(String graphName) {
        text.append(String.format("digraph \"%s\" { \n", graphName));
        directed = true;
        return this;
    }

    public Graphviz beginGraph(String graphName) {
        text.append(String.format("graph \"%s\" { \n", graphName));
        directed = false;
        return this;
    }

    public Graphviz beginSubgraph(String subGraphName) {
        text.append(String.format("subgraph \"%s\" { \n", subGraphName));
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

    public Graphviz addNode(String name, String... attributes) {
        text.append(String.format("%s [%s]\n", name, String.join(", ", attributes)));
        return this;
    }

    public Graphviz addEdge(String node1, String node2, String... options) {
        String edge = directed ? "->" : "--";
        if (options == null) {
            text.append(String.format("%s %s %s\n", node1, edge, node2));
        } else {
            text.append(String.format("%s %s %s [%s]\n", node1, edge, node2, String.join(", ", options)));
        }
        return this;
    }

    public Graphviz addEdges(Map<String, ? extends Iterable<String>> map) {
        for (final Map.Entry<String, ? extends Iterable<String>> entry : map.entrySet()) {
            final String from = entry.getKey();
            for (final String to : entry.getValue()) {
                addEdge(from, to);
            }
        }
        return this;
    }

    public void generateOutput(Writer writer) throws IOException {
        writer.write(text.toString());
    }

    /**
     * Executes the program {@code dot} to generate a PNG image of a graph.
     *
     * @param dotFile Existing {@code .dot} file, like the output of {@link #generateOutput(Writer)}.
     * @throws IOException          The program is not installed, or the directory of {@code dotFile} does not exist.
     * @throws InterruptedException The current thread is interrupted while waiting for the command to finish.
     */
    public static void convert(File dotFile) throws IOException, InterruptedException {
        String fileName = dotFile.getName();
        String fileNameBase = fileName.substring(0, fileName.lastIndexOf('.'));
        Process p = new ProcessBuilder().directory(dotFile.getParentFile())
                .command("dot", "-Tpng", fileName, "-o", fileNameBase + ".png").start();
        p.waitFor(1000, TimeUnit.MILLISECONDS);
    }
}
