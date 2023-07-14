package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Function;

import java.util.Arrays;

public interface FunctionProcessor {
    void run(Function function);

    static FunctionProcessor chain(FunctionProcessor... processors) {
        return function -> Arrays.asList(processors).forEach(p -> p.run(function));
    }
}
