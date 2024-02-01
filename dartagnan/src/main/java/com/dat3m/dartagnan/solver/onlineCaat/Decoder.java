package com.dat3m.dartagnan.solver.onlineCaat;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.EventGraph;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;

public class Decoder {

    private final Map<BooleanFormula, EncodingInfo> formula2Info = new HashMap<>();

    public Decoder(EncodingContext ctx) {
        extractExecutionInfo(ctx);
        extractRelationInfo(ctx);
    }

    public EncodingInfo decode(BooleanFormula formula) {
        return Preconditions.checkNotNull(formula2Info.get(formula),
                "No information associated to formula %s", formula);
    }

    private void extractRelationInfo(EncodingContext ctx) {
        final Wmm memoryModel = ctx.getTask().getMemoryModel();
        final RelationAnalysis ra = ctx.getAnalysisContext().requires(RelationAnalysis.class);
        //FIXME: The below does not treat data/addr/ctrl as base relations but rather idd, ctrlDirect, etc.
        // However, we want the base relations as understood by CAT!
        final List<Relation> baseRelations = memoryModel.getRelations().stream()
                .filter(r -> r.getDependencies().isEmpty()).toList();

        for (Relation rel : baseRelations) {
            final EventGraph maySet = ra.getKnowledge(rel).getMaySet();
            final Map<Event, Set<Event>> outMap = maySet.getOutMap();
            for (Event x : outMap.keySet()) {
                for (Event y : outMap.get(x)) {
                    final BooleanFormula edgeLiteral = ctx.edge(rel, x, y);
                    final RelationInfo info = (RelationInfo) formula2Info.getOrDefault(edgeLiteral, new RelationInfo());
                    info.add(rel, x, y);
                }
            }
        }
    }

    private void extractExecutionInfo(EncodingContext ctx) {
        final Program program = ctx.getTask().getProgram();
        final Map<BooleanFormula, List<Event>> lit2EventMap = new HashMap<>();

        for (Event e : program.getThreadEvents()) {
            lit2EventMap.computeIfAbsent(ctx.execution(e), key -> new ArrayList<>()).add(e);
        }

        lit2EventMap.forEach((lit, events) -> formula2Info.put(lit, new ExecInfo(events)));
    }

}
