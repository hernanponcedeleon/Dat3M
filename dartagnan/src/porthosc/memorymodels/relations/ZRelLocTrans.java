package porthosc.memorymodels.relations;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.memory.XMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.utils.Utils;


public class ZRelLocTrans extends ZUnaryRelation {

    public ZRelLocTrans(ZRelation r1) {
        super(r1, String.format("%s^+", r1.getName()));
    }

    @Override
    public BoolExpr encodeBasic(XProgram program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        //getEvents().stream().filter(e -> e instanceof SharedMemEvent || e instanceof LocalEvent).collect(Collectors.toSet());
        ImmutableSet<XMemoryEvent> events = program.getMemoryEvents();
        //copied from satTansIDL
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                BoolExpr orClause = ctx.mkFalse();
                for (XEvent e3 : events) {
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(this.getName(), e1, e3, ctx),
                                                            Utils.edge(this.getName(), e3, e2, ctx),
                                                            ctx.mkGt(Utils.intCount(
                                                                    String.format("(%s^+;%s^+)", r1.getName(),
                                                                                  r1.getName()), e1, e2, ctx),
                                                                     Utils.intCount(this.getName(), e1, e3, ctx)),
                                                            ctx.mkGt(Utils.intCount(
                                                                    String.format("(%s^+;%s^+)", r1.getName(),
                                                                                  r1.getName()), e1, e2, ctx),
                                                                     Utils.intCount(this.getName(), e3, e2, ctx))));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(
                        Utils.edge(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), e1, e2, ctx), orClause));
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(this.getName(), e1, e2, ctx), ctx.mkOr(
                        ctx.mkAnd(Utils.edge(r1.getName(), e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx),
                                           Utils.intCount(r1.getName(), e1, e2, ctx))),
                        ctx.mkAnd(Utils.edge(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), e1, e2, ctx),
                                  ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx),
                                           Utils.intCount(String.format("(%s^+;%s^+)", r1.getName(), r1.getName()), e1,
                                                          e2, ctx))))));
            }
        }
        return enc;
    }


    @Override
    public BoolExpr encodeApprox(XProgram program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        //Set<XEvent> events = program.getEvents().stream().filter(e -> e instanceof SharedMemEvent || e instanceof LocalEvent).collect(Collectors.toSet());
        ImmutableSet<XMemoryEvent> events = program.getMemoryEvents();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                //transitive
                BoolExpr orClause = ctx.mkFalse();
                for (XEvent e3 : events) {
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(Utils.edge(getName(), e1, e3, ctx),
                                                            Utils.edge(getName(), e3, e2, ctx)));
                }
                //original relation
                orClause = ctx.mkOr(orClause, Utils.edge(r1.getName(), e1, e2, ctx));
                //putting it together:
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), orClause));
            }
        }
        return enc;
    }
}
