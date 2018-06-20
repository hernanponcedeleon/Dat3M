package porthosc.memorymodels.wmm;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.memorymodels.Encodings;


public class PSO {

    public static BoolExpr encode(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();

        BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
        enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("poloc", "com", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("com-pso", "(co+fr)", "rfe", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("po", "RM", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("po-pso", "(po&RM)", "mfence", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-pso", "po-pso", "com-pso", events, ctx));
        return enc;
    }

    public static BoolExpr Consistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        return ctx.mkAnd(Encodings.satAcyclic("(poloc+com)", events, ctx),
                         Encodings.satAcyclic("ghb-pso", events, ctx));
    }

    public static BoolExpr Inconsistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("(poloc+com)", events, ctx),
                                 Encodings.satCycleDef("ghb-pso", events, ctx));
        enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("(poloc+com)", events, ctx),
                                      Encodings.satCycle("ghb-pso", events, ctx)));
        return enc;
    }
}