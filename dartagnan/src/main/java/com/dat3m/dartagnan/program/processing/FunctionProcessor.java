package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;

import java.util.Arrays;
import java.util.Objects;

public interface FunctionProcessor {
    void run(Function function);

    static FunctionProcessor chain(FunctionProcessor... processors) {
        return function -> Arrays.stream(processors).filter(Objects::nonNull).forEach(p -> p.run(function));
    }
}
