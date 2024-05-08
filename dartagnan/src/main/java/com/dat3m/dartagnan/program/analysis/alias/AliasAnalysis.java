package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.utils.Utils;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.witness.graphviz.Graphviz;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getOrCreateOutputDirectory;
import static com.dat3m.dartagnan.configuration.OptionNames.*;

public interface AliasAnalysis {

    Logger logger = LogManager.getLogger(AliasAnalysis.class);

    boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b);

    boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b);

    static AliasAnalysis fromConfig(Program program, Context analysisContext, Configuration config) throws InvalidConfigurationException {
        Config c = new Config(config);
        logger.info("Selected alias analysis: {}", c.method);
        long t0 = System.currentTimeMillis();
        AliasAnalysis a = switch (c.method) {
            case FIELD_SENSITIVE -> FieldSensitiveAndersen.fromConfig(program, config);
            case FIELD_INSENSITIVE -> AndersenAliasAnalysis.fromConfig(program, config);
            case FULL -> InclusionBasedPointerAnalysis.fromConfig(program, analysisContext, c);
        };
        a = new CombinedAliasAnalysis(a, EqualityAliasAnalysis.fromConfig(program, config));
        if (Arch.supportsVirtualAddressing(program.getArch())) {
            a = VirtualAliasAnalysis.wrap(a);
        }
        if (c.graphviz) {
            a.generateGraph(program, c);
        }

        long t1 = System.currentTimeMillis();
        logger.info("Finished alias analysis in {}", Utils.toTimeString(t1 - t0));
        return a;
    }

    @Options
    final class Config {
        @Option(name = ALIAS_METHOD,
                description = "General type of analysis that approximates the 'loc' relationship between memory events.")
        private Alias method = Alias.getDefault();

        @Option(name = ALIAS_GRAPHVIZ,
                description = "If 'true', stores the results of the alias analysis as a PNG image." +
                        " Defaults to 'false'.")
        private boolean graphviz;

        @Option(name = ALIAS_GRAPHVIZ_SPLIT_BY_THREAD,
                description = "Controls which event sets are represented by nodes in the graph output." +
                        " If 'true', nodes represent events of the same thread and source location." +
                        " If 'false', nodes represent events of just the same source location." +
                        " Requires '" + ALIAS_GRAPHVIZ + "=true'." +
                        " Defaults to 'false'.", secure = true)
        private boolean graphvizSplitByThread;

        @Option(name = ALIAS_GRAPHVIZ_SHOW_ALL,
                description = "If 'true', the graph representation contains even initializations." +
                        " Requires '" + ALIAS_GRAPHVIZ + "=true'." +
                        " Defaults to 'false'.", secure = true)
        private boolean graphvizShowAll;

        @Option(name = ALIAS_GRAPHVIZ_INTERNAL,
                description = "If 'true' and supported, the graph shows an internal representation." +
                        " Requires '" + ALIAS_GRAPHVIZ + "=true'." +
                        " Defaults to 'false'.", secure = true)
        boolean graphvizInternal;

        private Config(Configuration config) throws InvalidConfigurationException {
            config.inject(this);
        }
    }

    final class CombinedAliasAnalysis implements AliasAnalysis {

        private final AliasAnalysis a1;
        private final AliasAnalysis a2;

        private CombinedAliasAnalysis(AliasAnalysis a1, AliasAnalysis a2) {
            this.a1 = a1;
            this.a2 = a2;
        }

        @Override
        public boolean mustAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
            return a1.mustAlias(a, b) || a2.mustAlias(a, b);
        }

        @Override
        public boolean mayAlias(MemoryCoreEvent a, MemoryCoreEvent b) {
            return a1.mayAlias(a, b) && a2.mayAlias(a, b);
        }

        @Override
        public Graphviz getGraphVisualization() {
            return a1.getGraphVisualization();
        }
    }

    //this should be protected
    default Graphviz getGraphVisualization() {
        return null;
    }

    private Graphviz defaultGraph(Program program, Config configuration) {
        // Nodes represent sets of events.
        // A solid line marks the existence of events that must alias.
        // A dashed line marks the existence of events that may alias.
        final Map<String, Set<String>> mayGraph = new HashMap<>();
        final Map<String, Set<String>> mustGraph = new HashMap<>();
        final List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
        for (final MemoryCoreEvent event1 : events) {
            final String node1 = repr(event1, configuration);
            if (node1 == null) {
                continue;
            }
            final Set<String> maySet = mayGraph.computeIfAbsent(node1, k -> new HashSet<>());
            final Set<String> mustSet = mustGraph.computeIfAbsent(node1, k -> new HashSet<>());
            for (final MemoryCoreEvent event2 : events) {
                final String node2 = repr(event2, configuration);
                if (node2 != null && node1.compareTo(node2) < 0 && mayAlias(event1, event2)) {
                    (mustAlias(event1, event2) ? mustSet : maySet).add(node2);
                }
            }
            maySet.removeAll(mustSet);
        }

        // Generates the graphs
        final var graphviz = new Graphviz();
        graphviz.beginGraph("alias");
        graphviz.beginSubgraph("may alias");
        graphviz.setEdgeAttributes("color=mediumslateblue", "style=dashed");
        graphviz.addEdges(mayGraph);
        graphviz.end();
        graphviz.beginSubgraph("must alias");
        graphviz.setEdgeAttributes("color=mediumslateblue");
        graphviz.addEdges(mustGraph);
        graphviz.end();
        graphviz.end();
        return graphviz;
    }

    private void generateGraph(Program program, Config configuration) {
        final Graphviz internalGraph = configuration.graphvizInternal ? getGraphVisualization() : null;
        final Graphviz graphviz = internalGraph != null ? internalGraph : defaultGraph(program, configuration);
        // Generates the .dot file and convert into the .png file.
        String programName = program.getName();
        String programBase = programName.substring(0, programName.lastIndexOf('.'));
        try {
            File dotFile = new File(getOrCreateOutputDirectory() + "/" + programBase + "-alias.dot");
            try (var writer = new FileWriter(dotFile)) {
                graphviz.generateOutput(writer);
                writer.flush();
                logger.info("Alias graph written to {}.", dotFile);
                Graphviz.convert(dotFile);
            }
        } catch (IOException | InterruptedException x) {
            logger.warn("Could not write initial alias graph: \"{}\".", x.getMessage());
        }
    }

    private static String repr(MemoryEvent event, Config configuration) {
        if (!configuration.graphvizShowAll && event instanceof Init) {
            return null;
        }
        final SourceLocation location = event.getMetadata(SourceLocation.class);
        if (configuration.graphvizSplitByThread) {
            return location != null ? "\"T" + event.getThread().getId() + esc(location) + "\"" :
                    "\"T" + event.getThread().getId() + "E" + event.getGlobalId() + "\"";
        }
        return location != null ? "\"" + esc(location) + "\"" : "\"E" + event.getGlobalId() + "\"";
    }

    private static String esc(Object object) {
        return object.toString().replace('"', '\'');
    }
}
