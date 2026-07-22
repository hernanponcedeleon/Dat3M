package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.IREvaluator;

import java.util.EnumSet;

public interface TaskResult<TGoal extends TaskGoal> {

    TGoal getGoal();
    ResultStatus getStatus();

    // TODO: Maybe remove these two; they are not general for all types of tasks
    IREvaluator getModel();
    boolean hasModel();

    record Verify(ResultStatus result, IREvaluator model, TaskGoal.Verify goal) implements TaskResult<TaskGoal.Verify> {
        @Override
        public ResultStatus getStatus() {
            return result;
        }

        @Override
        public IREvaluator getModel() {
            return model;
        }

        @Override
        public boolean hasModel() {
            return model != null;
        }

        @Override
        public TaskGoal.Verify getGoal() {
            return goal;
        }

        public EnumSet<Property> getProperties() {
            return goal.properties();
        }
    }
}
