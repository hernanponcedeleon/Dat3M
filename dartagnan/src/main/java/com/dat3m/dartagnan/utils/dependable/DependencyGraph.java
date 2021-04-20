package com.dat3m.dartagnan.utils.dependable;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;

import java.util.*;
import java.util.function.Function;

public class DependencyGraph<T> {
    //TODO: Maybe add a way to enable Identity-based hashmaps
    private final Map<T, Node> nodeMap;
    private List<Node> nodeList;
    private final List<Set<Node>> sccs;
    private final Function<? super T, ? extends Collection<? extends T>> dependencyMap;

    public Node get(T item) {
        return nodeMap.get(item);
    }

    public List<Node> getNodes() {
        return nodeList;
    }

    public List<T> getNodeContents() {
        return Lists.transform(nodeList, x -> x.content);
    }

    public Node getRootNode() {
        return nodeList.get(0);
    }

    public T getRootContent() {
        return getRootNode().getContent();
    }

    public List<Set<Node>> getSCCs() {
        return Collections.unmodifiableList(sccs);
    }

    // ================= Public construction methods =================

    public static <V> DependencyGraph<V> from(final Collection<? extends V> items, final Function<? super V, ? extends Collection<? extends V>> dependencyMap) {
        return new DependencyGraph<>(items, dependencyMap);
    }

    public static <V> DependencyGraph<V> fromSingleton(final V item, final Function<? super V, ? extends Collection<? extends V>> dependencyMap) {
        return from(Collections.singletonList(item), dependencyMap);
    }

    public static <V> DependencyGraph<V> from(final Collection<? extends V> items, final Map<? super  V, ? extends Collection<? extends V>> dependencyMap) {
        return new DependencyGraph<>(items, x -> dependencyMap.containsKey(x) ? dependencyMap.get(x) : Collections.emptyList());
    }

    public static <V> DependencyGraph<V> fromSingleton(final V item, final Map<? super V, ? extends Collection<? extends V>> dependencyMap) {
        return from(Collections.singletonList(item), dependencyMap);
    }

    public static <V extends Dependent<? extends V>> DependencyGraph<V> from(final Collection<? extends V> items) {
        return new DependencyGraph<>(items, Dependent::getDependencies);
    }

    public static <V extends Dependent<? extends V>> DependencyGraph<V> fromSingleton(final V item) {
        return from(Collections.singletonList(item));
    }

    // ====================================================================

    private DependencyGraph(final Collection<? extends T> items, final Function<? super T, ? extends Collection<? extends T>> dependencyMap) {
        nodeMap = new HashMap<>();
        sccs = new ArrayList<>();
        this.dependencyMap = dependencyMap;

        items.forEach(this::getNodeInternal);
        initializeNodes();
        tarjan();
    }

    private Node getNodeInternal(T item) {
        if (nodeMap.containsKey(item)) {
            return nodeMap.get(item);
        }
        Node node = new Node(item);
        nodeMap.put(item, node);

        return node;
    }

    private void initializeNodes() {
        Queue<Node> workingQueue = new ArrayDeque<>(nodeMap.values());
        while (!workingQueue.isEmpty()) {
            Node node = workingQueue.remove();
            for (T dependency : dependencyMap.apply(node.content)) {
                boolean isNew = !nodeMap.containsKey(dependency);
                Node depNode = getNodeInternal(dependency);
                node.dependencies.add(depNode);
                depNode.dependents.add(node);
                if (isNew) {
                    workingQueue.add(depNode);
                }
            }
        }
    }

    // ================== Tarjan's Algorithm for computing topological ordering + SCC ================

    private int index;
    private int topIndex;
    private final Stack<Node> stack = new Stack<>();
    private void tarjan() {
        index = 0;
        topIndex = -1;
        stack.clear();

        for (Node node : nodeMap.values()) {
            if (!node.wasVisited())
                strongConnect(node);
        }

        // Tarjan finds reverse topological ordering, so we put it into standard order
        for (Node node : nodeMap.values()) {
            node.topologicalIndex = topIndex - node.getTopologicalIndex();
        }

        // Create sorted list of all nodes
        // and sort their dependencies/dependents as well
        Comparator<Node> cmp = Comparator.comparingInt(Node::getTopologicalIndex);
        nodeList = ImmutableList.sortedCopyOf(cmp, nodeMap.values());
        for (Node node : nodeList){
            node.getDependencies().sort(cmp);
            node.getDependents().sort(cmp);
        }

        Collections.reverse(sccs);

    }

    private void strongConnect(Node v) {
        v.index = index;
        v.lowlink = index;
        stack.push(v);
        v.isOnStack = true;
        index++;

        for (Node w : v.getDependents()) {
            if (!w.wasVisited()) {
                strongConnect(w);
                v.lowlink = Math.min(v.lowlink, w.lowlink);
            }
            else if (w.isOnStack)
                v.lowlink = Math.min(v.lowlink, w.index);
        }


        if (v.lowlink == v.index) {
            Set<Node> scc = new HashSet<>();
            sccs.add(scc);
            v.topologicalIndex = ++topIndex;
            Node w;
            do {
                w = stack.pop();
                w.isOnStack = false;
                scc.add(w);
                w.scc = scc;
                w.topologicalIndex = v.getTopologicalIndex();
            } while (w != v);
        }
    }

    public class Node implements Dependent<Node> {
        final T content;
        final List<Node> dependents;
        final List<Node> dependencies;
        Set<Node> scc;
        int topologicalIndex;

        boolean isOnStack = false;
        int index = -1;
        int lowlink = -1;

        boolean wasVisited() {
            return index != -1;
        }

        private Node(T content) {
            this.content = content;
            dependencies = new ArrayList<>();
            dependents = new ArrayList<>();
            scc = null;
            topologicalIndex = -1;
        }

        public T getContent() { return content; }

        public List<Node> getDependents() {
            return dependents;
        }

        public List<Node> getDependencies() {
            return dependencies;
        }

        public Set<Node> getSCC() {
            return scc;
        }

        public int getTopologicalIndex() {
            return topologicalIndex;
        }

        @Override
        public int hashCode() {
            return content.hashCode();
        }

        @Override
        @SuppressWarnings("unchecked")
        public boolean equals(Object obj) {
            if (obj == this)
                return true;
            if (obj == null || obj.getClass() != getClass())
                return false;
            Node node = (Node)obj;
            return node.content.equals(this.content);
        }

        @Override
        public String toString() {
            return content.toString();
        }
    }
}