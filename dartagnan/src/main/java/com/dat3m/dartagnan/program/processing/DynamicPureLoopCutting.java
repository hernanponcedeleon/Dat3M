package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.utils.printer.Printer;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DynamicPureLoopCutting implements ProgramProcessor {


    public static DynamicPureLoopCutting fromConfig() {
        return new DynamicPureLoopCutting();
    }

    @Override
    public void run(Program program) {
        for (Thread t : program.getThreads()) {
            run(t);
        }

        int cId = 0;
        program.clearCache(true);
        for (Event e : program.getEvents()) {
            e.setCId(cId++);
        }

        System.out.println("===== Program after unrolling =====");
        System.out.println(new Printer().print(program));
        System.out.println("===================================");
    }

    private void run(Thread thread) {

        class Loop {
            List<Event> iterBegins = new ArrayList<>();
            List<List<Event>> iterStores = new ArrayList<>();
        }

        List<Loop> loops = new ArrayList<>();
        List<Event> events = thread.getEvents();
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
            Loop loop = new Loop();
            loops.add(loop);
            loop.iterBegins.add(lbl);
            String prefix = lbl.getName().substring(0, idx);

            int iterCtr = 2;
            while (true) {
                int ctr = iterCtr;
                Optional<Label> nextIter = events.subList(i, events.size()).stream()
                        .filter(x -> (x instanceof Label)).map(Label.class::cast)
                        .filter(x -> x.getName().equals(prefix + "_" + ctr))
                        //.filter(x -> x.getName().substring(0, idx).equals(prefix) && x.getName().substring(idx + 1).equals(Integer.toString(ctr)))
                        .findFirst();

                if (nextIter.isPresent()) {
                    Label next = (Label) nextIter.get();
                    loop.iterBegins.add(next);
                    iterCtr++;

                    Event previous = loop.iterBegins.get(loop.iterBegins.size() - 2);
                    List<Event> stores = new ArrayList<>();
                    for (Event x : previous.getSuccessors()) {
                        i++;
                        if (x.equals(next)) {
                            break;
                        }
                        if (x instanceof Store && !x.is("nosideeffect")) {
                            if (x.getSuccessor() instanceof Load) {
                                if (((Store)x).getAddress().equals(((Load)x.getSuccessor()).getAddress())) {
                                    continue;
                                }
                            }
                            stores.add(x);
                        }
                    }
                    loop.iterStores.add(stores);
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
                List<Event> stores = loop.iterStores.get(i);
                Event cur = loop.iterBegins.get(i+1);
                List<Register> regs = new ArrayList<>();
                int storeCtr = 0;
                for (Event store : stores) {
                    storeCtr++;
                    Register dummy = new Register(String.format("Loop%s_%s_%s", loopCtr, i, storeCtr), thread.getId(), GlobalSettings.ARCH_PRECISION);
                    regs.add(dummy);
                    Event status = EventFactory.newExecutionStatus(dummy, store);
                    status.setThread(thread);
                    cur.getSuccessor().setPredecessor(status);
                    cur.setSuccessor(status);
                    cur = status;
                }

                BExpr atLeastOne = new BConst(false);
                for (Register reg : regs) {
                    atLeastOne = new BExprBin(atLeastOne, BOpBin.OR, new Atom(reg, COpBin.EQ, new IValue(BigInteger.ZERO, GlobalSettings.ARCH_PRECISION)));
                }
                Event assume = new Assume(atLeastOne);
                cur.getSuccessor().setPredecessor(assume);
                cur.setSuccessor(assume);
            }
        }
    }
}
