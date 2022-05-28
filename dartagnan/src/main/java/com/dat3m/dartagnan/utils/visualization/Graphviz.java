package com.dat3m.dartagnan.utils.visualization;


import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.concurrent.TimeUnit;
import java.util.function.BiPredicate;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

/*
    A simple class that allows creation of .dot files
    that can be visualized via Graphviz (e.g. "dot -Tpdf input.dot -o output.pdf")
 */
public class Graphviz {
	
    private static final Logger logger = LogManager.getLogger(Graphviz.class);
	
    private StringBuilder text;

    public Graphviz() { }

    public Graphviz begin(String graphName) {
        text = new StringBuilder();
        text.append(String.format("digraph \"%s\" { \n", graphName));
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

    public static void generateGraphvizFile(ExecutionModel model, int iterationCount, BiPredicate<EventData, EventData> edgeFilter, String directoryName, String fileNameBase) {
        File fileVio = new File(directoryName + fileNameBase + ".dot");
        fileVio.getParentFile().mkdirs();
        try (FileWriter writer = new FileWriter(fileVio)) {
            // Create .dot file
            new ExecutionGraphVisualizer()
                    .setReadFromFilter(edgeFilter)
                    .setCoherenceFilter(edgeFilter)
                    .generateGraphOfExecutionModel(writer, "Iteration " + iterationCount, model);

            writer.flush();
            // Convert .dot file to pdf
            Process p = new ProcessBuilder()
                    .directory(new File(directoryName))
                    .command("dot", "-Tpng", fileNameBase + ".dot", "-o", fileNameBase + ".png")
                    .start();
            p.waitFor(1000, TimeUnit.MILLISECONDS);
        } catch (Exception e) {
            logger.error(e);
        }
    }
}
