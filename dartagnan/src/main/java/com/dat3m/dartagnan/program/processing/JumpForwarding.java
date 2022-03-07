package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.base.Preconditions;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class JumpForwarding implements ProgramProcessor {

    private static final Logger logger = LogManager.getLogger(JumpForwarding.class);

    private JumpForwarding() { }

    public static JumpForwarding newInstance() {
        return new JumpForwarding();
    }

    public static JumpForwarding fromConfig(Configuration config) throws InvalidConfigurationException {
        return newInstance();
    }

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled(), "Jump forwarding should be performed after unrolling.");

        logger.info("#Events before jump forwarding: " + program.getEvents().size());

        int numForwardedJumps = 0;
        for (Thread t : program.getThreads()) {
            numForwardedJumps += run(t);
            t.clearCache();
        }
        program.clearCache(false);

        logger.info("#Jumps forwarded: " + numForwardedJumps);
        logger.info("#Events after jump forwarding: " + program.getEvents().size());
    }

    private int run(Thread thread) {
        Map<Label, Label> forwardingMap = new HashMap<>();
        Set<Event> toBeRemoved = new HashSet<>();

        int numForwardedJumps = 0;
        Label forwardTo = null;
        Event next = null;
        boolean nextIsGoto = false;

        for (Event cur : Lists.reverse(thread.getEvents())) {
            if (cur instanceof Label) {
                Label l = (Label) cur;
                if (forwardTo != null) {
                    // We have a label whose jumps can can get forwarded
                    forwardingMap.put(l, forwardingMap.get(forwardTo));
                    toBeRemoved.add(l);
                } else {
                    // We have a label that cannot get forwarded, but it itself can be a target for forwarding
                    forwardTo = l;
                    forwardingMap.put(l, l);
                }
            } else if (cur instanceof CondJump) {
                CondJump jump = (CondJump)cur;
                // We forward the jump if possible
                jump.setLabel(forwardingMap.getOrDefault(jump.getLabel(), jump.getLabel()));
                numForwardedJumps++;
                if (jump.isGoto() && !jump.is(Tag.BOUND)) {
                    // If we have a goto, we can possibly forward directly to its target label
                    // NOTE: We cannot forward past a bound jump, because that can make bound events
                    // unreachable.
                    forwardTo = jump.getLabel();
                    if (nextIsGoto) {
                        // We have 2 gotos in sequence... the latter cannot be reached
                        toBeRemoved.add(next);
                    }
                } else {
                    // We have a conditional jump, there is no clear forwarding doable
                    forwardTo = null;
                }
            } else {
                forwardTo = null;
            }

            nextIsGoto = (cur instanceof CondJump && (((CondJump) cur).isGoto()));
            next = cur;
        }

        // Here is the actual removal
        Event pred = null;
        Event cur = thread.getEntry();
        while (cur != null) {
            if (toBeRemoved.contains(cur)) {
                cur.delete(pred);
                cur = pred;
            }
            pred = cur;
            cur = cur.getSuccessor();
        }

        return numForwardedJumps;
    }
}