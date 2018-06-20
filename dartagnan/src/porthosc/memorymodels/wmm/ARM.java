package porthosc.memorymodels.wmm;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.memory.XMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.memorymodels.Encodings;
import porthosc.utils.Utils;

import java.util.Set;


public class ARM {

    public static BoolExpr encode(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        ImmutableSet<XMemoryEvent> eventsL = program.getMemoryEvents();

        BoolExpr enc = Encodings.satUnion("co", "fr", events, ctx);
        enc = ctx.mkAnd(enc, Encodings.satUnion("com", "(co+fr)", "rf", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("poloc", "com", events, ctx));

        enc = ctx.mkAnd(enc, Encodings.satTransFixPoint("idd", eventsL, ctx));

        enc = ctx.mkAnd(enc, Encodings.satIntersection("data", "idd^+", "RW", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satEmpty("addr", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("dp", "addr", "data", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("fre", "rfe", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("coe", "rfe", events, ctx));

        enc = ctx.mkAnd(enc, Encodings.satIntersection("rdw", "poloc", "(fre;rfe)", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("detour", "poloc", "(coe;rfe)", events, ctx));
        // Base case for program order
        enc = ctx.mkAnd(enc, Encodings.satUnion("dp", "rdw", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("ii0", "(dp+rdw)", "rfi", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satEmpty("ic0", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("ci0", "ctrlisb", "detour", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("dp", "ctrl", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("addr", "po", events, ctx));
        enc = ctx.mkAnd(enc, satARMPPO(events, ctx));

        enc = ctx.mkAnd(enc, Encodings.satUnion("cc0", "(dp+ctrl)", "(addr;po)", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("RR", "ii", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("RW", "ic", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("po-arm", "(RR&ii)", "(RW&ic)", events, ctx));
        // Happens before
        enc = ctx.mkAnd(enc, Encodings.satUnion("po-arm", "rfe", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("hb-arm", "(po-arm+rfe)", "ish", events, ctx));
        // Prop-base
        enc = ctx.mkAnd(enc, Encodings.satComp("rfe", "ish", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("ish", "(rfe;ish)", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satTransRef("hb-arm", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("prop-base", "(ish+(rfe;ish))", "(hb-arm)*", events, ctx));
        // Propagation for ARM
        enc = ctx.mkAnd(enc, Encodings.satTransRef("com", events, ctx));

        enc = ctx.mkAnd(enc, Encodings.satTransRef("prop-base", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("(com)*", "(prop-base)*", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("((com)*;(prop-base)*)", "ish", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("(((com)*;(prop-base)*);ish)", "(hb-arm)*", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satIntersection("WW", "prop-base", events, ctx));
        enc = ctx.mkAnd(enc,
                        Encodings.satUnion("prop", "(WW&prop-base)", "((((com)*;(prop-base)*);ish);(hb-arm)*)", events,
                                           ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("fre", "prop", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satComp("(fre;prop)", "(hb-arm)*", events, ctx));
        enc = ctx.mkAnd(enc, Encodings.satUnion("co", "prop", events, ctx));
        return enc;
    }

    public static BoolExpr Consistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        return ctx.mkAnd(Encodings.satAcyclic("hb-arm", events, ctx),
                         Encodings.satIrref("((fre;prop);(hb-arm)*)", events, ctx),
                         Encodings.satAcyclic("(co+prop)", events, ctx),
                         Encodings.satAcyclic("(poloc+com)", events, ctx));
    }

    public static BoolExpr Inconsistent(XProgram program, Context ctx) {
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        BoolExpr enc = ctx.mkAnd(Encodings.satCycleDef("hb-arm", events, ctx),
                                 Encodings.satCycleDef("(co+prop)", events, ctx),
                                 Encodings.satCycleDef("(poloc+com)", events, ctx));
        enc = ctx.mkAnd(enc, ctx.mkOr(Encodings.satCycle("hb-arm", events, ctx),
                                      ctx.mkNot(Encodings.satIrref("((fre;prop);(hb-arm)*)", events, ctx)),
                                      Encodings.satCycle("(co+prop)", events, ctx),
                                      Encodings.satCycle("(poloc+com)", events, ctx)));
        return enc;
    }

    private static BoolExpr satARMPPO(Set<? extends XEvent> events, Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                BoolExpr orClause1 = ctx.mkFalse();
                BoolExpr orClause2 = ctx.mkFalse();
                BoolExpr orClause3 = ctx.mkFalse();
                BoolExpr orClause4 = ctx.mkFalse();
                BoolExpr orClause5 = ctx.mkFalse();
                BoolExpr orClause6 = ctx.mkFalse();
                BoolExpr orClause7 = ctx.mkFalse();
                BoolExpr orClause8 = ctx.mkFalse();
                for (XEvent e3 : events) {
                    orClause1 = ctx.mkOr(orClause1,
                                         ctx.mkAnd(Utils.edge("ic", e1, e3, ctx), Utils.edge("ci", e3, e2, ctx)));
                    orClause2 = ctx.mkOr(orClause2,
                                         ctx.mkAnd(Utils.edge("ii", e1, e3, ctx), Utils.edge("ii", e3, e2, ctx)));
                    orClause3 = ctx.mkOr(orClause3,
                                         ctx.mkAnd(Utils.edge("ic", e1, e3, ctx), Utils.edge("cc", e3, e2, ctx)));
                    orClause4 = ctx.mkOr(orClause4,
                                         ctx.mkAnd(Utils.edge("ii", e1, e3, ctx), Utils.edge("ic", e3, e2, ctx)));
                    orClause5 = ctx.mkOr(orClause5,
                                         ctx.mkAnd(Utils.edge("ci", e1, e3, ctx), Utils.edge("ii", e3, e2, ctx)));
                    orClause6 = ctx.mkOr(orClause6,
                                         ctx.mkAnd(Utils.edge("cc", e1, e3, ctx), Utils.edge("ci", e3, e2, ctx)));
                    orClause7 = ctx.mkOr(orClause7,
                                         ctx.mkAnd(Utils.edge("ci", e1, e3, ctx), Utils.edge("ic", e3, e2, ctx)));
                    orClause8 = ctx.mkOr(orClause8,
                                         ctx.mkAnd(Utils.edge("cc", e1, e3, ctx), Utils.edge("cc", e3, e2, ctx)));

                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ic;ci", e1, e2, ctx), orClause1));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ii;ii", e1, e2, ctx), orClause2));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ic;cc", e1, e2, ctx), orClause3));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ii;ic", e1, e2, ctx), orClause4));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ci;ii", e1, e2, ctx), orClause5));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("cc;ci", e1, e2, ctx), orClause6));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ci;ic", e1, e2, ctx), orClause7));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("cc;cc", e1, e2, ctx), orClause8));

                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ii", e1, e2, ctx),
                                              ctx.mkOr(Utils.edge("ii0", e1, e2, ctx), Utils.edge("ci", e1, e2, ctx),
                                                       Utils.edge("ic;ci", e1, e2, ctx),
                                                       Utils.edge("ii;ii", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ic", e1, e2, ctx),
                                              ctx.mkOr(Utils.edge("ic0", e1, e2, ctx), Utils.edge("ii", e1, e2, ctx),
                                                       Utils.edge("cc", e1, e2, ctx), Utils.edge("ic;cc", e1, e2, ctx),
                                                       Utils.edge("ii;ic", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("ci", e1, e2, ctx),
                                              ctx.mkOr(Utils.edge("ci0", e1, e2, ctx), Utils.edge("ci;ii", e1, e2, ctx),
                                                       Utils.edge("cc;ci", e1, e2, ctx))));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge("cc", e1, e2, ctx),
                                              ctx.mkOr(Utils.edge("cc0", e1, e2, ctx), Utils.edge("ci", e1, e2, ctx),
                                                       Utils.edge("ci;ic", e1, e2, ctx),
                                                       Utils.edge("cc;cc", e1, e2, ctx))));

                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("ii", e1, e2, ctx), ctx.mkOr(
                        ctx.mkAnd(Utils.edge("ii0", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ii", e1, e2, ctx), Utils.intCount("ii0", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ci", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ii", e1, e2, ctx), Utils.intCount("ci", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ic;ci", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ii", e1, e2, ctx), Utils.intCount("ic;ci", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ii;ii", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ii", e1, e2, ctx), Utils.intCount("ii;ii", e1, e2, ctx))))));

                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("ic", e1, e2, ctx), ctx.mkOr(
                        ctx.mkAnd(Utils.edge("ic0", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ic", e1, e2, ctx), Utils.intCount("ic0", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ii", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ic", e1, e2, ctx), Utils.intCount("ii", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("cc", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ic", e1, e2, ctx), Utils.intCount("cc", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ic;cc", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ic", e1, e2, ctx), Utils.intCount("ic;cc", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ii;ic", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ic", e1, e2, ctx), Utils.intCount("ii;ic", e1, e2, ctx))))));

                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("ci", e1, e2, ctx), ctx.mkOr(
                        ctx.mkAnd(Utils.edge("ci0", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ci", e1, e2, ctx), Utils.intCount("ci0", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ci;ii", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ci", e1, e2, ctx), Utils.intCount("ci;ii", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("cc;ci", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("ci", e1, e2, ctx), Utils.intCount("cc;ci", e1, e2, ctx))))));

                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.edge("cc", e1, e2, ctx), ctx.mkOr(
                        ctx.mkAnd(Utils.edge("cc0", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("cc", e1, e2, ctx), Utils.intCount("cc0", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ci", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("cc", e1, e2, ctx), Utils.intCount("ci", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("ci;ic", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("cc", e1, e2, ctx), Utils.intCount("ci;ic", e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge("cc;cc", e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount("cc", e1, e2, ctx), Utils.intCount("cc;cc", e1, e2, ctx))))));
            }
        }
        return enc;
    }
}