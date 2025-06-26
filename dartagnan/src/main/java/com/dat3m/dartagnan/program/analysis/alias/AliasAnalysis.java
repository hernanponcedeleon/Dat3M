package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.configuration.Alias;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
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

    boolean mustAlias(Event a, Event b);

    boolean mayAlias(Event a, Event b);

    boolean mustObjectAlias(Event a, Event b);

    boolean mayObjectAlias(Event a, Event b);

    /**
     * Returns an overapproximation of the MSA points in the byte range of the specified event.
     * <p>
     * Two memory accesses are called overlapping, if their accessed byte ranges overlap/intersect.
     * They are called partially overlapping, if they overlap but don't access the exact same byte range.
     * In this case, at least one end point of one range is inside the other range. We call such a point an MSA point.
     *
     * @param event Memory event of the analyzed program.
     * @return A subset of integers between {@code 0} and {@code event.getAccessSize()}, exclusively.
     */
    List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event);

    static AliasAnalysis fromConfig(Program program, Context analysisContext, Configuration config,
            boolean detectMixedSizeAccesses) throws InvalidConfigurationException {
        Config c = new Config(config, detectMixedSizeAccesses);
        logger.info("Selected alias analysis: {}", c.method);
        long t0 = System.currentTimeMillis();
        AliasAnalysis a = switch (c.method) {
            case FIELD_SENSITIVE -> FieldSensitiveAndersen.fromConfig(program, c);
            case FIELD_INSENSITIVE -> AndersenAliasAnalysis.fromConfig(program, c);
            case FULL -> InclusionBasedPointerAnalysis.fromConfig(program, analysisContext, c);
        };
        a = new CombinedAliasAnalysis(a, EqualityAliasAnalysis.fromConfig(program, c));
        if (Arch.supportsVirtualAddressing(program.getArch())) {
            a = VirtualAliasAnalysis.wrap(a, c);
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

        final boolean detectMixedSizeAccesses;

        private Config(Configuration config, boolean msa) throws InvalidConfigurationException {
            detectMixedSizeAccesses = msa;
            config.inject(this);
        }

        List<Integer> defaultMayMixedSizeAccesses(MemoryCoreEvent event) {
            final var set = new ArrayList<Integer>();
            if (detectMixedSizeAccesses) {
                final int bytes = TypeFactory.getInstance().getMemorySizeInBytes(event.getAccessType());
                for (int i = 1; i < bytes; i++) {
                    set.add(i);
                }
            }
            return set;
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
        public boolean mustAlias(Event a, Event b) {
            return a1.mustAlias(a, b) || a2.mustAlias(a, b);
        }

        @Override
        public boolean mayAlias(Event a, Event b) {
            return a1.mayAlias(a, b) && a2.mayAlias(a, b);
        }

        @Override
        public boolean mustObjectAlias(Event a, Event b) {
            return a1.mustObjectAlias(a, b) || a2.mustObjectAlias(a, b);
        }

        @Override
        public boolean mayObjectAlias(Event a, Event b) {
            return a1.mayObjectAlias(a, b) && a2.mayObjectAlias(a, b);
        }

        @Override
        public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent a) {
            final List<Integer> set1 = a1.mayMixedSizeAccesses(a);
            final List<Integer> set2 = a2.mayMixedSizeAccesses(a);
            // compute the intersection
            if (set1.isEmpty() || set2.isEmpty()) {
                return set1.isEmpty() ? set1 : set2;
            }
            final boolean smaller = set1.size() < set2.size();
            return (smaller ? set1 : set2).stream().filter((smaller ? set2 : set1)::contains).toList();
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

    private void populateAddressGraph(Map<String, Set<String>> may, Map<String, Set<String>> must,
            List<? extends Event> list1, List<? extends Event> list2, Config configuration) {
        for (final Event event1 : list1) {
            final String node1 = repr(event1, configuration);
            if (node1 == null) {
                continue;
            }
            final Set<String> maySet = may.computeIfAbsent(node1, k -> new HashSet<>());
            final Set<String> mustSet = must.computeIfAbsent(node1, k -> new HashSet<>());
            for (final Event event2 : list2) {
                final String node2 = repr(event2, configuration);
                if ((event1 instanceof MemoryCoreEvent && event2 instanceof MemoryCoreEvent)
                        || (event1 instanceof MemFree && event2 instanceof MemFree)) {
                    if (event1.getGlobalId() - event2.getGlobalId() >= 0) {
                        continue;
                    }
                }
                if (node2 != null && mayAlias(event1, event2)) {
                    (mustAlias(event1, event2) ? mustSet : maySet).add(node2);
                }
            }
            maySet.removeAll(mustSet);
        }
    }

    private void populateObjectGraph(Map<String, Set<String>> may, Map<String, Set<String>> must,
            List<MemAlloc> allocs, List<MemoryCoreEvent> events, Config configuration) {
        for (final MemAlloc alloc : allocs) {
            final String node1 = repr(alloc, configuration);
            final Set<String> maySet = may.computeIfAbsent(node1, k -> new HashSet<>());
            final Set<String> mustSet = must.computeIfAbsent(node1, k -> new HashSet<>());
            for (final MemoryCoreEvent event : events) {
                final String node2 = repr(event, configuration);
                if (node2 != null && mayObjectAlias(alloc, event)) {
                    (mustObjectAlias(alloc, event) ? mustSet : maySet).add(node2);
                }
            }
            maySet.removeAll(mustSet);
        }
    }

    private Graphviz defaultGraph(Program program, Config configuration) {
        // Nodes represent sets of events.
        // A solid blue line marks the existence of events that must address-alias.
        final Map<String, Set<String>> mustAddressGraph = new HashMap<>();
        // A dashed blue line marks the existence of events that may address-alias.
        final Map<String, Set<String>> mayAddressGraph = new HashMap<>();
        // A solid orange line marks the existence of events that must object-alias.
        final Map<String, Set<String>> mustObjectGraph = new HashMap<>();
        // A dashed orange line marks the existence of events that may object-alias.
        final Map<String, Set<String>> mayObjectGraph = new HashMap<>();

        final List<MemoryCoreEvent> events = program.getThreadEvents(MemoryCoreEvent.class);
        final List<MemAlloc> allocs = program.getThreadEvents(MemAlloc.class);
        final List<MemFree> frees = program.getThreadEvents(MemFree.class);

        populateAddressGraph(mayAddressGraph, mustAddressGraph, events, events, configuration);
        populateAddressGraph(mayAddressGraph, mustAddressGraph, frees, frees, configuration);
        populateAddressGraph(mayAddressGraph, mustAddressGraph, allocs, frees, configuration);

        populateObjectGraph(mayObjectGraph, mustObjectGraph, allocs, events, configuration);

        // Generates the graphs
        final var graphviz = new Graphviz();
        graphviz.beginGraph("alias");
        // Group events
        for (final Thread thread : program.getThreads()) {
            graphviz.beginSubgraph("Thread" + thread.getId());
            graphviz.setEdgeAttributes("weight=100", "style=invis");
            final List<Event> grouped = new ArrayList<>();
            for (final Event event : thread.getEvents()) {
                if (event instanceof MemoryCoreEvent || event instanceof MemAlloc || event instanceof MemFree) {
                    if (!configuration.graphvizShowAll && event instanceof Init) {
                        continue;
                    }
                    grouped.add(event);
                }
            }
            for (int i = 1; i < grouped.size(); i++) {
                final String node1 = repr(grouped.get(i - 1), configuration);
                final String node2 = repr(grouped.get(i), configuration);
                graphviz.addEdge(node1, node2);
            }
            graphviz.end();
        }
        graphviz.beginSubgraph("may address alias");
        graphviz.setEdgeAttributes("color=mediumslateblue", "style=dashed");
        graphviz.addEdges(mayAddressGraph);
        graphviz.end();
        graphviz.beginSubgraph("must address alias");
        graphviz.setEdgeAttributes("color=mediumslateblue");
        graphviz.addEdges(mustAddressGraph);
        graphviz.end();
        graphviz.beginSubgraph("may object alias");
        graphviz.setEdgeAttributes("color=orangered", "style=dashed");
        graphviz.addEdges(mayObjectGraph);
        graphviz.end();
        graphviz.beginSubgraph("must object alias");
        graphviz.setEdgeAttributes("color=orangered");
        graphviz.addEdges(mustObjectGraph);
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

    private static String repr(Event event, Config configuration) {
        if (!configuration.graphvizShowAll && event instanceof Init) {
            return null;
        }
        final String type = event instanceof Load ? ": R"
                : event instanceof Store ? ": W"
                : event instanceof MemAlloc ? ": A"
                : event instanceof MemFree ? ": F"
                : "";
        final SourceLocation location = event.getMetadata(SourceLocation.class);
        if (configuration.graphvizSplitByThread) {
            return location != null ? "\"T" + event.getThread().getId() + esc(location) + type + "\"" :
                    "\"T" + event.getThread().getId() + "E" + event.getGlobalId() + type + "\"";
        }
        return location != null ? "\"" + esc(location) + type + "\"" : "\"E" + event.getGlobalId() + type + "\"";
    }

    private static String esc(Object object) {
        return object.toString().replace('"', '\'');
    }
}
