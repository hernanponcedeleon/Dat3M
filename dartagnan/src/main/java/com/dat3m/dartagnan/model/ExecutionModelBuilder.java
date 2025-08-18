package com.dat3m.dartagnan.model;

import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.events.*;
import com.dat3m.dartagnan.model.events.special.StateSnapshotModel;
import com.dat3m.dartagnan.model.events.threading.*;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.dat3m.dartagnan.program.event.core.special.StateSnapshot;
import com.dat3m.dartagnan.program.event.core.threading.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Relation;
import com.google.common.base.Preconditions;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import java.math.BigInteger;
import java.util.*;

public class ExecutionModelBuilder {

    private final BiMap<Event, EventModel> event2Model = HashBiMap.create();
    private final BiMap<Thread, ThreadModel> thread2Model = HashBiMap.create();
    private final BiMap<MemoryObject, MemoryObjectModel> memoryObject2Model = HashBiMap.create();
    private final BiMap<Relation, RelationModel> relation2Model = HashBiMap.create();

    private final VerificationTask task;
    private final IREvaluator evaluator;
    private final EventExtractor extractor = new EventExtractor();

    private ExecutionModel executionModel = null;

    public ExecutionModel getExecutionModel() {
        return executionModel;
    }

    public ExecutionModelBuilder(VerificationTask task, IREvaluator evaluator) {
        this.task = task;
        this.evaluator = evaluator;
    }

    public void extractProgramExecution() {
        extractExecutionModel(task.getProgram(), evaluator);
    }

    public void extractRelationModels(Set<Relation> relations) {
        Preconditions.checkState(!event2Model.isEmpty(), "The program execution has not been extracted yet");
        extractRelationModels(relations, event2Model.values(), evaluator);
    }

    public void addRelationModel(Relation relation, RelationModel relationModel) {
        Preconditions.checkState(!event2Model.isEmpty(), "The program execution has not been extracted yet");
        relation2Model.put(relation, relationModel);
    }

    public EventModel getEventModel(Event event) {
        return event2Model.get(event);
    }

    public Set<EventModel> getDomain() {
        return event2Model.values();
    }

    public ExecutionModel build() {
        final ExecutionModel executionModel = new ExecutionModel(
                thread2Model.values().stream()
                        .sorted(Comparator.comparingInt(ThreadModel::getThreadId)).toList(),
                memoryObject2Model.values().stream()
                        .sorted(Comparator.comparing(obj -> (BigInteger) obj.address().value())).toList(),
                relation2Model.values().stream().toList()
        );
        return executionModel;
    }

    public MappedExecutionModel buildMapped() {
        return new MappedExecutionModel(
                build(),
                new ModelMapping(event2Model, thread2Model, memoryObject2Model, relation2Model)
        );
    }

    // ==============================================================================================================
    // ========================================== Internal ==========================================================
    // ==============================================================================================================


    private void extractRelationModels(Set<Relation> relations, Set<EventModel> domain, IREvaluator evaluator) {
        final BiMap<EventModel, Event> model2Event = event2Model.inverse();

        for (Relation relation : relations) {
            final Map<EventModel, Set<EventModel>> edges = new HashMap<>();
            for (EventModel x : domain) {
                for (EventModel y : domain) {
                    if (evaluator.hasEdge(relation, model2Event.get(x), model2Event.get(y))) {
                        edges.computeIfAbsent(x, e -> new HashSet<>()).add(y);
                    }
                }
            }

            final RelationModel relationModel = new RelationModel(relation.getNameOrTerm(), edges);
            relation2Model.put(relation, relationModel);
        }
    }

    private void extractExecutionModel(Program program, IREvaluator evaluator) {
        for (Thread thread : program.getThreads()) {
            if (evaluator.threadHasStarted(thread)) {
                final ThreadModel threadModel = new ThreadModel(thread.getName(), thread.getId());
                thread2Model.put(thread, threadModel);
            }
        }

        for (MemoryObject memoryObject : program.getMemory().getObjects()) {
            if (evaluator.isAllocated(memoryObject)) {
                final MemoryObjectModel memoryObjectModel = new MemoryObjectModel(memoryObject.toString(),
                        evaluator.address(memoryObject), evaluator.size(memoryObject));
                memoryObject2Model.put(memoryObject, memoryObjectModel);
            }
        }

        for (Thread thread : program.getThreads()) {
            if (!evaluator.threadHasStarted(thread)) {
                continue;
            }

            final ThreadModel threadModel = thread2Model.get(thread);

            Event cur = thread.getEntry();
            while (cur != null) {
                if (skipEvent(cur)) {
                    cur = cur.getSuccessor();
                    continue;
                }

                assert evaluator.isInControlFlow(cur);
                final EventModel evModel = extractor.extract(cur);
                threadModel.append(evModel);

                if (cur instanceof Alloc alloc) {
                    memoryObject2Model.get(alloc.getAllocatedObject())
                            .setAllocationSite((AllocModel) event2Model.get(alloc));
                }

                if (cur instanceof CondJump jump && evaluator.jumpTaken(jump)) {
                    cur = jump.getLabel();
                } else if (cur instanceof BlockingEvent barrier && evaluator.isBlocked(barrier)) {
                    cur = null;
                } else {
                    cur = cur.getSuccessor();
                }
            }
        }
    }

    private boolean skipEvent(Event e) {
        return e instanceof CodeAnnotation;
    }

    // ------------------------------------------------------------------------------------------------------------
    // Helper classes

    private class EventExtractor implements EventVisitor<EventModel> {
        public EventModel extract(Event e) {
            if (event2Model.containsKey(e)) {
                return event2Model.get(e);
            }
            EventModel model = e.accept(this);
            event2Model.put(e, model);
            e.getTags().forEach(model.getTags()::add);
            return model;
        }

        @Override
        public EventModel visitEvent(Event e) {

            if (e instanceof ThreadArgument arg) {
                return new ThreadArgumentModel(
                        arg.getResultRegister(),
                        arg.getIndex(),
                        (ThreadCreateModel) extract(arg.getCreator())
                );
            } else if (e instanceof ThreadCreate create) {
                return new ThreadCreateModel(
                        thread2Model.get(create.getSpawnedThread()),
                        create.getArguments().stream().<TypedValue<?, ?>>map(arg -> evaluator.evaluateAt(arg, create)).toList()
                );
            } else if (e instanceof ThreadReturn ret) {
                return new ThreadReturnModel(ret.hasValue() ? evaluator.evaluateAt(ret.getValue().get(), ret) : null);
            } else if (e instanceof ThreadStart start) {
                final ThreadCreateModel creator = start.isSpawned() ? (ThreadCreateModel) extract(start.getCreator()) : null;
                return new ThreadStartModel(creator);
            } else if (e instanceof ThreadJoin join) {
                final boolean isBlocked = evaluator.isBlocked(join);
                return new ThreadJoinModel(
                        join.getResultRegister(),
                        isBlocked ? null : evaluator.result(join),
                        thread2Model.get(join.getJoinThread()),
                        isBlocked
                );
            } else if (e instanceof StateSnapshot snapshot) {
                return new StateSnapshotModel(
                        snapshot.getExpressions().stream()
                                .<TypedValue<?, ?>>map(arg -> evaluator.evaluateAt(arg, e)).toList()
                );
            }

            throw new UnsupportedOperationException("Unsupported event type " + e.getClass().getSimpleName());
        }

        @Override
        public EventModel visitAssume(Assume e) {
            return new AssumeModel(evaluator.evaluateBooleanAt(e.getExpr(), e));
        }

        @Override
        public EventModel visitAssert(Assert e) {
            return new AssertModel(
                    evaluator.evaluateBooleanAt(e.getExpression(), e),
                    e.getErrorMessage()
            );
        }

        @Override
        public CondJumpModel visitCondJump(CondJump e) {
            final boolean jumpTaken = evaluator.jumpTaken(e);
            final LabelModel target = jumpTaken ? (LabelModel) extract(e.getLabel()) : null;
            if (target != null) {
                event2Model.put(e.getLabel(), target);
            }
            return new CondJumpModel(evaluator.evaluateBooleanAt(e.getGuard(), e), target);
        }

        @Override
        public ControlBarrierModel visitControlBarrier(ControlBarrier e) {
            return new ControlBarrierModel(
                    e.getName(),
                    e.getInstanceId(),
                    e.getExecScope(),
                    evaluator.isBlocked(e)
            );
        }

        @Override
        public EventModel visitExecutionStatus(ExecutionStatus e) {
            final EventModel trackedEvent = evaluator.isExecuted(e.getStatusEvent()) ?
                    extract(e.getStatusEvent()) : null;
            return new ExecutionStatusModel(e.getResultRegister(), evaluator.result(e), trackedEvent);
        }

        @Override
        public CondJumpModel visitIfAsJump(IfAsJump e) {
            return visitCondJump(e);
        }

        @Override
        public LabelModel visitLabel(Label e) {
            return new LabelModel(e.getName());
        }

        @Override
        public LocalModel visitLocal(Local e) {
            return new LocalModel(e.getResultRegister(), evaluator.result(e));
        }

        @Override
        public GenericVisibleEventModel visitGenericVisibleEvent(GenericVisibleEvent e) {
            return new GenericVisibleEventModel(e.getName());
        }

        @Override
        public LoadModel visitLoad(Load e) {
            return new LoadModel(e.getResultRegister(), evaluator.address(e), evaluator.value(e));
        }

        @Override
        public StoreModel visitStore(Store e) {
            return new StoreModel(evaluator.address(e), evaluator.value(e));
        }

        @Override
        public InitModel visitInit(Init e) {
            return new InitModel(evaluator.address(e), evaluator.value(e));
        }

        @Override
        public AllocModel visitAlloc(Alloc e) {
            return new AllocModel(
                    e.getResultRegister(),
                    e.getAllocationType(),
                    evaluator.result(e),
                    evaluator.evaluateAt(e.getArraySize(), e),
                    evaluator.evaluateAt(e.getAlignment(), e),
                    e.isHeapAllocation()
            );
        }

        @Override
        public RMWStoreModel visitRMWStore(RMWStore e) {
            assert evaluator.isExecuted(e.getLoadEvent());
            final LoadModel loadModel = (LoadModel) extract(e.getLoadEvent());

            return new RMWStoreModel(loadModel, evaluator.address(e), evaluator.value(e));
        }

        @Override
        public RMWStoreExclusiveModel visitRMWStoreExclusive(RMWStoreExclusive e) {
            final boolean success = evaluator.isExecuted(e);
            return new RMWStoreExclusiveModel(evaluator.address(e), evaluator.value(e), e.isStrong(), success);
        }
    }
}
