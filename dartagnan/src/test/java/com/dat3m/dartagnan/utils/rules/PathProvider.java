package com.dat3m.dartagnan.utils.rules;

import org.junit.rules.ExternalResource;

import java.util.function.Function;
import java.util.function.Supplier;

public class PathProvider extends ExternalResource implements Supplier<String> {

    private final Supplier<String> pathProvider;
    private final Function<String, String> pathTransformer;

    private String path;
    public String get() { return path; }

    private PathProvider(Supplier<String> pathProvider, Function<String, String> pathTransformer) {
        this.pathProvider = pathProvider;
        this.pathTransformer = pathTransformer;
    }

    @Override
    protected void before() throws Throwable {
        path = pathTransformer.apply(pathProvider.get());
    }

    public static PathProvider addPrefix(Supplier<String> pathProvider, String prefix) {
        return new PathProvider(pathProvider, p -> prefix + p);
    }
}
