package porthosc.memorymodels.wmm;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.languages.syntax.xgraph.events.memory.XMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.memorymodels.Encodings;


public class Alpha {

    public static BoolExpr encode(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        ImmutableSet<XMemoryEvent> eventsL = program.getMemoryEvents();

        BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
        enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("poloc", "com", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("com-alpha", "(co+fr)", "rfe", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satTransFixPoint("idd", eventsL, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("data", "idd^+", "RW", eventsL, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("poloc", "WR", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("data", "(poloc&WR)", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satTransFixPoint("(data+(poloc&WR))", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("(data+(poloc&WR))^+", "RM", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("ctrl", "RW", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("(ctrl&RW)", "ctrlisync", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("dp-alpha", "((ctrl&RW)+ctrlisync)", "((data+(poloc&WR))^+&RM)", events,
                                                ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("dp-alpha", "rf", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("WW", "RM", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("(WW+RM)", "loc", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("po", "((WW+RM)&loc)", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("po-alpha", "(po&((WW+RM)&loc))", "mfence", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-alpha", "po-alpha", "com-alpha", events, ctx));
        return enc;
    }

    public static BoolExpr Consistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        return ctx.mkAnd(Encodings.satAcyclic("(poloc+com)", events, ctx),
                         Encodings.satAcyclic("(dp-alpha+rf)", events, ctx),
                         Encodings.satAcyclic("ghb-alpha", events, ctx));
    }

    public static BoolExpr Inconsistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("(poloc+com)", events, ctx),
                                 Encodings.satCycleDef("(dp-alpha+rf)", events, ctx),
                                 Encodings.satCycleDef("ghb-alpha", events, ctx));
        enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("(poloc+com)", events, ctx),
                                      Encodings.satCycle("(dp-alpha+rf)", events, ctx),
                                      Encodings.satCycle("ghb-alpha", events, ctx)));
        return enc;
    }

}