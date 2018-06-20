package porthosc.memorymodels.relations;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.utils.Utils;


public class ZRelComposition extends ZBinaryRelation {

    public ZRelComposition(ZRelation r1, ZRelation r2, String name) {
        super(r1, r2, name, String.format("(%s;%s)", r1.getName(), r2.getName()));
    }

    public ZRelComposition(ZRelation r1, ZRelation r2) {
        super(r1, r2, String.format("(%s;%s)", r1.getName(), r2.getName()));
    }

    @Override
    public BoolExpr encodeBasic(XProgram program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                BoolExpr orClause = ctx.mkFalse();
                for (XEvent e3 : events) {
                    BoolExpr opt1 = Utils.edge(r1.getName(), e1, e3, ctx);
                    if (r1.containsRec) {
                        opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(getName(), e1, e2, ctx),
                                                        Utils.intCount(r1.getName(), e1, e3, ctx)));
                    }
                    BoolExpr opt2 = Utils.edge(r2.getName(), e3, e2, ctx);
                    if (r2.containsRec) {
                        opt2 = ctx.mkAnd(opt2, ctx.mkGt(Utils.intCount(getName(), e1, e2, ctx),
                                                        Utils.intCount(r2.getName(), e3, e2, ctx)));
                    }
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(opt1, opt2));

                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), orClause));
            }
        }
        return enc;
    }

    @Override
    public BoolExpr encodeApprox(XProgram program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                BoolExpr orClause = ctx.mkFalse();
                for (XEvent e3 : events) {
                    BoolExpr opt1 = Utils.edge(r1.getName(), e1, e3, ctx);
                    BoolExpr opt2 = Utils.edge(r2.getName(), e3, e2, ctx);
                    orClause = ctx.mkOr(orClause, ctx.mkAnd(opt1, opt2));

                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), orClause));
            }
        }
        return enc;
    }

}
