package com.dat3m.dartagnan.utils.recursion;

import java.util.function.Function;
import java.util.function.Supplier;

public abstract class RecursiveFunction<T> {

    protected boolean isDone() {
    	return false;
    }
    
    protected T getFinalValue() {
    	return null;
    }
    
    protected abstract RecursiveFunction<T> process();

    public T execute() {
        RecursiveFunction<T> func = this;
        while (!func.isDone())
            func = func.process();
        return func.getFinalValue();
    }

    public <V> RecursiveFunction<V> then(Function<? super T, RecursiveFunction<V>> then) {
        return new Then<>(this, then);
    }

    public static <T> RecursiveFunction<T> done(T value) {
        return new Done<>(value);
    }

    public static <T> RecursiveFunction<T> call(Supplier<RecursiveFunction<T>> call) {
        return new Call<>(call);
    }

    public static <T> T execute(Supplier<RecursiveFunction<T>> call) {
        return call(call).execute();
    }


    // ================ Inner classes  ================

    static class Call<T> extends RecursiveFunction<T> {
        private final Supplier<RecursiveFunction<T>> call;

        public Call(Supplier<RecursiveFunction<T>> call) { this.call = call; }

        @Override
        public RecursiveFunction<T> process() { return call.get(); }
    }

    static class Done<T> extends RecursiveFunction<T> {
        final T value;

        public Done(T value) { this.value = value; }

        @Override
        public boolean isDone() { return true; }
        @Override
        public T getFinalValue() { return value; }
        @Override
        public RecursiveFunction<T> process() { return this; }
    }

    static class Then<T, V> extends RecursiveFunction<V> {
        RecursiveFunction<T> first;
        final Function<? super T, RecursiveFunction<V>> then;

        public Then(RecursiveFunction<T> first, Function<? super T, RecursiveFunction<V>> then) {
            this.first = first;
            this.then = then;
        }

        @Override
        public RecursiveFunction<V> process() {
            first = first.process(); // Note: This can lead to deep recursion if there are many successive Then's
            return first.isDone() ? then.apply(first.getFinalValue()) : this;
        }
    }
}