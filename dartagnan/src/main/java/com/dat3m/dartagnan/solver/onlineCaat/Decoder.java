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

    public record Info(List<Event> events, List<EdgeInfo> edges) {

        public Info() {
            this(new ArrayList<>(), new ArrayList<>());
        }

        public void add(Relation rel, Event x, Event y) {
            edges.add(new EdgeInfo(rel, x, y));
        }
    }

    private final Map<BooleanFormula, Info> formula2Info = new HashMap<>(1000, 0.5f);

    public Decoder(EncodingContext ctx) {
        extractExecutionInfo(ctx);
        extractRelationInfo(ctx);
    }

    public Info decode(BooleanFormula formula) {
        return Preconditions.checkNotNull(formula2Info.get(formula),
                "No information associated to formula %s", formula);
    }

    public Set<BooleanFormula> getDecodableFormulas() {
        return formula2Info.keySet();
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
                    final Info info = formula2Info.computeIfAbsent(edgeLiteral, key -> new Info());
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

        lit2EventMap.forEach((lit, events) -> formula2Info.put(lit, new Info(events, new ArrayList<>())));
    }

}
