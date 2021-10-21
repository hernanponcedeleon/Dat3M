package com.dat3m.dartagnan.utils.rules;

import java.util.function.Function;
import java.util.function.Supplier;

public class PathProvider extends AbstractProvider<String> {

    private final Supplier<String> pathProvider;
    private final Function<String, String> pathTransformer;

    private PathProvider(Supplier<String> pathProvider, Function<String, String> pathTransformer) {
        this.pathProvider = pathProvider;
        this.pathTransformer = pathTransformer;
    }

    @Override
    protected String provide() throws Throwable {
        return pathTransformer.apply(pathProvider.get());
    }


    public static PathProvider addPrefix(Supplier<String> pathProvider, String prefix) {
        return new PathProvider(pathProvider, p -> prefix + p);
    }
}
