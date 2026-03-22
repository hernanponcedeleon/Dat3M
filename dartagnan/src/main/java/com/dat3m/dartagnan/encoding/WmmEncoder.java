package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.smt.EncodingUtils;
import com.dat3m.dartagnan.smt.FormulaManagerExt;
import com.dat3m.dartagnan.wmm.*;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.definition.*;
import com.dat3m.dartagnan.wmm.definition.TagSet;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MapEventGraph;
import com.dat3m.dartagnan.wmm.utils.graph.mutable.MutableEventGraph;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.NumeralFormula;

import java.util.*;
import java.util.function.BiPredicate;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.encoding.ExpressionEncoder.ConversionMode.MEMORY_ROUND_TRIP_RELAXED;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LLVM;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Verify.verify;

@Options
public class WmmEncoder {

    private static final Logger logger = LoggerFactory.getLogger(WmmEncoder.class);
    private final EncodingContext context;
    private final RelationAnalysis ra;
    private final Wmm memoryModel;

    private final AxiomEncoder axiomEncoder = new AxiomEncoder();
    private final ActiveSetAnalysis activeSetAnalysis;

    // ==============================================================================================
    @Option(name = MEMORY_IS_ZEROED,
            description = "Assumes the whole memory is zeroed before the program runs." +
                    " In particular, if set to TRUE, reads from uninitialized memory will return zero." +
                    " Otherwise, uninitialized memory has a nondeterministic value.",
            secure = true)
    private boolean memoryIsZeroed = true;

    @Option(name = MULTI_READS,
            description = "Allows each load to have multiple, but at least one, incoming read-from relationships." +
                    " Otherwise, that number is restricted to 1.",
            secure = true)
    private boolean allowMultiReads = false;

    @Option(name=IDL_TO_SAT,
            description = "Use SAT-based encoding for totality and acyclicity.",
            secure = true)
    boolean useSATEncoding = false;

    // ==============================================================================================

    private WmmEncoder(EncodingContext ctx) throws InvalidConfigurationException {
        this.context = ctx;
        this.memoryModel = ctx.getTask().getMemoryModel();
        this.ra = ctx.getAnalysisContext().requires(RelationAnalysis.class);

        ctx.getTask().getConfig().inject(this);
        logger.info("{}: {}", MEMORY_IS_ZEROED, memoryIsZeroed);
        logger.info("{}: {}", MULTI_READS, allowMultiReads);
        logger.info("{}: {}", IDL_TO_SAT, useSATEncoding);

        this.activeSetAnalysis = ActiveSetAnalysis.newInstance(ctx.getTask(), ctx.getAnalysisContext());
    }

    public static WmmEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        return new WmmEncoder(context);
    }

    // ==================================================================================================
    // Public API

    public BooleanFormula encodeFullMemoryModel() {
        final Collection<Constraint> toEncode = context.constraintsToEncode;
        final Collection<? extends Constraint> total = memoryModel.getConstraints();
        logger.info("Encoding {} of {} constraints.", toEncode.size(), total.size());

        final var encoder = new ConstraintEncoder();
        for (Constraint c : toEncode) {
            logger.trace("Encoding {} '{}'", c instanceof Definition ? "definition" : "axiom", c);
            c.accept(encoder);
        }
        encodeContradictions(encoder.enc);

        // FIXME: This is slightly off for base relations like rf and co
        //  where we ignore the active set during encoding (we encode slightly more than
        //  what is active)
        final int totalEncodedEdgeDefs = toEncode.stream()
                .filter(Definition.class::isInstance)
                .map(Definition.class::cast)
                .mapToInt(def -> getActiveSet(def).size()).sum();
        logger.info("#Encoded edges: {}", totalEncodedEdgeDefs);

        return encoder.bmgr.and(encoder.enc);
    }

    public BooleanFormula encodeAxiomConsistency(Axiom axiom) {
        return axiom.accept(axiomEncoder);
    }

    public BooleanFormula encodeLastCoConstraints() {
        final Program program = context.getTask().getProgram();
        final ExecutionAnalysis exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);
        final AliasAnalysis alias = context.getAnalysisContext().requires(AliasAnalysis.class);
        final boolean doEncodeFinalAddressValues = program.getFormat() != LLVM;

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final Relation co = memoryModel.getRelation(CO);
        final RelationAnalysis.Knowledge knowledge = ra.getKnowledge(co);
        final EncodingContext.EdgeEncoder coEncoder = context.edge(co);
        // Find transitively implied coherences. We can use these to reduce the encoding.
        final EventGraph transCo = findTransitivelyImpliedCo();
        final ExpressionEncoder exprEncoder = context.getExpressionEncoder();

        final List<Init> initWrites = program.getThreadEvents(Init.class);
        // Find all writes that are never last, i.e., those that will always have a co-successor.
        final Set<Event> dominatedWrites = new HashSet<>();
        knowledge.getMustSet().apply((e1, e2) -> {
            if (exec.isImplied(e1, e2)) {
                dominatedWrites.add(e1);
            }
        });

        // ---- Construct encoding ----
        List<BooleanFormula> enc = new ArrayList<>();
        Map<Event, Set<Event>> out = knowledge.getMaySet().getOutMap();
        for (Store w1 : program.getThreadEvents(Store.class)) {
            if (dominatedWrites.contains(w1)) {
                enc.add(bmgr.not(context.lastCoVar(w1)));
                continue;
            }
            BooleanFormula isLast = context.execution(w1);
            // ---- Find all possibly overwriting writes ----
            for (Event w2 : out.getOrDefault(w1, Set.of())) {
                if (transCo.contains(w1, w2)) {
                    // We can skip the co-edge (w1,w2), because there will be an intermediate write w3
                    // that already witnesses that w1 is not last.
                    continue;
                }
                BooleanFormula isAfter = bmgr.not(knowledge.getMustSet().contains(w1, w2) ? context.execution(w2) : coEncoder.encode(w1, w2));
                isLast = bmgr.and(isLast, isAfter);
            }
            BooleanFormula lastCoExpr = context.lastCoVar(w1);
            enc.add(bmgr.equivalence(lastCoExpr, isLast));

            if (doEncodeFinalAddressValues && Arch.coIsTotal(program.getArch())) {
                // ---- Encode final values of addresses ----
                for (Init init : initWrites) {
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }
                    BooleanFormula sameAddress = context.sameAddress(init, w1);
                    final BooleanFormula sameValue = exprEncoder.assignEqual(
                            new FinalMemoryValue(null, init.getValue().getType(), init.getBase(), init.getOffset()),
                            context.value(w1),
                            MEMORY_ROUND_TRIP_RELAXED
                    );
                    enc.add(bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }

        if (doEncodeFinalAddressValues && !Arch.coIsTotal(program.getArch())) {
            // Coherence is not guaranteed to be total in all models (e.g., PTX),
            // but the final value of a location should always match that of some coLast event.
            // lastCo(w) => (lastVal(w.address) = w.val)
            //           \/ (exists w2 : lastCo(w2) /\ lastVal(w.address) = w2.val))
            for (Init init : initWrites) {
                BooleanFormula readLastStore = bmgr.makeFalse();
                BooleanFormula lastStoreExistsEnc = bmgr.makeFalse();
                Expression finalValue = new FinalMemoryValue(null, init.getValue().getType(), init.getBase(), init.getOffset());
                for (Store w : program.getThreadEvents(Store.class)) {
                    if (!alias.mayAlias(w, init)) {
                        continue;
                    }
                    BooleanFormula isLast = context.lastCoVar(w);
                    BooleanFormula sameAddr = context.sameAddress(init, w);
                    BooleanFormula sameValue = exprEncoder.assignEqual(finalValue, context.value(w), MEMORY_ROUND_TRIP_RELAXED);
                    readLastStore = bmgr.or(readLastStore, bmgr.and(isLast, sameAddr, sameValue));
                    lastStoreExistsEnc = bmgr.or(lastStoreExistsEnc, bmgr.and(isLast, sameAddr));
                }
                BooleanFormula readInitValue = exprEncoder.assignEqual(finalValue, context.value(init), MEMORY_ROUND_TRIP_RELAXED);
                enc.add(bmgr.ifThenElse(lastStoreExistsEnc, readLastStore, readInitValue));
            }
        }

        return bmgr.and(enc);
    }


    // ==================================================================================================
    // Internal

    /*
    Returns a set of edges (e1, e2) (subset of may set) for ordered relations whose
    clock-constraints do not need to get encoded explicitly.
    e.g. for co relation: (e1 = w1, e2 = w2)
    The reason is that whenever we have co(w1,w2) then there exists an intermediary
    w3 s.t. co(w1, w3) /\ co(w3, w2). As a result we have c(w1) < c(w3) < c(w2) transitively.
    Reasoning: Let (w1, w2) be a potential co-edge. Suppose there exists a w3 different to w1 and w2,
    whose execution is either implied by either w1 or w2.
    Now, if co(w1, w3) is a must-edge and co(w2, w3) is impossible, then we can reason as follows.
        - Suppose w1 and w2 get executed and their addresses match, then w3 must also get executed.
        - Since co(w1, w3) is a must-edge, we have that w3 accesses the same address as w1 and w2,
          and c(w1) < c(w3).
        - Because addr(w2)==addr(w3), we must also have either co(w2, e3) or co(w3, w2).
          The former is disallowed by assumption, so we have co(w3, w2) and hence c(w3) < c(w2).
        - By transitivity, we have c(w1) < c(w3) < c(w2) as desired.
        - Note that this reasoning has to be done inductively, because co(w1, w3) or co(w3, w2) may
          not involve encoding a clock constraint (due to this optimization).
    There is also a symmetric case where co(w3, w1) is impossible and co(w3, w2) is a must-edge.
*/
    private EventGraph findTransitivelyImpliedCo() {
        if (useSATEncoding) {
            return EventGraph.empty();
        }

        final Relation co = memoryModel.getRelation(RelationNameRepository.CO);
        final RelationAnalysis.Knowledge k = ra.getKnowledge(co);
        final ExecutionAnalysis exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);
        MutableEventGraph transCo = new MapEventGraph();
        Map<Event, Set<Event>> mustIn = k.getMustSet().getInMap();
        Map<Event, Set<Event>> mustOut = k.getMustSet().getOutMap();
        k.getMaySet().apply((e1, e2) -> {
            final MemoryEvent x = (MemoryEvent) e1;
            final MemoryEvent z = (MemoryEvent) e2;
            boolean hasIntermediary = mustOut.getOrDefault(x, Set.of()).stream().anyMatch(y -> y != x && y != z &&
                    (exec.isImplied(x, y) || exec.isImplied(z, y)) &&
                    !k.getMaySet().contains(z, y))
                    || mustIn.getOrDefault(z, Set.of()).stream().anyMatch(y -> y != x && y != z &&
                    (exec.isImplied(x, y) || exec.isImplied(z, y)) &&
                    !k.getMaySet().contains(y, x));
            if (hasIntermediary) {
                transCo.add(e1, e2);
            }
        });
        return transCo;
    }

    /*
        The returned predicate checks whether a pair of events (x, y) in a given relation <rel>
        can be unconditionally ordered.
        Used to optimize encodings of "acyclic <rel>" and "co".
    */
    private BiPredicate<Event, Event> getIsUnconditionallyOrderablePredicate(Relation rel) {
        // NOTE: This optimization tries to omit the guards of certain must-edges, i.e.,
        //  it promotes "exec(x) /\ exec(y) => clk(x) < clk(y)" to simply "clk(x) < clk(y)"
        // We can only do this when for a must-edge (x,y) we have
        //     (i)  exec(y) => exec(x)
        // OR  (ii) for all z: must(z,x) => must(z,y)
        final EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
        final Map<Event, Set<Event>> mustIn = mustSet.getInMap();
        final ExecutionAnalysis exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);
        return (x, y) -> {
            if (!mustSet.contains(x, y)) {
                return false;
            }
            return exec.isImplied(y, x) ||
                    mustIn.getOrDefault(x, Set.of()).stream().allMatch(z -> mustSet.contains(z, y));
        };
    }

    private void encodeContradictions(List<BooleanFormula> enc) {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        ra.getContradictions().apply((e1, e2) -> enc.add(bmgr.not(context.execution(e1, e2))));
    }

    private EventGraph getActiveSet(Definition definition) {
        return activeSetAnalysis.getActiveSet(definition);
    }

    private EventGraph getRelevantSet(Axiom axiom) {
        return activeSetAnalysis.getRelevantSet(axiom);
    }

    private NumeralFormula.IntegerFormula memoryOrderClock(Event write) {
        checkArgument(write.hasTag(WRITE), "Cannot get a clock-var for non-writes.");
        if (write.hasTag(INIT)) {
            return context.getFormulaManager().getIntegerFormulaManager().makeNumber(0);
        }
        return context.getFormulaManager().getIntegerFormulaManager().makeVariable("co " + write.getGlobalId());
    }

    // ================================================================================================
    // Constraint encoding

    // TODO: Change encoder to return encoding rather than accumulating it.
    //  Then fuse with AxiomEncoder
    private final class ConstraintEncoder implements Constraint.Visitor<Void> {
        private static final Set<Class<? extends Definition>> STATIC_RELATIONS = new HashSet<>(Arrays.asList(
                ProgramOrder.class,
                External.class,
                Internal.class,
                AMOPairs.class,
                DirectControlDependency.class,
                CASDependency.class,
                SameInstruction.class,
                SameScope.class,
                SyncWith.class,
                SameVirtualLocation.class, // FIXME?!
                Empty.class,
                TagSet.class
        ));

        final Program program = context.getTask().getProgram();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final List<BooleanFormula> enc = new ArrayList<>();

        // ASSUMPTION: The active set of a static relation is a subset of the most precise may-set.
        //             This holds true as long as our RA computes the most precise may-set for static relations.
        private void visitStatic(Definition def) {
            final Relation rel = def.getDefinedRelation();
            final EncodingContext.EdgeEncoder edge = context.edge(rel);
            final EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
            getActiveSet(def).apply((e1, e2) -> {
                if (!mustSet.contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge.encode(e1, e2), execution(e1, e2)));
                }
            });
        }

        @Override
        public Void visitDefinition(Definition def) {
            if (STATIC_RELATIONS.contains(def.getClass())) {
                visitStatic(def);
                return null;
            }
            final String errorMsg = String.format("Encoding of '%s' is not supported", def);
            throw new UnsupportedOperationException(errorMsg);
        }

        @Override
        public Void visitFree(Free def) {
            final Relation rel = def.getDefinedRelation();
            EncodingContext.EdgeEncoder edge = context.edge(rel);
            getActiveSet(def).apply((e1, e2) -> enc.add(bmgr.implication(edge.encode(e1, e2), execution(e1, e2))));
            return null;
        }

        @Override
        public Void visitUnion(Union union) {
            final Relation rel = union.getDefinedRelation();
            final List<Relation> operands = union.getOperands();
            EventGraph must = ra.getKnowledge(rel).getMustSet();
            EncodingContext.EdgeEncoder e0 = context.edge(rel);
            EncodingContext.EdgeEncoder[] encoders = operands.stream().map(context::edge).toArray(EncodingContext.EdgeEncoder[]::new);
            getActiveSet(union).apply((e1, e2) -> {
                BooleanFormula edge = e0.encode(e1, e2);
                if (must.contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    List<BooleanFormula> opt = new ArrayList<>(operands.size());
                    for (EncodingContext.EdgeEncoder e : encoders) {
                        opt.add(e.encode(e1, e2));
                    }
                    enc.add(bmgr.equivalence(edge, bmgr.or(opt)));
                }
            });
            return null;
        }

        @Override
        public Void visitIntersection(Intersection inter) {
            final Relation rel = inter.getDefinedRelation();
            final List<Relation> operands = inter.getOperands();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            RelationAnalysis.Knowledge[] knowledges = operands.stream().map(ra::getKnowledge).toArray(RelationAnalysis.Knowledge[]::new);
            EncodingContext.EdgeEncoder e0 = context.edge(rel);
            EncodingContext.EdgeEncoder[] encoders = operands.stream().map(context::edge).toArray(EncodingContext.EdgeEncoder[]::new);
            getActiveSet(inter).apply((e1, e2) -> {
                BooleanFormula edge = e0.encode(e1, e2);
                if (k.getMustSet().contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    List<BooleanFormula> opt = new ArrayList<>(operands.size());
                    for (int i = 0; i < operands.size(); i++) {
                        if (!knowledges[i].getMustSet().contains(e1, e2)) {
                            opt.add(encoders[i].encode(e1, e2));
                        }
                    }
                    enc.add(bmgr.equivalence(edge, bmgr.and(opt)));
                }
            });
            return null;
        }

        @Override
        public Void visitDifference(Difference diff) {
            final Relation rel = diff.getDefinedRelation();
            final Relation r1 = diff.getMinuend();
            final Relation r2 = diff.getSubtrahend();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            EncodingContext.EdgeEncoder enc2 = context.edge(r2);
            getActiveSet(diff).apply((e1, e2) -> {
                BooleanFormula edge = enc0.encode(e1, e2);
                if (k.getMustSet().contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    BooleanFormula opt1 = enc1.encode(e1, e2);
                    BooleanFormula opt2 = bmgr.not(enc2.encode(e1, e2));
                    enc.add(bmgr.equivalence(edge, bmgr.and(opt1, opt2)));
                }
            });
            return null;
        }

        @Override
        public Void visitComposition(Composition comp) {
            final Relation rel = comp.getDefinedRelation();
            final Relation r1 = comp.getLeftOperand();
            final Relation r2 = comp.getRightOperand();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rel);
            final RelationAnalysis.Knowledge k1 = ra.getKnowledge(r1);
            final RelationAnalysis.Knowledge k2 = ra.getKnowledge(r2);
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            EncodingContext.EdgeEncoder enc2 = context.edge(r2);
            final EventGraph a1 = EventGraph.union(getActiveSet(r1.getDefinition()), k1.getMustSet());
            final EventGraph a2 = EventGraph.union(getActiveSet(r2.getDefinition()), k2.getMustSet());
            Map<Event, Set<Event>> out = k1.getMaySet().getOutMap();
            getActiveSet(comp).apply((e1, e2) -> {
                BooleanFormula expr = bmgr.makeFalse();
                if (k.getMustSet().contains(e1, e2)) {
                    expr = execution(e1, e2);
                } else {
                    for (Event e : out.getOrDefault(e1, Set.of())) {
                        if (k2.getMaySet().contains(e, e2)) {
                            verify(a1.contains(e1, e) && a2.contains(e, e2),
                                    "Failed to properly propagate active sets across composition at triple: (%s, %s, %s).", e1, e, e2);
                            expr = bmgr.or(expr, bmgr.and(enc1.encode(e1, e), enc2.encode(e, e2)));
                        }
                    }
                }
                enc.add(bmgr.equivalence(enc0.encode(e1, e2), expr));
            });
            return null;
        }

        @Override
        public Void visitProjection(Projection projection) {
            final Relation rel = projection.getDefinedRelation();
            final Relation r1 = projection.getOperand();
            final EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            final EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            final boolean dom = projection.getDimension() == Projection.Dimension.DOMAIN;
            final EventGraph may1 = ra.getKnowledge(r1).getMaySet();
            final Map<Event, Set<Event>> altMap = dom ? may1.getOutMap() : may1.getInMap();
            getActiveSet(projection).apply((e1, e2) -> {
                assert e1.equals(e2);
                final var opt = new ArrayList<BooleanFormula>();
                for (Event alt : altMap.getOrDefault(e1, Set.of())) {
                    opt.add(enc1.encode(dom ? e1 : alt, dom ? alt : e1));
                }
                enc.add(bmgr.equivalence(enc0.encode(e1, e1), bmgr.or(opt)));
            });
            return null;
        }

        @Override
        public Void visitTransitiveClosure(TransitiveClosure trans) {
            final Relation rel = trans.getDefinedRelation();
            final Relation r1 = trans.getOperand();
            final EventGraph relMustSet = ra.getKnowledge(rel).getMustSet();
            final EventGraph relMaySet = ra.getKnowledge(rel).getMaySet();
            final EventGraph r1MaySet = ra.getKnowledge(r1).getMaySet();
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            getActiveSet(trans).apply((e1, e2) -> {
                BooleanFormula edge = enc0.encode(e1, e2);
                if (relMustSet.contains(e1, e2)) {
                    enc.add(bmgr.equivalence(edge, execution(e1, e2)));
                } else {
                    BooleanFormula orClause = bmgr.makeFalse();
                    if (r1MaySet.contains(e1, e2)) {
                        orClause = bmgr.or(orClause, enc1.encode(e1, e2));
                    }
                    for (Event e : r1MaySet.getRange(e1)) {
                        if (e.getGlobalId() != e1.getGlobalId() && e.getGlobalId() != e2.getGlobalId() && relMaySet.contains(e, e2)) {
                            BooleanFormula tVar = relMustSet.contains(e1, e) ? enc0.encode(e1, e) : enc1.encode(e1, e);
                            orClause = bmgr.or(orClause, bmgr.and(tVar, enc0.encode(e, e2)));
                        }
                    }
                    enc.add(bmgr.equivalence(edge, orClause));
                }
            });
            return null;
        }

        @Override
        public Void visitSetIdentity(SetIdentity id) {
            final Relation setId = id.getDefinedRelation();
            final Relation domain = id.getDomain();
            EventGraph mustSet = ra.getKnowledge(setId).getMustSet();
            EncodingContext.EdgeEncoder encSetId = context.edge(setId);
            EncodingContext.EdgeEncoder encDomain = context.edge(domain);
            getActiveSet(id).apply((e1, e2) ->
                    enc.add(bmgr.equivalence(
                            encSetId.encode(e1, e2),
                            mustSet.contains(e1, e2)
                                    ? execution(e1, e2)
                                    : e1 == e2 ? encDomain.encode(e1, e2) : bmgr.makeFalse()
                    ))
            );
            return null;
        }

        @Override
        public Void visitInverse(Inverse inv) {
            final Relation rel = inv.getDefinedRelation();
            final Relation r1 = inv.getOperand();
            EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
            EncodingContext.EdgeEncoder enc0 = context.edge(rel);
            EncodingContext.EdgeEncoder enc1 = context.edge(r1);
            getActiveSet(inv).apply((e1, e2) ->
                    enc.add(bmgr.equivalence(
                            enc0.encode(e1, e2),
                            mustSet.contains(e1, e2)
                                    ? execution(e1, e2)
                                    : enc1.encode(e2, e1)
                    ))
            );
            return null;
        }

        @Override
        public Void visitProduct(CartesianProduct cartesianProduct) {
            final Relation product = cartesianProduct.getDefinedRelation();
            final Relation domain = cartesianProduct.getDomain();
            final Relation range = cartesianProduct.getRange();
            EventGraph mustSet = ra.getKnowledge(product).getMustSet();
            EncodingContext.EdgeEncoder encProduct = context.edge(product);
            EncodingContext.EdgeEncoder encDomain = context.edge(domain);
            EncodingContext.EdgeEncoder encRange = context.edge(range);
            getActiveSet(cartesianProduct).apply((e1, e2) ->
                    enc.add(bmgr.equivalence(
                            encProduct.encode(e1, e2),
                            mustSet.contains(e1, e2)
                                    ? execution(e1, e2)
                                    : bmgr.and(encDomain.encode(e1, e1), encRange.encode(e2, e2))
                    ))
            );
            return null;
        }

        @Override
        public Void visitInternalDataDependency(DirectDataDependency idd) {
            return visitDirectDependency(idd);
        }

        @Override
        public Void visitAddressDependency(DirectAddressDependency addrDirect) {
            return visitDirectDependency(addrDirect);
        }

        private Void visitDirectDependency(Definition dep) {
            final ReachingDefinitionsAnalysis definitions = context.getAnalysisContext()
                    .get(ReachingDefinitionsAnalysis.class);
            final EncodingContext.EdgeEncoder edge = context.edge(dep.getDefinedRelation());
            getActiveSet(dep).apply((writer, reader) -> {
                if (!(writer instanceof RegWriter wr) || !(reader instanceof RegReader rr)) {
                    enc.add(bmgr.not(edge.encode(writer, reader)));
                } else {
                    final ReachingDefinitionsAnalysis.RegisterWriters state = definitions.getWriters(rr)
                            .ofRegister(wr.getResultRegister());
                    if (state.getMustWriters().contains(writer)) {
                        enc.add(bmgr.equivalence(edge.encode(writer, reader), context.execution(writer, reader)));
                    } else if (!state.getMayWriters().contains(writer)) {
                        enc.add(bmgr.not(edge.encode(writer, reader)));
                    }
                }
            });
            return null;
        }

        @Override
        public Void visitLinuxCriticalSections(LinuxCriticalSections rscsDef) {
            final Relation rscs = rscsDef.getDefinedRelation();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rscs);
            final Map<Event, Set<Event>> mayIn = k.getMaySet().getInMap();
            final Map<Event, Set<Event>> mayOut = k.getMaySet().getOutMap();
            EncodingContext.EdgeEncoder encoder = context.edge(rscs);
            getActiveSet(rscsDef).apply((lock, unlock) -> {
                BooleanFormula relation = execution(lock, unlock);
                for (Event y : mayIn.getOrDefault(unlock, Set.of())) {
                    if (lock.getGlobalId() < y.getGlobalId() && y.getGlobalId() < unlock.getGlobalId()) {
                        relation = bmgr.and(relation, bmgr.not(encoder.encode(y, unlock)));
                    }
                }
                for (Event y : mayOut.getOrDefault(lock, Set.of())) {
                    if (lock.getGlobalId() < y.getGlobalId() && y.getGlobalId() < unlock.getGlobalId()) {
                        relation = bmgr.and(relation, bmgr.not(encoder.encode(lock, y)));
                    }
                }
                enc.add(bmgr.equivalence(encoder.encode(lock, unlock), relation));
            });
            return null;
        }

        @Override
        public Void visitLXSXPairs(LXSXPairs lxsxDef) {
            final Relation rmw = lxsxDef.getDefinedRelation();
            BooleanFormula unpredictable = bmgr.makeFalse();
            final RelationAnalysis.Knowledge k = ra.getKnowledge(rmw);
            final Map<Event, Set<Event>> mayIn = k.getMaySet().getInMap();
            final Map<Event, Set<Event>> mayOut = k.getMaySet().getOutMap();
            final Map<Event, Event> siMap = new HashMap<>();
            for (InstructionBoundary end : program.getThreadEvents(InstructionBoundary.class)) {
                final List<Event> events = end.getInstructionEvents().stream().filter(e -> e.hasTag(EXCL)).toList();
                for (Event event : events) {
                    siMap.put(event, events.get(0));
                }
            }

            // ----------  Encode matching for LL/SC-type RMWs ----------
            for (RMWStoreExclusive store : program.getThreadEvents(RMWStoreExclusive.class)) {
                final Event firstStore = siMap.getOrDefault(store, store);
                if (!store.equals(firstStore)) {
                    enc.add(bmgr.equivalence(context.execution(store), context.execution(firstStore)));
                    continue;
                }
                final List<BooleanFormula> storeExec = new ArrayList<>();
                for (Event e : mayIn.getOrDefault(store, Set.of())) {
                    if (!e.equals(siMap.getOrDefault(e, e))) {
                        continue;
                    }
                    MemoryCoreEvent load = (MemoryCoreEvent) e;
                    BooleanFormula sameAddress = context.sameAddress(load, store);
                    // Encode if load and store form an exclusive pair
                    BooleanFormula isPair = exclPair(load, store);
                    List<BooleanFormula> pairingCond = new ArrayList<>();
                    pairingCond.add(context.execution(load));
                    pairingCond.add(context.controlFlow(store));
                    for (Event otherLoad : mayIn.getOrDefault(store, Set.of())) {
                        if (otherLoad.getGlobalId() > load.getGlobalId() &&
                                otherLoad.equals(siMap.getOrDefault(otherLoad, otherLoad))) {
                            pairingCond.add(bmgr.not(context.execution(otherLoad)));
                        }
                    }
                    for (Event otherStore : mayOut.getOrDefault(load, Set.of())) {
                        if (otherStore.getGlobalId() < store.getGlobalId() &&
                                otherStore.equals(siMap.getOrDefault(otherStore, otherStore))) {
                            pairingCond.add(bmgr.not(context.controlFlow(otherStore)));
                        }
                    }
                    // For ARMv8, the store can be executed if addresses mismatch, but behaviour is "constrained unpredictable"
                    // The implementation does not include all possible unpredictable cases: in case of address
                    // mismatch, addresses of read and write are unknown, i.e. read and write can use any address.
                    // For RISCV and Power, addresses should match.
                    if (store.doesRequireMatchingAddresses()) {
                        pairingCond.add(sameAddress);
                    } else {
                        unpredictable = bmgr.or(unpredictable, bmgr.and(context.execution(store), isPair, bmgr.not(sameAddress)));
                    }
                    enc.add(bmgr.equivalence(isPair, bmgr.and(pairingCond)));
                    storeExec.add(isPair);
                }
                enc.add(bmgr.implication(context.execution(store), bmgr.or(storeExec)));
            }

            // ---------- Encode actual RMW relation ----------
            EncodingContext.EdgeEncoder edge = context.edge(rmw);
            getActiveSet(lxsxDef).apply((e1, e2) -> {
                MemoryCoreEvent load = (MemoryCoreEvent) e1;
                MemoryCoreEvent store = (MemoryCoreEvent) e2;
                if (!load.hasTag(Tag.EXCL) || !(store instanceof RMWStoreExclusive exclStore)) {
                    // Non-LL/SC type RMWs always hold
                    enc.add(bmgr.equivalence(edge.encode(load, store), context.execution(load, store)));
                } else {
                    // Note that if the pair RMWStore requires matching addresses, then we do NOT(!)
                    // add an address check, because the pairing condition already includes the address check.
                    BooleanFormula sameAddress = exclStore.doesRequireMatchingAddresses() ?
                            bmgr.makeTrue() : context.sameAddress(load, store);
                    enc.add(bmgr.equivalence(
                            edge.encode(load, store),
                            k.getMustSet().contains(load, store) ?
                                    execution(load, store) :
                                    bmgr.and(
                                            context.execution(store),
                                            exclPair(siMap.getOrDefault(load, load), siMap.getOrDefault(store, store)),
                                            sameAddress
                                    )
                    ));
                }
            });

            return null;
        }

        private BooleanFormula exclPair(Event load, Event store) {
            return bmgr.makeVariable("excl(" + load.getGlobalId() + "," + store.getGlobalId() + ")");
        }

        @Override
        public Void visitSameLocation(SameLocation locDef) {
            final Relation loc = locDef.getDefinedRelation();
            EncodingContext.EdgeEncoder edge = context.edge(loc);
            getActiveSet(locDef).apply((e1, e2) ->
                    enc.add(bmgr.equivalence(edge.encode(e1, e2), bmgr.and(
                            execution(e1, e2),
                            context.sameAddress((MemoryCoreEvent) e1, (MemoryCoreEvent) e2)
                    )))
            );
            return null;
        }

        @Override
        public Void visitReadFrom(ReadFrom rfDef) {
            final ExpressionEncoder exprEncoder = context.getExpressionEncoder();
            final Relation rf = rfDef.getDefinedRelation();
            final EncodingContext.EdgeEncoder edge = context.edge(rf);
            final EncodingUtils utils = context.getFormulaManager().getEncodingUtils();

            final Map<MemoryEvent, List<BooleanFormula>> read2RfEdges = new HashMap<>();
            // Encode the semantics of rf-edges
            ra.getKnowledge(rf).getMaySet().apply((e1, e2) -> {
                final MemoryCoreEvent w = (MemoryCoreEvent) e1;
                final MemoryCoreEvent r = (MemoryCoreEvent) e2;

                final BooleanFormula rfEdge = edge.encode(w, r);
                final BooleanFormula sameAddress = context.sameAddress(w, r);
                final BooleanFormula sameValue = context.assignValue(r, w);
                enc.add(bmgr.implication(rfEdge, bmgr.and(execution(w, r), sameAddress, sameValue)));
                read2RfEdges.computeIfAbsent(r, key -> new ArrayList<>()).add(rfEdge);
            });

            // Encode the existence of rf-edges (+ semantics of uninit reads)
            for (Load r : program.getThreadEvents(Load.class)) {
                final BooleanFormula uninit = getUninitReadVar(r);
                if (memoryIsZeroed) {
                    final Expression zero = context.getExpressionFactory().makeGeneralZero(r.getAccessType());
                    enc.add(bmgr.implication(uninit, exprEncoder.assignEqual(context.value(r), zero)));
                }

                final List<BooleanFormula> rfChoices = Lists.newArrayList(Iterables.concat(
                        List.of(uninit), read2RfEdges.getOrDefault(r, List.of())
                ));
                final BooleanFormula rfExistenceConstraint = allowMultiReads
                        ? utils.atLeastOne(rfChoices)
                        : utils.exactlyOneSequence(rfChoices, "rf_E" + r.getGlobalId());
                enc.add(bmgr.implication(context.execution(r), rfExistenceConstraint));
            }
            return null;
        }

        private BooleanFormula getUninitReadVar(Load load) {
            return bmgr.makeVariable("uninit_read " + load.getGlobalId());
        }

        @Override
        public Void visitCoherence(Coherence coDef) {
            final Relation co = coDef.getDefinedRelation();
            final BiPredicate<Event, Event> alwaysOrdered = getIsUnconditionallyOrderablePredicate(co);
            final boolean idl = !useSATEncoding;
            final EventGraph maySet = ra.getKnowledge(co).getMaySet();
            final EventGraph mustSet = ra.getKnowledge(co).getMustSet();
            final EventGraph transCo = findTransitivelyImpliedCo();

            final List<MemoryCoreEvent> allWrites = program.getThreadEvents(MemoryCoreEvent.class).stream()
                    .filter(e -> e.hasTag(WRITE))
                    .sorted(Comparator.comparingInt(Event::getGlobalId))
                    .toList();
            final IntegerFormulaManager imgr = idl ? context.getFormulaManager().getIntegerFormulaManager() : null;
            final EncodingContext.EdgeEncoder edge = context.edge(co);

            if (idl) {
                // ---- Encode clock conditions (init = 0, non-init > 0) ----
                NumeralFormula.IntegerFormula zero = imgr.makeNumber(0);
                for (MemoryCoreEvent w : allWrites) {
                    NumeralFormula.IntegerFormula clock = memoryOrderClock(w);
                    enc.add(w.hasTag(INIT) ? imgr.equal(clock, zero) : imgr.lessThan(zero, clock));
                }
            }
            // ---- Encode coherences ----
            for (int i = 0; i < allWrites.size() - 1; i++) {
                MemoryCoreEvent x = allWrites.get(i);
                for (MemoryCoreEvent z : allWrites.subList(i + 1, allWrites.size())) {
                    boolean forwardPossible = maySet.contains(x, z);
                    boolean backwardPossible = maySet.contains(z, x);
                    if (!forwardPossible && !backwardPossible) {
                        continue;
                    }
                    BooleanFormula execPair = execution(x, z);
                    BooleanFormula sameAddress = context.sameAddress(x, z);
                    BooleanFormula pairingCond = bmgr.and(execPair, sameAddress);
                    BooleanFormula coF = forwardPossible ? edge.encode(x, z) : bmgr.makeFalse();
                    BooleanFormula coB = backwardPossible ? edge.encode(z, x) : bmgr.makeFalse();
                    // Coherence is not total for some architectures
                    if (Arch.coIsTotal(program.getArch())) {
                        enc.add(bmgr.equivalence(pairingCond, bmgr.or(coF, coB)));
                    } else {
                        enc.add(bmgr.implication(bmgr.or(coF, coB), pairingCond));
                    }
                    if (idl) {
                        if (alwaysOrdered.test(x, z)) {
                            enc.add(imgr.lessThan(memoryOrderClock(x), memoryOrderClock(z)));
                        } else if (alwaysOrdered.test(z, x)) {
                            enc.add(imgr.lessThan(memoryOrderClock(z), memoryOrderClock(x)));
                        } else {
                            enc.add(bmgr.implication(coF, x.hasTag(INIT) || transCo.contains(x, z)
                                    ? bmgr.makeTrue()
                                    : imgr.lessThan(memoryOrderClock(x), memoryOrderClock(z))));
                            enc.add(bmgr.implication(coB, z.hasTag(INIT) || transCo.contains(z, x) ? bmgr.makeTrue()
                                    : imgr.lessThan(memoryOrderClock(z), memoryOrderClock(x))));
                        }
                    } else {
                        enc.add(bmgr.or(bmgr.not(coF), bmgr.not(coB)));
                        if (!mustSet.contains(x, z) && !mustSet.contains(z, x)) {
                            for (MemoryEvent y : allWrites) {
                                if (forwardPossible && maySet.contains(x, y) && maySet.contains(y, z)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(x, y), edge.encode(y, z)), coF));
                                }
                                if (backwardPossible && maySet.contains(y, x) && maySet.contains(z, y)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(y, x), edge.encode(z, y)), coB));
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitSyncBarrier(SyncBar syncBar) {
            final Relation rel = syncBar.getDefinedRelation();
            EncodingContext.EdgeEncoder encoder = context.edge(rel);
            EventGraph mustSet = ra.getKnowledge(rel).getMustSet();
            getActiveSet(syncBar).apply((e1, e2) -> {
                BooleanFormula condition = execution(e1, e2);
                if (!mustSet.contains(e1, e2) && e1 instanceof NamedBarrier b1 && e2 instanceof NamedBarrier b2) {
                    condition = bmgr.and(condition, context.sync(b1));
                    if (!(b1.getResourceId() instanceof IntLiteral) || !(b2.getResourceId() instanceof IntLiteral)) {
                        condition = bmgr.and(condition, context.getExpressionEncoder().equalAt(
                                b1.getResourceId(), b1, b2.getResourceId(), b2
                        ));
                    }
                }
                enc.add(bmgr.equivalence(encoder.encode(e1, e2), condition));
            });
            return null;
        }

        @Override
        public Void visitSyncFence(SyncFence syncFenceDef) {
            final Relation syncFence = syncFenceDef.getDefinedRelation();
            final boolean idl = !useSATEncoding;
            final String relName = syncFence.getName().orElseThrow(); // syncFence is base, it always has a name
            List<Event> allFenceSC = program.getThreadEventsWithAllTags(VISIBLE, FENCE, PTX.SC);
            allFenceSC.removeIf(e -> !e.getThread().hasScope());
            EncodingContext.EdgeEncoder edge = context.edge(syncFence);
            EventGraph maySet = ra.getKnowledge(syncFence).getMaySet();
            EventGraph mustSet = ra.getKnowledge(syncFence).getMustSet();
            IntegerFormulaManager imgr = idl ? context.getFormulaManager().getIntegerFormulaManager() : null;
            // ---- Encode syncFence ----
            for (int i = 0; i < allFenceSC.size() - 1; i++) {
                Event x = allFenceSC.get(i);
                for (Event z : allFenceSC.subList(i + 1, allFenceSC.size())) {
                    String scope1 = Tag.getScopeTag(x, program.getArch());
                    String scope2 = Tag.getScopeTag(z, program.getArch());
                    if (scope1.isEmpty() || scope2.isEmpty()) {
                        continue;
                    }
                    if (!x.getThread().getScopeHierarchy().canSyncAtScope((z.getThread().getScopeHierarchy()), scope1) ||
                            !z.getThread().getScopeHierarchy().canSyncAtScope((x.getThread().getScopeHierarchy()), scope2)) {
                        continue;
                    }
                    boolean forwardPossible = maySet.contains(x, z);
                    boolean backwardPossible = maySet.contains(z, x);
                    if (!forwardPossible && !backwardPossible) {
                        continue;
                    }
                    BooleanFormula pairingCond = execution(x, z);
                    BooleanFormula scF = forwardPossible ? edge.encode(x, z) : bmgr.makeFalse();
                    BooleanFormula scB = backwardPossible ? edge.encode(z, x) : bmgr.makeFalse();
                    enc.add(bmgr.equivalence(pairingCond, bmgr.or(scF, scB)));
                    if (idl) {
                        enc.add(bmgr.implication(scF, imgr.lessThan(context.clockVariable(relName, x), context.clockVariable(relName, z))));
                        enc.add(bmgr.implication(scB, imgr.lessThan(context.clockVariable(relName, z), context.clockVariable(relName, x))));
                    } else {
                        enc.add(bmgr.or(bmgr.not(scF), bmgr.not(scB)));
                        if (!mustSet.contains(x, z) && !mustSet.contains(z, x)) {
                            for (Event y : allFenceSC) {
                                if (forwardPossible && maySet.contains(x, y) && maySet.contains(y, z)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(x, y), edge.encode(y, z)), scF));
                                }
                                if (backwardPossible && maySet.contains(y, x) && maySet.contains(z, y)) {
                                    enc.add(bmgr.implication(bmgr.and(edge.encode(y, x), edge.encode(z, y)), scB));
                                }
                            }
                        }
                    }
                }
            }
            return null;
        }

        @Override
        public Void visitAxiom(Axiom axiom) {
            if (!axiom.isFlagged()) {
                enc.add(axiom.accept(axiomEncoder));
            }
            return null;
        }

        private BooleanFormula execution(Event e1, Event e2) {
            return context.execution(e1, e2);
        }
    }



    // ================================================================================================
    // Axiom encoding

    public class AxiomEncoder implements Constraint.Visitor<BooleanFormula> {

        @Override
        public BooleanFormula visitConstraint(Constraint constraint) {
            throw new UnsupportedOperationException("AxiomEncoder does not support Constraint " + constraint.getClass().getSimpleName());
        }

        @Override
        public BooleanFormula visitEmptiness(Emptiness axiom) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final Relation relation = axiom.getRelation();
            final EncodingContext.EdgeEncoder edge = context.edge(relation);

            final List<BooleanFormula> edges = new ArrayList<>();
            getRelevantSet(axiom).apply((e1, e2) -> edges.add(edge.encode(e1, e2)));

            return axiom.isNegated() ? bmgr.or(edges) : bmgr.and(edges.stream().map(bmgr::not).toList());
        }

        @Override
        public BooleanFormula visitIrreflexivity(Irreflexivity axiom) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final Relation relation = axiom.getRelation();
            final EncodingContext.EdgeEncoder edge = context.edge(relation);

            final List<BooleanFormula> edges = new ArrayList<>();
            getRelevantSet(axiom).apply((e1, e2) -> {
                assert e1 == e2;
                edges.add(edge.encode(e1, e2));
            });

            return axiom.isNegated() ? bmgr.or(edges) : bmgr.and(edges.stream().map(bmgr::not).toList());
        }

        // ------------------------------------------------------------------------
        // Acyclicity

        @Override
        public BooleanFormula visitAcyclicity(Acyclicity axiom) {
            final Relation relation = axiom.getRelation();
            final EventGraph relevantEdges = getRelevantSet(axiom);
            final List<BooleanFormula> enc = axiom.isNegated()
                    ? cyclicSAT(relation, relevantEdges) // There is no IDL-based encoding for inconsistency
                    : useSATEncoding
                    ? acyclicSAT(relation, relevantEdges)
                    : acyclicIDL(relation, relevantEdges);
            return context.getBooleanFormulaManager().and(enc);
        }

        private List<BooleanFormula> cyclicSAT(Relation rel, EventGraph relevantEdges) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            List<BooleanFormula> enc = new ArrayList<>();
            List<BooleanFormula> eventsInCycle = new ArrayList<>();
            Map<Event, List<BooleanFormula>> inMap = new HashMap<>();
            Map<Event, List<BooleanFormula>> outMap = new HashMap<>();
            relevantEdges.apply((e1, e2) -> {
                BooleanFormula cycleVar = getSMTCycleVar(rel, e1, e2);
                inMap.computeIfAbsent(e2, k -> new ArrayList<>()).add(cycleVar);
                outMap.computeIfAbsent(e1, k -> new ArrayList<>()).add(cycleVar);
            });
            // We use Boolean variables, which guess the edges and nodes constituting the cycle.
            final EncodingContext.EdgeEncoder edge = context.edge(rel);
            for (Event e : relevantEdges.getDomain()) {
                eventsInCycle.add(cycleVar(rel, e));
                // We ensure that for every event in the cycle, there should be at least one incoming
                // edge and at least one outgoing edge that are also in the cycle.
                enc.add(bmgr.implication(cycleVar(rel, e), bmgr.and(bmgr.or(inMap.get(e)), bmgr.or(outMap.get(e)))));
                relevantEdges.apply((e1, e2) ->
                        // If an edge is guessed to be in a cycle, the edge must belong to relation,
                        // and both events must also be guessed to be on the cycle.
                        enc.add(bmgr.implication(getSMTCycleVar(rel, e1, e2),
                                bmgr.and(edge.encode(e1, e2), cycleVar(rel, e1), cycleVar(rel, e2))
                        ))
                );
            }
            // A cycle exists if there is an event in the cycle.
            enc.add(bmgr.or(eventsInCycle));
            return enc;
        }

        private List<BooleanFormula> acyclicIDL(Relation rel, EventGraph relevantEdges) {
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final IntegerFormulaManager imgr = context.getFormulaManager().getIntegerFormulaManager();
            final String clockVarName = rel.getNameOrTerm();
            final BiPredicate<Event, Event> alwaysOrder = getIsUnconditionallyOrderablePredicate(rel);

            List<BooleanFormula> enc = new ArrayList<>();
            final EncodingContext.EdgeEncoder edge = context.edge(rel);
            relevantEdges.apply((e1, e2) ->
                enc.add(bmgr.implication(
                        alwaysOrder.test(e1, e2) ? bmgr.makeTrue() : edge.encode(e1, e2),
                        imgr.lessThan(
                                context.clockVariable(clockVarName, e1),
                                context.clockVariable(clockVarName, e2)
                        )
                ))
            );

            return enc;
        }

        private List<BooleanFormula> acyclicSAT(Relation rel, EventGraph relevantEdges) {
            // We use a vertex-elimination graph-based encoding.
            final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
            final ExecutionAnalysis exec = context.getAnalysisContext().requires(ExecutionAnalysis.class);

            // Build original graph G
            Map<Event, Set<Event>> inEdges = new HashMap<>();
            Map<Event, Set<Event>> outEdges = new HashMap<>();
            Set<Event> nodes = new HashSet<>();
            Set<Event> selfloops = new HashSet<>();         // Special treatment for self-loops
            relevantEdges.apply((e1, e2) -> {
                if (Tuple.isLoop(e1, e2)) {
                    selfloops.add(e1);
                } else {
                    nodes.add(e1);
                    nodes.add(e2);
                    outEdges.computeIfAbsent(e1, key -> new HashSet<>()).add(e2);
                    inEdges.computeIfAbsent(e2, key -> new HashSet<>()).add(e1);
                }
            });

            // Handle corner-cases where some node has no ingoing or outgoing edges
            for (Event node : nodes) {
                outEdges.putIfAbsent(node, new HashSet<>());
                inEdges.putIfAbsent(node, new HashSet<>());
            }

            // Build vertex elimination graph G*, by iteratively modifying G
            Map<Event, Set<Event>> vertEleInEdges = new HashMap<>();
            Map<Event, Set<Event>> vertEleOutEdges = new HashMap<>();
            for (Event e : nodes) {
                vertEleInEdges.put(e, new HashSet<>(inEdges.get(e)));
                vertEleOutEdges.put(e, new HashSet<>(outEdges.get(e)));
            }
            List<Event[]> triangles = new ArrayList<>();

            // Build variable elimination ordering
            List<Event> varOrderings = new ArrayList<>(); // We should order this
            while (!nodes.isEmpty()) {
                // Find best vertex e to eliminate
                final Comparator<Event> comparator = Comparator.comparingInt(ev -> vertEleInEdges.get(ev).size() * vertEleOutEdges.get(ev).size());
                final Event e = nodes.stream().min(comparator).get();
                varOrderings.add(e);

                // Eliminate e
                nodes.remove(e);
                final Set<Event> in = inEdges.remove(e);
                final Set<Event> out = outEdges.remove(e);
                in.forEach(x -> outEdges.get(x).remove(e));
                out.forEach(x -> inEdges.get(x).remove(e));
                // Create new edges due to elimination of e
                for (Event e1 : in) {
                    for (Event e2 : out) {
                        if (e2 == e1 || exec.areMutuallyExclusive(e1, e2)) {
                            continue;
                        }
                        // Update next graph in the elimination sequence
                        inEdges.get(e2).add(e1);
                        outEdges.get(e1).add(e2);
                        // Update vertex elimination graph
                        vertEleOutEdges.get(e1).add(e2);
                        vertEleInEdges.get(e2).add(e1);
                        // Store constructed triangle
                        triangles.add(new Event[]{e1, e, e2});
                    }
                }
            }

            // --- Create encoding ---
            final EventGraph minSet = ra.getKnowledge(rel).getMustSet();
            List<BooleanFormula> enc = new ArrayList<>();
            final EncodingContext.EdgeEncoder edge = context.edge(rel);
            // Basic lifting
            relevantEdges.apply((e1, e2) -> {
                BooleanFormula cond = minSet.contains(e1, e2) ? context.execution(e1, e2) : edge.encode(e1, e2);
                enc.add(bmgr.implication(cond, getSMTCycleVar(rel, e1, e2)));
            });

            // Encode triangle rules
            for (Event[] tri : triangles) {
                BooleanFormula cond = minSet.contains(tri[0], tri[2]) ?
                        context.execution(tri[0], tri[2])
                        : bmgr.and(getSMTCycleVar(rel, tri[0], tri[1]), getSMTCycleVar(rel, tri[1], tri[2]));
                enc.add(bmgr.implication(cond, getSMTCycleVar(rel, tri[0], tri[2])));
            }

            //  --- Encode inconsistent assignments ---
            // Handle self-loops
            for (Event e : selfloops) {
                enc.add(bmgr.not(edge.encode(e, e)));
            }
            // Handle remaining cycles
            for (int i = 0; i < varOrderings.size(); i++) {
                Event e1 = varOrderings.get(i);
                Set<Event> out = vertEleOutEdges.get(e1);
                for (Event e2: out) {
                    if (varOrderings.indexOf(e2) > i && vertEleInEdges.get(e2).contains(e1)) {
                        BooleanFormula cond = minSet.contains(e1, e2) ? bmgr.makeTrue() : getSMTCycleVar(rel, e1, e2);
                        enc.add(bmgr.implication(cond, bmgr.not(getSMTCycleVar(rel, e2, e1))));
                    }
                }
            }

            return enc;
        }

        private BooleanFormula cycleVar(Relation rel, Event event) {
            FormulaManagerExt m = context.getFormulaManager();
            return m.getBooleanFormulaManager()
                    .makeVariable(String.format("cycle %s %d", m.escape(rel.getNameOrTerm()), event.getGlobalId()));
        }

        private BooleanFormula getSMTCycleVar(Relation rel, Event e1, Event e2) {
            FormulaManagerExt m = context.getFormulaManager();
            return m.getBooleanFormulaManager()
                    .makeVariable(String.format("cycle %s %d %d", m.escape(rel.getNameOrTerm()), e1.getGlobalId(), e2.getGlobalId()));
        }
    }

}
