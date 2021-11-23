package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.program.event.Store;
import com.dat3m.dartagnan.program.svcomp.event.EndAtomic;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterIntersection;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import com.dat3m.dartagnan.wmm.utils.alias.AliasAnalysis;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.utils.EType.*;
import static com.dat3m.dartagnan.program.utils.Utils.convertToIntegerFormula;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

@Options(prefix="wmm.rf")
public class RelRf extends Relation {

	@Option(
		description="Do not require that each read event is satisfied by some write.",
		name="allowUninitialized",
		secure = true)
	private boolean canAccessUninitializedMemory = false;

	@Option(
		description="Exclude multiple satisfaction by explicit clauses for each pair instead of using new variables.",
		name="naiveMutex",
		secure=true)
	private boolean naiveMutex = false;

	private static final Logger logger = LogManager.getLogger(RelRf.class);

    public RelRf(){
        term = RF;
        forceDoEncode = true;
    }

	@Override
	public void initialise(VerificationTask task, SolverContext ctx) {
		super.initialise(task,ctx);
		try {
			task.getConfig().inject(this);
		} catch(InvalidConfigurationException e) {
			logger.warn(e.getMessage());
		}
	}

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            minTupleSet = new TupleSet();
        }
        return minTupleSet;
    }

    @Override
    public TupleSet getMaxTupleSet(){
        if(maxTupleSet == null){
        	logger.info("Computing maxTupleSet for " + getName());
            maxTupleSet = new TupleSet();

            List<Event> loadEvents = task.getProgram().getCache().getEvents(FilterBasic.get(READ));
            List<Event> storeEvents = task.getProgram().getCache().getEvents(FilterBasic.get(WRITE));
			AliasAnalysis a = task.getAliasAnalysis();

            for(Event e1 : storeEvents){
                for(Event e2 : loadEvents){
                    if(a.mayAlias((MemEvent) e1, (MemEvent) e2)){
                    	maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
            applyLocalConsistency();
            atomicBlockOptimization();

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
    	
    	BooleanFormula enc = bmgr.makeTrue();
        Map<MemEvent, List<BooleanFormula>> edgeMap = new HashMap<>();
        Map<MemEvent, BooleanFormula> memInitMap = new HashMap<>();

        for(Tuple tuple : maxTupleSet){
            MemEvent w = (MemEvent) tuple.getFirst();
            MemEvent r = (MemEvent) tuple.getSecond();
            BooleanFormula edge = this.getSMTVar(tuple, ctx);

            IntegerFormula a1 = convertToIntegerFormula(w.getMemAddressExpr(), ctx);
            IntegerFormula a2 = convertToIntegerFormula(r.getMemAddressExpr(), ctx);
            BooleanFormula sameAddress = imgr.equal(a1, a2);

            IntegerFormula v1 = convertToIntegerFormula(w.getMemValueExpr(), ctx);
            IntegerFormula v2 = convertToIntegerFormula(r.getMemValueExpr(), ctx);
            BooleanFormula sameValue = imgr.equal(v1, v2);

            edgeMap.computeIfAbsent(r, key -> new ArrayList<>()).add(edge);
            if(canAccessUninitializedMemory && w.is(INIT)){
                memInitMap.put(r, bmgr.or(memInitMap.getOrDefault(r, bmgr.makeFalse()), sameAddress));
            }
            enc = bmgr.and(enc, bmgr.implication(edge, bmgr.and(getExecPair(w, r, ctx), sameAddress, sameValue)));
        }

        for(MemEvent r : edgeMap.keySet()){
            enc = bmgr.and(enc, naiveMutex
                    ? encodeEdgeNaive(r, memInitMap.get(r), edgeMap.get(r), ctx)
                    : encodeEdgeSeq(r, memInitMap.get(r), edgeMap.get(r), ctx));
        }
        return enc;
    }

    private BooleanFormula encodeEdgeNaive(Event read, BooleanFormula isMemInit, List<BooleanFormula> edges, SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	
    	BooleanFormula atMostOne = bmgr.makeTrue();
    	BooleanFormula atLeastOne = bmgr.makeFalse();
        for(int i = 0; i < edges.size(); i++){
            atLeastOne = bmgr.or(atLeastOne, edges.get(i));
            for(int j = i + 1; j < edges.size(); j++){
                atMostOne = bmgr.and(atMostOne, bmgr.not(bmgr.and(edges.get(i), edges.get(j))));
            }
        }

        if(canAccessUninitializedMemory) {
            atLeastOne = bmgr.implication(bmgr.and(read.exec(), isMemInit), atLeastOne);
        } else {
            atLeastOne = bmgr.implication(read.exec(), atLeastOne);
        }
        return bmgr.and(atMostOne, atLeastOne);
    }

    private BooleanFormula encodeEdgeSeq(Event read, BooleanFormula isMemInit, List<BooleanFormula> edges, SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
    	
        int num = edges.size();
        int readId = read.getCId();
        BooleanFormula lastSeqVar = mkSeqVar(readId, 0, ctx);
        BooleanFormula newSeqVar = lastSeqVar;
        BooleanFormula atMostOne = bmgr.equivalence(lastSeqVar, edges.get(0));

        for(int i = 1; i < num; i++){
            newSeqVar = mkSeqVar(readId, i, ctx);
            atMostOne = bmgr.and(atMostOne, bmgr.equivalence(newSeqVar, bmgr.or(lastSeqVar, edges.get(i))));
            atMostOne = bmgr.and(atMostOne, bmgr.not(bmgr.and(edges.get(i), lastSeqVar)));
            lastSeqVar = newSeqVar;
        }
        BooleanFormula atLeastOne = bmgr.or(newSeqVar, edges.get(edges.size() - 1));

        if(canAccessUninitializedMemory) {
            atLeastOne = bmgr.implication(bmgr.and(read.exec(), isMemInit), atLeastOne);
        } else {
            atLeastOne = bmgr.implication(read.exec(), atLeastOne);
        }
        return bmgr.and(atMostOne, atLeastOne);
    }

    private BooleanFormula mkSeqVar(int readId, int i, SolverContext ctx) {
    	return ctx.getFormulaManager().makeVariable(BooleanType, "s(" + term + ",E" + readId + "," + i + ")");
    }

    private void applyLocalConsistency() {
        if (task.getMemoryModel().isLocallyConsistent()) {
            // Remove future reads
            maxTupleSet.removeIf(Tuple::isBackward);

            // Remove past reads
            BranchEquivalence eq = task.getBranchEquivalence();
            AliasAnalysis a = task.getAliasAnalysis();
            Set<Tuple> deletedTuples = new HashSet<>();
            for (Event read: task.getProgram().getCache().getEvents(FilterBasic.get(READ))) {
                // TODO: remove this restriction?
                if (!a.hasMustAlias((MemEvent)read)) {
                    continue;
                }

                List<MemEvent> possibleWrites = maxTupleSet.getBySecond(read).stream().map(Tuple::getFirst)
                        .filter(e -> (e.getThread() == read.getThread() || e.is(INIT)))
                        .map(x -> (MemEvent)x)
                        .sorted((o1, o2) -> o1.is(INIT) == o2.is(INIT) ? (o1.getCId() - o2.getCId()) : o1.is(INIT) ? -1 : 1)
                        .collect(Collectors.toList());
                Set<MemEvent> deletedWrites = new HashSet<>();

                if (a.hasMustAlias((MemEvent)read)){
                    List<Event> impliedWrites = possibleWrites.stream().filter(x -> a.hasMustAlias(x) && eq.isImplied(read, x) && x.cfImpliesExec()).collect(Collectors.toList());
                    if (!impliedWrites.isEmpty()) {
                        Event lastImplied = impliedWrites.get(impliedWrites.size() - 1);
                        if (!lastImplied.is(INIT)) {
                            Predicate<Event> pred = x -> x.is(INIT) || x.getCId() < lastImplied.getCId();
                            possibleWrites.stream().filter(pred).forEach(deletedWrites::add);
                            possibleWrites.removeIf(pred);
                        }
                    }
                }
                //TODO: If a read can read from multiple addresses, we have to make sure that
                // we don't let writes of different addresses override each other
                List<MemEvent> canOverride = possibleWrites.stream()
                        .filter(x -> !x.is(INIT) && x.cfImpliesExec() && a.hasMustAlias(x))
                        .collect(Collectors.toList());
                possibleWrites.stream().filter(x ->
                        (x.is(INIT) && canOverride.stream().anyMatch(y -> eq.isImplied(x ,y)))
                                || (!x.is(INIT) && canOverride.stream().anyMatch(y ->  x.getCId() < y.getCId() && eq.isImplied(x ,y))))
                        .forEach(deletedWrites::add);
                for (Event w : deletedWrites) {
                    deletedTuples.add(new Tuple(w, read));
                }
            }
            maxTupleSet.removeAll(deletedTuples);
        }
    }

    private void atomicBlockOptimization() {
        if (!task.getMemoryModel().doesRespectAtomicBlocks()) {
            return;
        }

        int sizeBefore = maxTupleSet.size();

        // Atomics blocks: BeginAtomic -> EndAtomic
        BranchEquivalence eq = task.getBranchEquivalence();
        AliasAnalysis a = task.getAliasAnalysis();
        FilterAbstract filter = FilterIntersection.get(FilterBasic.get(RMW), FilterBasic.get(SVCOMPATOMIC));
        for(Event end : task.getProgram().getCache().getEvents(filter)){
            List<Store> writes = new ArrayList<>();
            List<Load> reads = new ArrayList<>();
            EndAtomic endAtomic = (EndAtomic) end;
            for(Event b : endAtomic.getBlock()) {
                if (b instanceof Load) {
                    reads.add((Load)b);
                } else if (b instanceof Store) {
                    writes.add((Store)b);
                }
            }

            for (Load read : reads) {
                if (!a.hasMustAlias(read)) {
                    continue;
                }

                List<Store> ownWrites = writes.stream()
                        .filter(x -> x.getCId() < read.getCId() && a.mustAlias(x,read))
                        .collect(Collectors.toList());
                boolean hasImpliedWrites = ownWrites.stream().anyMatch(x -> eq.isImplied(read, x) && x.cfImpliesExec());
                if (hasImpliedWrites) {
                    maxTupleSet.removeIf(t -> t.getSecond() == read && t.isCrossThread());
                }
            }


        }
        logger.info("Atomic block optimization eliminated "  + (sizeBefore - maxTupleSet.size()) + " reads");
    }

}
