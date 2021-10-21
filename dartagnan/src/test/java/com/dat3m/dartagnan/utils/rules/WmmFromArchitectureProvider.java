package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.apache.logging.log4j.LogManager;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

import static com.dat3m.dartagnan.utils.ResourceHelper.CAT_RESOURCE_PATH;

public class WmmFromArchitectureProvider extends AbstractProvider<Wmm> {


    private static final Map<Arch, Wmm> ARCH_WMM_MAP = new HashMap<>();

    static {
        try {
            ARCH_WMM_MAP.put(Arch.TSO, new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/tso.cat")));
            ARCH_WMM_MAP.put(Arch.ARM8, new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/aarch64.cat")));
            ARCH_WMM_MAP.put(Arch.ARM, new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/arm.cat")));
            ARCH_WMM_MAP.put(Arch.POWER, new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/power.cat")));
        } catch (IOException e) {
            LogManager.getRootLogger().error(e.getMessage());
        }
    }

    private final Supplier<Arch> archSupplier;
    public WmmFromArchitectureProvider(Supplier<Arch> archSupplier) {
        this.archSupplier = archSupplier;
    }

    @Override
    protected Wmm provide() throws Throwable {
        Wmm wmm = ARCH_WMM_MAP.get(archSupplier.get());
        if (wmm == null) {
            throw new IllegalArgumentException(String.format("The provided architecture %s has no associated memory model", archSupplier.get()));
        }
        return wmm;
    }
}
