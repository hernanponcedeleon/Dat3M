package porthosc.memorymodels.wmm;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.memorymodels.Encodings;


public class SC {

    public static BoolExpr encode(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
        enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("ghb-sc", "po", "com", events, ctx));
        return enc;
    }

    public static BoolExpr Consistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        return Encodings.satAcyclic("ghb-sc", events, ctx);
    }

    public static BoolExpr Inconsistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        return ctx.mkAnd(Encodings.satCycleDef("ghb-sc", events, ctx), Encodings.satCycle("ghb-sc", events, ctx));
    }
}