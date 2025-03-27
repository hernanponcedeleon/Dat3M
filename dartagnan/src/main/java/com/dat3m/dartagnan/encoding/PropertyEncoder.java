package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.metadata.MemoryOrder;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;

import java.util.*;
import java.util.function.BiFunction;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LLVM;
import static com.dat3m.dartagnan.program.Program.SpecificationType.ASSERT;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.encoding.EncodingContext.ConversionMode.LEFT_TO_RIGHT;

public class PropertyEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(PropertyEncoder.class);
    private static final TypeFactory types = TypeFactory.getInstance();

    private final EncodingContext context;
    private final Program program;
    private final Wmm memoryModel;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    private final RelationAnalysis ra;

    // We may want to make this configurable or just keep the option fixed.
    private final boolean doWeakTracking = true;

    /*
        We use trackable formulas to find out why a disjunctive formula was satisfied:
            - Consider Enc = (P or Q or R), where P, Q, and R are arbitrary formulas.
            - In case of satisfaction of Enc, we want to track which of the 3 cases was true.
            - We associate to each formula a tracking variable, V(P), V(Q), and V(R)
            - We then encode "(V(P) or V(Q) or V(R)) and (V(P) <=> P) and (V(Q) <=> Q) and (V(R) <=> R).
                - With "weak tracking", we encode an implication "V(P) => P" instead.
            - In case of satisfaction, the variables will tell us which of the 3 formulas was true.

       Since we encode a lot of potential violations, and we want to trace back which one lead to
       our query being SAT, we use trackable formulas.
     */
    public static class TrackableFormula {
        private final BooleanFormula trackingLiteral;
        private final BooleanFormula trackedFormula;

        public TrackableFormula(BooleanFormula trackingLit, BooleanFormula formula) {
            this.trackingLiteral = trackingLit;
            this.trackedFormula = formula;
        }
    }

    // =====================================================================

    private PropertyEncoder(EncodingContext c) {
        Preconditions.checkArgument(c.getTask().getProgram().isCompiled(),
                "The program must get compiled first before its properties can be encoded.");
        context = c;
        program = c.getTask().getProgram();
        memoryModel = c.getTask().getMemoryModel();
        exec = c.getAnalysisContext().requires(ExecutionAnalysis.class);
        alias = c.getAnalysisContext().requires(AliasAnalysis.class);
        ra = c.getAnalysisContext().requires(RelationAnalysis.class);
    }

    public static PropertyEncoder withContext(EncodingContext context) throws InvalidConfigurationException {
        return new PropertyEncoder(context);
    }

    public BooleanFormula encodeBoundEventExec() {
        logger.info("Encoding bound events execution");
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        return program.getThreadEvents()
                .stream().filter(e -> e.hasTag(Tag.BOUND)).map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);
    }

    public BooleanFormula encodeProperties(EnumSet<Property> properties) {
        Property.Type specType = Property.getCombinedType(properties, context.getTask());
        if (specType == Property.Type.MIXED) {
            final String warn = String.format(
                    "The set of properties %s are of mixed type (safety and reachability properties). " +
                    "Cannot encode mixed properties into a single SMT-query. " +
                    "You can select a different set of properties with option --property. " +
                    "Defaulting to " + Property.PROGRAM_SPEC.asStringOption() + ".",
                    properties);
            logger.warn(warn);
            properties = EnumSet.of(Property.PROGRAM_SPEC);
        }

        BooleanFormula encoding = (specType == Property.Type.SAFETY) ?
                encodePropertyViolations(properties) : encodePropertyWitnesses(properties);
        if (!program.getFormat().equals(LLVM) || properties.contains(TERMINATION)) {
            // Both litmus assertions and termination need to identify
            // the final stores to addresses.
            // TODO Optimization: This encoding can be restricted to only those addresses
            //  that are relevant for the specification (e.g., only variables that are used in loops).
            encoding = context.getBooleanFormulaManager().and(encoding, encodeLastCoConstraints());
        }
        return encoding;
    }

    private BooleanFormula encodePropertyViolations(EnumSet<Property> properties) {
        final List<TrackableFormula> trackableViolationEncodings = new ArrayList<>();
        if (properties.contains(TERMINATION)) {
            trackableViolationEncodings.add(encodeNontermination());
        }
        if (properties.contains(DATARACEFREEDOM)) {
            trackableViolationEncodings.add(encodeDataRaces());
        }
        if (properties.contains(CAT_SPEC)) {
            trackableViolationEncodings.addAll(encodeCATSpecificationViolations());
        }
        if (properties.contains(PROGRAM_SPEC)) {
            trackableViolationEncodings.add(encodeProgramSpecification());
        }

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        // Weak tracking: "TrackingVar => TrackingEnc", strong tracking: "TrackingVar <=> TrackingEnc"
        final BiFunction<BooleanFormula, BooleanFormula, BooleanFormula> trackingConnector =
                doWeakTracking ? bmgr::implication : bmgr::equivalence;
        final BooleanFormula trackedViolationEnc = bmgr.and(Lists.transform(trackableViolationEncodings,
                vio -> trackingConnector.apply(vio.trackingLiteral, vio.trackedFormula)));
        final BooleanFormula atLeastOneViolation = bmgr.or(Lists.transform(trackableViolationEncodings,
                vio -> vio.trackingLiteral));

        return bmgr.and(atLeastOneViolation, trackedViolationEnc);

    }

    private BooleanFormula encodePropertyWitnesses(EnumSet<Property> properties) {
        // NOTE: For now, the only witness-able properties are existential queries formulated in
        // Litmus (program spec). We cannot check this together with safety specs, so we make sure
        // that we do not mix them up.
        Preconditions.checkArgument(properties.contains(PROGRAM_SPEC));
        Preconditions.checkArgument(program.hasReachabilitySpecification());

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final TrackableFormula progSpec = encodeProgramSpecification();
        // NOTE: We have a single property to check, so the tracking becomes trivial.
        return bmgr.and(progSpec.trackingLiteral, progSpec.trackedFormula);
    }

    private BooleanFormula encodeLastCoConstraints() {
        final Relation co = memoryModel.getRelation(CO);
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext.EdgeEncoder coEncoder = context.edge(co);
        final RelationAnalysis.Knowledge knowledge = ra.getKnowledge(co);
        final List<Init> initEvents = program.getThreadEvents(Init.class);
        final boolean doEncodeFinalAddressValues = program.getFormat() != LLVM;
        // Find transitively implied coherences. We can use these to reduce the encoding.
        final EventGraph transCo = ra.findTransitivelyImpliedCo(co);
        // Find all writes that are never last, i.e., those that will always have a co-successor.
        Set<Event> dominatedWrites = new HashSet<>();
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
                for (Init init : initEvents) {
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }
                    BooleanFormula sameAddress = context.sameAddress(init, w1);
                    int size = types.getMemorySizeInBits(init.getValue().getType());
                    Formula v2 = context.lastValue(init.getBase(), init.getOffset(), size);
                    BooleanFormula sameValue = context.equal(context.value(w1), v2, LEFT_TO_RIGHT);
                    enc.add(bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        if (doEncodeFinalAddressValues && !Arch.coIsTotal(program.getArch())) {
            // Coherence is not guaranteed to be total in all models (e.g., PTX),
            // but the final value of a location should always match that of some coLast event.
            // lastCo(w) => (lastVal(w.address) = w.val)
            //           \/ (exists w2 : lastCo(w2) /\ lastVal(w.address) = w2.val))
            for (Init init : program.getThreadEvents(Init.class)) {
                BooleanFormula lastValueEnc = bmgr.makeFalse();
                BooleanFormula lastStoreExistsEnc = bmgr.makeFalse();
                int size = types.getMemorySizeInBits(init.getValue().getType());
                Formula v2 = context.lastValue(init.getBase(), init.getOffset(), size);
                BooleanFormula readFromInit = context.equal(context.value(init), v2);
                for (Store w : program.getThreadEvents(Store.class)) {
                    if (!alias.mayAlias(w, init)) {
                        continue;
                    }
                    BooleanFormula isLast = context.lastCoVar(w);
                    BooleanFormula sameAddr = context.sameAddress(init, w);
                    BooleanFormula sameValue = context.equal(context.value(w), v2);
                    lastValueEnc = bmgr.or(lastValueEnc, bmgr.and(isLast, sameAddr, sameValue));
                    lastStoreExistsEnc = bmgr.or(lastStoreExistsEnc, bmgr.and(isLast, sameAddr));
                }
                enc.add(bmgr.ifThenElse(lastStoreExistsEnc, lastValueEnc, readFromInit));
            }
        }
        return bmgr.and(enc);
    }

    // ======================================================================
    // ======================================================================
    // ======================= Program specification ========================
    // ======================================================================
    // ======================================================================

    private TrackableFormula encodeProgramSpecification() {
        logger.info("Encoding program specification");
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        // We can only perform existential queries to the SMT-engine, so for
        // safety specs we need to query for a violation (= negation of the spec)
        BooleanFormula encoding = switch (program.getSpecificationType()) {
            case EXISTS, NOT_EXISTS -> context.encodeFinalExpressionAsBoolean(program.getSpecification());
            case FORALL -> bmgr.not(context.encodeFinalExpressionAsBoolean(program.getSpecification()));
            case ASSERT -> {
                // User-placed assertions inside C code.
                List<BooleanFormula> assertionsHold = new ArrayList<>();
                for (Assert assertion : program.getThreadEvents(Assert.class)) {
                    assertionsHold.add(bmgr.implication(context.execution(assertion),
                            context.encodeExpressionAsBooleanAt(assertion.getExpression(), assertion)));
                }
                yield bmgr.not(bmgr.and(assertionsHold));
            }
        };
        BooleanFormula trackingLiteral = switch (program.getSpecificationType()) {
            case FORALL, NOT_EXISTS, ASSERT -> bmgr.not(PROGRAM_SPEC.getSMTVariable(context));
            case EXISTS -> PROGRAM_SPEC.getSMTVariable(context);
        };
        if (!ASSERT.equals(program.getSpecificationType())) {
            encoding = bmgr.and(encoding, encodeProgramTermination());
        }
        return new TrackableFormula(trackingLiteral, encoding);
    }

    private BooleanFormula encodeProgramTermination() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final BooleanFormula exitReached = bmgr.and(program.getThreads().stream()
                .map(t -> bmgr.equivalence(context.execution(t.getEntry()), context.execution(t.getExit())))
                .toList());
        final BooleanFormula terminated = program.getThreadEventsWithAllTags(Tag.NONTERMINATION).stream()
                .map(CondJump.class::cast)
                .map(jump -> bmgr.not(context.jumpTaken(jump)))
                .reduce(bmgr.makeTrue(), bmgr::and);
        return bmgr.and(exitReached, terminated);
    }

    // ======================================================================
    // ======================================================================
    // ======================== CAT Specification  ==========================
    // ======================================================================
    // ======================================================================

    /*
        CAT Properties are defined within the .cat model itself using flagged axioms.
        CAUTION: A flagged axiom is considered a specification violation if it is satisfied!
    */
    public List<TrackableFormula> encodeCATSpecificationViolations() {
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext ctx = this.context;
        final Wmm memoryModel = this.memoryModel;
        final List<Axiom> flaggedAxioms = memoryModel.getAxioms().stream()
                .filter(Axiom::isFlagged).toList();

        if (flaggedAxioms.isEmpty()) {
            logger.info("No CAT specification in the WMM. Skipping encoding.");
            return List.of();
        } else {
            logger.info("Encoding CAT specification");
        }

        final List<TrackableFormula> specViolations = flaggedAxioms.stream()
                .map(ax -> new TrackableFormula(bmgr.not(CAT_SPEC.getSMTVariable(ax, ctx)), bmgr.and(ax.consistent(ctx))))
                .collect(Collectors.toList());
        return specViolations;
    }

    // ======================================================================
    // ======================================================================
    // ============================ Data races ==============================
    // ======================================================================
    // ======================================================================

    /*
        This data race encoding is only valid for models with a defined "hb"-relation
        Typically, this is only the case for SC/SVCOMP.
        More general notions of data races (for e.g. weak models) can be defined as a flagged axiom
        inside the .cat, just like C11 and LKMM do.
    */
    public TrackableFormula encodeDataRaces() {
        logger.info("Encoding data races");

        final Wmm memoryModel = this.memoryModel;
        Preconditions.checkState(memoryModel.containsRelation("hb"),
                "The provided WMM needs a happens-before relation 'hb' to encode data races.");
        final Relation hbRelation = memoryModel.getRelation("hb");
        Preconditions.checkState(memoryModel.getAxioms().stream().anyMatch(ax ->
                        ax.isAcyclicity() && ax.getRelation().equals(hbRelation)),
                "The provided WMM needs an 'acyclic(hb)' axiom to encode data races.");

        final EncodingContext ctx = this.context;
        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        final IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
        final EncodingContext.EdgeEncoder hbEncoder = ctx.edge(hbRelation);
        final Program program = this.program;
        final AliasAnalysis alias = this.alias;

        final Predicate<MemoryEvent> canRace = (m -> {
            final MemoryOrder mo = m.getMetadata(MemoryOrder.class);
            return mo == null || mo.value().equals(Tag.C11.NONATOMIC);
        });

        BooleanFormula hasRace = bmgr.makeFalse();
        for(Thread t1 : program.getThreads()) {
            for(Thread t2 : program.getThreads()) {
                if(t1 == t2) {
                    continue;
                }
                for (Event e1 : t1.getEvents()) {
                    if (!e1.hasTag(Tag.WRITE) || e1.hasTag(Tag.INIT)) {
                        continue;
                    }
                    MemoryCoreEvent w = (MemoryCoreEvent)e1;
                    if (!canRace.test(w)) {
                        continue;
                    }
                    for(Event e2 : t2.getEvents()) {
                        if (!e2.hasTag(Tag.MEMORY) || e2.hasTag(Tag.INIT)) {
                            continue;
                        }
                        MemoryCoreEvent m = (MemoryCoreEvent)e2;
                        if((w.hasTag(Tag.RMW) && m.hasTag(Tag.RMW)) || !canRace.test(m) || !alias.mayAlias(m, w)) {
                            continue;
                        }

                        final BooleanFormula isConflictingPair = bmgr.and(ctx.execution(m, w), ctx.sameAddress(m, w));
                        final BooleanFormula isAdjacentInHb = bmgr.and(
                                hbEncoder.encode(m, w), // In Hb
                                imgr.equal( // Adjacent (We assume "w-hb->m" cause in a race the store can be assumed to be first)
                                        ctx.clockVariable("hb", w),
                                        imgr.add(ctx.clockVariable("hb", m), imgr.makeNumber(1))
                                )
                        );
                        final BooleanFormula isRacingPair = bmgr.and(isConflictingPair, isAdjacentInHb);
                        hasRace = bmgr.or(hasRace, isRacingPair);
                    }
                }
            }
        }
        return new TrackableFormula(bmgr.not(DATARACEFREEDOM.getSMTVariable(ctx)), hasRace);
    }

    // ======================================================================
    // ======================================================================
    // ============================= Liveness ===============================
    // ======================================================================
    // ======================================================================

    private TrackableFormula encodeNontermination() {
        final BooleanFormula hasNontermination = new NonTerminationEncoder(context.getTask(), context).encodeNontermination();
        return new TrackableFormula(context.getBooleanFormulaManager().not(TERMINATION.getSMTVariable(context)), hasNontermination);
    }

}