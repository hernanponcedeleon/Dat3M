package com.dat3m.dartagnan.task.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.model.Execution;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.task.TaskResult;
import com.google.common.base.Preconditions;

import java.util.EnumSet;
import java.util.Set;

import static com.dat3m.dartagnan.configuration.Property.TRACKABILITY;

/*
    The result of a verification task. If the solver found an execution (e.g. a counterexample),
    the result contains it as an Execution, which is independent of the solver's SMT model.
 */
public final class VerificationResult implements TaskResult<VerificationTask> {

    private final VerificationTask task;
    private final VerificationStatus status;
    private final Execution execution;
    private final Set<Property> violatedProperties;
    private final Set<MemoryObject> untrackableObjects;

    private VerificationResult(VerificationTask task, VerificationStatus status, Execution execution,
                               Set<Property> violatedProperties, Set<MemoryObject> untrackableObjects) {
        this.task = Preconditions.checkNotNull(task);
        this.status = status;
        this.execution = execution;
        this.violatedProperties = Set.copyOf(violatedProperties);
        this.untrackableObjects = Set.copyOf(untrackableObjects);
    }

    public static VerificationResult withoutExecution(VerificationTask task, VerificationStatus status) {
        return new VerificationResult(task, status, null, Set.of(), Set.of());
    }

    // Extracts everything needed from the model. The model is not kept and can be closed afterward.
    public static VerificationResult fromModel(VerificationTask task, VerificationStatus status, IREvaluator model) {
        final Set<Property> violated = EnumSet.noneOf(Property.class);
        task.getProperties().stream().filter(model::propertyViolated).forEach(violated::add);
        final Set<MemoryObject> untrackable = violated.contains(TRACKABILITY)
                ? Set.copyOf(task.getProgram().getMemory().getObjects().stream()
                        .filter(o -> model.isLeaked(o) && !model.isTrackable(o)).toList())
                : Set.of();
        return new VerificationResult(task, status, Execution.fromModel(model), violated, untrackable);
    }

    public VerificationStatus getStatus() {
        return status;
    }

    public boolean hasExecution() {
        return execution != null;
    }

    public Execution getExecution() {
        Preconditions.checkState(hasExecution(), "No execution available");
        return execution;
    }

    // Whether the solver reports the property as violated by the found execution.
    public boolean isViolated(Property property) {
        return violatedProperties.contains(property);
    }

    public Set<Property> getViolatedProperties() {
        return violatedProperties;
    }

    // Heap objects that leak without being trackable (only computed if TRACKABILITY is violated).
    public Set<MemoryObject> getUntrackableObjects() {
        return untrackableObjects;
    }

    @Override
    public VerificationTask getTask() {
        return task;
    }

    @Override
    public String toString() {
        return "VerificationResult[property=%s, status=%s, execution=%s]".formatted(
                task.getProperties(), status, hasExecution() ? "yes" : "no"
        );
    }

}
