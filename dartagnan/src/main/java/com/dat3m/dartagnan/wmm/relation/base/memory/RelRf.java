package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.FilterAbstract;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterIntersection;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.*;

import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.utils.Utils.generalEqual;
import static com.dat3m.dartagnan.program.event.Tag.*;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;
import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

public class RelRf extends Relation {

	private static final Logger logger = LogManager.getLogger(RelRf.class);

    public RelRf(){
        term = RF;
        forceDoEncode = true;
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
            AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
            WmmAnalysis wmmAnalysis = analysisContext.get(WmmAnalysis.class);
        	logger.info("Computing maxTupleSet for " + getName());
            maxTupleSet = new TupleSet();

            List<Event> loadEvents = task.getProgram().getCache().getEvents(FilterBasic.get(READ));
            List<Event> storeEvents = task.getProgram().getCache().getEvents(FilterBasic.get(WRITE));

            for(Event e1 : storeEvents){
                for(Event e2 : loadEvents){
                    if(alias.mayAlias((MemEvent) e1, (MemEvent) e2)){
                    	maxTupleSet.add(new Tuple(e1, e2));
                    }
                }
            }
            removeMutuallyExclusiveTuples(maxTupleSet);
            if (wmmAnalysis.isLocallyConsistent()) {
                applyLocalConsistency();
            }
            if (wmmAnalysis.doesRespectAtomicBlocks()) {
                atomicBlockOptimization();
            }

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }

    private void applyLocalConsistency() {
        // Remove future reads
        maxTupleSet.removeIf(Tuple::isBackward);

        // Remove past reads
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        Set<Tuple> deletedTuples = new HashSet<>();
        for (Event r : task.getProgram().getCache().getEvents(FilterBasic.get(READ))) {
            MemEvent read = (MemEvent)r;

            // The set of same-thread writes as well as init writes that could be read from (all before the read)
            // sorted by order (init events first)
            List<MemEvent> possibleWrites = maxTupleSet.getBySecond(read).stream().map(Tuple::getFirst)
                    .filter(e -> (e.getThread() == read.getThread() || e.is(INIT)))
                    .map(x -> (MemEvent)x)
                    .sorted((o1, o2) -> o1.is(INIT) == o2.is(INIT) ? (o1.getCId() - o2.getCId()) : o1.is(INIT) ? -1 : 1)
                    .collect(Collectors.toList());

            // The set of writes that won't be readable due getting overwritten.
            Set<MemEvent> deletedWrites = new HashSet<>();

            // A rf-edge (w1, r) is impossible, if there exists a write w2 such that
            // - w2 is exec-implied by w1 or r (i.e. cf-implied + w2.cfImpliesExec)
            // - w2 must alias with either w1 or r.
            for (int i = 0; i < possibleWrites.size(); i++) {
                MemEvent w1 = possibleWrites.get(i);
                for (MemEvent w2 : possibleWrites.subList(i + 1, possibleWrites.size())) {
                    // w2 dominates w1 if it aliases with it and it is guaranteed to execute if either w1 or the read are
                    // executed
                    if ((exec.isImplied(w1, w2) || exec.isImplied(read, w2))
                            && (alias.mustAlias(w1, w2) || alias.mustAlias(w2, read))) {
                        deletedWrites.add(w1);
                        break;
                    }
                }
            }

            for (Event w : deletedWrites) {
                deletedTuples.add(new Tuple(w, read));
            }
        }
        maxTupleSet.removeAll(deletedTuples);
    }

    private void atomicBlockOptimization() {
        //TODO: This function can not only reduce rf-edges
        // but we could also figure out implied coherences:
        // Assume w1 and w2 are aliasing in the same block and w1 is before w2,
        // then if w1 is co-before some external w3, then so is w2, i.e.
        // co(w1, w3) => co(w2, w3), but we also have co(w2, w3) => co(w1, w3)
        // so co(w1, w3) <=> co(w2, w3).
        // This information is not expressible in terms of min/must sets, but
        // we could still encode it.
        int sizeBefore = maxTupleSet.size();

        // Atomics blocks: BeginAtomic -> EndAtomic
        ExecutionAnalysis exec = analysisContext.get(ExecutionAnalysis.class);
        AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
        FilterAbstract filter = FilterIntersection.get(FilterBasic.get(RMW), FilterBasic.get(SVCOMP.SVCOMPATOMIC));
        for(Event end : task.getProgram().getCache().getEvents(filter)) {
            // Collect memEvents of the atomic block
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


            for (Load r : reads) {
                // If there is any write w inside the atomic block that is guaranteed to
                // execute before the read and that aliases with it,
                // then the read won't be able to read any external writes
                boolean hasImpliedWrites = writes.stream()
                        .anyMatch(w -> w.getCId() < r.getCId()
                                && exec.isImplied(r, w) && alias.mustAlias(r, w));
                if (hasImpliedWrites) {
                    maxTupleSet.removeIf(t -> t.getSecond() == r && t.isCrossThread());
                }
            }

        }
        logger.info("Atomic block optimization eliminated "  + (sizeBefore - maxTupleSet.size()) + " reads");
    }

    @Override
    protected BooleanFormula encodeApprox(SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();

    	BooleanFormula enc = bmgr.makeTrue();
        Map<MemEvent, List<BooleanFormula>> edgeMap = new HashMap<>();

        for(Tuple tuple : maxTupleSet){
            MemEvent w = (MemEvent) tuple.getFirst();
            MemEvent r = (MemEvent) tuple.getSecond();
            BooleanFormula edge = this.getSMTVar(tuple, ctx);

            // The boogie file might have a different type (Ints vs BVs) that the imposed by ARCH_PRECISION
            // In such cases we perform the transformation 
            Formula a1 = w.getMemAddressExpr();
            Formula a2 = r.getMemAddressExpr();
            BooleanFormula sameAddress = generalEqual(a1, a2, ctx);
            Formula v1 = w.getMemValueExpr();
            Formula v2 = r.getMemValueExpr();
            BooleanFormula sameValue = generalEqual(v1, v2, ctx);

            edgeMap.computeIfAbsent(r, key -> new ArrayList<>()).add(edge);
            enc = bmgr.and(enc, bmgr.implication(edge, bmgr.and(getExecPair(w, r, ctx), sameAddress, sameValue)));
        }

        for(MemEvent r : edgeMap.keySet()){
            enc = bmgr.and(enc, encodeEdgeSeq(r, edgeMap.get(r), ctx));
        }
        return enc;
    }

    private BooleanFormula encodeEdgeSeq(Event read, List<BooleanFormula> edges, SolverContext ctx){
    	BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        if (GlobalSettings.ALLOW_MULTIREADS) {
            return bmgr.implication(read.exec(), bmgr.or(edges));
        }
    	
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

        atLeastOne = bmgr.implication(read.exec(), atLeastOne);
        return bmgr.and(atMostOne, atLeastOne);
    }

    private BooleanFormula mkSeqVar(int readId, int i, SolverContext ctx) {
    	return ctx.getFormulaManager().makeVariable(BooleanType, "s(" + term + ",E" + readId + "," + i + ")");
    }

}