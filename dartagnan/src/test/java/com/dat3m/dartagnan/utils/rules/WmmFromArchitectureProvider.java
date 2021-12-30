package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

import static com.dat3m.dartagnan.utils.ResourceHelper.CAT_RESOURCE_PATH;

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

    private static final Map<Arch, UncheckedSupplier<Wmm>> ARCH_WMM_MAP = new HashMap<>();

    static {
        ARCH_WMM_MAP.put(Arch.TSO, () -> new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/tso.cat")));
        ARCH_WMM_MAP.put(Arch.ARM8, () -> new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/aarch64.cat")));
        ARCH_WMM_MAP.put(Arch.POWER, () -> new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/power.cat")));
    }

    private final Supplier<Arch> archSupplier;
    private WmmFromArchitectureProvider(Supplier<Arch> archSupplier) {
        this.archSupplier = archSupplier;
    }

    public static Provider<Wmm> create(Supplier<Arch> archSupplier) {
        return new WmmFromArchitectureProvider(archSupplier);
    }

    @Override
    protected Wmm provide() throws Throwable {
        Supplier<Wmm> wmmSupplier = ARCH_WMM_MAP.get(archSupplier.get());
        if (wmmSupplier == null) {
            throw new IllegalArgumentException(String.format("The provided architecture %s has no associated memory model", archSupplier.get()));
        }
        return wmmSupplier.get();
    }
}
