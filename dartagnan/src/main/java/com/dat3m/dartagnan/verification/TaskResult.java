package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.encoding.IREvaluator;

public interface TaskResult {

    ResultStatus getStatus();

    record Verify(ResultStatus result, IREvaluator model) implements TaskResult {
        @Override
        public ResultStatus getStatus() {
            return result;
        }

        public boolean hasModel() {
            return model != null;
        }
    }
}
