package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
import com.google.common.base.Predicate;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.OptionNames.CO_ANTISYMMETRY;
import static com.dat3m.dartagnan.configuration.Property.LIVENESS;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.utils.Utils.edge;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

@Options
public class RelCo extends Relation {

	private static final Logger logger = LogManager.getLogger(RelCo.class);

    // =========================== Configurables ===========================

	@Option(
		name=CO_ANTISYMMETRY,
		description="Encodes the antisymmetry of coherences explicitly.",
		secure=true)
	private boolean antisymmetry = false;

	// =====================================================================

    public RelCo(){
        term = CO;
        forceDoEncode = true;
    }

    @Override
    public void initializeEncoding(SolverContext ctx) {
        super.initializeEncoding(ctx);
        try {
            task.getConfig().inject(this);
            logger.info("{}: {}", CO_ANTISYMMETRY, antisymmetry);
        } catch(InvalidConfigurationException e) {
            logger.warn(e.getMessage());
        }
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
            WmmAnalysis wmmAnalysis = analysisContext.get(WmmAnalysis.class);
            if (wmmAnalysis.isLocallyConsistent()) {
                applyLocalConsistencyMinSet();
            }
        }
        return minTupleSet;
    }

    private void applyLocalConsistencyMinSet() {
        AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        for (Tuple t : getMaxTupleSet()) {
            MemEvent w1 = (MemEvent) t.getFirst();
            MemEvent w2 = (MemEvent) t.getSecond();
            if (!w2.is(INIT) && alias.mustAlias(w1, w2) && (w1.is(INIT) || t.isForward())) {
                minTupleSet.add(t);
            }
        }
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	logger.info("Computing maxTupleSet for " + getName());
        	AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
            WmmAnalysis wmmAnalysis = analysisContext.get(WmmAnalysis.class);
            maxTupleSet = new TupleSet();
            List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(INIT));
            List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(WRITE),
                    FilterBasic.get(INIT)
            ));

            for(Event e1 : eventsInit){
                for(Event e2 : eventsStore){
                    if(alias.mayAlias((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            for(Event e1 : eventsStore){
                for(Event e2 : eventsStore){
                    if(e1.getCId() != e2.getCId() && alias.mayAlias((MemEvent) e1, (MemEvent)e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

            removeMutuallyExclusiveTuples(maxTupleSet);
            if (wmmAnalysis.isLocallyConsistent()) {
                maxTupleSet.removeIf(Tuple::isBackward);
            }

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
        
    	BooleanFormula enc = bmgr.makeTrue();

        List<Event> eventsInit = task.getProgram().getCache().getEvents(FilterBasic.get(INIT));
        List<Event> eventsStore = task.getProgram().getCache().getEvents(FilterMinus.get(
                FilterBasic.get(WRITE),
                FilterBasic.get(INIT)
        ));

		for(Event e : eventsInit) {
            enc = bmgr.and(enc, imgr.equal(getClockVar(e, ctx), imgr.makeNumber(BigInteger.ZERO)));
        }
        for(Event w : eventsStore) {
            enc = bmgr.and(enc, imgr.greaterThan(getClockVar(w, ctx), imgr.makeNumber(BigInteger.ZERO)));
        }

        // We find classes of events such that events in different classes
        // may never alias.
        // It suffices to generate distinctness constraints per class.
        DependencyGraph<Event> aliasGraph = DependencyGraph.from(eventsStore, e ->
                Stream.concat(
                        maxTupleSet.getByFirst(e).stream().map(Tuple::getSecond),
                        maxTupleSet.getBySecond(e).stream().map(Tuple::getFirst)
                )::iterator
        );
        for (Set<DependencyGraph<Event>.Node> aliasClass : aliasGraph.getSCCs()) {
            List<IntegerFormula> clockVars = aliasClass.stream().map(DependencyGraph.Node::getContent)
                    .filter(e -> !e.is(INIT)).map(e -> getClockVar(e, ctx)).collect(Collectors.toList());
            enc = bmgr.and(enc, imgr.distinct(clockVars));
        }

        final Set<Tuple> transCo = findTransitivelyImpliedCo();
        final TupleSet maxSet = getMaxTupleSet();
        final TupleSet minSet = getMinTupleSet();
        for(Event w :  task.getProgram().getCache().getEvents(FilterBasic.get(WRITE))) {
            MemEvent w1 = (MemEvent)w;
            BooleanFormula lastCo = w1.exec();

            for(Tuple t : maxSet.getByFirst(w1)){
                MemEvent w2 = (MemEvent)t.getSecond();
                BooleanFormula relation = getSMTVar(t, ctx);
                BooleanFormula execPair = getExecPair(t, ctx);
                lastCo = bmgr.and(lastCo, bmgr.not(relation));

                Formula a1 = w1.getMemAddressExpr();
                Formula a2 = w2.getMemAddressExpr();
                BooleanFormula sameAddress = generalEqual(a1, a2, ctx);
                BooleanFormula clockConstr = (w1.is(INIT) || transCo.contains(t)) ? bmgr.makeTrue()
                        : imgr.lessThan(getClockVar(w1, ctx), getClockVar(w2, ctx));

                if (minSet.contains(t)) {
                    enc = bmgr.and(enc, clockConstr, bmgr.equivalence(relation, execPair));
                } else if (!maxSet.contains(t.getInverse())) {
                    enc = bmgr.and(enc,
                            bmgr.equivalence(relation, bmgr.and(execPair, sameAddress)),
                            bmgr.implication(sameAddress, clockConstr));
                } else {
                    enc = bmgr.and(enc, bmgr.equivalence(relation, bmgr.and(execPair, sameAddress, clockConstr)));
                }
            }

            if (task.getProgram().getFormat().equals(LITMUS) || task.getProperty().contains(LIVENESS)) {
                BooleanFormula lastCoExpr = getLastCoVar(w1, ctx);
                enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, lastCo));

                for (Event i : eventsInit) {
                    Init init = (Init) i;
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }

                    IExpr address = init.getAddress();
                    Formula a1 = w1.getMemAddressExpr();
                    Formula a2 = address.toIntFormula(init,ctx);
                    BooleanFormula sameAddress = generalEqual(a1, a2, ctx); 
                    Formula v1 = w1.getMemValueExpr();
                    Formula v2 = init.getBase().getLastMemValueExpr(ctx,init.getOffset());
                    BooleanFormula sameValue = generalEqual(v1, v2, ctx);
                    enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        return enc;
    }

    /*
        Returns a set of co-edges (w1, w2) (subset of maxTupleSet) whose clock-constraints
        do not need to get encoded explicitly.
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
    private Set<Tuple> findTransitivelyImpliedCo() {
        ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
        Set<Tuple> transCo = new HashSet<>();

        final TupleSet min = getMinTupleSet();
        final TupleSet max = getMaxTupleSet();
        for (final Tuple t : max) {
            final MemEvent e1 = (MemEvent) t.getFirst();
            final MemEvent e2 = (MemEvent) t.getSecond();
            final Predicate<Event> execPred = (e3 -> e3 != e1 && e3 != e2 && (exec.isImplied(e1, e3) || exec.isImplied(e2, e3)));
            final boolean hasIntermediary = min.getByFirst(e1).stream().map(tuple -> (MemEvent)tuple.getSecond())
                                    .anyMatch(e3 -> execPred.apply(e3) && !max.contains(new Tuple(e2, e3))) ||
                                min.getBySecond(e2).stream().map(tuple -> (MemEvent)tuple.getFirst())
                                    .anyMatch(e3 -> execPred.apply(e3) && !max.contains(new Tuple(e3, e1)));
            if (hasIntermediary) {
                transCo.add(t);
            }
        }
        return transCo;
    }

    @Override
    public BooleanFormula getSMTVar(Tuple edge, SolverContext ctx) {
        if(!antisymmetry) {
            return super.getSMTVar(edge, ctx);
        }

    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

        MemEvent first = (MemEvent) edge.getFirst();
        MemEvent second = (MemEvent) edge.getSecond();
        // Doing the check at the java level seems to slightly improve  performance
        BooleanFormula eqAdd = first.getAddress().equals(second.getAddress()) ? bmgr.makeTrue() :
                generalEqual(first.getMemAddressExpr(), second.getMemAddressExpr(), ctx);
        return !getMaxTupleSet().contains(edge) ? bmgr.makeFalse() :
    		first.getCId() <= second.getCId() ?
    				edge(getName(), first, second, ctx) :
    					bmgr.ifThenElse(bmgr.and(getExecPair(edge, ctx), eqAdd),
    							bmgr.not(getSMTVar(edge.getInverse(), ctx)),
    							bmgr.makeFalse());
    }

    public IntegerFormula getClockVar(Event write, SolverContext ctx) {
    	Preconditions.checkArgument(write.is(WRITE), "Cannot get a clock-var for non-writes.");
        return intVar(term, write, ctx);
    }

    public BooleanFormula getLastCoVar(Event write, SolverContext ctx) {
        return ctx.getFormulaManager().makeVariable(BooleanType, "co_last(" + write.repr() + ")");
    }
}