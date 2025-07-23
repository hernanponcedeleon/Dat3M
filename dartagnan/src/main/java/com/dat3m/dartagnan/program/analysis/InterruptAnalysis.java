package com.dat3m.dartagnan.program.analysis;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.List;

public class InterruptAnalysis {

    public record Info(Thread thread, List<Thread> interrupts, List<Event> irqBarriers) {

        public List<Event> getImmediateIRQBarriersBefore(Event ev, ExecutionAnalysis exec) {
            int lowerIndex = 0;
            int upperIndex = -1;
            for (int i = irqBarriers.size() - 1; i >= 0; i--) {
                final Event barrier = irqBarriers.get(i);
                if (upperIndex == -1 && barrier.getLocalId() <= ev.getLocalId()) {
                    upperIndex = i;
                }
                if (upperIndex != -1 && exec.isImplied(ev, barrier)) {
                    lowerIndex = i;
                    break;
                }
            }
            return irqBarriers.subList(lowerIndex, upperIndex + 1);
        }
    }

    public static List<Thread> computeInterrupts(Thread thread) {
        return thread.getProgram().getThreads().stream()
                .filter(t -> t.getThreadType() == Thread.Type.INTERRUPT_HANDLER
                        && t.getEntry().getCreator().getThread() == thread)
                .toList();

    }

    public static Info computeInterruptInfo(Thread thread) {
        final List<Thread> interrupts = computeInterrupts(thread);
        final List<Event> irqBarriers = thread.getEvents()
                .stream()
                .filter(e -> e.hasTag(Tag.DISABLE_INTERRUPT) || e.hasTag(Tag.ENABLE_INTERRUPT))
                .toList();

        return new Info(thread, interrupts, irqBarriers);
    }

}
