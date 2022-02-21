package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.CO_ANTISYMMETRY;
import static com.dat3m.dartagnan.configuration.OptionNames.ENCODE_FINAL_MEMVALUES;
import static com.dat3m.dartagnan.expression.utils.Utils.convertToIntegerFormula;
import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
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

    @Option(
            name=ENCODE_FINAL_MEMVALUES,
            description="Encode final memory values per address.",
            secure=true)
    private boolean encodeLastCo = true; //TODO: Automatically set this option only for litmus tests

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
            logger.info("{}: {}", ENCODE_FINAL_MEMVALUES, encodeLastCo);
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
        for (Tuple t : getMaxTupleSet()) {
            AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
            MemEvent w1 = (MemEvent) t.getFirst();
            MemEvent w2 = (MemEvent) t.getSecond();
            if (!w1.is(INIT) && alias.mustAlias(w1, w2) && (w1.is(INIT) || t.isForward())) {
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
                applyLocalConsistencyMaxSet();
            }

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    private void applyLocalConsistencyMaxSet() {
        //TODO: Make sure that this is correct and does not cause any issues with totality of co
        maxTupleSet.removeIf(t -> t.getSecond().is(INIT) || t.isBackward());
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
        AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        WmmAnalysis wmmAnalysis = analysisContext.get(WmmAnalysis.class);
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
            enc = bmgr.and(enc, imgr.equal(getIntVar(e, ctx), imgr.makeNumber(BigInteger.ZERO)));
        }

        List<IntegerFormula> intVars = new ArrayList<>();
        for(Event w : eventsStore) {
        	IntegerFormula coVar = getIntVar(w, ctx);
            enc = bmgr.and(enc, imgr.greaterThan(coVar, imgr.makeNumber(BigInteger.ZERO)));
            intVars.add(coVar);
        }

        BooleanFormula distinct = intVars.size() > 1 ?
        		imgr.distinct(intVars) :
                bmgr.makeTrue();

        enc = bmgr.and(enc, distinct);

        for(Event w :  task.getProgram().getCache().getEvents(FilterBasic.get(WRITE))) {
            MemEvent w1 = (MemEvent)w;
            BooleanFormula lastCo = w1.exec();

            for(Tuple t : maxTupleSet.getByFirst(w1)){
                MemEvent w2 = (MemEvent)t.getSecond();
                BooleanFormula relation = getSMTVar(t, ctx);
                BooleanFormula execPair = getExecPair(t, ctx);
                lastCo = bmgr.and(lastCo, bmgr.not(relation));

                IntegerFormula a1 = convertToIntegerFormula(w1.getMemAddressExpr(), ctx);
                IntegerFormula a2 = convertToIntegerFormula(w2.getMemAddressExpr(), ctx);
                BooleanFormula sameAddress = imgr.equal(a1, a2);
                enc = bmgr.and(enc, bmgr.equivalence(relation,
                        bmgr.and(execPair, sameAddress, imgr.lessThan(getIntVar(w1, ctx), getIntVar(w2, ctx))
                )));

                // ============ Local consistency optimizations ============
                if (getMinTupleSet().contains(t)) {
                   enc = bmgr.and(enc, bmgr.equivalence(relation, execPair));
                } else if (wmmAnalysis.isLocallyConsistent()) {
                    if (w2.is(INIT) || t.isBackward()){
                        enc = bmgr.and(enc, bmgr.equivalence(relation, bmgr.makeFalse()));
                    }
                    if (w1.is(INIT) || t.isForward()) {
                        enc = bmgr.and(enc, bmgr.implication(bmgr.and(execPair, sameAddress), relation));
                    }
                }
            }

            if (encodeLastCo) {
                // TODO: This encoding should be extracted as it is orthogonal to how co itself gets encoded.
                BooleanFormula lastCoExpr = fmgr.makeVariable(BooleanType, "co_last(" + w1.repr() + ")");
                enc = bmgr.and(enc, bmgr.equivalence(lastCoExpr, lastCo));

                for (Event i : eventsInit) {
                    Init init = (Init) i;
                    if (!alias.mayAlias(w1, init)) {
                        continue;
                    }

                    IExpr address = init.getAddress();
                    IntegerFormula a1 = convertToIntegerFormula(w1.getMemAddressExpr(), ctx);
                    IntegerFormula a2 = convertToIntegerFormula(address.toIntFormula(init,ctx), ctx);
                    IntegerFormula v1 = convertToIntegerFormula(w1.getMemValueExpr(), ctx);
                    IntegerFormula v2 = convertToIntegerFormula(init.getBase().getLastMemValueExpr(ctx,init.getOffset()), ctx);
                    BooleanFormula sameAddress = imgr.equal(a1, a2);
                    BooleanFormula sameValue = imgr.equal(v1, v2);
                    enc = bmgr.and(enc, bmgr.implication(bmgr.and(lastCoExpr, sameAddress), sameValue));
                }
            }
        }
        return enc;
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

    public IntegerFormula getIntVar(Event write, SolverContext ctx) {
    	Preconditions.checkArgument(write.is(WRITE), "Cannot get an int-var for non-writes.");
        return intVar(term, write, ctx);
    }
}