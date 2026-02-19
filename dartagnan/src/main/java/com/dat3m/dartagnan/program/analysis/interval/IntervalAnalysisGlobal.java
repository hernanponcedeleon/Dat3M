package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.verification.Context;

import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

import com.google.common.base.Preconditions;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public class IntervalAnalysisGlobal extends IntervalAnalysisWorklist {

    private final RelationAnalysis relationAnalysis;
    private final Wmm memoryModel;

    private IntervalAnalysisGlobal(Program program, Context analysisContext, Wmm memoryModel) {
        super();
        this.relationAnalysis = analysisContext.requires(RelationAnalysis.class);
        this.memoryModel = memoryModel;
        computeIntervals(program);
    }

    public static IntervalAnalysis fromConfig(Program program, Context analysisContext, Wmm memoryModel) {
        return new IntervalAnalysisGlobal(program, analysisContext, memoryModel);
    }

    @Override
    protected RegWriterVisitor runVisitor(Event event, Map<Register, Interval> eventState) {
        return new RegWriterVisitorGlobal(event, eventState);
    }

    class RegWriterVisitorGlobal extends RegWriterVisitor {
        RegWriterVisitorGlobal(Event e, Map<Register, Interval> eventState) {
            super(e, eventState);
        }

        @Override
        public RegisterState visitLoad(Load l) {
            Set<Store> stores = getPotentialStores(l);
            Interval interval = calculatePossibleInterval(stores, l.getResultRegister());

            return new RegisterState(l.getResultRegister(), interval);
        }
    }

    // Calculate the interval of a memory address.
    // Takes into account all stores from a load can read from.
    // Join the intervals of all possible stores.
    private Interval calculatePossibleInterval(Set<Store> stores, Register r) {
        Preconditions.checkArgument(r.getType() instanceof IntegerType);
        IntegerType registerType = (IntegerType) r.getType();

        if (stores.isEmpty()) {
            return Interval.getTop(registerType);
        }

        Interval interval = null;
        for (Store s : stores) {
            Map<Register, Interval> eventState = eventStates.getOrDefault(s, new HashMap<>());
            Expression value = s.getMemValue();
            Interval resultInterval = new AbstractExpressionEvaluator(registerType, value, eventState).getResultInterval();
            interval = interval == null ? resultInterval : interval.join(resultInterval);
        }
        return interval;
    }

    // Use the Relation Analysis to calculate the possible store from which a load can read from.
    private Set<Store> getPotentialStores(Load event) {
        return relationAnalysis
                .getKnowledge(memoryModel.getRelation(RF))
                .getMaySet()
                .getInMap()
                .getOrDefault(event, Collections.emptySet())
                .stream()
                .map(e -> (Store) e)
                .collect(Collectors.toSet());
    }
}

