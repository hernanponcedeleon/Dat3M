package porthosc.languages.common.graph;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.util.Iterator;

import static porthosc.utils.StringUtils.wrap;


public abstract class UnrolledFlowGraph<N extends FlowGraphNode>
        extends FlowGraph<N> {

    private ImmutableMap<N, ImmutableSet<N>> edgesReversed;
    private ImmutableMap<N, ImmutableSet<N>> altEdgesReversed;

    private final ImmutableList<N> nodesLinearised;
    private final ImmutableMap<N, Integer> condLevelMap;//TODO: this is unnecessary information

    public UnrolledFlowGraph(N source,
                             N sink,
                             ImmutableMap<N, N> edges,
                             ImmutableMap<N, N> altEdges,
                             ImmutableMap<N, ImmutableSet<N>> edgesReversed,
                             ImmutableMap<N, ImmutableSet<N>> altEdgesReversed,
                             ImmutableList<N> nodesLinearised,
                             ImmutableMap<N, Integer> condLevelMap) {
        super(source, sink, edges, altEdges);
        this.edgesReversed = edgesReversed;
        this.altEdgesReversed = altEdgesReversed;
        this.nodesLinearised = nodesLinearised;
        this.condLevelMap = condLevelMap;
    }

    public Iterator<N> linearisedNodesIterator() {
        return nodesLinearised.iterator();
    }

    public int compareTopologicallyAndCondLevel(N one, N two) {
        int topologically = compareTopologically(one, two);
        if (topologically == 0) {
            assert (one == two) : one + "," + two;
            return 0;
        }
        N first, second;
        if (topologically < 0) {
            first = one;
            second = two;
        }
        else {
            first = two;
            second = one;
        }
        // ..., first, ..., second, ...
        int firstCondLevel = condLevelMap.get(first);
        int secondCondLevel = condLevelMap.get(second);
        return (-1 * topologically) * (firstCondLevel - secondCondLevel); // TODO: check this equation
    }

    public int compareTopologically(N one, N two) {
        if (one == two) {
            assert nodesLinearised.contains(one);
            assert nodesLinearised.contains(two);
            return 0;
        }
        boolean oneFound = false, twoFound = false;
        for (N node : nodesLinearised) {
            if (oneFound) {
                if (two.equals(node)) {
                    return -1; // ..., one, ..., two, ...
                }
            }
            else {
                oneFound = one.equals(node);
            }
            if (twoFound) {
                if (one.equals(node)) {
                    return 1; // ..., two, ..., one, ...
                }
            }
            else {
                twoFound = two.equals(node);
            }
        }
        throw new IllegalArgumentException("Could not find both of nodes in linearised set: " + wrap(one) + " and " + wrap(two));
    }

    public boolean hasParent(boolean edgeSign, N node) {
        return getEdgesReversed(edgeSign).containsKey(node);
    }

    public ImmutableSet<N> parents(boolean edgeKind, N node) {
        ImmutableMap<N, ImmutableSet<N>> reversedMap = getEdgesReversed(edgeKind);
        assert reversedMap.containsKey(node) : node;
        return reversedMap.get(node);
    }

    public ImmutableMap<N, ImmutableSet<N>> getEdgesReversed(boolean edgesSign) {
        return edgesSign ? edgesReversed : altEdgesReversed;
    }
}
