package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;

import java.util.function.Supplier;

public class SettingsProvider extends Provider<Settings>  {

    private final Supplier<Alias> aliasSupplier;
    private final Supplier<Integer> boundSupplier;
    private final Supplier<Integer> timeoutSupplier;

    private SettingsProvider(Supplier<Alias> aliasSupplier, Supplier<Integer> boundSupplier, Supplier<Integer> timeoutSupplier) {
        this.aliasSupplier = aliasSupplier;
        this.boundSupplier = boundSupplier;
        this.timeoutSupplier = timeoutSupplier;
    }

    @Override
    protected Settings provide() {
        return new Settings(aliasSupplier.get(), boundSupplier.get(), timeoutSupplier.get());
    }

    public static class Builder {
        private Supplier<Alias> aliasSupplier = () -> Alias.CFIS;
        private Supplier<Integer> boundSupplier = () -> 1;
        private Supplier<Integer> timeoutSupplier = () -> 0;

        public SettingsProvider build() {
            return new SettingsProvider(aliasSupplier, boundSupplier, timeoutSupplier);
        }

        public Builder withAlias(Supplier<Alias> aliasSupplier) {
            this.aliasSupplier = aliasSupplier;
            return this;
        }

        public Builder withAlias(Alias alias) {
            return withAlias(() -> alias);
        }

        public Builder withBound(Supplier<Integer> boundSupplier) {
            this.boundSupplier = boundSupplier;
            return this;
        }

        public Builder withBound(Integer bound) {
            return withBound(() -> bound);
        }

        public Builder withTimeout(Supplier<Integer> timeoutSupplier) {
            this.timeoutSupplier = timeoutSupplier;
            return this;
        }

        public Builder withTimeout(Integer timeout) {
            return withBound(() -> timeout);
        }
    }
}
