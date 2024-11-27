package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

import java.math.BigInteger;
import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Preconditions.checkState;


public class EventModelManager {
    private static final Logger logger = LogManager.getLogger(EventModelManager.class);

    private final ExecutionModelManager manager;

    private ExecutionModelNext executionModel;
    private EncodingContext context;
    private Filter eventFilter;

    public EventModelManager(ExecutionModelManager manager) {
        this.manager = manager;
    }

    public void buildEventModels(ExecutionModelNext executionModel, EncodingContext context) {
        this.executionModel = executionModel;
        this.context = context;
        eventFilter = Filter.byTag(Tag.VISIBLE);
        extractEvents();
    }

    private void extractEvents() {
        int id = 0;
        List<Thread> threadList = new ArrayList<>(context.getTask().getProgram().getThreads());

        for (Thread t : threadList) {
            ThreadModel tm = new ThreadModel(t);
            int atomicBegin = -1;
            List<EventModel> eventList = new ArrayList<>();
            List<List<Integer>> atomicBlockRanges = new ArrayList<>();
            Event e = t.getEntry();

            do {
                if (!manager.isTrue(context.execution(e))) {
                    e = e.getSuccessor();
                    continue;
                }

                if (toExtract(e)) {
                    eventList.add(extractEvent(e, tm, id++));
                }
                
                if (e instanceof BeginAtomic) {
                    atomicBegin = id;
                } else if (e instanceof EndAtomic) {
                    checkState(atomicBegin != -1,
                               "EndAtomic without matching BeginAtomic in model");
                    atomicBlockRanges.add(List.of(atomicBegin, id));
                    atomicBegin = -1;
                }

                if (e instanceof CondJump jump
                    && manager.isTrue(context.jumpCondition(jump))
                ) {
                    e = jump.getLabel();
                } else {
                    e = e.getSuccessor();
                }

            } while (e != null);

            if (atomicBegin != -1) {
                atomicBlockRanges.add(List.of(atomicBegin, id));
            }

            if (eventList.size() > 0) {
                executionModel.addThread(tm);

                List<List<EventModel>> atomicBlocks = new ArrayList<>(atomicBlockRanges.size());
                for (int i = 0; i < atomicBlockRanges.size(); i++) {
                    List<Integer> range = atomicBlockRanges.get(i);
                    List<EventModel> atomicBlock = new ArrayList<>();
                    for (int j = range.get(0); j < range.get(1); j++) {
                        atomicBlock.add(executionModel.getEventModelById(j));
                    }
                    atomicBlocks.add(atomicBlock);
                }
                executionModel.addAtomicBlocks(t, atomicBlocks);
            }
        }
    }

    private EventModel extractEvent(Event e, ThreadModel tm, int id) {
        EventModel em;
        if (e.hasTag(Tag.MEMORY)) {
            Object addressObj = checkNotNull(
                manager.evaluateByModel(context.address((MemoryEvent) e))
            );
            final BigInteger address = new BigInteger(addressObj.toString());
            executionModel.addAccessedAddress(address);
            
            String valueString = String.valueOf(
                manager.evaluateByModel(context.value((MemoryCoreEvent) e))
            );
            final BigInteger value = switch(valueString) {
                // NULL case can happen if the solver optimized away a variable.
                // This should only happen if the value is irrelevant, so we will just pick 0.
                case "false", "null" -> BigInteger.ZERO;
                case "true" -> BigInteger.ONE;
                default -> new BigInteger(valueString);
            };

            if (e.hasTag(Tag.READ)) {
                em = new LoadModel(e, tm, id, address, value);
                executionModel.addAddressRead(address, (LoadModel) em);
            } else if (e.hasTag(Tag.WRITE)) {
                em = new StoreModel(e, tm, id, address, value);
                executionModel.addAddressWrite(address, (StoreModel) em);
            } else {
                // Should never happen.
                logger.warn("Event {} has Tag MEMORY but no READ or WRITE", e);
                em = new MemoryEventModel(e, tm, id, address, value);
            }

        } else if (e.hasTag(Tag.FENCE)) {
            final String name = ((GenericVisibleEvent) e).getName();
            em = new FenceModel(e, tm, id, name);
        } else if (e instanceof Assert assrt) {
            em = new AssertModel(assrt, tm, id);
        } else if (e instanceof Local local) {
            em = new LocalModel(local, tm, id);
        } else if (e instanceof CondJump cj) {
            em = new CondJumpModel(cj, tm, id);
        } else {
            // Should never happen.
            logger.warn("Extracting the event {} that should not be extracted", e);
            em = new DefaultEventModel(e, tm, id);
        }

        executionModel.addEvent(e, em);
        return em;
    }

    private boolean toExtract(Event e) {
        // We extract visible events, Locals and Asserts to show them in the witness,
        // and extract also CondJumps for tracking internal dependencies.
        return eventFilter.apply(e)
               || e instanceof Local
               || e instanceof Assert
               || e instanceof CondJump;
    }
}