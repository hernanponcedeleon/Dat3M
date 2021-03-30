package com.dat3m.dartagnan.utils.recursion;

import java.util.function.Supplier;

public abstract class RecursiveAction {
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
            first = first.process();
            return first.isDone() ? then : this;
        }
    }
}









