package dartagnan.program.event;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import dartagnan.expression.ExprInterface;
import dartagnan.program.Thread;
import dartagnan.utils.MapSSA;
import dartagnan.utils.Pair;

import java.util.HashSet;
import java.util.Set;

import static dartagnan.utils.Encodings.encodeMissingIndexes;
import static dartagnan.utils.Utils.mergeMaps;

public class If extends Event {

    private ExprInterface expr;
    private Thread t1;
    private Thread t2;

    public If(ExprInterface expr, Thread t1, Thread t2) {
        this.expr = expr;
        this.t1 = t1;
        this.t2 = t2;
        t1.incCondLevel();
        t2.incCondLevel();
    }

    public Thread getT1() {
        return t1;
    }

    public Thread getT2() {
        return t2;
    }

    public void setT1(Thread t) {
        t1 = t;
    }

    public void setT2(Thread t) {
        t2 = t;
    }

    @Override
    public ExprInterface getExpr(){
        return expr;
    }

    @Override
    public void setMainThread(Thread t) {
        this.mainThread = t;
        t1.setMainThread(t);
        t2.setMainThread(t);
    }

    @Override
    public int setTId(int i) {
        this.tid = i;
        i++;
        i = t1.setTId(i);
        i = t2.setTId(i);
        return i;
    }

    @Override
    public void incCondLevel() {
        condLevel++;
        t1.incCondLevel();
        t2.incCondLevel();
    }

    @Override
    public void decCondLevel() {
        condLevel--;
        t1.decCondLevel();
        t2.decCondLevel();
    }

    @Override
    public boolean is(String param){
        return false;
    }

    @Override
    public int setEId(int i) {
        i = super.setEId(i);
        i = t1.setEId(i);
        i = t2.setEId(i);
        return i;
    }

    @Override
    public Set<Event> getEvents() {
        Set<Event> ret = new HashSet<>();
        ret.addAll(t1.getEvents());
        ret.addAll(t2.getEvents());
        ret.add(this);
        return ret;
    }

    @Override
    public void beforeClone(){
        t1.beforeClone();
        t2.beforeClone();
    }

    @Override
    public If clone() {
        Thread newT1 = t1.clone();
        newT1.decCondLevel();
        Thread newT2 = t2.clone();
        newT2.decCondLevel();
        ExprInterface newPred = expr.clone();
        If newIf = new If(newPred, newT1, newT2);
        newIf.condLevel = condLevel;
        return newIf;
    }

    @Override
    public If unroll(int steps, boolean obsNoTermination) {
        t1 = t1.unroll(steps, obsNoTermination);
        t2 = t2.unroll(steps, obsNoTermination);
        return this;
    }

    @Override
    public If unroll(int steps) {
        return unroll(steps, false);
    }

    @Override
    public If compile(String target, boolean ctrl, boolean leading) {
        t1 = t1.compile(target, ctrl, leading);
        t2 = t2.compile(target, ctrl, leading);
        return this;
    }

    @Override
    public Pair<BoolExpr, MapSSA> encodeDF(MapSSA map, Context ctx) {
        if(mainThread != null){
            MapSSA map1 = map.clone();
            MapSSA map2 = map.clone();

            BoolExpr enc = ctx.mkAnd(ctx.mkImplies(ctx.mkBoolConst(t1.cfVar()), expr.toZ3Boolean(map, ctx)),
                    ctx.mkImplies(ctx.mkBoolConst(t2.cfVar()), ctx.mkNot(expr.toZ3Boolean(map, ctx))));

            Pair<BoolExpr, MapSSA> p1 = t1.encodeDF(map1, ctx);
            enc = ctx.mkAnd(enc, p1.getFirst());
            Pair<BoolExpr, MapSSA> p2 = t2.encodeDF(map2, ctx);
            enc = ctx.mkAnd(enc, p2.getFirst());
            enc = ctx.mkAnd(enc, encodeMissingIndexes(this, map1, map2, ctx));
            map = mergeMaps(map1, map2);
            return new Pair<>(enc, map);
        }
        throw new RuntimeException("Main thread is not set for " + toString());
    }

    @Override
    public BoolExpr encodeCF(Context ctx) {
        return ctx.mkAnd(
                ctx.mkEq(ctx.mkBoolConst(cfVar()), ctx.mkXor(ctx.mkBoolConst(t1.cfVar()), ctx.mkBoolConst(t2.cfVar()))),
                ctx.mkEq(ctx.mkBoolConst(cfVar()), executes(ctx)),
                t1.encodeCF(ctx),
                t2.encodeCF(ctx));
    }

    @Override
    public String toString() {
        if (t2 instanceof Skip)
            return nTimesCondLevel() + "if (" + expr + ") {\n" + t1 + "\n" + nTimesCondLevel() + "}";
        else
            return nTimesCondLevel() + "if (" + expr + ") {\n" + t1 + "\n" + nTimesCondLevel() + "}\n"
                    + nTimesCondLevel() + "else {\n" + t2 + "\n" + nTimesCondLevel() + "}";
    }
}