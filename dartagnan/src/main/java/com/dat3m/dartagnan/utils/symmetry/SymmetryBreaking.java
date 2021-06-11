package com.dat3m.dartagnan.utils.symmetry;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Function;


// A first rough implementation for SymmetryBreaking
public class SymmetryBreaking {

    private static final int LEX_LEADER_SIZE = 1000;

    private final VerificationTask task;
    private final ThreadSymmetry symm;
    private final Wmm wmm;
    private final Relation rf;

    public SymmetryBreaking(VerificationTask task, ThreadSymmetry symm) {
        this.task = task;
        this.symm = symm;
        this.wmm = task.getMemoryModel();
        this.rf = wmm.getRelationRepository().getRelation("rf");

    }

    public BoolExpr encode(Thread thread, Context ctx) {
        BoolExpr enc = ctx.mkTrue();
        List<Thread> symmThreads = new ArrayList<>(symm.getEquivalenceClass(thread));
        symmThreads.sort(Comparator.comparingInt(Thread::getId));

        Thread t1 = symmThreads.get(0);

        // ===== Construct row =====
        //IMPORTANT: Each thread writes to its own special location for the purpose of starting/terminating threads
        // These need to get skipped!
        List<Tuple> r1 = new ArrayList<>();
        for (Tuple t : rf.getMaxTupleSet()) {
            Event a = t.getFirst();
            Event b = t.getSecond();
            if (!a.is(EType.PTHREAD) && !b.is(EType.PTHREAD) && a.getThread() == t1) {
                r1.add(t);
            }
        }
        r1.sort(Comparator.naturalOrder());

        // Construct
        for (int i = 1; i < symmThreads.size(); i++) {
            Thread t2 = symmThreads.get(i);
            Function<Event, Event> p = symm.createTransposition(t1, t2);
            List<Tuple> r2 = new ArrayList<>();
            for (Tuple t : r1) {
                r2.add(mapTuple(t, p));
                // assert rf.getMaxTupleSet().contains(r2.get(r2.size() - 1));
            }


            enc = ctx.mkAnd(enc, encodeLexLeader(i, r1, r2, ctx));
            t1 = t2;
            r1 = r2;
        }

        return enc;
    }

    // y0, ..., y(n-1)
    // x1, ..., xn
    private BoolExpr encodeLexLeader(int index, List<Tuple> r1, List<Tuple> r2, Context ctx) {
        int size = Math.min(r1.size(), LEX_LEADER_SIZE);
        BoolExpr ylast = ctx.mkBoolConst("y0_" + index);
        BoolExpr enc = ctx.mkEq(ylast, ctx.mkTrue());
        // From x1 to x(n-1)
        for (int i = 1; i < size; i++) {
            BoolExpr y = ctx.mkBoolConst("y" + i + "_" + index);
            BoolExpr orig = rf.getSMTVar(r1.get(i-1), ctx);
            BoolExpr perm = rf.getSMTVar(r2.get(i-1), ctx);
            enc = ctx.mkAnd(enc, ctx.mkOr(y, ctx.mkNot(ylast), ctx.mkNot(orig)));
            enc = ctx.mkAnd(enc, ctx.mkOr(y, ctx.mkNot(ylast), perm));
            enc = ctx.mkAnd(enc, ctx.mkOr(ctx.mkNot(ylast), ctx.mkNot(orig), perm));
            ylast = y;
        }
        // Final iteration is handled differently
        BoolExpr orig = rf.getSMTVar(r1.get(size-1), ctx);
        BoolExpr perm = rf.getSMTVar(r2.get(size-1), ctx);
        enc = ctx.mkAnd(enc, ctx.mkOr(ctx.mkNot(ylast), ctx.mkNot(orig), perm));


        return enc;
    }

    private Tuple mapTuple(Tuple t, Function<Event, Event> p) {
        return new Tuple(p.apply(t.getFirst()), p.apply(t.getSecond()));
    }
}
