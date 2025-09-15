package com.dat3m.dartagnan.program;

import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.IRHelper.isAuxiliaryThread;

public interface ThreadHierarchy {
    String getScope();
    int getId();
    Group getParent();

    List<ThreadHierarchy> getChildren();

    default List<ThreadHierarchy> getFlattened() {
        final List<ThreadHierarchy> flattened = new ArrayList<>();
        final ArrayDeque<ThreadHierarchy> worklist = new ArrayDeque<>();
        worklist.add(this);
        while (!worklist.isEmpty()) {
            flattened.add(worklist.peek());
            worklist.addAll(worklist.remove().getChildren());
        }

        return flattened;
    }

    default boolean isRoot() { return getParent() == null; }
    default boolean isLeaf() { return getChildren().isEmpty(); }

    private static String getScopeChain(ThreadHierarchy node) {
        if (node.isRoot()) {
            return node.getScope();
        }
        List<Integer> ids = new ArrayList<>();
        while (!node.isRoot()) {
            ids.add(node.getId());
            node = node.getParent();
        }
        return Lists.reverse(ids).stream()
                .map(Object::toString)
                .collect(Collectors.joining(",", "[", "]"));
    }

    static ThreadHierarchy from(Program program) {
        final List<Thread> threads = program.getThreads().stream().filter(t -> !isAuxiliaryThread(t)).toList();

        final Group root = new Group("__root", 0, null, new ArrayList<>());
        final List<String> scopes;
        if (threads.get(0).hasScope()) {
            scopes = threads.get(0).getScopeHierarchy().getScopes();
        } else {
            scopes = List.of();
        }
        construct(root, threads, scopes);
        return root;
    }

    private static void construct(Group parent, List<Thread> threads, List<String> scopes) {
        if (scopes.isEmpty()) {
            for (Thread t : threads) {
                parent.children.add(new Leaf(t, parent));
            }
        } else {
            final String curScope = scopes.get(0);
            threads.stream()
                    .collect(Collectors.groupingBy(t -> t.getScopeHierarchy().getScopeId(curScope)))
                    .forEach((id, group) -> {
                        Group groupNode = new Group(curScope, id, parent, new ArrayList<>());
                        construct(groupNode, group, scopes.subList(1, scopes.size()));
                        parent.children.add(groupNode);
                    });
        }
    }

    // =================================================================================================
    // Inner classes

    record Group(String scope, int id, Group parent, List<ThreadHierarchy> children)
            implements ThreadHierarchy {

        @Override
        public int getId() { return id; }
        @Override
        public String getScope() { return scope; }
        @Override
        public Group getParent() { return parent; }

        @Override
        public List<ThreadHierarchy> getChildren() {
            return children;
        }

        @Override
        public String toString() {
            return String.format("%s(size=%d)%s", getScope(), children.size(),
                    !isRoot() ? "@" + getScopeChain(this) : ""
            );
        }
    }

    record Leaf(Thread thread, Group parent) implements ThreadHierarchy {
        public Leaf {
            Preconditions.checkNotNull(thread);
            Preconditions.checkNotNull(parent);
        }
        @Override
        public int getId() { return thread.getId(); }
        @Override
        public String getScope() { return "__leaf"; }
        @Override
        public Group getParent() { return parent; }

        @Override
        public List<ThreadHierarchy> getChildren() {
            return List.of();
        }

        @Override
        public String toString() {
            return thread + "#" + getId() + "@" + getScopeChain(parent);
        }
    }

}