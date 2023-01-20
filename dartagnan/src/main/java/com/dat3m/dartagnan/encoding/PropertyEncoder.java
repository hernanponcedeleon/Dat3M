package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.relation.RelationNameRepository;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.configuration.Property.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
public class PropertyEncoder implements Encoder {

    private static final Logger logger = LogManager.getLogger(PropertyEncoder.class);

    private final EncodingContext context;
    private final Program program;
    private final Wmm memoryModel;
    private final ExecutionAnalysis exec;
    private final AliasAnalysis alias;
    private final RelationAnalysis ra;

    // =====================================================================

    private PropertyEncoder(EncodingContext c) {
        checkArgument(c.getTask().getProgram().isCompiled(),
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

    public BooleanFormula encodeSpecification() {
        EnumSet<Property> property = context.getTask().getProperty();
    	BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
    	// We have a default property therefore this false will always be overwritten
    	BooleanFormula enc = bmgr.makeFalse();
    	if(property.contains(REACHABILITY)) {
    		enc = bmgr.or(enc, encodeAssertions());
    	}
    	if(property.contains(LIVENESS)) {
    		enc = bmgr.or(enc, encodeLiveness());
    	}
    	if(property.contains(RACES)) {
    		enc = bmgr.or(enc, encodeDataRaces());
    	}
    	if(property.contains(CAT)) {
    		enc = bmgr.or(enc, encodeCATProperties());
    	}
        if (program.getFormat().equals(LITMUS) || property.contains(LIVENESS)) {
            enc = bmgr.and(enc, encodeLastCoConstraints());
        }
    	return enc;
    }

    public BooleanFormula encodeBoundEventExec() {
        logger.info("Encoding bound events execution");
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> enc = new ArrayList<>();
        for (Event e : program.getEvents()) {
            if (e.is(Tag.BOUND) && !e.is(Tag.SPINLOOP)) {
                enc.add(context.execution(e));
            }
        }
        return bmgr.or(enc);
    }

    public BooleanFormula encodeAssertions() {
        logger.info("Encoding assertions");
        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        BooleanFormula assertionEncoding = program.getAss().encode(context);
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(REACHABILITY.getSMTVariable(fmgr), assertionEncoding);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(assertionEncoding) ? assertionEncoding : bmgr.and(REACHABILITY.getSMTVariable(fmgr), enc);
    }

    public BooleanFormula encodeCATProperties() {
        logger.info("Encoding CAT properties");
        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        List<BooleanFormula> cat = new ArrayList<>();
        List<BooleanFormula> one = new ArrayList<>();
    	for(Axiom ax : memoryModel.getAxioms()) {
    		// Only flagged axioms are encoded as properties
    		if(!ax.isFlagged()) {
    			continue;
    		}
            BooleanFormula v = CAT.getSMTVariable(ax, fmgr);
			cat.add(bmgr.equivalence(v, bmgr.and(ax.consistent(context))));
			one.add(v);
    	}
		// No need to use the SMT variable if the formula is trivially false
        return one.isEmpty() ? bmgr.makeFalse() : bmgr.and(bmgr.or(one), bmgr.and(cat));
    }

    public BooleanFormula encodeLiveness() {

        // We assume a spinloop to consist of a tagged label and bound jump.
        // Further, we assume that the spinloops are indeed correct, i.e., side-effect free
        class SpinLoop {
            public List<Load> loads = new ArrayList<>();
            public Event bound;
        }

        logger.info("Encoding liveness");

        Map<Thread, List<SpinLoop>> spinloopsMap = new HashMap<>();
        // Find spinloops of all threads
        for (Thread t : program.getThreads()) {
            List<Event> spinStarts = t.getEvents().stream().filter(e -> e instanceof Label && e.is(Tag.SPINLOOP)).collect(Collectors.toList());
            List<SpinLoop> spinLoops = new ArrayList<>();
            spinloopsMap.put(t, spinLoops);

            Event cur = t.getEntry();
            List<Load> loads = new ArrayList<>();
            while(cur != null) {
            	if(spinStarts.contains(cur)) {
            		// A new loop started: we reset the load list
            		loads = new ArrayList<>();
            	}
                if(cur.is(Tag.READ)) {
                	// Update
                    loads.add((Load)cur);
                }
                if(cur.is(Tag.SPINLOOP) && !spinStarts.contains(cur)) {
                	// We found one possible end of the loop
                	// There might be others thus we keep the load list
                    SpinLoop loop = new SpinLoop();
                    loop.bound = cur;
                    loop.loads.addAll(loads);
                	spinLoops.add(loop);
                }
            	cur = cur.getSuccessor();
            }
        }

        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        Relation rf = memoryModel.getRelation(RelationNameRepository.RF);
        final EncodingContext.EdgeEncoder edge = context.edge(rf);
        final Function<Event, Collection<Tuple>> mayIn = ra.getKnowledge(rf).getMayIn();
        // Compute "stuckness": A thread is stuck if it reaches a spinloop bound event
        // while reading from a co-maximal write.
        Map<Thread, BooleanFormula> isStuckMap = new HashMap<>();
        for (Thread t : program.getThreads()) {
            List<SpinLoop> loops = spinloopsMap.get(t);
            if (loops.isEmpty()) {
                continue;
            }

            List<BooleanFormula> isStuck = new ArrayList<>();
            for (SpinLoop pair : loops) {
                List<BooleanFormula> allCoMaximalLoad = new ArrayList<>();
                for (Load load : pair.loads) {
                    List<BooleanFormula> coMaximalLoad = new ArrayList<>();
                    for (Tuple rfEdge : mayIn.apply(load)) {
                        coMaximalLoad.add(bmgr.and(edge.encode(rfEdge), lastCoVar(rfEdge.getFirst())));
                    }
                    allCoMaximalLoad.add(bmgr.implication(context.execution(load), bmgr.or(coMaximalLoad)));
                }
                isStuck.add(bmgr.and(context.execution(pair.bound), bmgr.and(allCoMaximalLoad)));
            }
            isStuckMap.put(t, bmgr.or(isStuck));
        }

        // LivenessViolation <=> allStuckOrDone /\ atLeastOneStuck
        List<BooleanFormula> allStuckOrDone = new ArrayList<>();
        List<BooleanFormula> atLeastOneStuck = new ArrayList<>();
        for (Thread t : program.getThreads()) {
            BooleanFormula isStuck = isStuckMap.getOrDefault(t, bmgr.makeFalse());
            BooleanFormula pending = t.getEvents().stream()
                    .filter(e -> e.is(Tag.EARLYTERMINATION))
                    .map(context::execution).reduce(bmgr.makeFalse(), bmgr::or);
            atLeastOneStuck.add(isStuck);
            allStuckOrDone.add(bmgr.or(isStuck, bmgr.not(pending)));
        }
        allStuckOrDone.add(bmgr.or(atLeastOneStuck));
        BooleanFormula livenessViolation = bmgr.and(allStuckOrDone);
        // We use the SMT variable to extract from the model if the property was violated
		BooleanFormula enc = bmgr.equivalence(LIVENESS.getSMTVariable(fmgr), livenessViolation);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(enc) ? enc : bmgr.and(LIVENESS.getSMTVariable(fmgr), enc);
    }

    public BooleanFormula encodeDataRaces() {
        final Relation hbRelation = memoryModel.getRelation("hb");
        final EncodingContext.EdgeEncoder hb = context.edge(hbRelation);
        checkState(memoryModel.getAxioms().stream().anyMatch(ax ->
                        ax.isAcyclicity() && ax.getRelation().equals(hbRelation)),
                "The provided WMM needs an 'acyclic(hb)' axiom to encode data races.");
        logger.info("Encoding data-races");
        FormulaManager fmgr = context.getFormulaManager();
        BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();

        BooleanFormula enc = bmgr.makeFalse();
        for(Thread t1 : program.getThreads()) {
            for(Thread t2 : program.getThreads()) {
                if(t1.getId() == t2.getId()) {
                    continue;
                }
                for(Event e1 : t1.getEvents()) {
                    if (!(e1 instanceof MemEvent) || !e1.is(Tag.WRITE) || e1.is(Tag.INIT)) {
                        continue;
                    }
                    MemEvent w = (MemEvent)e1;
                    for(Event e2 : t2.getEvents()) {
                        if (!(e2 instanceof MemEvent) || e2.is(Tag.INIT)) {
                            continue;
                        }
                        MemEvent m = (MemEvent)e2;
                        if(w.hasFilter(Tag.RMW) && m.hasFilter(Tag.RMW)) {
                            continue;
                        }
                        if(w.canRace() && m.canRace() && alias.mayAlias(w, m)) {
                            BooleanFormula conflict = bmgr.and(context.execution(m, w), hb.encode(m, w),
                                    context.sameAddress(w, m),
                                    imgr.equal(context.clockVariable("hb", w),
                                            imgr.add(context.clockVariable("hb", m), imgr.makeNumber(BigInteger.ONE))));
                            enc = bmgr.or(enc, conflict);
                        }
                    }
                }
            }
        }
        // We use the SMT variable to extract from the model if the property was violated
		enc = bmgr.equivalence(RACES.getSMTVariable(fmgr), enc);
		// No need to use the SMT variable if the formula is trivially false 
        return bmgr.isFalse(enc) ? enc : bmgr.and(RACES.getSMTVariable(fmgr), enc);
    }

    private BooleanFormula encodeLastCoConstraints() {
        final Relation co = memoryModel.getRelation(CO);
        final FormulaManager fmgr = context.getFormulaManager();
        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final EncodingContext.EdgeEncoder edge = context.edge(co);
        final RelationAnalysis.Knowledge knowledge = ra.getKnowledge(co);
        final List<Init> initEvents = program.getEvents(Init.class);
        final boolean doEncodeFinalAddressValues = program.getFormat() == LITMUS;
        // Find transitively implied coherences. We can use these to reduce the encoding.
        final Set<Tuple> transCo = ra.findTransitivelyImpliedCo(co);
        // Find all writes that are never last, i.e., those that will always have a co-successor.
        final Set<Event> dominatedWrites = knowledge.getMustSet().stream()
                .filter(t -> exec.isImplied(t.getFirst(), t.getSecond()))
                .map(Tuple::getFirst).collect(Collectors.toSet());
        // ---- Construct encoding ----
        List<BooleanFormula> enc = new ArrayList<>();
        final Function<Event, Collection<Tuple>> out = knowledge.getMayOut();
        for (Event writeEvent : program.getEvents()) {
            if (!writeEvent.is(Tag.WRITE)) {
                continue;
            }
            MemEvent w1 = (MemEvent) writeEvent;
            if (dominatedWrites.contains(w1)) {
                enc.add(bmgr.not(lastCoVar(w1)));
                continue;
            }
            BooleanFormula isLast = context.execution(w1);
            // ---- Find all possibly overwriting writes ----
            for (Tuple t : out.apply(w1)) {
                if (transCo.contains(t)) {
                    // We can skip the co-edge (w1,w2), because there will be an intermediate write w3
                    // that already witnesses that w1 is not last.
                    continue;
                }
                Event w2 = t.getSecond();
                BooleanFormula isAfter = bmgr.not(knowledge.containsMust(t) ? context.execution(w2) : edge.encode(t));
                isLast = bmgr.and(isLast, isAfter);
            }
            BooleanFormula lastCoExpr = lastCoVar(w1);
            enc.add(bmgr.equivalence(lastCoExpr, isLast));
            if (doEncodeFinalAddressValues) {
                // ---- Encode final values of addresses ----
                for (Init init : initEvents) {
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }
                    BooleanFormula sameAddress = context.sameAddress(init, w1);
                    Formula v2 = init.getBase().getLastMemValueExpr(fmgr, init.getOffset());
                    BooleanFormula sameValue = context.equal(context.value(w1), v2);
                    enc.add(bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        return bmgr.and(enc);
    }

    private BooleanFormula lastCoVar(Event write) {
        return context.getBooleanFormulaManager().makeVariable("co_last(" + write.getGlobalId() + ")");
    }
}
