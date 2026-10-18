package com.dat3m.ui.witness;

import com.dat3m.ui.witness.WitnessGraph.Edge;
import com.dat3m.ui.witness.WitnessGraph.Node;

import java.awt.*;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.ToDoubleFunction;

/*
    A layered layout in the style of Sugiyama et al.: edges point downwards wherever possible.
    1. Cycles are broken by reversing the back edges of a depth-first search.
    2. Every event gets the layer of the longest path that leads to it.
    3. Edges that span several layers pass through dummy vertices, one per layer they cross.
    4. The order within layers is improved by barycenter sweeps, keeping the order with the fewest crossings.
    5. Horizontal positions move towards the average of the neighbours, without overlaps.
    6. Edges become smooth curves that leave events at the bottom and enter them at the top.
 */
final class LayeredLayout {

    // The points of an edge, from its source to its target. Between two points, the edge is a curve with vertical tangents.
    record Route(List<Point2D> points, Point2D labelAnchor) {
    }

    record Result(Map<Integer, Rectangle2D> nodes, Map<Edge, Route> routes, Dimension size) {
    }

    private static final double DUMMY_WIDTH = 12;
    private static final double NODE_GAP = 48;
    private static final double DUMMY_GAP = 14;
    private static final double LAYER_GAP = 80;
    private static final double PARALLEL_OFFSET = 7;
    private static final int ORDER_SWEEPS = 16;
    private static final int POSITION_SWEEPS = 10;

    private final Dimension nodeSize;
    private final int margin;
    private final int realCount;

    // Vertices 0 to realCount - 1 are events, the others are dummies.
    private final List<Integer> layerOf = new ArrayList<>();
    private final List<List<Integer>> upper = new ArrayList<>();
    private final List<List<Integer>> lower = new ArrayList<>();
    private final List<List<Integer>> layers = new ArrayList<>();
    private double[] x;

    private LayeredLayout(int realCount, Dimension nodeSize, int margin) {
        this.realCount = realCount;
        this.nodeSize = nodeSize;
        this.margin = margin;
    }

    // The nodes are expected in model order (thread by thread), which serves as the initial order within layers.
    static Result compute(List<Node> nodes, List<Edge> edges, Dimension nodeSize, int margin) {
        return new LayeredLayout(nodes.size(), nodeSize, margin).run(nodes, edges);
    }

    private Result run(List<Node> nodes, List<Edge> edges) {
        final Map<Integer, Integer> vertexOf = new HashMap<>();
        for (int i = 0; i < nodes.size(); i++) {
            vertexOf.put(nodes.get(i).id(), i);
            addVertex();
        }

        // The pairs of events that are connected, oriented such that they form an acyclic graph.
        final Map<List<Integer>, List<Edge>> edgesOfPair = new LinkedHashMap<>();
        final Set<List<Integer>> directed = new HashSet<>();
        final List<List<Integer>> successors = new ArrayList<>();
        nodes.forEach(node -> successors.add(new ArrayList<>()));
        for (Edge edge : edges) {
            final int from = vertexOf.get(edge.from());
            final int to = vertexOf.get(edge.to());
            if (from != to && directed.add(List.of(from, to))) {
                successors.get(from).add(to);
            }
        }
        final Set<List<Integer>> reversed = findBackEdges(successors);
        for (Edge edge : edges) {
            final int from = vertexOf.get(edge.from());
            final int to = vertexOf.get(edge.to());
            if (from == to) {
                continue;
            }
            final List<Integer> pair = reversed.contains(List.of(from, to)) ? List.of(to, from) : List.of(from, to);
            edgesOfPair.computeIfAbsent(pair, key -> new ArrayList<>()).add(edge);
        }

        assignLayers(edgesOfPair.keySet());
        final Map<List<Integer>, List<Integer>> paths = new HashMap<>();
        for (List<Integer> pair : edgesOfPair.keySet()) {
            paths.put(pair, insertDummies(pair.get(0), pair.get(1)));
        }
        orderLayers();
        assignPositions();
        return buildResult(nodes, vertexOf, edgesOfPair, paths);
    }

    private int addVertex() {
        layerOf.add(0);
        upper.add(new ArrayList<>());
        lower.add(new ArrayList<>());
        return layerOf.size() - 1;
    }

    private boolean isDummy(int vertex) {
        return vertex >= realCount;
    }

    private double widthOf(int vertex) {
        return isDummy(vertex) ? DUMMY_WIDTH : nodeSize.width;
    }

    // ================================= Cycle breaking =================================

    private Set<List<Integer>> findBackEdges(List<List<Integer>> successors) {
        final Set<List<Integer>> backEdges = new HashSet<>();
        final int[] state = new int[successors.size()];
        for (int start = 0; start < successors.size(); start++) {
            if (state[start] != 0) {
                continue;
            }
            // Iterative depth-first search: each entry holds a vertex and the index of its next successor.
            final Deque<int[]> stack = new ArrayDeque<>();
            stack.push(new int[]{start, 0});
            state[start] = 1;
            while (!stack.isEmpty()) {
                final int[] top = stack.peek();
                final List<Integer> next = successors.get(top[0]);
                if (top[1] == next.size()) {
                    state[top[0]] = 2;
                    stack.pop();
                    continue;
                }
                final int successor = next.get(top[1]++);
                if (state[successor] == 1) {
                    backEdges.add(List.of(top[0], successor));
                } else if (state[successor] == 0) {
                    state[successor] = 1;
                    stack.push(new int[]{successor, 0});
                }
            }
        }
        return backEdges;
    }

    // ================================= Layering =================================

    private void assignLayers(Set<List<Integer>> pairs) {
        final List<List<Integer>> predecessors = new ArrayList<>();
        final List<List<Integer>> successors = new ArrayList<>();
        final int[] inDegree = new int[realCount];
        for (int i = 0; i < realCount; i++) {
            predecessors.add(new ArrayList<>());
            successors.add(new ArrayList<>());
        }
        for (List<Integer> pair : pairs) {
            successors.get(pair.get(0)).add(pair.get(1));
            predecessors.get(pair.get(1)).add(pair.get(0));
            inDegree[pair.get(1)]++;
        }
        // Longest paths, in topological order.
        final Deque<Integer> ready = new ArrayDeque<>();
        for (int i = 0; i < realCount; i++) {
            if (inDegree[i] == 0) {
                ready.add(i);
            }
        }
        final List<Integer> topological = new ArrayList<>();
        while (!ready.isEmpty()) {
            final int vertex = ready.poll();
            topological.add(vertex);
            for (int successor : successors.get(vertex)) {
                layerOf.set(successor, Math.max(layerOf.get(successor), layerOf.get(vertex) + 1));
                if (--inDegree[successor] == 0) {
                    ready.add(successor);
                }
            }
        }
        // Sources move down to just above their closest successor, e.g., initial writes next to their readers.
        for (int i = topological.size() - 1; i >= 0; i--) {
            final int vertex = topological.get(i);
            if (predecessors.get(vertex).isEmpty() && !successors.get(vertex).isEmpty()) {
                final int closest = successors.get(vertex).stream().mapToInt(layerOf::get).min().orElseThrow();
                layerOf.set(vertex, closest - 1);
            }
        }
        // Events without edges would crowd the first layer. Instead, they fill rows of their own below the graph.
        final List<Integer> isolated = new ArrayList<>();
        for (int i = 0; i < realCount; i++) {
            if (predecessors.get(i).isEmpty() && successors.get(i).isEmpty()) {
                isolated.add(i);
            } else {
                addToLayer(i, layerOf.get(i));
            }
        }
        if (!isolated.isEmpty()) {
            final int widest = layers.stream().mapToInt(List::size).max().orElse(0);
            final int rowSize = Math.max(Math.max(4, widest), (int) Math.ceil(Math.sqrt(isolated.size())));
            final int firstRow = layers.size();
            for (int i = 0; i < isolated.size(); i++) {
                layerOf.set(isolated.get(i), firstRow + i / rowSize);
                addToLayer(isolated.get(i), firstRow + i / rowSize);
            }
        }
    }

    private void addToLayer(int vertex, int layer) {
        while (layers.size() <= layer) {
            layers.add(new ArrayList<>());
        }
        layers.get(layer).add(vertex);
    }

    // Returns the vertices that the edge passes, including both of its ends.
    private List<Integer> insertDummies(int from, int to) {
        final List<Integer> path = new ArrayList<>();
        path.add(from);
        int previous = from;
        for (int layer = layerOf.get(from) + 1; layer < layerOf.get(to); layer++) {
            final int dummy = addVertex();
            layerOf.set(dummy, layer);
            layers.get(layer).add(dummy);
            link(previous, dummy);
            path.add(dummy);
            previous = dummy;
        }
        link(previous, to);
        path.add(to);
        return path;
    }

    private void link(int from, int to) {
        lower.get(from).add(to);
        upper.get(to).add(from);
    }

    // ================================= Crossing reduction =================================

    private void orderLayers() {
        List<List<Integer>> best = copyLayers();
        long fewest = countCrossings();
        for (int sweep = 0; sweep < ORDER_SWEEPS && fewest > 0; sweep++) {
            if (sweep % 2 == 0) {
                for (int layer = 1; layer < layers.size(); layer++) {
                    sortByBarycenter(layer, upper);
                }
            } else {
                for (int layer = layers.size() - 2; layer >= 0; layer--) {
                    sortByBarycenter(layer, lower);
                }
            }
            final long crossings = countCrossings();
            if (crossings < fewest) {
                fewest = crossings;
                best = copyLayers();
            }
        }
        layers.clear();
        layers.addAll(best);
    }

    private List<List<Integer>> copyLayers() {
        return layers.stream().map(layer -> (List<Integer>) new ArrayList<>(layer)).toList();
    }

    private void sortByBarycenter(int layer, List<List<Integer>> neighbours) {
        final Map<Integer, Integer> position = positionsOf(layer + (neighbours == upper ? -1 : 1));
        final List<Integer> vertices = layers.get(layer);
        final Map<Integer, Double> barycenter = new HashMap<>();
        for (int i = 0; i < vertices.size(); i++) {
            final int vertex = vertices.get(i);
            final List<Integer> adjacent = neighbours.get(vertex);
            // Vertices without neighbours keep their place.
            barycenter.put(vertex, adjacent.isEmpty() ? i
                    : adjacent.stream().mapToInt(position::get).average().orElseThrow());
        }
        vertices.sort(Comparator.comparingDouble(barycenter::get));
    }

    private Map<Integer, Integer> positionsOf(int layer) {
        final Map<Integer, Integer> position = new HashMap<>();
        final List<Integer> vertices = layers.get(layer);
        for (int i = 0; i < vertices.size(); i++) {
            position.put(vertices.get(i), i);
        }
        return position;
    }

    // Counts pairs of crossing segments between neighbouring layers, as inversions with a Fenwick tree.
    private long countCrossings() {
        long crossings = 0;
        for (int layer = 0; layer + 1 < layers.size(); layer++) {
            final Map<Integer, Integer> top = positionsOf(layer);
            final Map<Integer, Integer> bottom = positionsOf(layer + 1);
            final List<int[]> segments = new ArrayList<>();
            for (int vertex : layers.get(layer)) {
                for (int below : lower.get(vertex)) {
                    segments.add(new int[]{top.get(vertex), bottom.get(below)});
                }
            }
            segments.sort(Comparator.<int[]>comparingInt(segment -> segment[0]).thenComparingInt(segment -> segment[1]));
            final long[] tree = new long[layers.get(layer + 1).size() + 1];
            for (int i = 0; i < segments.size(); i++) {
                // Segments seen so far that end further right cross this one.
                long notGreater = 0;
                for (int index = segments.get(i)[1] + 1; index > 0; index -= index & -index) {
                    notGreater += tree[index];
                }
                crossings += i - notGreater;
                for (int index = segments.get(i)[1] + 1; index < tree.length; index += index & -index) {
                    tree[index]++;
                }
            }
        }
        return crossings;
    }

    // ================================= Horizontal positions =================================

    private void assignPositions() {
        x = new double[layerOf.size()];
        for (List<Integer> layer : layers) {
            double left = 0;
            for (int vertex : layer) {
                x[vertex] = left + widthOf(vertex) / 2;
                left += widthOf(vertex) + NODE_GAP;
            }
        }
        for (int sweep = 0; sweep < POSITION_SWEEPS; sweep++) {
            final boolean useBoth = sweep >= POSITION_SWEEPS / 2;
            if (sweep % 2 == 0) {
                for (int layer = 1; layer < layers.size(); layer++) {
                    alignLayer(layer, useBoth ? null : upper);
                }
            } else {
                for (int layer = layers.size() - 2; layer >= 0; layer--) {
                    alignLayer(layer, useBoth ? null : lower);
                }
            }
        }
        final double minLeft = layers.stream().flatMap(List::stream).mapToDouble(v -> x[v] - widthOf(v) / 2).min().orElse(0);
        for (int vertex = 0; vertex < x.length; vertex++) {
            x[vertex] += margin - minLeft;
        }
    }

    /*
        Moves the vertices of the layer as close as possible to the average of their neighbours (both sides if
        neighbours is null), keeping their order and minimum distances: an isotonic regression, solved by pooling
        adjacent violators.
     */
    private void alignLayer(int layer, List<List<Integer>> neighbours) {
        final List<Integer> vertices = layers.get(layer);
        final int count = vertices.size();
        final double[] offset = new double[count];
        final double[] target = new double[count];
        for (int i = 0; i < count; i++) {
            final int vertex = vertices.get(i);
            if (i > 0) {
                final int previous = vertices.get(i - 1);
                final double gap = isDummy(previous) && isDummy(vertex) ? DUMMY_GAP : NODE_GAP;
                offset[i] = offset[i - 1] + (widthOf(previous) + widthOf(vertex)) / 2 + gap;
            }
            final List<Integer> adjacent = new ArrayList<>();
            if (neighbours == null || neighbours == upper) {
                adjacent.addAll(upper.get(vertex));
            }
            if (neighbours == null || neighbours == lower) {
                adjacent.addAll(lower.get(vertex));
            }
            final double desired = adjacent.isEmpty() ? x[vertex] : adjacent.stream().mapToDouble(v -> x[v]).average().orElseThrow();
            target[i] = desired - offset[i];
        }
        // Pool adjacent violators: blocks of equal values whose means must not decrease.
        final double[] blockSum = new double[count];
        final int[] blockSize = new int[count];
        int blocks = 0;
        for (int i = 0; i < count; i++) {
            blockSum[blocks] = target[i];
            blockSize[blocks] = 1;
            blocks++;
            while (blocks > 1 && blockSum[blocks - 2] / blockSize[blocks - 2] > blockSum[blocks - 1] / blockSize[blocks - 1]) {
                blockSum[blocks - 2] += blockSum[blocks - 1];
                blockSize[blocks - 2] += blockSize[blocks - 1];
                blocks--;
            }
        }
        int i = 0;
        for (int block = 0; block < blocks; block++) {
            final double value = blockSum[block] / blockSize[block];
            for (int k = 0; k < blockSize[block]; k++, i++) {
                x[vertices.get(i)] = value + offset[i];
            }
        }
    }

    // ================================= Result =================================

    private double topOf(int layer) {
        return margin + layer * (nodeSize.height + LAYER_GAP);
    }

    private Result buildResult(List<Node> nodes, Map<Integer, Integer> vertexOf, Map<List<Integer>, List<Edge>> edgesOfPair,
                               Map<List<Integer>, List<Integer>> paths) {
        final Map<Integer, Rectangle2D> bounds = new HashMap<>();
        double right = 0;
        for (int vertex = 0; vertex < realCount; vertex++) {
            final Rectangle2D box = new Rectangle2D.Double(x[vertex] - nodeSize.width / 2.0, topOf(layerOf.get(vertex)),
                    nodeSize.width, nodeSize.height);
            bounds.put(nodes.get(vertex).id(), box);
            right = Math.max(right, box.getMaxX());
        }

        // Edges leave at the bottom and enter at the top, spread over the side in the order of their other ends.
        final Map<List<Integer>, Double> sourcePort = new HashMap<>();
        final Map<List<Integer>, Double> targetPort = new HashMap<>();
        final Map<Integer, List<List<Integer>>> outgoing = new HashMap<>();
        final Map<Integer, List<List<Integer>>> incoming = new HashMap<>();
        for (List<Integer> pair : edgesOfPair.keySet()) {
            outgoing.computeIfAbsent(pair.get(0), key -> new ArrayList<>()).add(pair);
            incoming.computeIfAbsent(pair.get(1), key -> new ArrayList<>()).add(pair);
        }
        outgoing.forEach((vertex, pairs) -> spreadPorts(vertex, pairs, pair -> x[paths.get(pair).get(1)], sourcePort));
        incoming.forEach((vertex, pairs) -> spreadPorts(vertex, pairs,
                pair -> x[paths.get(pair).get(paths.get(pair).size() - 2)], targetPort));

        final Map<Edge, Route> routes = new HashMap<>();
        edgesOfPair.forEach((pair, pairEdges) -> {
            final List<Integer> path = paths.get(pair);
            final List<Edge> parallel = pairEdges.stream().sorted(Comparator.comparing(Edge::relation)).toList();
            for (int k = 0; k < parallel.size(); k++) {
                final double shift = (k - (parallel.size() - 1) / 2.0) * PARALLEL_OFFSET;
                final List<Point2D> points = new ArrayList<>();
                points.add(new Point2D.Double(sourcePort.get(pair) + shift, topOf(layerOf.get(path.get(0))) + nodeSize.height));
                for (int dummy : path.subList(1, path.size() - 1)) {
                    // Dummies pass the row of their layer vertically, where they cannot hit an event.
                    points.add(new Point2D.Double(x[dummy] + shift, topOf(layerOf.get(dummy))));
                    points.add(new Point2D.Double(x[dummy] + shift, topOf(layerOf.get(dummy)) + nodeSize.height));
                }
                points.add(new Point2D.Double(targetPort.get(pair) + shift, topOf(layerOf.get(path.get(path.size() - 1)))));
                final Edge edge = parallel.get(k);
                // Edges that were reversed to break cycles get their original direction back.
                if (vertexOf.get(edge.from()) != path.get(0).intValue()) {
                    Collections.reverse(points);
                }
                routes.put(edge, new Route(List.copyOf(points), pointAlong(points, 0.35)));
            }
        });

        final double bottom = topOf(layers.size() - 1) + nodeSize.height;
        return new Result(bounds, routes, new Dimension((int) Math.ceil(right) + margin, (int) Math.ceil(bottom) + margin));
    }

    private void spreadPorts(int vertex, List<List<Integer>> pairs, ToDoubleFunction<List<Integer>> otherEnd,
                             Map<List<Integer>, Double> ports) {
        final List<List<Integer>> sorted = pairs.stream().sorted(Comparator.comparingDouble(otherEnd)).toList();
        final double left = x[vertex] - nodeSize.width / 2.0;
        for (int i = 0; i < sorted.size(); i++) {
            ports.put(sorted.get(i), left + nodeSize.width * (i + 1.0) / (sorted.size() + 1));
        }
    }

    // The point at the given fraction of the length of the polyline.
    private static Point2D pointAlong(List<Point2D> points, double fraction) {
        double length = 0;
        for (int i = 1; i < points.size(); i++) {
            length += points.get(i - 1).distance(points.get(i));
        }
        double remaining = length * fraction;
        for (int i = 1; i < points.size(); i++) {
            final double segment = points.get(i - 1).distance(points.get(i));
            if (remaining <= segment && segment > 0) {
                final double t = remaining / segment;
                return new Point2D.Double(points.get(i - 1).getX() + t * (points.get(i).getX() - points.get(i - 1).getX()),
                        points.get(i - 1).getY() + t * (points.get(i).getY() - points.get(i - 1).getY()));
            }
            remaining -= segment;
        }
        return points.get(points.size() - 1);
    }
}
