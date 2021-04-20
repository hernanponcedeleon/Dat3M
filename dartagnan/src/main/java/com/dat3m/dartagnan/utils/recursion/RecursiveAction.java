package com.dat3m.dartagnan.utils.recursion;

import java.util.function.Supplier;

public abstract class RecursiveAction {

    @SuppressWarnings("all")
	private static final Done DONE = new Done();

    protected boolean isDone() { return false; }
    protected abstract RecursiveAction process();

    public void execute() {
        RecursiveAction action = this;
        while (!action.isDone())
            action = action.process();
    }

    public RecursiveAction then(RecursiveAction then) {
        return new Then(this, then);
    }

    public RecursiveAction then(Supplier<RecursiveAction> call) {
        return new Then(this, call(call));
    }

    public RecursiveAction then(Runnable call) {
        return new Then(this, call(call));
    }

    public static RecursiveAction done() {
        return DONE;
    }

    public static RecursiveAction call(Supplier<RecursiveAction> call) {
        return new Call(call);
    }

    public static RecursiveAction call(Runnable call) {
        return call(() -> {
            call.run();
            return done();
        });
    }

    public static void execute(Supplier<RecursiveAction> call) {
        call(call).execute();
    }


    // ===================== Inner classes =====================

    static class Done extends RecursiveAction {
        @Override
        public boolean isDone() { return true; }
        @Override
        public RecursiveAction process() { return this; }
    }

    static class Call extends RecursiveAction {
        private final Supplier<RecursiveAction> call;

        public Call(Supplier<RecursiveAction> call) { this.call = call; }

        @Override
        public RecursiveAction process() { return call.get(); }
    }

    static class Then extends RecursiveAction {
        RecursiveAction first;
        final RecursiveAction then;

        public Then(RecursiveAction first, RecursiveAction then) {
            this.first = first;
            this.then = then;
        }

        @Override
        public RecursiveAction process() {
            first = first.process(); // Note: This can lead to deep recursion if there are many successive Then's
            return first.isDone() ? then : this;
        }
    }
}