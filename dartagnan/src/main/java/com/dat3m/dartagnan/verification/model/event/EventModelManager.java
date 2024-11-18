package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.program.filter.Filter;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Preconditions.checkState;

import java.math.BigInteger;
import java.util.*;


public class EventModelManager {
    private final ExecutionModelNext executionModel;
    private final Map<Event, EventModel> eventCache;

    private Filter eventFilter;

    private EventModelManager(ExecutionModelNext executionModel) {
        this.executionModel = checkNotNull(executionModel);
        eventCache = new HashMap<>();
    }

    public static EventModelManager newEMManager(ExecutionModelNext executionModel) {
        return new EventModelManager(executionModel);
    }

    public EncodingContext getEncodingContext() {
        return executionModel.getEncodingContext();
    }

    public void initialize() {
        eventCache.clear();
        eventFilter = Filter.byTag(Tag.VISIBLE);
        extractEvents();
    }

    private void extractEvents() {
        int id = 0;
        List<Thread> threadList = new ArrayList<>(executionModel.getProgram().getThreads());

        for (Thread t : threadList) {
            int localId = 0;
            int atomicBegin = -1;
            List<EventModel> eventList = new ArrayList<>();
            List<List<Integer>> atomicBlockRanges = new ArrayList<>();
            Event e = t.getEntry();

            do {
                if (!executionModel.isTrue(getEncodingContext().execution(e))) {
                    e = e.getSuccessor();
                    continue;
                }

                if (toExtract(e)) {
                    eventList.add(extractEvent(e, id++, localId++));
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
                    && executionModel.isTrue(getEncodingContext().jumpCondition(jump))
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
                executionModel.addThreadEvents(t, Collections.unmodifiableList(eventList));

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

    private EventModel extractEvent(Event e, int id, int localId) {
        EventModel em = getOrCreateModel(e, id, localId);
        executionModel.addEvent(e, em);
        return em;
    }

    private EventModel getOrCreateModel(Event e, int id, int localId) {
        if (eventCache.containsKey(e)) {
            return eventCache.get(e);
        }

        EventModel em = createAndInitializeModel(e);
        em.setId(id);
        em.setLocalId(localId);
        if (e instanceof CondJump) {
            em.setWasExecuted(
                executionModel.isTrue(getEncodingContext().jumpCondition((CondJump) e))
            );
        } else { em.setWasExecuted(true); }
        eventCache.put(e, em);

        return em;
    }

    private EventModel createAndInitializeModel(Event e) {
        EventModel em;
        if (e.hasTag(Tag.MEMORY)) {
            Object addressObj = checkNotNull(
                executionModel.evaluateByModel(getEncodingContext().address((MemoryEvent) e))
            );
            BigInteger address = new BigInteger(addressObj.toString());
            executionModel.addAccessedAddress(address);

            if (e.hasTag(Tag.READ)) {
                em = new LoadModel(e);
                executionModel.addAddressRead(address, (LoadModel) em);
            } else if (e.hasTag(Tag.WRITE)) {
                em = new StoreModel(e);
                executionModel.addAddressWrite(address, (StoreModel) em);
                if (em.isInit()) {
                    executionModel.addAddressInit(address, (StoreModel) em);
                }
            } else {
                em = new MemoryEventModel(e);
            }

            ((MemoryEventModel) em).setAccessedAddress(address);

            if (em.isRead() || em.isWrite()) {
                String valueString = String.valueOf(
                    executionModel.evaluateByModel(
                        getEncodingContext().value((MemoryCoreEvent) e)
                    )
                );
                BigInteger value = switch(valueString) {
                    // NULL case can happen if the solver optimized away a variable.
                    // This should only happen if the value is irrelevant, so we will just pick 0.
                    case "false", "null" -> BigInteger.ZERO;
                    case "true" -> BigInteger.ONE;
                    default -> new BigInteger(valueString);
                };
                ((MemoryEventModel) em).setValue(value);
            }

        } else if (e.hasTag(Tag.FENCE)) {
            String name = ((GenericVisibleEvent) e).getName();
            em = new FenceModel(e, name);
            executionModel.addFence((FenceModel) em);
        } else if (e instanceof Assert) {
            em = new AssertModel((Assert) e);
        } else if (e instanceof Local) {
            em = new LocalModel((Local) e);
        } else if (e instanceof CondJump) {
            em = new CondJumpModel((CondJump) e);
        } else {
            em = new DefaultEventModel(e);
        }

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