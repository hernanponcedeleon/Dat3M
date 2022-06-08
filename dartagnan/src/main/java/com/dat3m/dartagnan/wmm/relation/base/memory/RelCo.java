package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.analysis.AliasAnalysis;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
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
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.Property.LIVENESS;
import static com.dat3m.dartagnan.encoding.ProgramEncoder.execution;
import static com.dat3m.dartagnan.expression.utils.Utils.*;
import static com.dat3m.dartagnan.program.Program.SourceLanguage.LITMUS;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.utils.Utils.intVar;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

public class RelCo extends Relation {

	private static final Logger logger = LogManager.getLogger(RelCo.class);

	// =====================================================================

    public RelCo(){
        term = CO;
        forceDoEncode = true;
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
            ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
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
                    if(e1.getCId() != e2.getCId()
                            && alias.mayAlias((MemEvent) e1, (MemEvent)e2)
                            && !exec.areMutuallyExclusive(e1, e2)){
                        maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }

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
    public BooleanFormula encode(Set<Tuple> encodeTupleSet, WmmEncoder encoder) {
        SolverContext ctx = encoder.solverContext();
        AliasAnalysis alias = encoder.analysisContext().get(AliasAnalysis.class);
        WmmAnalysis wmmAnalysis = encoder.analysisContext().get(WmmAnalysis.class);
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
        IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
        
    	BooleanFormula enc = bmgr.makeTrue();

        List<Event> eventsInit = encoder.task().getProgram().getCache().getEvents(FilterBasic.get(INIT));
        List<Event> eventsStore = encoder.task().getProgram().getCache().getEvents(FilterMinus.get(
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

        ExecutionAnalysis exec = encoder.analysisContext().requires(ExecutionAnalysis.class);
        for(Event w :  encoder.task().getProgram().getCache().getEvents(FilterBasic.get(WRITE))) {
            MemEvent w1 = (MemEvent)w;
            BooleanFormula lastCo = w1.exec();

            for(Tuple t : maxTupleSet.getByFirst(w1)){
                MemEvent w2 = (MemEvent)t.getSecond();
                BooleanFormula relation = encoder.edge(this, t);
                BooleanFormula execPair = execution(t.getFirst(), t.getSecond(), exec, ctx);
                lastCo = bmgr.and(lastCo, bmgr.not(relation));

                Formula a1 = w1.getMemAddressExpr();
                Formula a2 = w2.getMemAddressExpr();
                BooleanFormula sameAddress = generalEqual(a1, a2, ctx);

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

            if (encoder.task().getProgram().getFormat().equals(LITMUS) || encoder.task().getProperty().contains(LIVENESS)) {
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

    public IntegerFormula getIntVar(Event write, SolverContext ctx) {
    	Preconditions.checkArgument(write.is(WRITE), "Cannot get an int-var for non-writes.");
        return intVar(term, write, ctx);
    }

    public BooleanFormula getLastCoVar(Event write, SolverContext ctx) {
        return ctx.getFormulaManager().makeVariable(BooleanType, "co_last(" + write.repr() + ")");
    }
}