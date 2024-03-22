package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.Dependency;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.utils.visualization.Graphviz;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import com.google.common.math.IntMath;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;

/**
 * Offset- and alignment-enhanced inclusion-based pointer analysis based on Andersen's.
 * This implementation is insensitive to control-flow, but field-sensitive.
 * <p>
 * The edges of the inclusion graph are labeled with sets of offset-alignment pairs.
 * Expressions with well-defined behavior have the form `base [+ constant * register]* + constant`.
 * Bases are either {@link Register variables} or {@link MemoryObject direct references to structures}.
 * Non-conforming expressions are probed for bases, which contribute in the most general manner:
 * Given the base refers to an object {@code x},
 * then the expression may return a pointer to any byte of {@code x},
 * even outside its bounds.
 * <p>
 * Structures, that never occurs in any expression, are considered unreachable.
 */
public class InclusionBasedPointerAnalysis implements AliasAnalysis {

    private static final Logger logger = LogManager.getLogger(InclusionBasedPointerAnalysis.class);

    private static final List<Integer> TOP = List.of(1);

    private final Map<Integer, int[]> totalAlignmentSizes = logger.isDebugEnabled() ? new HashMap<>() : null;

    private int totalVariables = 0;
    private int totalReplacements = 0;
    private int failedAddInto = 0;
    private int succeededAddInto = 0;
    private Graphviz graphviz;

    ///When a pointer set gains new content, it is added to this queue
    private final LinkedHashMap<Variable, List<Offset<Variable>>> queue = new LinkedHashMap<>();

    ///Result sets
    private final Map<MemoryCoreEvent, Offset<Variable>> eventAddressSpaceMap = new HashMap<>();

    // These instances should never get incoming edges.
    private final Map<MemoryObject, Variable> constantMap = new HashMap<>();

    private final Map<List<RegWriter>, Offset<Variable>> variableMap = new HashMap<>();

    private final Dependency dependency;
    private final Supplier<SyntacticContextAnalysis> synContext;

    private static final class Variable {
        private final List<Offset<Variable>> includes = new ArrayList<>();
        private final List<Offset<Variable>> loads = new ArrayList<>();
        private final List<Offset<Offset<Variable>>> stores = new ArrayList<>();
        // all variables that have a direct link to this
        private final HashSet<Variable> seeAlso = new HashSet<>();
        private final MemoryObject object;
        private final String name;
        private Variable(MemoryObject o, String n) {
            object = o;
            name = n;
        }
        @Override public String toString() { return name; }
    }

    // ================================ Construction ================================

    public static InclusionBasedPointerAnalysis fromConfig(Program program, Context analysisContext, AliasAnalysis.Config config) {
        final var analysis = new InclusionBasedPointerAnalysis(program, analysisContext.requires(Dependency.class));
        analysis.run(program, config);
        logger.debug("variable count: {}", analysis.totalVariables);
        logger.debug("replacement count: {}", analysis.totalReplacements);
        logger.debug("alignment sizes: {}", analysis.totalAlignmentSizes);
        logger.debug("addInto: {} successes vs {} fails", analysis.succeededAddInto, analysis.failedAddInto);
        return analysis;
    }

    private InclusionBasedPointerAnalysis(Program p, Dependency d) {
        dependency = d;
        synContext = Suppliers.memoize(() -> SyntacticContextAnalysis.newInstance(p));
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        final Offset<Variable> vx = eventAddressSpaceMap.get(x);
        final Offset<Variable> vy = eventAddressSpaceMap.get(y);
        if (vx == null || vy == null) {
            return true;
        }
        if (vx.base == vy.base && vx.alignment.isEmpty() && vy.alignment.isEmpty()) {
            return vx.offset == vy.offset;
        }
        final List<Offset<Variable>> ox = new ArrayList<>(vx.base.includes);
        ox.add(new Offset<>(vx.base, 0, List.of()));
        final List<Offset<Variable>> oy = new ArrayList<>(vy.base.includes);
        oy.add(new Offset<>(vy.base, 0, List.of()));
        for (final Offset<Variable> ax : ox) {
            for (final Offset<Variable> ay : oy) {
                if (ax.base == ay.base && overlaps(ay.offset + vy.offset - ax.offset - vx.offset,
                        join(ax.alignment, vx.alignment), join(ay.alignment, vy.alignment))) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        final Offset<Variable> vx = eventAddressSpaceMap.get(x);
        final Offset<Variable> vy = eventAddressSpaceMap.get(y);
        return vx != null && vy != null && vx.base == vy.base && vx.offset == vy.offset &&
                vx.alignment.isEmpty() && vy.alignment.isEmpty();
    }

    @Override
    public Graphviz getGraphVisualization() {
        return graphviz;
    }

    // ================================ Processing ================================

    private void run(Program program, AliasAnalysis.Config configuration) {
        checkArgument(program.isCompiled(), "The program must be compiled first.");
        // Pre-processing:
        for (final MemoryObject object : program.getMemory().getObjects()) {
            totalVariables++;
            constantMap.put(object, new Variable(object, object.toString()));
        }
        for (final RegWriter writer : program.getThreadEvents(RegWriter.class)) {
            processWriter(writer);
        }
        for (final MemoryCoreEvent store : program.getThreadEvents(MemoryCoreEvent.class)) {
            processMemoryEvent(store);
        }
        // Fixed-point computation:
        while (!queue.isEmpty()) {
            //TODO replace with removeFirst() when using java 21 or newer
            final Variable variable = queue.keySet().iterator().next();
            final List<Offset<Variable>> edges = queue.remove(variable);
            logger.trace("dequeue {}", variable);
            algorithm(variable, edges);
        }
        if (configuration.graphvizInternal) {
            generateGraph();
        }
        for (final Map.Entry<MemoryCoreEvent, Offset<Variable>> entry : eventAddressSpaceMap.entrySet()) {
            postProcess(entry);
        }
        constantMap.clear();
        variableMap.clear();
    }

    private void processWriter(RegWriter event) {
        logger.trace("{}", event);
        final Expression expr = event instanceof Local local ? local.getExpr() :
                event instanceof ThreadArgument arg ? arg.getCreator().getArguments().get(arg.getIndex()) : null;
        final Offset<Variable> value;
        if (expr != null) {
            final Event pov = event instanceof ThreadArgument arg ? arg.getCreator() : event;
            value = getResultVariable(expr, pov);
            if (value == null) {
                return;
            }
        } else if (event instanceof Load load) {
            final Offset<Variable> address = getResultVariable(load.getAddress(), load);
            if (address == null) {
                logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
                return;
            }
            eventAddressSpaceMap.put(load, address);
            final var result = newVariable("ld" + load.getGlobalId() + "(" + load.getResultRegister().getName() + ")");
            addInto(address.base.loads, new Offset<>(result, address.offset, address.alignment));
            result.seeAlso.add(address.base);
            value = new Offset<>(result, 0, List.of());
        } else {
            return;
        }
        final Offset<Variable> old = variableMap.put(List.of(event), value);
        if (old != null) {
            // this might happen if events are iterated out of order
            assert old.offset == 0 && old.alignment.isEmpty();
            replace(old.base, value);
        }
    }

    private void processMemoryEvent(MemoryCoreEvent event) {
        logger.trace("{}", event);
        if (event instanceof Load) {
            // event was already processed in processWriter(RegWriter)
            return;
        }
        final Offset<Variable> address = getResultVariable(event.getAddress(), event);
        if (address == null) {
            logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
            return;
        }
        eventAddressSpaceMap.put(event, address);
        if (event instanceof Store store) {
            final Offset<Variable> value = getResultVariable(store.getMemValue(), store);
            if (value != null) {
                final Offset<Offset<Variable>> edge = new Offset<>(value, address.offset, address.alignment);
                addInto(address.base.stores, edge);
                value.base.seeAlso.add(address.base);
                final List<Offset<Variable>> loads = new ArrayList<>(address.base.loads);
                for (final Variable includer : address.base.seeAlso) {
                    if (includer.loads.isEmpty()) {
                        continue;
                    }
                    for (final Offset<Variable> i : includer.includes) {
                        if (i.base == address.base) {
                            for (final Offset<Variable> load : includer.loads) {
                                loads.add(join(load, i.offset, i.alignment));
                            }
                        }
                    }
                }
                processCommunication(List.of(edge), loads);
            }
        }
    }

    private void algorithm(Variable variable, List<Offset<Variable>> edges) {
        logger.trace("{} includes {}", variable, edges);
        // 'A -> variable -> B' implies 'A -> B'.
        for (final Variable user : List.copyOf(variable.seeAlso)) {
            for (final Offset<Variable> edgeAfter : user.includes.stream().filter(e -> e.base == variable).toList()) {
                for (final Offset<Variable> edge : edges) {
                    addEdge(edge.base, user, edge.offset + edgeAfter.offset, join(edge.alignment, edgeAfter.alignment));
                }
            }
        }
        // memory communication
        // X <stores- A <- variable -> B -loads> Y   ==>   X -> Y (if overlapping modifiers)
        // Note that variable -> variable can be implied here
        final boolean hasLoads = !variable.loads.isEmpty();
        final boolean hasStores = !variable.stores.isEmpty();
        if (hasLoads || hasStores) {
            for (final Offset<Variable> edge : edges) {
                final Set<Offset<Variable>> loads = new HashSet<>(edge.base.loads);
                final Set<Offset<Offset<Variable>>> stores = new HashSet<>(edge.base.stores);
                for (final Variable out : edge.base.seeAlso) {
                    for (final Offset<Variable> edge1 : out.includes) {
                        if (hasStores && edge1.base == edge.base) {
                            for (final Offset<Variable> load : out.loads) {
                                loads.add(join(load, edge1.offset, edge1.alignment));
                            }
                        }
                        if (hasLoads && edge1.base == edge.base) {
                            for (final Offset<Offset<Variable>> store : out.stores) {
                                stores.add(join(store, edge1.offset, edge1.alignment));
                            }
                        }
                    }
                }
                processCommunication(variable.stores, loads);
                processCommunication(stores, variable.loads);
            }
        }
    }

    private void postProcess(Map.Entry<MemoryCoreEvent, Offset<Variable>> entry) {
        logger.trace("{}", entry);
        final Offset<Variable> address = entry.getValue();
        if (address == null) {
            // should have already warned about this event
            return;
        }
        // Remove all obsolete inclusion relationships between register states.
        address.base.includes.removeIf(i -> i.base.object == null);
        address.base.loads.clear();
        address.base.stores.clear();
        address.base.seeAlso.clear();
        // In a well-structured program, all address expressions refer to at least one memory object.
        if (logger.isWarnEnabled() && address.base.object == null &&
                address.base.includes.stream().allMatch(i -> i.base.object == null)) {
            logger.warn("empty pointer set for {}", synContext.get().getContextInfo(entry.getKey()));
        }
        if (address.base.includes.size() != 1) {
            return;
        }
        final Offset<Variable> included = join(address.base.includes.get(0), address.offset, address.alignment);
        assert included.base.object != null;
        // If the only included address refers to the last element, treat it as a direct static offset instead.
        final int remainingSize = included.base.object.size() - included.offset;
        for (final Integer a : included.alignment) {
            if (a < remainingSize) {
                return;
            }
        }
        entry.setValue(new Offset<>(included.base, included.offset, List.of()));
    }

    // Inserts a single inclusion relationship into the graph.
    // Also detects and eliminates cycles, assuming that the graph was already closed transitively.
    // Also closes the inclusion relation transitively on the left.
    private void addEdge(Variable v1, Variable v2, int o, List<Integer> a) {
        // When adding a self-loop, try to accelerate it immediately: 'v -+1> v' means 'v -+1x> v'.
        final var edge = tryAccelerateEdge(new Offset<>(v1, o, a), v2);
        if (!addInto(v2.includes, edge)) {
            return;
        }
        v1.seeAlso.add(v2);
        final List<Offset<Variable>> edges = queue.computeIfAbsent(v2, k -> new ArrayList<>());
        if (edges.isEmpty()) {
            logger.trace("enqueue {}", v2);
        }
        edges.add(edge);
        // 'v0 -> v1 -> v2' implies 'v0 -> v2'.
        // Cases of 'v0 == v2' or 'v0 == v1' require recursion.
        final var stack = new Stack<Offset<Variable>>();
        stack.push(edge);
        while (!stack.empty()) {
            final Offset<Variable> e = stack.pop();
            for (final Offset<Variable> edgeBefore : List.copyOf(e.base.includes)) {
                final var joinedEdge = tryAccelerateEdge(join(edgeBefore, e.offset, e.alignment), v2);
                if (addInto(v2.includes, joinedEdge)) {
                    edgeBefore.base.seeAlso.add(v2);
                    edges.add(joinedEdge);
                    if (edgeBefore.base == v1 || edgeBefore.base == v2) {
                        stack.push(joinedEdge);
                    }
                }
            }
        }
    }

    // Called before adding an 'include' edge.  For self-loops, promotes the static modifier to a dynamic modifier.
    private static Offset<Variable> tryAccelerateEdge(Offset<Variable> edge, Variable v2) {
        // FIXME if 0+[1]x is not able to include -1, then self-loops will not terminate
        // therefore, negative edge.offset get passed as-is into join.
        return v2 != edge.base ? edge : new Offset<>(v2, 0, join(edge.alignment, edge.offset));
    }

    // Called when a placeholder variable for a register writer is to be replaced by the proper variable.
    // A variable cannot be removed, if some event maps to it and there are multiple replacements.
    // In this case, the mapping stays but all outgoing edges are removed from that variable.
    private void replace(Variable old, Offset<Variable> replacement) {
        assert old != replacement.base;
        assert !constantMap.containsValue(old);
        totalReplacements++;
        logger.trace("{} -> {}", old, replacement);
        // likely / most frequent case
        eventAddressSpaceMap.replaceAll((k, v) -> v.base != old ? v : join(replacement, v.offset, v.alignment));
        variableMap.replaceAll((k, v) -> v.base != old ? v : join(replacement, v.offset, v.alignment));
        for (final Variable out : old.seeAlso) {
            out.includes.replaceAll(e -> e.base != old ? e : join(replacement, e.offset, e.alignment));
            out.loads.replaceAll(e -> e.base != old ? e : join(replacement, e.offset, e.alignment));
            out.stores.replaceAll(e -> e.base.base != old ? e :
                    new Offset<>(join(replacement, e.base.offset, e.base.alignment), e.offset, e.alignment));
        }
        replacement.base.seeAlso.addAll(old.seeAlso);
        for (final Offset<Variable> edge : old.includes) {
            edge.base.seeAlso.remove(old);
            edge.base.seeAlso.add(replacement.base);
        }
        // Redirect load and store relationships.
        // This could enable more communications, but replacement.
        for (final Offset<Variable> load : old.loads) {
            addInto(replacement.base.loads, join(load, replacement.offset, replacement.alignment));
            load.base.seeAlso.add(replacement.base);
        }
        for (final Offset<Offset<Variable>> store : old.stores) {
            addInto(replacement.base.stores, join(store, replacement.offset, replacement.alignment));
            store.base.base.seeAlso.add(replacement.base);
        }
        old.seeAlso.clear();
        old.includes.clear();
        old.loads.clear();
        old.stores.clear();
    }

    private void processCommunication(Collection<Offset<Offset<Variable>>> stores, Collection<Offset<Variable>> loads) {
        logger.trace("{} vs {}", stores, loads);
        if (loads.isEmpty()) {
            return;
        }
        for (final Offset<Offset<Variable>> store : stores) {
            for (final Offset<Variable> load : loads) {
                if (overlaps(load.offset - store.offset, store.alignment, load.alignment)) {
                    addEdge(store.base.base, load.base, store.base.offset, store.base.alignment);
                }
            }
        }
    }

    private record Offset<Base>(Base base, int offset, List<Integer> alignment) {
        @Override public String toString() { return String.format("%s+%d+%sx", base, offset, alignment); }
    }

    // checks if leftAlignment contains all linear combinations of offset + rightAlignment
    private boolean includes(int offset, List<Integer> leftAlignment, List<Integer> rightAlignment) {
        if (totalAlignmentSizes != null) {
            totalAlignmentSizes.computeIfAbsent(leftAlignment.size() + rightAlignment.size(), k -> new int[1])[0]++;
        }
        if (leftAlignment.isEmpty()) {
            return rightAlignment.isEmpty() && offset == 0;
        }
        for (final Integer a : leftAlignment) {
            if (a < 0) {
                final int l = absGcd(leftAlignment);
                final int r = absGcd(rightAlignment);
                return offset % l == 0 && r % l == 0;
            }
        }
        for (final Integer a : rightAlignment) {
            if (a < 0) {
                final int l = absGcd(leftAlignment);
                final int r = absGcd(rightAlignment);
                return offset % l == 0 && r % l == 0;
            }
        }
        // FIXME assumes that dynamic indexes used here only have non-negative values.
        // This cannot be used when a negative alignment occurs, because the analysis would not terminate.
        if (leftAlignment.size() == 1) {
            final int alignment = Math.abs(leftAlignment.get(0));
            for (final Integer a : rightAlignment) {
                if (a % alignment != 0) {
                    return false;
                }
            }
            return offset % alignment == 0;
        }
        // Case of multiple dynamic indexes with pairwise indivisible alignments.
        final int gcd = IntMath.gcd(gcd(rightAlignment), Math.abs(offset));
        if (gcd == 0) {
            return true;
        }
        int max = Math.abs(offset);
        for (final Integer i : rightAlignment) {
            max = Math.max(max, i);
        }
        final var mem = new boolean[max / gcd + 1];
        mem[0] = true;
        for (int j = 1; j < mem.length; j++) {
            for (final Integer i : leftAlignment) {
                if (j - i/gcd >= 0 && mem[j - i/gcd]) {
                    mem[j] = true;
                    break;
                }
            }
        }
        for (final Integer j : rightAlignment) {
            if (!mem[j/gcd]) {
                return false;
            }
        }
        return mem[Math.abs(offset)/gcd];
    }

    // checks if leftAlignment contains some linear combination of offset + rightAlignment
    private static boolean overlaps(int offset, List<Integer> leftAlignment, List<Integer> rightAlignment) {
        // exists non-negative integers x, y with leftOffset + x * leftAlignment == rightOffset + y * rightAlignment
        final int left = gcd(leftAlignment);
        final int right = gcd(rightAlignment);
        if (left == 0 && right == 0) {
            return offset == 0;
        }
        final int divisor = left == 0 ? right : right == 0 ? left : IntMath.gcd(left, right);
        final boolean nonNegativeIndexes = left == 0 ? offset <= 0 : right != 0 || offset >= 0;
        return nonNegativeIndexes && offset % divisor == 0;
    }

    private <T> boolean addInto(List<Offset<T>> set, Offset<T> element) {
        //NOTE The Stream API is too costly here
        for (final Offset<T> o : set) {
            if (element.base.equals(o.base) && includes(element.offset - o.offset, o.alignment, element.alignment)) {
                failedAddInto++;
                return false;
            }
        }
        set.removeIf(o -> element.base.equals(o.base) &&
                includes(o.offset - element.offset, element.alignment, o.alignment));
        set.add(element);
        succeededAddInto++;
        return true;
    }

    private static int absGcd(List<Integer> alignment) {
        if (alignment.isEmpty()) {
            return 0;
        }
        int result = Math.abs(alignment.get(0));
        for (final Integer a : alignment.subList(1, alignment.size())) {
            result = IntMath.gcd(result, Math.abs(a));
        }
        return result;
    }

    private static int gcd(List<Integer> alignment) {
        if (alignment.isEmpty()) {
            return 0;
        }
        int result = alignment.get(0);
        for (final Integer a : alignment.subList(1, alignment.size())) {
            result = IntMath.gcd(result, a);
        }
        return result;
    }

    private static List<Integer> join(List<Integer> left, List<Integer> right) {
        if (left.isEmpty() || right.isEmpty()) {
            return right.isEmpty() ? left : right;
        }
        if (left == TOP || right == TOP) {
            return TOP;
        }
        // assert left and right each consist of pairwise indivisible positives
        final List<Integer> result = new ArrayList<>();
        for (final Integer i : left) {
            if (!right.contains(i) && hasNoDivisorsInList(i, right)) {
                result.add(i);
            }
        }
        for (final Integer j : right) {
            if (hasNoDivisorsInList(j, left)) {
                result.add(j);
            }
        }
        return result;
    }

    private static boolean hasNoDivisorsInList(int value, List<Integer> candidates) {
        for (final Integer candidate : candidates) {
            if (value % candidate == 0) {
                return false;
            }
        }
        return true;
    }

    private static List<Integer> join(List<Integer> left, int right) {
        return right == 0 ? left : join(left, List.of(right));
    }

    private static List<Integer> join(List<Integer> left, Register right) {
        return right == null ? left : TOP;
    }

    private static <T> Offset<T> join(Offset<T> other, int offset, List<Integer> alignment) {
        if (offset == 0 && alignment.isEmpty()) {
            return other;
        }
        return new Offset<>(other.base, other.offset + offset, join(other.alignment, alignment));
    }

    private static List<Integer> mul(List<Integer> a, int factor) {
        return factor == 0 ? List.of() : a.stream().map(i -> i * factor).toList();
    }

    // Describes (constant address or register or zero) + offset + alignment * (variable)
    private record Result(MemoryObject address, Register register, BigInteger offset, List<Integer> alignment) {
        @Override
        public String toString() {
            return String.format("%s+%s+%sx", address != null ? address : register, offset, alignment);
        }
    }

    // Interprets an expression.
    // The result refers to an existing variable,
    // if the expression has a static base, or if the expression has a dynamic base with exactly one writer.
    // Otherwise, it refers to a new variable with proper incoming edges.
    private Offset<Variable> getResultVariable(Expression expression, Event event) {
        final var collector = new Collector();
        final Result result = expression.accept(collector);
        final Offset<Variable> main;
        final int offset = result == null ? 0 : result.offset.intValue();
        if (result == null) {
            main = null;
        } else if (result.address != null) {
            main = new Offset<>(constantMap.get(result.address), offset, result.alignment);
        } else if (result.register == null) {
            main = null;
        } else {
            main = join(getPhiNodeVariable(result.register, event), offset, result.alignment);
        }
        if (main != null &&
                collector.address.stream().noneMatch(a -> a != result.address) &&
                collector.register.stream().noneMatch(r -> r != result.register)) {
            return main;
        }
        if (main == null && collector.address.isEmpty() && collector.register.isEmpty()) {
            return null;
        }
        final var variable = newVariable("re" + event.getGlobalId() + "(" + expression + ")");
        if (main != null) {
            addEdge(main.base, variable, main.offset, main.alignment);
        }
        for (final MemoryObject object : collector.address) {
            if (result == null || object != result.address) {
                addEdge(constantMap.get(object), variable, 0, TOP);
            }
        }
        for (final Register register : collector.register) {
            if (result == null || register != result.register) {
                final Offset<Variable> registerVariable = getPhiNodeVariable(register, event);
                addEdge(registerVariable.base, variable, 0, TOP);
            }
        }
        return new Offset<>(variable, 0, List.of());
    }

    // Fetches the node for address values that can be read from a register at a specific program point.
    // Constructs a new node, if there are multiple writers.
    private Offset<Variable> getPhiNodeVariable(Register r, Event e) {
        final List<RegWriter> writers = dependency.of(e, r).may;
        final Offset<Variable> find = variableMap.get(writers);
        if (find != null) {
            return find;
        }
        final var result = newVariable("jn" + e.getGlobalId() + "(" + r.getName() + ")");
        for (final RegWriter writer : writers.size() == 1 ? List.<RegWriter>of() : writers) {
            // The variables created here will be replaced later, if the events are out of order.
            final Offset<Variable> writerVariable = variableMap.computeIfAbsent(List.of(writer),
                    k -> new Offset<>(newVariable("ph" + e.getGlobalId()), 0, List.of()));
            addEdge(writerVariable.base, result, writerVariable.offset, writerVariable.alignment);
        }
        return variableMap.compute(writers, (k, v) -> new Offset<>(result, 0, List.of()));
    }

    private Variable newVariable(String name) {
        totalVariables++;
        return new Variable(null, name);
    }

    private static final class Collector implements ExpressionVisitor<Result> {

        final HashSet<MemoryObject> address = new HashSet<>();
        final HashSet<Register> register = new HashSet<>();

        @Override
        public Result visitExpression(Expression expr) {
            return null;
        }

        @Override
        public Result visitIntBinaryExpression(IntBinaryExpr x) {
            final Result left = x.getLeft().accept(this);
            final Result right = x.getRight().accept(this);
            final IntBinaryOp kind = x.getKind();
            if (left == null || right == null || kind == IntBinaryOp.RSHIFT) {
                return null;
            }
            if (left.address == null && left.register == null && left.alignment.isEmpty() && right.address == null &&
                    right.register == null && right.alignment.isEmpty()) {
                // TODO: Make sure that the type of normalization does not break this code.
                //  Maybe always do signed normalization?
                return new Result(null, null, kind.apply(left.offset, right.offset, x.getType().getBitWidth()), List.of());
            }
            return switch (kind) {
                case MUL -> {
                    if (left.address != null || right.address != null) {
                        yield null;
                    }
                    final List<Integer> leftAlignment = mul(join(left.alignment, left.register), right.offset.intValue());
                    final List<Integer> rightAlignment = mul(join(right.alignment, right.register), left.offset.intValue());
                    yield new Result(null, null, left.offset.multiply(right.offset), join(leftAlignment, rightAlignment));
                }
                case ADD, SUB -> {
                    if (left.address != null && right.address != null) {
                        yield null;
                    }
                    final MemoryObject base = left.address != null ? left.address : right.address;
                    final BigInteger offset = kind.apply(left.offset, right.offset, x.getType().getBitWidth());
                    if (base != null) {
                        final List<Integer> leftAlignment = join(left.alignment, left.register);
                        final List<Integer> rightAlignment = join(right.alignment, right.register);
                        yield new Result(base, null, offset, join(leftAlignment, rightAlignment));
                    }
                    if (left.register != null && right.register != null) {
                        yield null;
                    }
                    final Register register = left.register != null ? left.register : right.register;
                    final List<Integer> alignment = join(left.alignment, right.alignment);
                    yield new Result(null, register, offset, alignment);
                }
                default -> null;
            };
        }

        @Override
        public Result visitIntUnaryExpression(IntUnaryExpr x) {
            final Result result = x.getOperand().accept(this);
            return result == null ? null : x.getKind() != IntUnaryOp.MINUS ? result :
                    new Result(null, null, result.offset.negate(), result.alignment.isEmpty() ? TOP : result.alignment);
        }

        @Override
        public Result visitITEExpression(ITEExpr x) {
            x.getTrueCase().accept(this);
            x.getFalseCase().accept(this);
            return null;
        }

        @Override
        public Result visitMemoryObject(MemoryObject a) {
            address.add(a);
            return new Result(a, null, BigInteger.ZERO, List.of());
        }

        @Override
        public Result visitRegister(Register r) {
            register.add(r);
            return new Result(null, r, BigInteger.ZERO, List.of());
        }

        @Override
        public Result visitIntLiteral(IntLiteral v) {
            return new Result(null, null, v.getValue(), List.of());
        }
    }

    // Projects the internal representation of this analysis:
    // Nodes are variables, grey edges are inclusions.
    // Blue edges connect address variables to register variables.
    // Red edges connect address variables to stored value variables.
    // Green-labeled nodes represent memory objects.
    // Red-labeled nodes are address variables that do not include any memory objects (probably a bug).
    // Blue-labeled nodes are variables where transitivity is broken (certainly a bug).
    private void generateGraph() {
        final Set<Variable> seen = new HashSet<>(constantMap.values());
        for (Set<Variable> news = seen; !news.isEmpty();) {
            final var next = new HashSet<Variable>();
            for (final Variable v : news) {
                next.addAll(v.seeAlso);
                v.includes.forEach(o -> next.add(o.base));
                v.loads.forEach(o -> next.add(o.base));
                v.stores.forEach(o -> next.add(o.base.base));
            }
            next.removeAll(seen);
            seen.addAll(next);
            news = next;
        }
        final Map<String, Set<String>> map = new HashMap<>();
        final Map<String, Set<String>> loads = new HashMap<>();
        final Map<String, Set<String>> stores = new HashMap<>();
        for (Variable v : seen) {
            if (v == null) {
                continue;
            }
            for (final Offset<Variable> i : v.includes) {
                verify(i.base.seeAlso.contains(v));
                map.computeIfAbsent("\"" + i.base.name + "\"", k -> new HashSet<>()).add("\"" + v.name + "\"");
            }
            for (final Offset<Variable> i : v.loads) {
                verify(i.base.seeAlso.contains(v));
                loads.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.base.name + "\"");
            }
            for (final Offset<Offset<Variable>> i : v.stores) {
                verify(i.base.base.seeAlso.contains(v));
                stores.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.base.base.name + "\"");
            }
        }
        final Set<String> problematic = new HashSet<>();
        for (final Offset<Variable> a : eventAddressSpaceMap.values()) {
            if (!constantMap.containsValue(a.base) &&
                    a.base.includes.stream().noneMatch(i -> constantMap.containsValue(i.base))) {
                problematic.add("\"" + a.base.name + "\"");
            }
        }
        final Set<String> transitionBlocker = new HashSet<>();
        for (final var e : map.values()) {
            for (final var v2 : e) {
                if (!e.containsAll(map.getOrDefault(v2, Set.of()))) {
                    transitionBlocker.add(v2);
                }
            }
        }
        problematic.removeAll(transitionBlocker);
        graphviz = new Graphviz();
        graphviz.beginDigraph("internal alias");
        for (final Variable v : constantMap.values()) {
            graphviz.addNode("\"" + v.name + "\"", "fontcolor=mediumseagreen");
        }
        for (final String v : problematic) {
            graphviz.addNode(v, "fontcolor=red");
        }
        for (final String v : transitionBlocker) {
            graphviz.addNode(v, "fontcolor=blue");
        }
        graphviz.beginSubgraph("inclusion");
        graphviz.setEdgeAttributes("color=grey");
        graphviz.addEdges(map);
        graphviz.end();
        graphviz.beginSubgraph("loads");
        graphviz.setEdgeAttributes("color=mediumslateblue");
        graphviz.addEdges(loads);
        graphviz.end();
        graphviz.beginSubgraph("stores");
        graphviz.setEdgeAttributes("color=orangered3");
        graphviz.addEdges(stores);
        graphviz.end();
        graphviz.end();
    }
}
