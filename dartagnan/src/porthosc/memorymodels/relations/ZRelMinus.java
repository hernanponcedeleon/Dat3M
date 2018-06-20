package porthosc.memorymodels.relations;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.utils.Utils;

import java.util.Set;


public class ZRelMinus extends ZBinaryRelation {

    public ZRelMinus(ZRelation r1, ZRelation r2, String name) {
        super(r1, r2, name, String.format("(%s\\%s)", r1.getName(), r2.getName()));

    }

    public ZRelMinus(ZRelation r1, ZRelation r2) {
        super(r1, r2, String.format("(%s\\%s)", r1.getName(), r2.getName()));
    }

    @Override
    public BoolExpr encodeBasic(XProgram program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        //Set<XEvent> events = program.getMemEvents();
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
                if (r1.containsRec) {
                    opt1 = ctx.mkAnd(opt1, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx),
                                                    Utils.intCount(r1.getName(), e1, e2, ctx)));
                }
                BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
                if (r2.containsRec) {
                    opt2 = ctx.mkAnd(opt2, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx),
                                                    Utils.intCount(r2.getName(), e1, e2, ctx)));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));

            }
        }
        return enc;
    }

    @Override
    public BoolExpr encodeApprox(XProgram program, Context ctx) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        //Set<XEvent> events = program.getMemEvents();
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                BoolExpr opt1 = Utils.edge(r1.getName(), e1, e2, ctx);
                BoolExpr opt2 = ctx.mkNot(Utils.edge(r2.getName(), e1, e2, ctx));
                if (r2.containsRec) {
                    opt2 = ctx.mkAnd(opt2, ctx.mkGt(Utils.intCount(this.getName(), e1, e2, ctx),
                                                    Utils.intCount(r2.getName(), e1, e2, ctx)));
                }
                enc = ctx.mkAnd(enc, ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), ctx.mkAnd(opt1, opt2)));

            }
        }
        return enc;
    }

    @Override
    public BoolExpr encode(XProgram program, Context ctx, Set<String> encodedRels) throws Z3Exception {
        if (!encodedRels.contains(getName())) {
            encodedRels.add(getName());
            BoolExpr enc = r1.encode(program, ctx, encodedRels);
            //the second relation must not be overapproximated since that would mean the inverse is underapproximated.
            // TODO: this is unacceptably bad:
            boolean approx = ZRelation.Approx;
            ZRelation.Approx = false;
            enc = ctx.mkAnd(enc, r2.encode(program, ctx, encodedRels));
            ZRelation.Approx = approx;
            if (ZRelation.Approx) {
                return ctx.mkAnd(enc, this.encodeBasic(program, ctx));
            }
            else {
                return ctx.mkAnd(enc, this.encodeApprox(program, ctx));
            }

        }
        else {
            return ctx.mkTrue();
        }

    }
}
