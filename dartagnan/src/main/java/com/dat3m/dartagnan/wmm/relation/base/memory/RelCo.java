package com.dat3m.dartagnan.wmm.relation.base.memory;

import com.dat3m.dartagnan.program.analysis.ExecutionAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.MemEvent;
import com.dat3m.dartagnan.program.filter.FilterBasic;
import com.dat3m.dartagnan.program.filter.FilterMinus;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import static com.dat3m.dartagnan.program.event.Tag.INIT;
import static com.dat3m.dartagnan.program.event.Tag.WRITE;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;

public class RelCo extends Relation {

	private static final Logger logger = LogManager.getLogger(RelCo.class);

    public RelCo(){
        term = CO;
    }

    @Override
    public <T> T accept(Visitor<? extends T> v) {
        return v.visitMemoryOrder(this);
    }

    @Override
    public TupleSet getMinTupleSet(){
        if(minTupleSet == null){
            final WmmAnalysis wmmAnalysis = analysisContext.get(WmmAnalysis.class);
            minTupleSet = new TupleSet();
            if (wmmAnalysis.isLocallyConsistent()) {
                applyLocalConsistencyMinSet();
            }
        }
        return minTupleSet;
    }

    private void applyLocalConsistencyMinSet() {
        final AliasAnalysis alias = analysisContext.get(AliasAnalysis.class);
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
        	final AliasAnalysis alias = analysisContext.requires(AliasAnalysis.class);
            final ExecutionAnalysis exec = analysisContext.requires(ExecutionAnalysis.class);
            final WmmAnalysis wmmAnalysis = analysisContext.requires(WmmAnalysis.class);
            final List<Event> allWrites = task.getProgram().getCache().getEvents(FilterBasic.get(WRITE));
            final List<Event> nonInitWrites = task.getProgram().getCache().getEvents(FilterMinus.get(
                    FilterBasic.get(WRITE),
                    FilterBasic.get(INIT)
            ));

            maxTupleSet = new TupleSet();
            for (Event w1 : allWrites) {
                for (Event w2 : nonInitWrites) {
                    if(w1.getCId() != w2.getCId() && !exec.areMutuallyExclusive(w1, w2)
                            && alias.mayAlias((MemEvent) w1, (MemEvent)w2)) {
                        maxTupleSet.add(new Tuple(w1, w2));
                    }
                }
            }

            if (wmmAnalysis.isLocallyConsistent()) {
                maxTupleSet.removeIf(Tuple::isBackward);
            }

            logger.info("maxTupleSet size for " + getName() + ": " + maxTupleSet.size());
        }
        return maxTupleSet;
    }
}