package porthosc.memorymodels.relations;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.memory.XSharedMemoryEvent;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.memorymodels.Encodings;
import porthosc.utils.Utils;

import java.util.HashSet;
import java.util.Set;

import static porthosc.memorymodels.Encodings.encodeEO;


public class ZTemplateRelation extends ZBinaryRelation {

    protected static int ID;
    public static String PREFIX = "";
    private BoolExpr unionexp;
    private BoolExpr interexp;
    private BoolExpr compexp;
    private BoolExpr transrefexp;
    private BoolExpr idexp;

    public ZTemplateRelation(ZRelation r1, ZRelation r2) {
        super(r1, r2, "TR" + String.valueOf(ID));
        ID++;

    }


    public BoolExpr Inconsistent(String prefix, XProgram p, Context ctx) throws Z3Exception {
        PREFIX = prefix;
        boolean approxtemp = ZRelation.Approx;
        ZRelation.Approx = false;
        ImmutableSet<XSharedMemoryEvent> events = p.getSharedMemoryEvents();//Set<Event> events = p.getMemEvents();
        BoolExpr enc = Encodings.satCycle(prefix + name, events, ctx);
        enc = ctx.mkAnd(enc, encode(p, ctx, new HashSet<>()));

        for (XEvent e1 : events) {
            Set<BoolExpr> source = new HashSet<>();
            Set<BoolExpr> target = new HashSet<>();
            //TODO: cycles grober definieren.
            for (XEvent e2 : events) {
                source.add(Utils.cycleEdge(prefix + name, e1, e2, ctx));
                target.add(Utils.cycleEdge(prefix + name, e2, e1, ctx));
                enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.cycleEdge(prefix + name, e1, e2, ctx),
                                                   ctx.mkAnd(Utils.edge(prefix + name, e1, e2, ctx),
                                                             Utils.cycleVar(prefix + name, e1, ctx),
                                                             Utils.cycleVar(prefix + name, e2, ctx))));
            }
            enc = ctx.mkAnd(enc, ctx.mkImplies(Utils.cycleVar(prefix + name, e1, ctx),
                                               ctx.mkAnd(encodeEO(source, ctx), encodeEO(target, ctx))));
        }

        PREFIX = "";
        ZRelation.Approx = approxtemp;
        return enc;
    }

    //public ZRelation getSolution(Solver s, Context ctx) {
    //    Model m = s.getModel();
    //    ZRelation rel1, rel2;
    //    if (r1 instanceof ZTemplateRelation) {
    //        rel1 = ((ZTemplateRelation) r1).getSolution(s, ctx);
    //    }
    //    else {
    //        rel1 = ((ZTemplateBasicRelation) r1).getSolution(s, ctx);
    //    }
    //    if (r2 instanceof ZTemplateRelation) {
    //        rel2 = ((ZTemplateRelation) r2).getSolution(s, ctx);
    //    }
    //    else {
    //        rel2 = ((ZTemplateBasicRelation) r2).getSolution(s, ctx);
    //    }
    //    if (m.eval(unionexp, true).isTrue()) {
    //        return new ZRelUnion(rel1, rel2);
    //    }
    //    if (m.eval(interexp, true).isTrue()) {
    //        return new ZRelInterSect(rel1, rel2);
    //    }
    //    if (m.eval(compexp, true).isTrue()) {
    //        return new ZRelComposition(rel1, rel2);
    //    }
    //    if (m.eval(transrefexp, true).isTrue()) {
    //        return new ZRelTransRef(rel1);
    //    }
    //    if (m.eval(idexp, true).isTrue()) {
    //        return rel1;
    //    }
    //    System.err.println("could not find Solution for TemplateRelation " + name);
    //    return null;
    //}

    @Override
    protected BoolExpr encodeBasic(XProgram program, Context ctx) throws Z3Exception {
        //TODO: relminus

        //union:
        ZRelUnion union = new ZRelUnion(r1, r2, name);
        BoolExpr enc;
        unionexp = ctx.mkBoolConst("union" + name);
        enc = ctx.mkAnd(unionexp, union.encodeBasic(program, ctx));

        //inter:
        ZRelInterSect inter = new ZRelInterSect(r1, r2, name);
        interexp = ctx.mkBoolConst("inter" + name);
        enc = ctx.mkOr(ctx.mkAnd(ctx.mkNot(interexp), enc), ctx.mkAnd(interexp, inter.encodeBasic(program, ctx)));

        //comp:
        ZRelComposition comp = new ZRelComposition(r1, r2, name);
        compexp = ctx.mkBoolConst("comp" + name);
        enc = ctx.mkOr(ctx.mkAnd(ctx.mkNot(compexp), enc), ctx.mkAnd(compexp, comp.encodeBasic(program, ctx)));

        //RelTransRef:
        ZRelTransRef transref = new ZRelTransRef(r1, name);
        transrefexp = ctx.mkBoolConst("transref" + name);
        enc = ctx.mkOr(ctx.mkAnd(ctx.mkNot(transrefexp), enc),
                       ctx.mkAnd(transrefexp, transref.encodeBasic(program, ctx)));

        //id:
        idexp = ctx.mkBoolConst("id" + name);

        BoolExpr enc2 = ctx.mkTrue();
        ImmutableSet<XSharedMemoryEvent> events = program.getSharedMemoryEvents();//Set<Event> events = program.getMemEvents();
        for (XEvent e1 : events) {
            for (XEvent e2 : events) {
                enc2 = ctx.mkAnd(enc2,
                                 ctx.mkEq(Utils.edge(getName(), e1, e2, ctx), Utils.edge(r1.getName(), e1, e2, ctx)));
            }
        }
        enc = ctx.mkOr(ctx.mkAnd(ctx.mkNot(idexp), enc), ctx.mkAnd(idexp, enc2));

        return enc;
    }

    //public static ZTemplateRelation getTemplateRelation(int level) {
    //    if (level > 1) {
    //        return new ZTemplateRelation(getTemplateRelation(level - 1), getTemplateRelation(level - 1));
    //    }
    //    else {
    //        return new ZTemplateRelation(new ZTemplateBasicRelation(), new ZTemplateBasicRelation());
    //    }
    //}

}
