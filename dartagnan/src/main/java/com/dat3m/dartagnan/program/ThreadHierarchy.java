package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.program.event.Tag;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ThreadHierarchy {

    private final Group root = new Group(null, "GLOBAL", 0);
    private final Program program;
    private final List<Thread> threadCache = new ArrayList<>();

    public Group getRoot() { return root; }

    public ThreadHierarchy(Program program) {
        this.program = Preconditions.checkNotNull(program);
    }

    public List<Thread> getThreads() {
        return threadCache;
        /*final List<Thread> threads = Lists.newArrayList();
        final Consumer<Node> collector = n -> {
            if (n instanceof Leaf leaf) {
                threads.add(leaf.getThread());
            }
        };
        final Predicate<Node> filter = n -> true;
        Node.collect(root, collector, filter);
        return threads;*/
    }

    public Leaf addThread(Thread thread, Position position) {
        return root.addThread(thread, position);
    }

    public boolean haveCommonScopeGroups(Thread t1, Thread t2, Set<String> scopes) {
        final Set<String> commonScopes = new HashSet<>();
        Group group = leastCommonAncestor(t1, t2);
        while (group != null) {
            commonScopes.add(group.getScope());
            group = group.getParent();
        }

        return commonScopes.containsAll(scopes);
    }

    public Group leastCommonAncestor(Thread t1, Thread t2) {
        Group g1 = t1.getPosition().getParent();
        Group g2 = t2.getPosition().getParent();
        int d1 = depthOf(t1);
        int d2 = depthOf(t2);

        while (d1 != d2) {
            if (d2 > d1) {
                g2 = g2.getParent();
                d2--;
            } else {
                g1 = g1.getParent();
                d1--;
            }
        }

        while (g1 != g2) {
            g1 = g1.getParent();
            g2 = g2.getParent();
        }
        return g1;
    }

    public int depthOf(Thread t) {
        Node node = t.getPosition();
        int depth = 0;
        while (!node.isRoot()) {
            depth++;
            node = node.getParent();
        }
        return depth;
    }

    // =========================================================================================================
    // ============================================= Inner classes =============================================
    // =========================================================================================================

    // ---------------------------------------------------------------------------------------------------------
    // Node

    public sealed interface Node permits Group, Leaf {
        int getLocalId();
        Group getParent();
        List<Node> getChildren();
        String getScope();

        default boolean isRoot() { return getParent() == null; }

        default boolean isLeaf() { return this instanceof Leaf; }

        default boolean isInit() {
            return this instanceof Group group && group.getScope().equals("INIT")
                    || this instanceof Leaf leaf && leaf.getParent().isInit();
        }

        default List<Node> flatten(Predicate<Node> filter) {
            final List<Node> nodes = new ArrayList<>();
            collect(this, nodes::add, filter);
            return nodes;
        }


        private static void collect(Node node, Consumer<Node> collector, Predicate<Node> filter) {
            if (!filter.test(node)) {
                return;
            }

            collector.accept(node);
            for (Node child : node.getChildren()) {
                collect(child, collector, filter);
            }
        }


        default String getPositionString() {
            List<String> scopedIds = new ArrayList<>();
            Node group = this;
            while (!group.isRoot()) {
                scopedIds.add(group.getScope() + ":" + group.getLocalId());
                group = group.getParent();
            }

            return Lists.reverse(scopedIds).stream().collect(Collectors.joining(",", "[", "]"));
        }

        private String simpleString() {
            if (this instanceof Leaf leaf) {
                return leaf.toString();
            } else if (this instanceof Group group) {
                return group.getScope() + "#" + group.getLocalId();
            }

            throw new RuntimeException("Unreachable");
        }
    }

    // ---------------------------------------------------------------------------------------------------------
    // Group


    public final class Group implements Node {
        private final Group parent;
        private final String scope;
        private final int id;
        private final List<Node> children = new ArrayList<>();

        public Group(Group parent, String scope, int id) {
            this.parent = parent;
            this.scope = scope;
            this.id = id;
        }

        @Override
        public int getLocalId() { return id; }
        @Override
        public Group getParent() { return parent; }
        @Override
        public String getScope() { return scope; }
        @Override
        public List<Node> getChildren() { return children; }

        public Group findGroup(Position position, boolean createIfAbsent) {
            Group cur = this;
            for (int i = 0; i < position.ids().size(); i++) {
                final int id = position.ids().get(i);
                final String scope = position.scopes().get(i);

                boolean found = false;
                for (Node node : cur.getChildren()) {
                    if (node.getScope().equals(scope) && node.getLocalId() == id) {
                        if (!(node instanceof Group group)) {
                            throw new IllegalArgumentException(String.format("Position %s is not a group.", position));
                        }
                        cur = group;
                        found = true;
                    }
                }

                if (!found) {
                    if (!createIfAbsent) {
                        throw new IllegalArgumentException("Position " + position + " does not exist.");
                    }

                    final Group newGroup = new Group(cur, scope, id);
                    cur.getChildren().add(newGroup);
                    cur = newGroup;
                }
            }

            return cur;
        }

        public Leaf addThread(Thread thread, Position position) {
            final Group group = findGroup(position, true);
            var node = new Leaf(group, thread);
            group.children.add(node);

            thread.setPosition(node);
            thread.setProgram(program);
            threadCache.add(thread);
            return node;
        }

        @Override
        public String toString() {
            return String.format("%s#%d%s", getScope(), getLocalId(), getChildren().stream()
                    .map(Node::simpleString)
                    .collect(Collectors.joining(", ", "[", "]"))
            );
        }
    }

    // ---------------------------------------------------------------------------------------------------------
    // Leaf

    public static final class Leaf implements Node {
        private final Group parent;
        private final Thread thread;

        public Leaf(Group group, Thread thread) {
            this.parent = Preconditions.checkNotNull(group);
            this.thread = Preconditions.checkNotNull(thread);
        }

        public Thread getThread() { return thread; }

        @Override
        public int getLocalId() { return thread.getId(); }
        @Override
        public Group getParent() { return parent; }
        @Override
        public List<Node> getChildren() { return List.of(); }
        @Override
        public String getScope() { return "THREAD"; }

        @Override
        public String toString() {
            return String.format("%d: %s", getLocalId(), thread.getName());
        }
    }

    // ---------------------------------------------------------------------------------------------------------
    // Position

    public record Position(List<String> scopes, List<Integer> ids) {
        public static final Position EMPTY = new Position(ImmutableList.of(), ImmutableList.of());
        public static final Position INIT = new Position(ImmutableList.of("INIT"), ImmutableList.of(0));

        private static List<String> getScopesForArch(Arch arch) {
            final List<String> scopes = switch (arch) {
                case VULKAN -> Tag.Vulkan.getScopeTags();
                case OPENCL -> Tag.OpenCL.getScopeTags();
                case PTX -> Tag.PTX.getScopeTags();
                default -> throw new MalformedProgramException("Unsupported architecture for thread creation: " + arch);
            };
            return Lists.reverse(scopes);
        }

        public static Position fromGrid(Arch arch, ThreadGrid grid, int tid) {
            final List<Integer> ids = switch (arch) {
                case VULKAN -> List.of(0, grid.qfId(tid), grid.wgId(tid), grid.sgId(tid));
                case OPENCL -> List.of(0, grid.qfId(tid), grid.wgId(tid), grid.sgId(tid));
                default -> throw new MalformedProgramException("Unsupported architecture for thread creation: " + arch);
            };

            return new Position(getScopesForArch(arch), ids);
        }

        public static Position fromArchitecture(Arch arch, int... ids) {
            final List<Integer> idList = Arrays.stream(ids).boxed().toList();
            return new Position(getScopesForArch(arch), idList);
        }

        public Position {
            Preconditions.checkArgument(scopes.size() == ids.size());
        }

        @Override
        public String toString() {
            return IntStream.range(0, ids.size())
                    .mapToObj(i -> scopes.get(i) + ":" + ids.get(i))
                    .collect(Collectors.joining(", ", "[", "]"));
        }
    }
}
