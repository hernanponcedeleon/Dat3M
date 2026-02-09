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
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.threading.ThreadArgument;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.witness.graphviz.Graphviz;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
public class InclusionBasedPointerAnalysis<Modifier> implements AliasAnalysis {

    private static final Logger logger = LoggerFactory.getLogger(InclusionBasedPointerAnalysis.class);

    private static final TypeFactory types = TypeFactory.getInstance();

    // Manages labels / weights on the edges between the variables managed by this analysis.
    private final ModifierTrait<Modifier> trait;
    private final Modifier relaxedModifier;
    private final Modifier trivialModifier;

    // This analysis depends on another, that maps used registers to a list of possible direct writers.
    private final ReachingDefinitionsAnalysis dependency;

    // For providing helpful error messages, this analysis prints call-stack and loop information for events.
    private final Supplier<SyntacticContextAnalysis> synContext;

    // When a variable gains an includes-edge, it is added to this queue for later processing.
    // For lazy cycle detection, it is grouped by the absolute value of IncludeEdge.modifier.offset.
    private final TreeMap<Integer, LinkedHashMap<Variable<Modifier>, List<IncludeEdge<Modifier>>>> queue = new TreeMap<>();

    // Maps memory events to variables representing their pointer set.
    private final Map<MemoryCoreEvent, DerivedVariable<Modifier>> addressVariables = new HashMap<>();
    private final Map<MemoryCoreEvent, DerivedVariable<Modifier>> valueVariables = new HashMap<>();

    // Maps memory objects to variables representing their base address.
    // These Variables should always have empty includes-sets.
    private final Map<MemoryObject, Variable<Modifier>> objectVariables = new HashMap<>();

    // Maps a set of same-register writers to a variable representing their combined result sets (~phi node).
    // Non-trivial modifiers may only appear for singleton Locals.
    private final Map<List<RegWriter>, DerivedVariable<Modifier>> registerVariables = new HashMap<>();

    // Maps memory events to additional offsets inside their byte range, which may match other accesses' bounds.
    private final Map<MemoryCoreEvent, List<Integer>> mixedAccesses = new HashMap<>();

    // If enabled, the algorithm describes its internal graph to be written into a file.
    private Graphviz graphviz;

    // ================================ Debugging ================================

    // Count created variables.
    private int totalVariables = 0;
    // Count variable substitutions.
    private int totalReplacements = 0;
    // Count times a piece of new information was added to the graph.
    private int addIntoGraphSuccesses, addIntoGraphFails, addIntoCyclesSuccesses, addIntoCyclesFails;
    // Count cycle checks, which can result in fast or slow rejects, or accepts.
    private int cyclesFastCulled;
    private int cyclesSlowCulled;
    private int cyclesDetected;

    // ================================ Construction ================================

    public static InclusionBasedPointerAnalysis<?> fromConfig(Program program, Context analysisContext, AliasAnalysis.Config config) {
        final ReachingDefinitionsAnalysis def = analysisContext.requires(ReachingDefinitionsAnalysis.class);
        final var analysis = switch (config.method) {
            case EXPERIMENTAL_FIELD_INSENSITIVE -> new InclusionBasedPointerAnalysis<>(new ModifierTrait.VoidTrait(), program, def);
            case EXPERIMENTAL_FIELD_SENSITIVE -> new InclusionBasedPointerAnalysis<>(new ModifierTrait.Offsets(), program, def);
            case EXPERIMENTAL_LINEAR_1D -> new InclusionBasedPointerAnalysis<>(new ModifierTrait.SdLinear(), program, def);
            default -> new InclusionBasedPointerAnalysis<>(new ModifierTrait.MdLinear(), program, def);
        };
        analysis.run(program, config);
        if (config.detectMixedSizeAccesses) {
            analysis.detectMixedSizeAccesses();
        }
        logger.debug("variable count: {}",
                analysis.totalVariables);
        logger.debug("replacement count: {}",
                analysis.totalReplacements);
        logger.debug("addInto graph: {} successes vs {} fails",
                analysis.addIntoGraphSuccesses,
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

    private InclusionBasedPointerAnalysis(ModifierTrait<Modifier> t, Program p, ReachingDefinitionsAnalysis d) {
        trait = t;
        dependency = d;
        synContext = Suppliers.memoize(() -> SyntacticContextAnalysis.newInstance(p));
        relaxedModifier = t.relaxedModifier();
        trivialModifier = t.constantModifier(0);
    }

    // ================================ API ================================

    @Override
    public boolean mayAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        final DerivedVariable<Modifier> vx = addressVariables.get(x);
        final DerivedVariable<Modifier> vy = addressVariables.get(y);
        if (vx == null || vy == null) {
            return true;
        }
        if (vx.base == vy.base && isConstant(vx.modifier) && isConstant(vy.modifier)) {
            return Objects.equals(vx.modifier, vy.modifier);
        }
        final List<IncludeEdge<Modifier>> ox = toIncludeSet(vx.base);
        final List<IncludeEdge<Modifier>> oy = toIncludeSet(vy.base);
        for (final IncludeEdge<Modifier> ax : ox) {
            for (final IncludeEdge<Modifier> ay : oy) {
                if (ax.source == ay.source) {
                    final Modifier l = trait.compose(ax.modifier, vx.modifier);
                    final Modifier r = trait.compose(ay.modifier, vy.modifier);
                    if (trait.overlaps(l, r)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    @Override
    public boolean mustAlias(MemoryCoreEvent x, MemoryCoreEvent y) {
        final DerivedVariable<Modifier> vx = addressVariables.get(x);
        final DerivedVariable<Modifier> vy = addressVariables.get(y);
        return vx != null && vy != null && vx.base == vy.base &&
                isConstant(vx.modifier) && Objects.equals(vx.modifier, vy.modifier);
    }

    @Override
    public Collection<MemoryObject> addressableObjects(MemoryCoreEvent e) {
        final DerivedVariable<Modifier> v = addressVariables.get(e);
        return v == null ? objectVariables.keySet() : v.base.object != null ? Set.of(v.base.object)
                : v.base.includes.stream().map(i -> i.source.object).collect(Collectors.toSet());
    }

    @Override
    public Collection<MemoryObject> communicableObjects(MemoryCoreEvent e) {
        final DerivedVariable<Modifier> v = valueVariables.get(e);
        return v == null ? e instanceof Load || e instanceof Store ? objectVariables.keySet() : Set.of()
                : v.base.object != null ? Set.of(v.base.object)
                : v.base.includes.stream().map(i -> i.source.object).collect(Collectors.toSet());
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
        final List<MemoryCoreEvent> events = List.copyOf(addressVariables.keySet());
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
        final DerivedVariable<Modifier> vx = addressVariables.get(x);
        final DerivedVariable<Modifier> vy = addressVariables.get(y);
        assert vx != null & vy != null;
        final int bytesX = types.getMemorySizeInBytes(x.getAccessType());
        final int bytesY = types.getMemorySizeInBytes(y.getAccessType());
        if (vx.base == vy.base) {
            fetchAllMixedOffsets(xSet, vx.modifier, bytesX, ySet, vy.modifier, bytesY);
            return;
        }
        final List<IncludeEdge<Modifier>> oy = toIncludeSet(vy.base);
        for (final IncludeEdge<Modifier> ax : toIncludeSet(vx.base)) {
            for (final IncludeEdge<Modifier> ay : oy) {
                if (ax.source == ay.source) {
                    final Modifier modifierX = trait.compose(ax.modifier, vx.modifier);
                    final Modifier modifierY = trait.compose(ay.modifier, vy.modifier);
                    fetchAllMixedOffsets(xSet, modifierX, bytesX, ySet, modifierY, bytesY);
                }
            }
        }
    }


    private List<IncludeEdge<Modifier>> toIncludeSet(Variable<Modifier> address) {
        final List<IncludeEdge<Modifier>> set = new ArrayList<>(address.includes);
        set.add(new IncludeEdge<>(address, trivialModifier));
        return set;
    }

    private void fetchAllMixedOffsets(Set<Integer> xSet, Modifier xModifier, int xBytes,
            Set<Integer> ySet, Modifier yModifier, int yBytes) {
        fetchMixedOffsets(xSet, xModifier, xBytes, yModifier, yBytes);
        fetchMixedOffsets(ySet, yModifier, yBytes, xModifier, xBytes);
    }

    private void fetchMixedOffsets(Set<Integer> out, Modifier modifier0, int bytes0, Modifier modifier1, int bytes1) {
        final Modifier next = trait.compose(modifier1, trait.constantModifier(bytes1));
        for (int i = 1; i < bytes0; i++) {
            final Modifier offset = trait.compose(modifier0, trait.constantModifier(i));
            if (trait.overlaps(offset, modifier1) || trait.overlaps(offset, next)) {
                out.add(i);
            }
        }
    }

    @Override
    public Graphviz getGraphVisualization() {
        return graphviz;
    }

    // ================================ Processing ================================

    private void run(Program program, AliasAnalysis.Config configuration) {
        checkArgument(program.isCompiled(), "The program must be compiled first.");
        // Pre-processing:
        // Each memory object gets a variable representing its base address value.
        for (final MemoryObject object : program.getMemory().getObjects()) {
            totalVariables++;
            objectVariables.put(object, new Variable<>(object, null, object.toString()));
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
        // Fixed-point computation:
        while (!queue.isEmpty()) {
            final Map.Entry<Integer, LinkedHashMap<Variable<Modifier>, List<IncludeEdge<Modifier>>>> q = queue.pollFirstEntry();
            logger.trace("dequeue level={}", q.getKey());
            for (final Map.Entry<Variable<Modifier>, List<IncludeEdge<Modifier>>> e : q.getValue().entrySet()) {
                algorithm(e.getKey(), e.getValue());
            }
        }
        if (configuration.graphvizInternal) {
            generateGraph();
        }
        for (final Map.Entry<MemoryCoreEvent, DerivedVariable<Modifier>> entry : addressVariables.entrySet()) {
            postProcess(entry);
        }
        registerVariables.clear();
    }

    // Declares the "out" variable of 'event' and inserts initial 'includes' and 'loads' edges.
    // Also declares "res" and "phi" variables, if needed.
    private void processWriter(RegWriter event) {
        logger.trace("{}", event);
        final Expression expr = event instanceof Local local ? local.getExpr() :
                        event instanceof ThreadArgument arg ? arg.getCreator().getArguments().get(arg.getIndex()) :
                        event instanceof Alloc alloc ? alloc.getAllocatedObject() : null;
        final DerivedVariable<Modifier> value;
        if (expr != null) {
            final RegReader reader = event instanceof ThreadArgument arg ? arg.getCreator() : (RegReader) event;
            value = getResultVariable(expr, reader);
            if (value == null) {
                return;
            }
        } else if (event instanceof Load load) {
            final DerivedVariable<Modifier> address = getResultVariable(load.getAddress(), load);
            if (address == null) {
                logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
                return;
            }
            addressVariables.put(load, address);
            final Variable<Modifier> result = newVariable("ld" + load.getGlobalId() + "(" + load.getResultRegister().getName() + ")");
            address.base.loads.add(new LoadEdge<>(result, address.modifier));
            result.seeAlso.add(address.base);
            value = derive(result);
        } else {
            return;
        }
        final DerivedVariable<Modifier> old = registerVariables.put(List.of(event), value);
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
        final DerivedVariable<Modifier> address = getResultVariable(event.getAddress(), event);
        if (address == null) {
            logger.warn("null pointer address for {}", synContext.get().getContextInfo(event));
            return;
        }
        addressVariables.put(event, address);
        if (event instanceof Store store) {
            final DerivedVariable<Modifier> value = getResultVariable(store.getMemValue(), store);
            if (value != null) {
                valueVariables.put(store, value);
                final StoreEdge<Modifier> edge = new StoreEdge<>(value, address.modifier);
                address.base.stores.add(edge);
                value.base.seeAlso.add(address.base);
                final List<LoadEdge<Modifier>> loads = new ArrayList<>(address.base.loads);
                for (final Variable<Modifier> includer : address.base.seeAlso) {
                    if (includer.loads.isEmpty()) {
                        continue;
                    }
                    for (final IncludeEdge<Modifier> includeEdge : includer.includes) {
                        if (includeEdge.source == address.base) {
                            for (final LoadEdge<Modifier> load : includer.loads) {
                                loads.add(compose(load, includeEdge.modifier));
                            }
                        }
                    }
                }
                processCommunication(List.of(edge), loads);
            }
        }
    }

    // Propagates the pointer sets and tests for new communications.
    private void algorithm(Variable<Modifier> variable, List<IncludeEdge<Modifier>> edges) {
        logger.trace("{} includes {}", variable, edges);
        verify(variable.object == null, "Trying to add include edge to object %s.", variable);
        // Propagate pointer sets.
        final List<IncludeEdge<Modifier>> pointers = edges.stream().filter(e -> e.source.object != null).toList();
        if (!pointers.isEmpty()) {
            for (final Variable<Modifier> user : List.copyOf(variable.seeAlso)) {
                for (final IncludeEdge<Modifier> edgeAfter : user.includes.stream().filter(e -> e.source == variable).toList()) {
                    for (final IncludeEdge<Modifier> edge : pointers) {
                        addInclude(user, compose(edge, edgeAfter.modifier));
                    }
                    // In a cycle, variable gets an accelerating self-loop.
                    for (final IncludeEdge<Modifier> cycleEdge : detectCycles(user, edgeAfter)) {
                        if (cycleEdge.source == user) {
                            final Modifier composed = trait.compose(cycleEdge.modifier, edgeAfter.modifier);
                            final Modifier accelerated = trait.accelerate(composed);
                            addInclude(user, new IncludeEdge<>(user, accelerated));
                        }
                    }
                }
            }
        }
        for (final IncludeEdge<Modifier> edgeAfter : edges) {
            if (edgeAfter.source.object != null) {
                continue;
            }
            for (final IncludeEdge<Modifier> edge : List.copyOf(edgeAfter.source.includes)) {
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
            for (final IncludeEdge<Modifier> edge : edges) {
                if (edge.source.object == null) {
                    continue;
                }
                final List<LoadEdge<Modifier>> loads = new ArrayList<>(edge.source.loads);
                final List<StoreEdge<Modifier>> stores = new ArrayList<>(edge.source.stores);
                for (final Variable<Modifier> out : edge.source.seeAlso) {
                    for (final IncludeEdge<Modifier> edge1 : out.includes) {
                        if (hasStores && edge1.source == edge.source) {
                            for (final LoadEdge<Modifier> load : out.loads) {
                                loads.add(compose(load, edge1.modifier));
                            }
                        }
                        if (hasLoads && edge1.source == edge.source) {
                            for (final StoreEdge<Modifier> store : out.stores) {
                                stores.add(compose(store, edge1.modifier));
                            }
                        }
                    }
                }
                final boolean isTrivial = isTrivial(edge.modifier);
                final List<LoadEdge<Modifier>> variableLoads = isTrivial ? variable.loads : new ArrayList<>(variable.loads.size());
                final List<StoreEdge<Modifier>> variableStores = isTrivial ? variable.stores : new ArrayList<>(variable.stores.size());
                if (!isTrivial) {
                    for (final LoadEdge<Modifier> load : variable.loads) {
                        variableLoads.add(new LoadEdge<>(load.result, trait.compose(load.addressModifier, edge.modifier)));
                    }
                    for (final StoreEdge<Modifier> store : variable.stores) {
                        variableStores.add(new StoreEdge<>(store.value, trait.compose(store.addressModifier, edge.modifier)));
                    }
                }
                processCommunication(variableStores, loads);
                processCommunication(stores, variableLoads);
            }
        }
    }

    // Removes information from the internal graph, which are no longer needed after the algorithm has finished.
    // This simplifies alias queries and releases memory resources.
    private void postProcess(Map.Entry<MemoryCoreEvent, DerivedVariable<Modifier>> entry) {
        logger.trace("{}", entry);
        final DerivedVariable<Modifier> address = entry.getValue();
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
            logger.warn("empty pointer set for {}", synContext.get().getContextInfo(entry.getKey()));
        }
        if (address.base.includes.size() != 1) {
            return;
        }
        final IncludeEdge<Modifier> includeEdge = address.base.includes.get(0);
        final Modifier modifier = trait.compose(includeEdge.modifier, address.modifier);
        assert includeEdge.source.object != null;
        // If the only included address refers to the last element, treat it as a direct static offset instead.
        // This only works on concrete objects, where size is reliable.
        if (!includeEdge.source.object.getClass().equals(MemoryObject.class) || !includeEdge.source.object.hasKnownSize()) {
            return;
        }
        final Modifier post = trait.postProcess(modifier, includeEdge.source.object.getKnownSize());
        if (trait.isConstant(post)) {
            entry.setValue(new DerivedVariable<>(includeEdge.source, post));
        }
    }

    // ================================ Internals ================================

    private static final class Variable<Modifier> {
        // Any value contained in the referred variables is also contained (+ modifier).
        // Visualized as ingoing edges.
        private final List<IncludeEdge<Modifier>> includes = new ArrayList<>();
        // There is some load event using this (+ address modifier) as pointer set and the referred variable as result set.
        // Visualized as outgoing edges.
        private final List<LoadEdge<Modifier>> loads = new ArrayList<>();
        // There is some store event using this (+ address modifier) as pointer set and the derived variable as value set.
        // Visualized as outgoing edges.
        private final List<StoreEdge<Modifier>> stores = new ArrayList<>();
        // All variables that have a direct (includes/loads/stores) link to this.
        private final Set<Variable<Modifier>> seeAlso = new LinkedHashSet<>();
        // If nonnull, this variable represents that object's base address.
        private final MemoryObject object;
        // If nonnull, this variable represents an aggregate of field variables.
        private final DerivedVariable<Modifier>[] aggregate;
        // For visualization.
        private final String name;
        private Variable(MemoryObject o, DerivedVariable<Modifier>[] a, String n) {
            object = o;
            aggregate = a;
            name = n;
        }
        @Override public String toString() { return name; }
    }

    private record IncludeEdge<Modifier>(Variable<Modifier> source, Modifier modifier) {}

    private record LoadEdge<Modifier>(Variable<Modifier> result, Modifier addressModifier) {}

    private record StoreEdge<Modifier>(DerivedVariable<Modifier> value, Modifier addressModifier) {}

    private record DerivedVariable<Modifier>(Variable<Modifier> base, Modifier modifier) {}

    private boolean isConstant(Modifier modifier) {
        return trait.isConstant(modifier);
    }

    private boolean isTrivial(Modifier modifier) {
        return trait.isTrivial(modifier);
    }

    private DerivedVariable<Modifier> derive(Variable<Modifier> base) {
        return new DerivedVariable<>(base, trivialModifier);
    }

    private IncludeEdge<Modifier> includeEdge(DerivedVariable<Modifier> variable) {
        return new IncludeEdge<>(variable.base, variable.modifier);
    }

    private Variable<Modifier> newVariable(String name) {
        totalVariables++;
        return new Variable<>(null, null, name);
    }

    // Inserts a single inclusion relationship into the graph.
    // Any cycle closed by this edge will eventually be detected and resolved.
    private void addInclude(Variable<Modifier> variable, IncludeEdge<Modifier> includeEdge) {
        // accelerate for self-loops.
        // this is necessary besides lazy cycle detection, because it handles cycles of length 1.
        // LCD uses the edge that triggered the detection, which is not always the self-loop.
        final IncludeEdge<Modifier> edge = tryAccelerate(variable, includeEdge);
        if (!addInto(variable.includes, edge, true)) {
            return;
        }
        edge.source.seeAlso.add(variable);
        final int level = trait.level(edge.modifier);
        // enqueue the new edge
        final List<IncludeEdge<Modifier>> edges = queue.computeIfAbsent(level, k -> new LinkedHashMap<>())
                .computeIfAbsent(variable, k -> new ArrayList<>());
        if (edges.isEmpty()) {
            logger.trace("enqueue level={} variable={}", level, variable);
        }
        edges.add(edge);
    }

    private IncludeEdge<Modifier> tryAccelerate(Variable<Modifier> variable, IncludeEdge<Modifier> edge) {
        return edge.source != variable ? edge : new IncludeEdge<>(edge.source, trait.accelerate(edge.modifier));
    }

    // Tries to detect cycles when a new edge is to be added.
    // Called when a pointer propagates from variable to successor, due to an inclusion edge.
    private List<IncludeEdge<Modifier>> detectCycles(Variable<Modifier> variable, IncludeEdge<Modifier> edge) {
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
        final Set<Variable<Modifier>> includerSet = getIncluderSet(variable);
        if (!includerSet.contains(edge.source)) {
            cyclesSlowCulled++;
            return List.of();
        }
        cyclesDetected++;
        final List<IncludeEdge<Modifier>> result = getAllCyclicPaths(edge, includerSet);
        assert result.stream().anyMatch(e -> e.source == variable);
        return result;
    }

    private boolean equalsPointerSet(Variable<Modifier> left, Variable<Modifier> right) {
        // TODO hashing: each variable gets a hash code for its pointer set.
        return includesPointerSet(left, right) && includesPointerSet(right, left);
    }

    private boolean includesPointerSet(Variable<Modifier> variable1, Variable<Modifier> variable2) {
        for (final IncludeEdge<Modifier> i : variable1.includes) {
            if (i.source.object != null && !variable2.includes.contains(i)) {
                return false;
            }
        }
        return true;
    }

    private Set<Variable<Modifier>> getIncluderSet(Variable<Modifier> variable) {
        final Set<Variable<Modifier>> result = new HashSet<>(List.of(variable));
        List<Variable<Modifier>> worklist = new ArrayList<>(List.of(variable));
        while (!worklist.isEmpty()) {
            final List<Variable<Modifier>> next = new ArrayList<>();
            for (final Variable<Modifier> current : worklist) {
                for (final Variable<Modifier> v : current.seeAlso) {
                    // Culling
                    if (result.contains(v)) {
                        continue;
                    }
                    // Try to find some include edge, as 'seeAlso' also indicates store and load edges.
                    for (final IncludeEdge<Modifier> i : v.includes) {
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

    private List<IncludeEdge<Modifier>> getAllCyclicPaths(IncludeEdge<Modifier> edge, Set<Variable<Modifier>> includerSet) {
        final Map<Variable<Modifier>, List<IncludeEdge<Modifier>>> edges = new HashMap<>();
        // Use 'set' for performance.
        final Set<IncludeEdge<Modifier>> set = new HashSet<>();
        List<IncludeEdge<Modifier>> worklist = new ArrayList<>(List.of(new IncludeEdge<>(edge.source, trivialModifier)));
        // Since cycles are detected lazily, we need a bound for cycle lengths.
        for (int length = 0; length < includerSet.size(); length++) {
            if (worklist.isEmpty()) {
                break;
            }
            final List<IncludeEdge<Modifier>> next = new ArrayList<>();
            for (final IncludeEdge<Modifier> current : worklist) {
                for (final IncludeEdge<Modifier> i : current.source.includes) {
                    if (edge.source != i.source && includerSet.contains(i.source)) {
                        final IncludeEdge<Modifier> joinedEdge = compose(i, current.modifier);
                        if (set.add(joinedEdge) &&
                                addInto(edges.computeIfAbsent(i.source, k -> new ArrayList<>()), joinedEdge, false)) {
                            next.add(joinedEdge);
                        }
                    }
                }
            }
            worklist = next;
        }
        final List<IncludeEdge<Modifier>> result = new ArrayList<>();
        edges.values().forEach(result::addAll);
        return result;
    }

    private boolean addInto(List<IncludeEdge<Modifier>> list, IncludeEdge<Modifier> element, boolean isGraphModification) {
        //NOTE The Stream API is too costly here
        for (final IncludeEdge<Modifier> o : list) {
            if (element.source.equals(o.source) && trait.includes(o.modifier, element.modifier)) {
                if (isGraphModification) {
                    addIntoGraphFails++;
                } else {
                    addIntoCyclesFails++;
                }
                return false;
            }
        }
        if (isGraphModification) {
            addIntoGraphSuccesses++;
        } else {
            addIntoCyclesSuccesses++;
        }
        list.removeIf(o -> {
            if (!element.source.equals(o.source)) return false;
            return trait.includes(element.modifier, o.modifier);
        });
        list.add(element);
        return true;
    }

    // Called when a placeholder variable for a register writer is to be replaced by the proper variable.
    // A variable cannot be removed, if some event maps to it and there are multiple replacements.
    // In this case, the mapping stays but all outgoing edges are removed from that variable.
    private void replace(Variable<Modifier> old, DerivedVariable<Modifier> replacement) {
        assert old != replacement.base;
        assert !objectVariables.containsValue(old);
        totalReplacements++;
        logger.trace("{} -> {}", old, replacement);
        // likely / most frequent case
        addressVariables.replaceAll((k, v) -> v.base != old ? v : compose(replacement, v.modifier));
        registerVariables.replaceAll((k, v) -> v.base != old ? v : compose(replacement, v.modifier));
        for (final Variable<Modifier> out : old.seeAlso) {
            out.includes.replaceAll(e -> e.source != old ? e : includeEdge(compose(replacement, e.modifier)));
            assert out.loads.stream().noneMatch(e -> e.result == old);
            out.stores.replaceAll(e -> e.value.base != old ? e :
                    new StoreEdge<>(compose(replacement, e.value.modifier), e.addressModifier));
        }
        replacement.base.seeAlso.addAll(old.seeAlso);
        for (final IncludeEdge<Modifier> edge : old.includes) {
            edge.source.seeAlso.remove(old);
            edge.source.seeAlso.add(replacement.base);
        }
        // Redirect load and store relationships.
        // This could enable more communications, but replacement.
        for (final LoadEdge<Modifier> load : old.loads) {
            replacement.base.loads.add(compose(load, replacement.modifier));
            load.result.seeAlso.add(replacement.base);
        }
        for (final StoreEdge<Modifier> store : old.stores) {
            replacement.base.stores.add(compose(store, replacement.modifier));
            store.value.base.seeAlso.add(replacement.base);
        }
        old.seeAlso.clear();
        old.includes.clear();
        old.loads.clear();
        old.stores.clear();
    }

    // Find "may read from" relationships and deduce new 'includes' edges for the internal graph.
    private void processCommunication(List<StoreEdge<Modifier>> stores, List<LoadEdge<Modifier>> loads) {
        logger.trace("{} vs {}", stores, loads);
        if (loads.isEmpty()) {
            return;
        }
        for (final StoreEdge<Modifier> store : stores) {
            for (final LoadEdge<Modifier> load : loads) {
                if (trait.overlaps(store.addressModifier, load.addressModifier)) {
                    addInclude(load.result, includeEdge(store.value));
                }
            }
        }
    }

    // Applies another offset to an existing labeled edge.
    private DerivedVariable<Modifier> compose(DerivedVariable<Modifier> other, Modifier modifier) {
        return isTrivial(modifier) ? other : new DerivedVariable<>(other.base, trait.compose(other.modifier, modifier));
    }

    private IncludeEdge<Modifier> compose(IncludeEdge<Modifier> other, Modifier modifier) {
        return isTrivial(modifier) ? other : new IncludeEdge<>(other.source, trait.compose(other.modifier, modifier));
    }

    private LoadEdge<Modifier> compose(LoadEdge<Modifier> other, Modifier modifier) {
        return isTrivial(modifier) ? other : new LoadEdge<>(other.result, trait.compose(other.addressModifier, modifier));
    }

    private StoreEdge<Modifier> compose(StoreEdge<Modifier> other, Modifier modifier) {
        return isTrivial(modifier) ? other : new StoreEdge<>(other.value, trait.compose(other.addressModifier, modifier));
    }

    // Interprets an expression.
    // The result refers to an existing variable,
    // if the expression has a static base, or if the expression has a dynamic base with exactly one writer.
    // Otherwise, it refers to a new variable with proper incoming edges.
    private DerivedVariable<Modifier> getResultVariable(Expression expression, RegReader reader) {
        final var collector = new Collector(reader);
        final List<IncludeEdge<Modifier>> result = expression.accept(collector);
        return getOrNewVariable(result, String.format("res%d(%s)", reader.getGlobalId(), expression));
    }

    // Fetches the node for address values that can be read from a register at a specific program point.
    // Constructs a new node, if there are multiple writers.
    private DerivedVariable<Modifier> getPhiNodeVariable(Register register, RegReader reader) {
        // We assume here that uninitialized values carry no meaningful address to any memory object.
        final List<RegWriter> writers = dependency.getWriters(reader).ofRegister(register).getMayWriters();
        final DerivedVariable<Modifier> find = registerVariables.get(writers);
        if (find != null) {
            return find;
        }
        final Variable<Modifier> result = newVariable("phi" + reader.getGlobalId() + "(" + register.getName() + ")");
        // If writers is a singleton here, its "phi" node will be replaced later.  Otherwise, the "out" nodes.
        for (final RegWriter writer : writers.size() == 1 ? List.<RegWriter>of() : writers) {
            // The variables created here will be replaced later, if the events are out of order.
            final DerivedVariable<Modifier> writerVariable = registerVariables.computeIfAbsent(List.of(writer),
                    k -> derive(newVariable("out" + writer.getGlobalId())));
            addInclude(result, includeEdge(writerVariable));
        }
        return writers.isEmpty() ? derive(result) : registerVariables.compute(writers, (k, v) -> derive(result));
    }

    private DerivedVariable<Modifier> getOrNewVariable(List<IncludeEdge<Modifier>> edges, String name) {
        if (edges.isEmpty()) {
            return null;
        }
        if (edges.size() == 1) {
            return new DerivedVariable<>(edges.get(0).source, edges.get(0).modifier);
        }
        final Variable<Modifier> base = newVariable(name);
        for (IncludeEdge<Modifier> edge : edges) {
            addInclude(base, edge);
        }
        return derive(base);
    }

    private final class Collector implements ExpressionVisitor<List<IncludeEdge<Modifier>>> {

        private final RegReader reader;

        private Collector(RegReader reader) {
            this.reader = reader;
        }

        @Override
        public List<IncludeEdge<Modifier>> visitExpression(Expression expr) {
            final List<IncludeEdge<Modifier>> edges = new ArrayList<>();
            expr.accept(new ExpressionInspector() {
                @Override
                public Expression visitRegister(Register register) {
                    edges.add(new IncludeEdge<>(getPhiNodeVariable(register, reader).base, relaxedModifier));
                    return register;
                }
                @Override
                public Expression visitMemoryObject(MemoryObject object) {
                    edges.add(new IncludeEdge<>(objectVariables.get(object), relaxedModifier));
                    return object;
                }
            });
            return edges;
        }

        record ExprFlip(Expression x, int factor) {}

        @Override
        public List<IncludeEdge<Modifier>> visitIntBinaryExpression(IntBinaryExpr x) {
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
            final List<IncludeEdge<Modifier>> result = new ArrayList<>();
            final Modifier offsetModifier = trait.constantModifier(offset.intValue());
            for (int i = 0; i < operands.size(); i++) {
                final ExprFlip operand = operands.get(i);
                if (operand.factor != 1) {
                    result.addAll(visitExpression(operand.x));
                    continue;
                }
                Modifier alignment = trivialModifier;
                for (int j = 0; j < operands.size(); j++) {
                    alignment = j == i ? alignment : trait.compose(alignment, trait.accelerate(trait.constantModifier(operands.get(j).factor)));
                }
                for (IncludeEdge<Modifier> subResult : operand.x.accept(this)) {
                    addInto(result, compose(subResult, trait.compose(offsetModifier, alignment)), false);
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
        public List<IncludeEdge<Modifier>> visitIntSizeCastExpression(IntSizeCast expr) {
            // We assume type casts do not affect the value of pointers.
            return expr.isExtension() && !expr.preservesSign() ? expr.getOperand().accept(this) : visitExpression(expr);
        }

        @Override
        public List<IncludeEdge<Modifier>> visitITEExpression(ITEExpr x) {
            final List<IncludeEdge<Modifier>> result = new ArrayList<>(x.getTrueCase().accept(this));
            for (IncludeEdge<Modifier> edge : x.getFalseCase().accept(this)) {
                addInto(result, edge, false);
            }
            return result;
        }

        @Override
        public List<IncludeEdge<Modifier>> visitMemoryObject(MemoryObject a) {
            return List.of(new IncludeEdge<>(objectVariables.get(a), trivialModifier));
        }

        @Override
        public List<IncludeEdge<Modifier>> visitRegister(Register r) {
            DerivedVariable<Modifier> phiVariable = getPhiNodeVariable(r, reader);
            return List.of(includeEdge(phiVariable));
        }

        @Override
        public List<IncludeEdge<Modifier>> visitExtractExpression(ExtractExpr extract) {
            final List<IncludeEdge<Modifier>> result = new ArrayList<>();
            for (IncludeEdge<Modifier> operand : extract.getOperand().accept(this)) {
                DerivedVariable<Modifier> field = new DerivedVariable<>(operand.source, operand.modifier);
                for (int index : extract.getIndices()) {
                    final DerivedVariable<Modifier>[] aggregate = operand.source.aggregate;
                    final DerivedVariable<Modifier> f = aggregate == null || aggregate.length <= index ? null : aggregate[index];
                    if (f == null) {
                        field = compose(field, relaxedModifier);
                        break;
                    }
                    field = compose(f, field.modifier);
                }
                result.add(includeEdge(field));
            }
            return result;
        }

        @Override
        @SuppressWarnings("unchecked")
        public List<IncludeEdge<Modifier>> visitConstructExpression(ConstructExpr construct) {
            final List<IncludeEdge<Modifier>> result = new ArrayList<>();
            final int size = construct.getOperands().size();
            final DerivedVariable<Modifier>[] operands = (DerivedVariable<Modifier>[]) new DerivedVariable<?>[size];
            final String name = construct.toString();
            for (int i = 0; i < construct.getOperands().size(); i++) {
                final String fieldName = String.format("%s[%d]", name, i);
                operands[i] = getOrNewVariable(construct.getOperands().get(i).accept(this), fieldName);
            }
            final Variable<Modifier> proxy = new Variable<>(null, operands, name);
            totalVariables++;
            for (DerivedVariable<Modifier> operand : operands) {
                if (operand != null) {
                    addInclude(proxy, includeEdge(operand));
                }
            }
            result.add(new IncludeEdge<>(proxy, trivialModifier));
            return result;
        }
    }

    // Projects the internal representation of this analysis:
    // Nodes are variables, gray edges are inclusions.
    // Blue edges connect address variables to register variables.
    // Red edges connect address variables to stored value variables.
    // Green-labeled nodes represent memory objects.
    // Red-labeled nodes are address variables that do not include any memory objects (probably a bug).
    private void generateGraph() {
        final Set<Variable<Modifier>> seen = new HashSet<>(objectVariables.values());
        for (Set<Variable<Modifier>> news = seen; !news.isEmpty();) {
            final var next = new HashSet<Variable<Modifier>>();
            for (final Variable<Modifier> v : news) {
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
        for (Variable<Modifier> v : seen) {
            if (v == null) {
                continue;
            }
            for (final IncludeEdge<Modifier> i : v.includes) {
                verify(i.source.seeAlso.contains(v));
                map.computeIfAbsent("\"" + i.source.name + "\"", k -> new HashSet<>()).add("\"" + v.name + "\"");
            }
            for (final LoadEdge<Modifier> i : v.loads) {
                verify(i.result.seeAlso.contains(v));
                loads.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.result.name + "\"");
            }
            for (final StoreEdge<Modifier> i : v.stores) {
                verify(i.value.base.seeAlso.contains(v));
                stores.computeIfAbsent("\"" + v.name + "\"", k -> new HashSet<>()).add("\"" + i.value.base.name + "\"");
            }
        }
        final Set<String> problematic = new HashSet<>();
        for (final DerivedVariable<Modifier> a : addressVariables.values()) {
            if (!objectVariables.containsValue(a.base) &&
                    a.base.includes.stream().noneMatch(i -> objectVariables.containsValue(i.source))) {
                problematic.add("\"" + a.base.name + "\"");
            }
        }
        graphviz = new Graphviz();
        graphviz.beginDigraph("internal alias");
        for (final Variable<Modifier> v : objectVariables.values()) {
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
