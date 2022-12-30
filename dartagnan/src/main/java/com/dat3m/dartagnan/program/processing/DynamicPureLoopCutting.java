package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Store;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class DynamicPureLoopCutting implements ProgramProcessor {


    public static DynamicPureLoopCutting fromConfig() {
        return new DynamicPureLoopCutting();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isCompiled(), "DynamicPureLoopCutting can only be run on compiled programs.");
        for (Thread t : program.getThreads()) {
            run(t);
        }

        // Update cIds
        int cId = 0;
        program.clearCache(true);
        for (Event e : program.getEvents()) {
            e.setCId(cId++);
        }
    }

    private void run(Thread thread) {
        // TODO: This code does not check for non-store side effects yet (i.e., modifications to local variables)
        //  Therefore, it will generate wrong results in the general case and is just intended as test code for now!

        // Helper class
        class Loop {
            final List<Label> iterLabels = new ArrayList<>();
            final List<List<Event>> iterStores = new ArrayList<>();
        }
        final List<Loop> loops = new ArrayList<>();
        final List<Event> events = thread.getEvents();

        for (int i = 0; i < events.size(); i++) {
            Event e = events.get(i);
            if (!(e instanceof Label)) {
                continue;
            }
            Label lbl = (Label) e;
            int idx = lbl.getName().lastIndexOf("_");
            if (idx < 0 || !(lbl.getName().substring(idx + 1).equals("1"))) {
                continue;
            }
            // We found the first occurrence of a loop-label named "labelName_1".
            Loop loop = new Loop();
            loops.add(loop);
            loop.iterLabels.add(lbl);
            String prefix = lbl.getName().substring(0, idx);

            // Find remaining iterations of this loop
            int iterCtr = 2;
            int iterLblIndex = i;
            while (true) {
                Label nextLbl = null;
                while (++iterLblIndex < events.size()) {
                    Event x = events.get(iterLblIndex);
                    if (x instanceof Label && ((Label) x).getName().equals(prefix + "_" + iterCtr)) {
                        nextLbl = (Label) x;
                        break;
                    }
                }
                if (nextLbl != null) {
                    final Label finalNextLbl = nextLbl;
                    final Event previousItr = loop.iterLabels.get(loop.iterLabels.size() - 1);
                    final List<Event> stores = previousItr.getSuccessors().stream()
                            .takeWhile(x -> !x.equals(finalNextLbl))
                            .filter(Store.class::isInstance).collect(Collectors.toList());

                    loop.iterLabels.add(nextLbl);
                    loop.iterStores.add(stores);
                    iterCtr++;
                } else {
                    break;
                }
            }
        }

        // --------- Modify code ----------
        int loopCtr = 0;
        for (Loop loop : loops) {
            loopCtr++;
            for (int i = 0; i < loop.iterStores.size(); i++) {
                final List<Event> stores = loop.iterStores.get(i);

                List<Register> regs = new ArrayList<>();
                Event cur = loop.iterLabels.get(i+1);
                int storeCtr = 0;
                for (Event store : stores) {
                    storeCtr++;
                    Register dummy = new Register(String.format("Loop%s_%s_%s", loopCtr, i, storeCtr), thread.getId(), GlobalSettings.ARCH_PRECISION);
                    regs.add(dummy);

                    Event status = EventFactory.newExecutionStatus(dummy, store);
                    cur.insertAfter(status);
                    cur = status;
                }

                BExpr atLeastOneSideEffect = new BConst(false);
                for (Register reg : regs) {
                    atLeastOneSideEffect = new BExprBin(atLeastOneSideEffect, BOpBin.OR, new Atom(reg, COpBin.EQ, new IValue(BigInteger.ZERO, GlobalSettings.ARCH_PRECISION)));
                }
                CondJump assumeSideEffect = EventFactory.newJumpUnless(atLeastOneSideEffect, (Label) thread.getExit());
                // TODO: Do proper tagging (Tag.BOUND, Tag.SPINLOOP ???)
                // TODO 2: Consider this early termination in the liveness detection.
                cur.insertAfter(assumeSideEffect);
            }
        }
    }
}
