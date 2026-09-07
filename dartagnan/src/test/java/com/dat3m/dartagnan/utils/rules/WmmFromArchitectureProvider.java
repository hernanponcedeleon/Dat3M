package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.configuration.Arch;

import java.nio.file.Path;
import java.util.function.Supplier;

/*
    DESC: This Provider provides the canonical Wmm (.cat) associated with a target architecture.

    NOTE: The .cat file gets re-parsed for each test. This is different to our previous behavior where
    we reused a single Wmm throughout all tests. However, this is problematic as
    - It breaks as soon as we modify the Wmms during verification.
    - We have very short timeouts because then a next test might start while the previous is still
      performing its relational analysis, causing ConcurrentModificationExceptions (this does not happen for
      reasonable timeouts, but it is still unexpected behavior).
 */
public class WmmFromArchitectureProvider extends AbstractProvider<Wmm> {

    private final Supplier<Arch> archSupplier;
    private WmmFromArchitectureProvider(Supplier<Arch> archSupplier) {
        this.archSupplier = archSupplier;
    }

    public static Provider<Wmm> create(Supplier<Arch> archSupplier) {
        return new WmmFromArchitectureProvider(archSupplier);
    }

    @Override
    protected Wmm provide() {
        final Path path = ResourceHelper.getCatPath(archSupplier.get(), null);
        return Providers.createWmmFromPath(() -> path).get();
    }
}
