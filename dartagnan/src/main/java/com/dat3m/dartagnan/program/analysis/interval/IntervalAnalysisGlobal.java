package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.type.IntegerType;

import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;

import java.util.*;
import java.util.stream.Collectors;

public class IntervalAnalysisGlobal extends IntervalAnalysisWorklist {

    private final RelationAnalysis relationAnalysis;
    private final VerificationTask task;

    
    private IntervalAnalysisGlobal(Program program, Context analysisContext, VerificationTask task) {
        super(program);
        this.relationAnalysis = analysisContext.requires(RelationAnalysis.class);
        this.task = task;
        computeIntervals(program);
    }

    
    public static IntervalAnalysis fromConfig(Program program, Context analysisContext, VerificationTask task) {
        return new IntervalAnalysisGlobal(program,analysisContext,task);
    }

    // Calculate the interval of a memory address.
    // Takes into account all stores from a load can read from.
    // Join the intervals of all possible stores
    private Interval calculatePossibleInterval(Set<Store> stores, Register r) {
        if (!stores.isEmpty()) {
            Interval interval = null;
            for (Store s : stores) {
                Map<Register, Interval> eventState = eventStates.getOrDefault(s, new HashMap<>());
                Expression value = s.getMemValue();
                Interval resultInterval = new AbstractExpressionEvaluator((IntegerType) r.getType(), value, eventState).getResultInterval();
                interval = interval == null ? resultInterval : interval.join(resultInterval);
            }
            return interval;
        } else { return Interval.getTop((IntegerType)r.getType()); }
    }


    // Use the Relation Analysis to calculate the possible store from which a load can read from.
    private Set<Store> getPotentialStores(Load event) {
        Set<Event> potentialStoreEvents =
        relationAnalysis
        .getKnowledge(
            task
            .getMemoryModel()
            .getRelation(RF)
        )
        .getMaySet()
        .getInMap()
        .get(event);

        if (potentialStoreEvents != null) {
            return potentialStoreEvents
            .stream()
            .map(e -> (Store) e)
            .collect(Collectors.toSet());
        } else return Collections.emptySet();
    }


    @Override
    protected RegisterState analyseLoad(Load l, Map<Register, Interval> eventState) {
        Set<Store> stores = getPotentialStores(l);
        Interval interval = calculatePossibleInterval(stores, l.getResultRegister());
        return new RegisterState(l.getResultRegister(), interval);
    }







}
