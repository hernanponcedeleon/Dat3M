package com.dat3m.dartagnan.program.analysis.alias;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.SyntacticContextAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.witness.graphviz.Graphviz;
import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import com.google.common.collect.Sets;
import com.google.common.math.IntMath;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;

/**
 * Offset- and alignment-enhanced inclusion-based pointer analysis based on Andersen's.
 * This implementation is insensitive to control-flow, but field-sensitive.
 */
/*
    The analysis constructs a directed inclusion graph over expressions of the program.
    The nodes abstractly represent the values an expression (at a program location) could take over all executions.
    There is a node (also called variable in the code) for each memory object (addr), two for each Local (result and rhs), Load (result and addr), and Store (addr and value).
    These nodes are not just per expression but also per program location to achieve an SSA-like form (*).

    Edges between two nodes A and B describe one of three relationships:
    (1) An edge "A -f_includes-> B" means that "f(A) \subseteq B" holds (where A/B are understood as sets of values).
    Rather than arbitrary functions "f", we use multi-linear expressions "f(A) = A + k1*x1 + k2*x2 + ... kn*xn + o" where ki and o are constants.
    For simplicity, we write "k*x + o" where k=(k1,...,kn) and x=(x1,...,xn) are understood as vectors, and drop the _includes suffix (i.e. write A -f-> B).
    The (sub)expression "k*x + o" describes the set of values {k*x + o | x \in Z^n} that can be obtained by varying x freely (**).
    (2) An edge "A -stores-> B" means that there exists a store that stores at address-expression A the value-expression B.
    (3) An edge "A -loads-> R" means that there exists a load that loads from address-expression A and puts its result into R (R is the node of a register).

    Initially, the graph has the following edges
    - For every "store(A, V)" event, it has a "A -stores-> V" edge
    - For every "R = load(A)" event, it has a "A -loads-> R" edge.
    - For every assignment "R := B + k*x + o", we have a "B -(k*x+o)-> R" edge
    For too complex assignments that do not match the structure, say "R := h(B1, B2, .., Bn)" where h is complex, we introduce edges "Bi -1x+0-> R".

    On this initial graph, two rules are applied until saturation
    (1) Transitivity: A -f_includes-> B AND B -g_includes-> C IMPLIES A -fg_includes-> C (notice that we need to compose the labels as well).
    (2) Communication: if A -loads-> R and B -stores-> V and A and B can overlap (i.e. the corresponding Load/Store events can alias), then V -0x+0-> R (all values in V are included in R)

    It can happen that these rules generate an edge A -f-> B although another edge A -g-> B already exists.
    In this case, the edges get merged by a join operation.
    To guarantee termination, the saturation of cyclic inclusion relationships get accelerated:
    E.g. if A includes B (B -0x+0-> A) and B includes A+2 (A -0x+2-> B)
    then A includes A+2x, B includes A+2x+2 and both include B+2x.

    (*) We also generate special phi nodes that can improve precision on code that is not in SSA form.
    (**) In the implementation we make an unsound assumption that x is non-negative.
    This disallows negative (dynamic) indexing into arrays/pointers but gives additional precision in other cases.
    Note that "o" can be negative which is sufficient to support "containerof" functionality.
*/
public class InclusionBasedPointerAnalysis implements AliasAnalysis {

    private static final Logger logger = LogManager.getLogger(InclusionBasedPointerAnalysis.class);

    private static final TypeFactory types = TypeFactory.getInstance();

    // This analysis depends on another, that maps used registers to a list of possible direct writers.
    private final ReachingDefinitionsAnalysis dependency;

    // For providing helpful error messages, this analysis prints call-stack and loop information for events.
    private final Supplier<SyntacticContextAnalysis> synContext;

    // When a variable gains an includes-edge, it is added to this queue for later processing.
    // For lazy cycle detection, it is grouped by the absolute value of IncludeEdge.modifier.offset.
    private final TreeMap<Integer, LinkedHashMap<Variable, List<IncludeEdge>>> queue = new TreeMap<>();

    // Maps memory events, allocs, and frees to variables representing their pointer set.
    private final Map<Event, DerivedVariable> addressVariables = new HashMap<>();

    // Maps pointer sets to their accessible memory objects.
    private final Map<DerivedVariable, Set<MemoryObject>> accessibleObjects = new HashMap<>();

    // Maps memory objects to variables representing their base address.
    // These Variables should always have empty includes-sets.
    private final Map<MemoryObject, Variable> objectVariables = new HashMap<>();

    // Maps a set of same-register writers to a variable representing their combined result sets (~phi node).
    // Non-trivial modifiers may only appear for singleton Locals.
    private final Map<List<RegWriter>, DerivedVariable> registerVariables = new HashMap<>();

    // Maps memory events to additional offsets inside their byte range, which may match other accesses' bounds.
    private final Map<MemoryCoreEvent, List<Integer>> mixedAccesses = new HashMap<>();

    // If enabled, the algorithm describes its internal graph to be written into a file.
    private Graphviz graphviz;

    // ================================ Debugging ================================

    private record IntPair(int x, int y) {
        @Override public String toString() {return x + "," + y;}
    }

    // Count inclusion tests grouped by complexity.
    private final Map<IntPair, Integer> totalAlignmentSizes = logger.isDebugEnabled() ? new HashMap<>() : null;
    // Count created variables.
    private int totalVariables = 0;
    // Count variable substitutions.
    private int totalReplacements = 0;
    // Count times a piece of new information was added to the graph.
    private int addIntoGraphSucceesses, addIntoGraphFails, addIntoCyclesSuccesses, addIntoCyclesFails;
    // Count cycle checks, which can result in fast or slow rejects, or accepts.
    private int cyclesFastCulled;
    private int cyclesSlowCulled;
    private int cyclesDetected;

    // ================================ Construction ================================

    public static InclusionBasedPointerAnalysis fromConfig(Program program, Context analysisContext, AliasAnalysis.Config config) {
        final ReachingDefinitionsAnalysis def = analysisContext.requires(ReachingDefinitionsAnalysis.class);
        final var analysis = new InclusionBasedPointerAnalysis(program, def);
        analysis.run(program, config);
        if (config.detectMixedSizeAccesses) {
            analysis.detectMixedSizeAccesses();
        }
        logger.debug("variable count: {}",
                analysis.totalVariables);
        logger.debug("replacement count: {}",
                analysis.totalReplacements);
        logger.debug("alignment sizes: {}",
                analysis.totalAlignmentSizes);
        logger.debug("addInto graph: {} successes vs {} fails",
                analysis.addIntoGraphSucceesses,
                analysis.addIntoGraphFails);
        logger.debug("addInto for cycle detection: {} successes vs {} fails",
                analysis.addIntoCyclesSuccesses,
                analysis.addIntoCyclesFails);
        logger.debug("cycles: {} detected vs {} fast-culled vs {} slow-culled",
                analysis.cyclesDetected,
                analysis.cyclesFastCulled,
                analysis.cyclesSlowCulled);
        return analysis;
    }

    private InclusionBasedPointerAnalysis(Program p, ReachingDefinitionsAnalysis d) {
        dependency = d;
        synContext = Suppliers.memoize(() -> SyntacticContextAnalysis.newInstance(p));
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(Event x, Event y) {
        final DerivedVariable vx = addressVariables.get(x);
        final DerivedVariable vy = addressVariables.get(y);
        if (vx == null || vy == null) {
            return true;
        }
        if (vx.base == vy.base && isConstant(vx.modifier) && isConstant(vy.modifier)) {
            return vx.modifier.offset == vy.modifier.offset;
        }
        final List<IncludeEdge> ox = toIncludeSet(vx.base);
        final List<IncludeEdge> oy = toIncludeSet(vy.base);
        for (final IncludeEdge ax : ox) {
            for (final IncludeEdge ay : oy) {
                if (ax.source == ay.source) {
                    final Modifier l = compose(ax.modifier, vx.modifier);
                    final Modifier r = compose(ay.modifier, vy.modifier);
                    if (overlaps(l, r)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    @Override
    public boolean mustAlias(Event x, Event y) {
        final DerivedVariable vx = addressVariables.get(x);
        final DerivedVariable vy = addressVariables.get(y);
        return vx != null && vy != null && vx.base == vy.base && vx.modifier.offset == vy.modifier.offset &&
                isConstant(vx.modifier) && isConstant(vy.modifier);
    }

    @Override
    public boolean mayObjectAlias(Event a, Event b) {
        final DerivedVariable va = addressVariables.get(a);
        final DerivedVariable vb = addressVariables.get(b);
        return va == null || vb == null || !Sets.intersection(accessibleObjects.get(va), accessibleObjects.get(vb)).isEmpty();
    }

    @Override
    public boolean mustObjectAlias(Event a, Event b) {
        final DerivedVariable va = addressVariables.get(a);
        final DerivedVariable vb = addressVariables.get(b);
        if (va == null || vb == null) {
            return false;
        }
        if (va.base == vb.base) {
            return true;
        }
        final Set<MemoryObject> objsA = accessibleObjects.get(va);
        return objsA.size() == 1 && objsA.equals(accessibleObjects.get(vb));
    }

    @Override
    public List<Integer> mayMixedSizeAccesses(MemoryCoreEvent event) {
        final List<Integer> result = mixedAccesses.get(event);
        if (result != null) {
            return Collections.unmodifiableList(result);
        }
        final int bytes = types.getMemorySizeInBytes(event.getAccessType());
        return IntStream.range(1, bytes).boxed().toList();
    }

    // ================================ Mixed Size Access Detection ================================

    private void detectMixedSizeAccesses() {
        final List<MemoryCoreEvent> events = addressVariables.keySet().stream()
                .filter(e -> e instanceof MemoryCoreEvent)
                .map(e -> (MemoryCoreEvent) e).collect(Collectors.toList());
        final List<Set<Integer>> offsets = new ArrayList<>();
        for (int i = 0; i < events.size(); i++) {
            final MemoryCoreEvent event0 = events.get(i);
            final var set0 = new HashSet<Integer>();
            for (int j = 0; j < i; j++) {
                detectMixedSizeAccessPair(event0, set0, events.get(j), offsets.get(j));
            }
            offsets.add(set0);
        }
        for (int i = 0; i < events.size(); i++) {
            mixedAccesses.put(events.get(i), offsets.get(i).stream().sorted().toList());
        }
    }

    private void detectMixedSizeAccessPair(MemoryCoreEvent x, Set<Integer> xSet, MemoryCoreEvent y, Set<Integer> ySet) {
        final DerivedVariable vx = addressVariables.get(x);
        final DerivedVariable vy = addressVariables.get(y);
        assert vx != null & vy != null;
        final int bytesX = types.getMemorySizeInBytes(x.getAccessType());
        final int bytesY = types.getMemorySizeInBytes(y.getAccessType());
        if (vx.base == vy.base) {
            fetchAllMixedOffsets(xSet, vx.modifier, bytesX, ySet, vy.modifier, bytesY);
            return;
        }
        final List<IncludeEdge> oy = toIncludeSet(vy.base);
        for (final IncludeEdge ax : toIncludeSet(vx.base)) {
            for (final IncludeEdge ay : oy) {
                if (ax.source == ay.source) {
                    final Modifier modifierX = compose(ax.modifier, vx.modifier);
                    final Modifier modifierY = compose(ay.modifier, vy.modifier);
                    fetchAllMixedOffsets(xSet, modifierX, bytesX, ySet, modifierY, bytesY);
                }
            }
        }
    }


    private List<IncludeEdge> toIncludeSet(Variable address) {
        final List<IncludeEdge> set = new ArrayList<>(address.includes);
        set.add(new IncludeEdge(address, TRIVIAL_MODIFIER));
        return set;
    }

    private void fetchAllMixedOffsets(Set<Integer> xSet, Modifier xModifier, int xBytes,
            Set<Integer> ySet, Modifier yModifier, int yBytes) {
        fetchMixedOffsets(xSet, xModifier, xBytes, yModifier, yBytes);
        fetchMixedOffsets(ySet, yModifier, yBytes, xModifier, xBytes);
    }

    private void fetchMixedOffsets(Set<Integer> out, Modifier modifier0, int bytes0, Modifier modifier1, int bytes1) {
        final Modifier next = compose(modifier1, modifier(bytes1, List.of()));
        for (int i = 1; i < bytes0; i++) {
            final Modifier offset = compose(modifier0, modifier(i, List.of()));
            if (overlaps(offset, modifier1) || overlaps(offset, next)) {
                out.add(i);
            }
        }
    }

    @Override
    public Graphviz getGraphVisualization() {
        return graphviz;
    }

    private Set<MemoryObject> getAccessibleObjects(DerivedVariable address) {
        final Set<MemoryObject> objs = new HashSet<>();
        objs.add(address.base.object);
        address.base.includes.forEach(i -> objs.add(i.source.object));
        objs.remove(null);
        return objs;
    }

    // ================================ Processing ================================

    private void run(Program program, AliasAnalysis.Config configuration) {
        checkArgument(program.isCompiled(), "The program must be compiled first.");
        // Pre-processing:
        // Each memory object gets a variable representing its base address value.
        for (final MemoryObject object : program.getMemory().getObjects()) {
            totalVariables++;
            objectVariables.put(object, new Variable(object, null, object.toString()));
        }
        for (final MemAlloc alloc : program.getThreadEvents(MemAlloc.class)) {
            addressVariables.put(alloc, derive(objectVariables.get(alloc.getAllocatedObject())));
        }
        // Each expression gets a "res" variable representing its result value set.
        // Each register writer gets an "out" variable ("ld" for loads) representing its return value set.
        // If needed, a register gets a "phi" variable representing its phi-node's value set.
        // Variables may fulfill multiple roles, e.g. the "out" of a Local is the "res" of its expression, etc.
        for (final RegWriter writer : program.getThreadEvents(RegWriter.class)) {
            processWriter(writer);
        }
        for (final MemoryCoreEvent memoryEvent : program.getThreadEvents(MemoryCoreEvent.class)) {
            processMemoryEvent(memoryEvent);
        }
        for (final MemFree free : program.getThreadEvents(MemFree.class)) {
            processFree(free);
        }
        // Fixed-point computation:
        while (!queue.isEmpty()) {
            final Map.Entry<Integer, LinkedHashMap<Variable, List<IncludeEdge>>> q = queue.pollFirstEntry();
            logger.trace("dequeue level={}", q.getKey());
            for (final Map.Entry<Variable, List<IncludeEdge>> e : q.getValue().entrySet()) {
                algorithm(e.getKey(), e.getValue());
            }
        }
        if (configuration.graphvizInternal) {
            generateGraph();
        }
        for (final Map.Entry<Event, DerivedVariable> entry : addressVariables.entrySet()) {
            postProcess(entry);
        }
        for (final DerivedVariable v : addressVariables.values()) {
            accessibleObjects.computeIfAbsent(v, k -> getAccessibleObjects(v));
        }
        objectVariables.clear();
        registerVariables.clear();
    }

    // Declares the "out" variable of 'event' and inserts initial 'includes' and 'loads' edges.
    // Also declares "res" and "phi" variables, if needed.
    private void processWriter(RegWriter event) {
        logger.trace("{}", event);
        final Expression expr = event instanceof Local local ? local.getExpr() :
                        event instanceof ThreadArgument arg ? arg.getCreator().getArguments().get(arg.getIndex()) :
                        event instanceof MemAlloc alloc ? alloc.getAllocatedObject() : null;
        final DerivedVariable value;
        if (expr != null) {
            final RegReader reader = event instanceof ThreadArgument arg ? arg.getCreator() : (RegReader) event;
            value = getResultVariable(expr, reader);
            if (value == null) {
                return;
            }
        } else if (event instanceof Load load) {
            final DerivedVariable address = getResultVariable(load.getAddress(), load);
            if (address == null) {
                logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
                return;
            }
            addressVariables.put(load, address);
            final Variable result = newVariable("ld" + load.getGlobalId() + "(" + load.getResultRegister().getName() + ")");
            address.base.loads.add(new LoadEdge(result, address.modifier));
            result.seeAlso.add(address.base);
            value = derive(result);
        } else {
            return;
        }
        final DerivedVariable old = registerVariables.put(List.of(event), value);
        if (old != null) {
            // this might happen if events are iterated out of order
            assert isTrivial(old.modifier);
            replace(old.base, value);
        }
    }

    // Declares the "res" variables of the address of 'event', if needed, and inserts 'stores' relationships.
    // Also propagates communications to loads, if both directly access the same variable.
    private void processMemoryEvent(MemoryCoreEvent event) {
        logger.trace("{}", event);
        if (event instanceof Load) {
            // event was already processed in processWriter(RegWriter)
            return;
        }
        final DerivedVariable address = getResultVariable(event.getAddress(), event);
        if (address == null) {
            logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
            return;
        }
        addressVariables.put(event, address);
        if (event instanceof Store store) {
            final DerivedVariable value = getResultVariable(store.getMemValue(), store);
            if (value != null) {
                final StoreEdge edge = new StoreEdge(value, address.modifier);
                address.base.stores.add(edge);
                value.base.seeAlso.add(address.base);
                final List<LoadEdge> loads = new ArrayList<>(address.base.loads);
                for (final Variable includer : address.base.seeAlso) {
                    if (includer.loads.isEmpty()) {
                        continue;
                    }
                    for (final IncludeEdge includeEdge : includer.includes) {
                        if (includeEdge.source == address.base) {
                            for (final LoadEdge load : includer.loads) {
                                loads.add(compose(load, includeEdge.modifier));
                            }
                        }
                    }
                }
                processCommunication(List.of(edge), loads);
            }
        }
    }

    private void processFree(MemFree free) {
        logger.trace("{}", free);
        final DerivedVariable address = getResultVariable(free.getAddress(), free);
        if (address == null) {
            logger.warn("null pointer address for {}", synContext.get().getContextInfo(free));
            return;
        }
        addressVariables.put(free, address);
    }

    // Propagates the pointer sets and tests for new communications.
    private void algorithm(Variable variable, List<IncludeEdge> edges) {
        logger.trace("{} includes {}", variable, edges);
        verify(variable.object == null, "Trying to add include edge to object %s.", variable);
        // Propagate pointer sets.
        final List<IncludeEdge> pointers = edges.stream().filter(e -> e.source.object != null).toList();
        if (!pointers.isEmpty()) {
            for (final Variable user : List.copyOf(variable.seeAlso)) {
                for (final IncludeEdge edgeAfter : user.includes.stream().filter(e -> e.source == variable).toList()) {
                    for (final IncludeEdge edge : pointers) {
                        addInclude(user, compose(edge, edgeAfter.modifier));
                    }
                    // In a cycle, variable gets an accelerating self-loop.
                    for (final IncludeEdge cycleEdge : detectCycles(user, edgeAfter)) {
                        if (cycleEdge.source == user) {
                            final Modifier composed = compose(cycleEdge.modifier, edgeAfter.modifier);
                            final var accelerated = new Modifier(0, compose(composed.alignment, composed.offset));
                            addInclude(user, new IncludeEdge(user, accelerated));
                        }
                    }
                }
            }
        }
        for (final IncludeEdge edgeAfter : edges) {
            if (edgeAfter.source.object != null) {
                continue;
            }
            for (final IncludeEdge edge : List.copyOf(edgeAfter.source.includes)) {
                if (edge.source.object != null) {
                    addInclude(variable, compose(edge, edgeAfter.modifier));
                }
            }
        }
        // memory communication
        // X <stores- A <- variable -> B -loads> Y   ==>   X -> Y (if overlapping modifiers)
        // Note that variable -> variable can be implied here
        final boolean hasLoads = !variable.loads.isEmpty();
        final boolean hasStores = !variable.stores.isEmpty();
        if (hasLoads || hasStores) {
            for (final IncludeEdge edge : edges) {
                if (edge.source.object == null) {
                    continue;
                }
                final List<LoadEdge> loads = new ArrayList<>(edge.source.loads);
                final List<StoreEdge> stores = new ArrayList<>(edge.source.stores);
                for (final Variable out : edge.source.seeAlso) {
                    for (final IncludeEdge edge1 : out.includes) {
                        if (hasStores && edge1.source == edge.source) {
                            for (final LoadEdge load : out.loads) {
                                loads.add(compose(load, edge1.modifier));
                            }
                        }
                        if (hasLoads && edge1.source == edge.source) {
                            for (final StoreEdge store : out.stores) {
                                stores.add(compose(store, edge1.modifier));
                            }
                        }
                    }
                }
                final boolean isTrivial = isTrivial(edge.modifier);
                final List<LoadEdge> variableLoads = isTrivial ? variable.loads : new ArrayList<>(variable.loads.size());
                final List<StoreEdge> variableStores = isTrivial ? variable.stores : new ArrayList<>(variable.stores.size());
                if (!isTrivial) {
                    for (final LoadEdge load : variable.loads) {
                        variableLoads.add(new LoadEdge(load.result, compose(load.addressModifier, edge.modifier)));
                    }
                    for (final StoreEdge store : variable.stores) {
                        variableStores.add(new StoreEdge(store.value, compose(store.addressModifier, edge.modifier)));
                    }
                }
                processCommunication(variableStores, loads);
                processCommunication(stores, variableLoads);
            }
        }
    }

    // Removes information from the internal graph, which are no longer needed after the algorithm has finished.
    // This simplifies alias queries and releases memory resources.
    private void postProcess(Map.Entry<Event, DerivedVariable> entry) {
        logger.trace("{}", entry);
        final Event e = entry.getKey();
        final DerivedVariable address = entry.getValue();
        if (address == null) {
            // should have already warned about this event
            return;
        }
        // Remove all obsolete inclusion relationships between register states.
        address.base.includes.removeIf(i -> i.source.object == null);
        address.base.loads.clear();
        address.base.stores.clear();
        address.base.seeAlso.clear();
        // In a well-structured program, all address expressions refer to at least one memory object.
        if (logger.isWarnEnabled() && address.base.object == null &&
                address.base.includes.stream().allMatch(i -> i.source.object == null)) {
            logger.warn("empty pointer set for {}", synContext.get().getContextInfo(e));
        }
        if (address.base.includes.size() != 1) {
            return;
        }
        final IncludeEdge includeEdge = address.base.includes.get(0);
        final Modifier modifier = compose(includeEdge.modifier, address.modifier);
        assert includeEdge.source.object != null;
        // If the only included address refers to the last element, treat it as a direct static offset instead.
        // This only works on concrete objects, where size is reliable.
        if (!includeEdge.source.object.getClass().equals(MemoryObject.class) || !includeEdge.source.object.hasKnownSize()) {
            return;
        }
        if (e instanceof MemoryCoreEvent mce) {
            final int accessSize = types.getMemorySizeInBytes(mce.getAccessType());
            final int remainingSize = includeEdge.source.object.getKnownSize() - modifier.offset - (accessSize - 1);
            for (final Integer a : modifier.alignment) {
                if (Math.abs(a) < remainingSize || a < 0 && modifier.offset + a >= 0) {
                    return;
                }
            }
        } else {
            assert e instanceof MemFree;
            final int remainingSize = includeEdge.source.object.getKnownSize() - modifier.offset;
            for (final Integer a : modifier.alignment) {
                if (a < remainingSize) {
                    return;
                }
            }
        }
        entry.setValue(derive(includeEdge.source, modifier.offset, List.of()));
    }

    // ================================ Internals ================================

    private static final class Variable {
        // Any value contained in the referred variables is also contained (+ modifier).
        // Visualized as ingoing edges.
        private final List<IncludeEdge> includes = new ArrayList<>();
        // There is some load event using this (+ address modifier) as pointer set and the referred variable as result set.
        // Visualized as outgoing edges.
        private final List<LoadEdge> loads = new ArrayList<>();
        // There is some store event using this (+ address modifier) as pointer set and the derived variable as value set.
        // Visualized as outgoing edges.
        private final List<StoreEdge> stores = new ArrayList<>();
        // All variables that have a direct (includes/loads/stores) link to this.
        private final Set<Variable> seeAlso = new LinkedHashSet<>();
        // If nonnull, this variable represents that object's base address.
        private final MemoryObject object;
        // If nonnull, this variable represents an aggregate of field variables.
        private final DerivedVariable[] aggregate;
        // For visualization.
        private final String name;
        private Variable(MemoryObject o, DerivedVariable[] a, String n) {
            object = o;
            aggregate = a;
            name = n;
        }
        @Override public String toString() { return name; }
    }

    private record IncludeEdge(Variable source, Modifier modifier) {}

    private record LoadEdge(Variable result, Modifier addressModifier) {}

    private record StoreEdge(DerivedVariable value, Modifier addressModifier) {}

    private record Modifier(int offset, List<Integer> alignment) {}

    private record DerivedVariable(Variable base, Modifier modifier) {}

    private static boolean isConstant(Modifier modifier) {
        return modifier.alignment.isEmpty();
    }

    private static boolean isTrivial(Modifier modifier) {
        return modifier.offset == 0 && isConstant(modifier);
    }

    private static final List<Integer> TOP = List.of(-1);

    private static final Modifier RELAXED_MODIFIER = new Modifier(0, TOP);

    private static final Modifier TRIVIAL_MODIFIER = new Modifier(0, List.of());

    private static Modifier modifier(int offset, List<Integer> alignment) {
        int a = singleAlignment(alignment);
        return new Modifier(a >= 0 ? offset : offset % -a, alignment);
    }

    private static DerivedVariable derive(Variable base) {
        return new DerivedVariable(base, TRIVIAL_MODIFIER);
    }

    private static DerivedVariable derive(Variable base, int offset, List<Integer> alignment) {
        return new DerivedVariable(base, modifier(offset, alignment));
    }

    private static IncludeEdge includeEdge(DerivedVariable variable) {
        return new IncludeEdge(variable.base, variable.modifier);
    }

    private Variable newVariable(String name) {
        totalVariables++;
        return new Variable(null, null, name);
    }

    // Inserts a single inclusion relationship into the graph.
    // Any cycle closed by this edge will eventually be detected and resolved.
    private void addInclude(Variable variable, IncludeEdge includeEdge) {
        // accelerate for self-loops.
        // this is necessary besides lazy cycle detection, because it handles cycles of length 1.
        // LCD uses the edge that triggered the detection, which is not always the self-loop.
        final IncludeEdge edge = tryAccelerate(variable, includeEdge);
        if (!addInto(variable.includes, edge, true)) {
            return;
        }
        edge.source.seeAlso.add(variable);
        final int level = Math.abs(edge.modifier.offset);
        // enqueue the new edge
        final List<IncludeEdge> edges = queue.computeIfAbsent(level, k -> new LinkedHashMap<>())
                .computeIfAbsent(variable, k -> new ArrayList<>());
        if (edges.isEmpty()) {
            logger.trace("enqueue level={} variable={}", level, variable);
        }
        edges.add(edge);
    }

    private IncludeEdge tryAccelerate(Variable variable, IncludeEdge edge) {
        if (edge.source != variable) {
            return edge;
        }
        return new IncludeEdge(edge.source, new Modifier(0, compose(edge.modifier.alignment, edge.modifier.offset)));
    }

    // Tries to detect cycles when a new edge is to be added.
    // Called when a pointer propagates from variable to successor, due to an inclusion edge.
    private List<IncludeEdge> detectCycles(Variable variable, IncludeEdge edge) {
        // Fast check for cycles of length 1.
        if (edge.source == variable) {
            return List.of(edge);
        }
        // Fast check with lazy cycle detection:
        // Eventually, any cycle will have a 'new' edge, where the pointer sets are equal.
        // Therefore, we wait for this, instead of trying to immediately detect the cycle.
        if (!equalsPointerSet(variable, edge.source)) {
            cyclesFastCulled++;
            return List.of();
        }
        // Slow check
        final Set<Variable> includerSet = getIncluderSet(variable);
        if (!includerSet.contains(edge.source)) {
            cyclesSlowCulled++;
            return List.of();
        }
        cyclesDetected++;
        final List<IncludeEdge> result = getAllCyclicPaths(edge, includerSet);
        assert result.stream().anyMatch(e -> e.source == variable);
        return result;
    }

    private boolean equalsPointerSet(Variable left, Variable right) {
        // TODO hashing: each variable gets a hash code for its pointer set.
        return includesPointerSet(left, right) && includesPointerSet(right, left);
    }

    private boolean includesPointerSet(Variable variable1, Variable variable2) {
        for (final IncludeEdge i : variable1.includes) {
            if (i.source.object != null && !variable2.includes.contains(i)) {
                return false;
            }
        }
        return true;
    }

    private Set<Variable> getIncluderSet(Variable variable) {
        final Set<Variable> result = new HashSet<>(List.of(variable));
        List<Variable> worklist = new ArrayList<>(List.of(variable));
        while (!worklist.isEmpty()) {
            final List<Variable> next = new ArrayList<>();
            for (final Variable current : worklist) {
                for (final Variable v : current.seeAlso) {
                    // Culling
                    if (result.contains(v)) {
                        continue;
                    }
                    // Try to find some include edge, as 'seeAlso' also indicates store and load edges.
                    for (final IncludeEdge i : v.includes) {
                        if (i.source == current && result.add(v)) {
                            next.add(v);
                            break;
                        }
                    }
                }
            }
            worklist = next;
        }
        return result;
    }

    private List<IncludeEdge> getAllCyclicPaths(IncludeEdge edge, Set<Variable> includerSet) {
        final Map<Variable, List<IncludeEdge>> edges = new HashMap<>();
        // Use 'set' for performance.
        final Set<IncludeEdge> set = new HashSet<>();
        List<IncludeEdge> worklist = new ArrayList<>(List.of(new IncludeEdge(edge.source, TRIVIAL_MODIFIER)));
        // Since cycles are detected lazily, we need a bound for cycle lengths.
        for (int length = 0; length < includerSet.size(); length++) {
            if (worklist.isEmpty()) {
                break;
            }
            final List<IncludeEdge> next = new ArrayList<>();
            for (final IncludeEdge current : worklist) {
                for (final IncludeEdge i : current.source.includes) {
                    if (edge.source != i.source && includerSet.contains(i.source)) {
                        final IncludeEdge joinedEdge = compose(i, current.modifier);
                        if (set.add(joinedEdge) &&
                                addInto(edges.computeIfAbsent(i.source, k -> new ArrayList<>()), joinedEdge, false)) {
                            next.add(joinedEdge);
                        }
                    }
                }
            }
            worklist = next;
        }
        final List<IncludeEdge> result = new ArrayList<>();
        edges.values().forEach(result::addAll);
        return result;
    }

    private boolean addInto(List<IncludeEdge> list, IncludeEdge element, boolean isGraphModification) {
        //NOTE The Stream API is too costly here
        for (final IncludeEdge o : list) {
            if (element.source.equals(o.source) && includes(o.modifier, element.modifier)) {
                if (isGraphModification) {
                    addIntoGraphFails++;
                } else {
                    addIntoCyclesFails++;
                }
                return false;
            }
        }
        if (isGraphModification) {
            addIntoGraphSucceesses++;
        } else {
            addIntoCyclesSuccesses++;
        }
        list.removeIf(o -> element.source.equals(o.source) && includes(element.modifier, o.modifier));
        list.add(element);
        return true;
    }

    // Called when a placeholder variable for a register writer is to be replaced by the proper variable.
    // A variable cannot be removed, if some event maps to it and there are multiple replacements.
    // In this case, the mapping stays but all outgoing edges are removed from that variable.
    private void replace(Variable old, DerivedVariable replacement) {
        assert old != replacement.base;
        assert !objectVariables.containsValue(old);
        totalReplacements++;
        logger.trace("{} -> {}", old, replacement);
        // likely / most frequent case
        addressVariables.replaceAll((k, v) -> v.base != old ? v : compose(replacement, v.modifier));
        registerVariables.replaceAll((k, v) -> v.base != old ? v : compose(replacement, v.modifier));
        for (final Variable out : old.seeAlso) {
            out.includes.replaceAll(e -> e.source != old ? e : includeEdge(compose(replacement, e.modifier)));
            assert out.loads.stream().noneMatch(e -> e.result == old);
            out.stores.replaceAll(e -> e.value.base != old ? e :
                    new StoreEdge(compose(replacement, e.value.modifier), e.addressModifier));
        }
        replacement.base.seeAlso.addAll(old.seeAlso);
        for (final IncludeEdge edge : old.includes) {
            edge.source.seeAlso.remove(old);
            edge.source.seeAlso.add(replacement.base);
        }
        // Redirect load and store relationships.
        // This could enable more communications, but replacement.
        for (final LoadEdge load : old.loads) {
            replacement.base.loads.add(compose(load, replacement.modifier));
            load.result.seeAlso.add(replacement.base);
        }
        for (final StoreEdge store : old.stores) {
            replacement.base.stores.add(compose(store, replacement.modifier));
            store.value.base.seeAlso.add(replacement.base);
        }
        old.seeAlso.clear();
        old.includes.clear();
        old.loads.clear();
        old.stores.clear();
    }

    // Find "may read from" relationships and deduce new 'includes' edges for the internal graph.
    private void processCommunication(List<StoreEdge> stores, List<LoadEdge> loads) {
        logger.trace("{} vs {}", stores, loads);
        if (loads.isEmpty()) {
            return;
        }
        for (final StoreEdge store : stores) {
            for (final LoadEdge load : loads) {
                if (overlaps(store.addressModifier, load.addressModifier)) {
                    addInclude(load.result, includeEdge(store.value));
                }
            }
        }
    }

    // Checks if leftAlignment contains all linear combinations of offset + rightAlignment.
    // Is allowed to have false negatives, as such only lead to more memory usage of the analysis.
    private boolean includes(Modifier left, Modifier right) {
        int offset = right.offset - left.offset;
        // DEBUG: Count this test.
        if (totalAlignmentSizes != null) {
            totalAlignmentSizes.merge(new IntPair(left.alignment.size(), right.alignment.size()), 1, Integer::sum);
        }
        if (left.alignment.isEmpty()) {
            return right.alignment.isEmpty() && offset == 0;
        }
        // Case of unbounded dynamic indexes.
        int leftAlignment = singleAlignment(left.alignment);
        int rightAlignment = singleAlignment(right.alignment);
        if (leftAlignment < 0 || rightAlignment < 0) {
            int l = leftAlignment < 0 ? -leftAlignment : reduceGCD(left.alignment);
            int r = rightAlignment < 0 ? -rightAlignment : reduceGCD(right.alignment);
            return offset % l == 0 && r % l == 0;
        }
        // Case of a single non-negative dynamic index.
        if (left.alignment.size() == 1) {
            for (final Integer a : right.alignment) {
                if (a % leftAlignment != 0) {
                    return false;
                }
            }
            return offset % leftAlignment == 0 && offset >= 0;
        }
        // Case of multiple dynamic indexes with pairwise indivisible alignments.
        final int gcd = IntMath.gcd(reduceGCD(right.alignment), Math.abs(offset));
        if (gcd == 0) {
            return true;
        }
        int max = Math.abs(offset);
        for (final Integer i : right.alignment) {
            max = Math.max(max, i);
        }
        final var mem = new boolean[max / gcd + 1];
        mem[0] = true;
        for (int j = 1; j < mem.length; j++) {
            for (final Integer i : left.alignment) {
                if (j - i/gcd >= 0 && mem[j - i/gcd]) {
                    mem[j] = true;
                    break;
                }
            }
        }
        for (final Integer j : right.alignment) {
            if (!mem[j/gcd]) {
                return false;
            }
        }
        return mem[Math.abs(offset)/gcd];
    }

    // Checks if there may be some common value in both sets.
    // Allowed to have false positives.
    private static boolean overlaps(Modifier l, Modifier r) {
        // exists non-negative integers x, y with l.offset + x * l.alignment == r.offset + y * r.alignment
        final int offset = r.offset - l.offset;
        final int leftAlignment = singleAlignment(l.alignment);
        final int rightAlignment = singleAlignment(r.alignment);
        final int left = leftAlignment < 0 ? -leftAlignment : reduceGCD(l.alignment);
        final int right = rightAlignment < 0 ? -rightAlignment : reduceGCD(r.alignment);
        if (left == 0 && right == 0) {
            return offset == 0;
        }
        final int divisor = left == 0 ? right : right == 0 ? left : IntMath.gcd(left, right);
        final boolean leftDirectedTowardsRight = right != 0 || leftAlignment < 0 || offset >= 0;
        final boolean rightDirectedTowardsLeft = left != 0 || rightAlignment < 0 || offset <= 0;
        return leftDirectedTowardsRight && rightDirectedTowardsLeft && offset % divisor == 0;
    }

    private static int singleAlignment(List<Integer> alignment) {
        return alignment.size() != 1 ? 0 : alignment.get(0);
    }

    // Computes the greatest common divisor of the operands.
    private static int reduceGCD(List<Integer> alignment) {
        if (alignment.isEmpty()) {
            return 0;
        }
        int result = alignment.get(0);
        for (final Integer a : alignment.subList(1, alignment.size())) {
            result = IntMath.gcd(result, a);
        }
        return result;
    }

    // Merges two sets of pairwise-indivisible dynamic offsets.
    private static List<Integer> compose(List<Integer> left, List<Integer> right) {
        if (left.isEmpty() || right.isEmpty()) {
            return right.isEmpty() ? left : right;
        }
        if (left == TOP || right == TOP) {
            return TOP;
        }
        // Negative values are unrestricted and compose always.
        // Therefore, each list shall either contain a single negative value, or only positive values.
        int leftAlignment = singleAlignment(left);
        int rightAlignment = singleAlignment(right);
        if (leftAlignment < 0 || rightAlignment < 0) {
            int alignment = leftAlignment < 0 ? -leftAlignment : -rightAlignment;
            for (Integer other : leftAlignment < 0 ? right : left) {
                alignment = IntMath.gcd(alignment, Math.abs(other));
            }
            return List.of(-alignment);
        }
        // assert left and right each consist of pairwise indivisible positives
        final List<Integer> result = new ArrayList<>();
        for (final Integer i : left) {
            if (hasNoDivisorsInList(i, right, true)) {
                result.add(i);
            }
        }
        for (final Integer j : right) {
            if (hasNoDivisorsInList(j, left, false)) {
                result.add(j);
            }
        }
        sort(result);
        return result;
    }

    private static void sort(List<Integer> alignment) {
        if (alignment.size() > 1) {
            Collections.sort(alignment);
        }
    }

    // Checks if value is no multiple of any element in the list.
    private static boolean hasNoDivisorsInList(int value, List<Integer> candidates, boolean strict) {
        for (final Integer candidate : candidates) {
            if ((strict || value < candidate) && value % candidate == 0) {
                return false;
            }
        }
        return true;
    }

    private static Modifier compose(Modifier left, Modifier right) {
        return modifier(left.offset + right.offset, compose(left.alignment, right.alignment));
    }

    // Adds a single value to a set of dynamic offsets.
    private static List<Integer> compose(List<Integer> left, int right) {
        return right == 0 ? left : compose(left, List.of(right));
    }

    // Applies another offset to an existing labeled edge.
    private static DerivedVariable compose(DerivedVariable other, Modifier modifier) {
        return isTrivial(modifier) ? other : new DerivedVariable(other.base, compose(other.modifier, modifier));
    }

    private static IncludeEdge compose(IncludeEdge other, Modifier modifier) {
        return isTrivial(modifier) ? other : new IncludeEdge(other.source, compose(other.modifier, modifier));
    }

    private static LoadEdge compose(LoadEdge other, Modifier modifier) {
        return isTrivial(modifier) ? other : new LoadEdge(other.result, compose(other.addressModifier, modifier));
    }

    private static StoreEdge compose(StoreEdge other, Modifier modifier) {
        return isTrivial(modifier) ? other : new StoreEdge(other.value, compose(other.addressModifier, modifier));
    }

    // Interprets an expression.
    // The result refers to an existing variable,
    // if the expression has a static base, or if the expression has a dynamic base with exactly one writer.
    // Otherwise, it refers to a new variable with proper incoming edges.
    private DerivedVariable getResultVariable(Expression expression, RegReader reader) {
        final var collector = new Collector(reader);
        final List<IncludeEdge> result = expression.accept(collector);
        return getOrNewVariable(result, String.format("res%d(%s)", reader.getGlobalId(), expression));
    }

    // Fetches the node for address values that can be read from a register at a specific program point.
    // Constructs a new node, if there are multiple writers.
    private DerivedVariable getPhiNodeVariable(Register register, RegReader reader) {
        // We assume here that uninitialized values carry no meaningful address to any memory object.
        final List<RegWriter> writers = dependency.getWriters(reader).ofRegister(register).getMayWriters();
        final DerivedVariable find = registerVariables.get(writers);
        if (find != null) {
            return find;
        }
        final Variable result = newVariable("phi" + reader.getGlobalId() + "(" + register.getName() + ")");
        // If writers is a singleton here, its "phi" node will be replaced later.  Otherwise, the "out" nodes.
        for (final RegWriter writer : writers.size() == 1 ? List.<RegWriter>of() : writers) {
            // The variables created here will be replaced later, if the events are out of order.
            final DerivedVariable writerVariable = registerVariables.computeIfAbsent(List.of(writer),
                    k -> derive(newVariable("out" + writer.getGlobalId())));
            addInclude(result, includeEdge(writerVariable));
        }
        return writers.isEmpty() ? derive(result) : registerVariables.compute(writers, (k, v) -> derive(result));
    }

    private DerivedVariable getOrNewVariable(List<IncludeEdge> edges, String name) {
        if (edges.isEmpty()) {
            return null;
        }
        if (edges.size() == 1) {
            return new DerivedVariable(edges.get(0).source, edges.get(0).modifier);
        }
        final Variable base = newVariable(name);
        for (IncludeEdge edge : edges) {
            addInclude(base, edge);
        }
        return derive(base);
    }

    private final class Collector implements ExpressionVisitor<List<IncludeEdge>> {

        private final RegReader reader;

        private Collector(RegReader reader) {
            this.reader = reader;
        }

        @Override
        public List<IncludeEdge> visitExpression(Expression expr) {
            final List<IncludeEdge> edges = new ArrayList<>();
            expr.accept(new ExpressionInspector() {
                @Override
                public Expression visitRegister(Register register) {
                    edges.add(new IncludeEdge(getPhiNodeVariable(register, reader).base, RELAXED_MODIFIER));
                    return register;
                }
                @Override
                public Expression visitMemoryObject(MemoryObject object) {
                    edges.add(new IncludeEdge(objectVariables.get(object), RELAXED_MODIFIER));
                    return object;
                }
            });
            return edges;
        }

        record ExprFlip(Expression x, int factor) {}

        @Override
        public List<IncludeEdge> visitIntBinaryExpression(IntBinaryExpr x) {
            BigInteger offset = BigInteger.ZERO;
            final List<ExprFlip> operands = new ArrayList<>();
            final Stack<ExprFlip> stack = new Stack<>();
            if (!matchLinearExpression(new ExprFlip(x, 1), stack)) {
                return visitExpression(x);
            }
            while (!stack.isEmpty()) {
                final ExprFlip operand = stack.pop();
                if (matchLinearExpression(operand, stack)) {
                    continue;
                }
                if (operand.x instanceof IntLiteral literal) {
                    offset = offset.add(literal.getValue().multiply(BigInteger.valueOf(operand.factor)));
                } else {
                    operands.add(operand);
                }
            }
            final List<IncludeEdge> result = new ArrayList<>();
            final int o = offset.intValue();
            for (int i = 0; i < operands.size(); i++) {
                final ExprFlip operand = operands.get(i);
                if (operand.factor != 1) {
                    result.addAll(visitExpression(operand.x));
                    continue;
                }
                List<Integer> alignment = List.of();
                for (int j = 0; j < operands.size(); j++) {
                    alignment = j == i ? alignment : compose(alignment, operands.get(j).factor);
                }
                for (IncludeEdge subResult : operand.x.accept(this)) {
                    addInto(result, compose(subResult, modifier(o, alignment)), false);
                }
            }
            return result;
        }

        private boolean matchLinearExpression(ExprFlip operand, Stack<ExprFlip> stack) {
            final Expression left = operand.x instanceof IntBinaryExpr x ? x.getLeft() : null;
            final Expression right = operand.x instanceof IntBinaryExpr x ? x.getRight() : null;
            final boolean add = operand.x.getKind().equals(IntBinaryOp.ADD);
            final boolean sub = operand.x.getKind().equals(IntBinaryOp.SUB);
            final boolean mul = operand.x.getKind().equals(IntBinaryOp.MUL);
            if (add || sub) {
                stack.push(new ExprFlip(right, operand.factor * (add ? 1 : -1)));
                stack.push(new ExprFlip(left, operand.factor));
                return true;
            } else if (mul) {
                final IntLiteral leftLiteral = left instanceof IntLiteral l ? l : null;
                final IntLiteral rightLiteral = right instanceof IntLiteral l ? l : null;
                if (leftLiteral != null || rightLiteral != null) {
                    final int factor = (leftLiteral != null ? leftLiteral : rightLiteral).getValueAsInt();
                    stack.push(new ExprFlip(leftLiteral != null ? right : left, operand.factor * factor));
                    return true;
                }
            }
            return false;
        }

        @Override
        public List<IncludeEdge> visitIntSizeCastExpression(IntSizeCast expr) {
            // We assume type casts do not affect the value of pointers.
            return expr.isExtension() && !expr.preservesSign() ? expr.getOperand().accept(this) : visitExpression(expr);
        }

        @Override
        public List<IncludeEdge> visitITEExpression(ITEExpr x) {
            final List<IncludeEdge> result = new ArrayList<>(x.getTrueCase().accept(this));
            for (IncludeEdge edge : x.getFalseCase().accept(this)) {
                addInto(result, edge, false);
            }
            return result;
        }

        @Override
        public List<IncludeEdge> visitMemoryObject(MemoryObject a) {
            return List.of(new IncludeEdge(objectVariables.get(a), TRIVIAL_MODIFIER));
        }

        @Override
        public List<IncludeEdge> visitRegister(Register r) {
            DerivedVariable phiVariable = getPhiNodeVariable(r, reader);
            return List.of(includeEdge(phiVariable));
        }

        @Override
        public List<IncludeEdge> visitExtractExpression(ExtractExpr extract) {
            final List<IncludeEdge> result = new ArrayList<>();
            for (IncludeEdge operand : extract.getOperand().accept(this)) {
                DerivedVariable field = new DerivedVariable(operand.source, operand.modifier);
                for (int index : extract.getIndices()) {
                    final DerivedVariable[] aggregate = operand.source.aggregate;
                    final DerivedVariable f = aggregate == null || aggregate.length <= index ? null : aggregate[index];
                    if (f == null) {
                        field = compose(field, RELAXED_MODIFIER);
                        break;
                    }
                    field = compose(f, field.modifier);
                }
                result.add(includeEdge(field));
            }
            return result;
        }

        @Override
        public List<IncludeEdge> visitConstructExpression(ConstructExpr construct) {
            final List<IncludeEdge> result = new ArrayList<>();
            final var operands = new DerivedVariable[construct.getOperands().size()];
            final String name = construct.toString();
            for (int i = 0; i < construct.getOperands().size(); i++) {
                final String fieldName = String.format("%s[%d]", name, i);
                operands[i] = getOrNewVariable(construct.getOperands().get(i).accept(this), fieldName);
            }
            final Variable proxy = new Variable(null, operands, name);
            totalVariables++;
            for (DerivedVariable operand : operands) {
                if (operand != null) {
                    addInclude(proxy, includeEdge(operand));
                }
            }
            result.add(new IncludeEdge(proxy, TRIVIAL_MODIFIER));
            return result;
        }
    }

    // Projects the internal representation of this analysis:
    // Nodes are variables, grey edges are inclusions.
    // Blue edges connect address variables to register variables.
    // Red edges connect address variables to stored value variables.
    // Green-labeled nodes represent memory objects.
    // Red-labeled nodes are address variables that do not include any memory objects (probably a bug).
    private void generateGraph() {
        final Set<Variable> seen = new HashSet<>(objectVariables.values());
        for (Set<Variable> news = seen; !news.isEmpty();) {
            final var next = new HashSet<Variable>();
            for (final Variable v : news) {
                next.addAll(v.seeAlso);
                v.includes.forEach(o -> next.add(o.source));
                v.loads.forEach(o -> next.add(o.result));
                v.stores.forEach(o -> next.add(o.value.base));
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
            for (final IncludeEdge i : v.includes) {
                verify(i.source.seeAlso.contains(v));
                map.computeIfAbsent("\"" + i.source.name + "\"", k -> new HashSet<>()).add("\"" + v.name + "\"");
            }
            for (final LoadEdge i : v.loads) {
                verify(i.result.seeAlso.contains(v));
                loads.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.result.name + "\"");
            }
            for (final StoreEdge i : v.stores) {
                verify(i.value.base.seeAlso.contains(v));
                stores.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.value.base.name + "\"");
            }
        }
        final Set<String> problematic = new HashSet<>();
        for (final DerivedVariable a : addressVariables.values()) {
            if (!objectVariables.containsValue(a.base) &&
                    a.base.includes.stream().noneMatch(i -> objectVariables.containsValue(i.source))) {
                problematic.add("\"" + a.base.name + "\"");
            }
        }
        graphviz = new Graphviz();
        graphviz.beginDigraph("internal alias");
        for (final Variable v : objectVariables.values()) {
            graphviz.addNode("\"" + v.name + "\"", "fontcolor=mediumseagreen");
        }
        for (final String v : problematic) {
            graphviz.addNode(v, "fontcolor=red");
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
