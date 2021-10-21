package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import org.apache.logging.log4j.LogManager;
import org.junit.rules.ExternalResource;

import java.io.File;
import java.io.IOException;
import java.util.function.Supplier;

import static com.dat3m.dartagnan.utils.ResourceHelper.CAT_RESOURCE_PATH;

public class WmmProvider extends ExternalResource implements Supplier<Wmm> {

    private static Wmm MM_TSO;
    private static Wmm MM_ARM8;
    private static Wmm MM_POWER;

    static {
        try {
            MM_TSO = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/tso.cat"));
            MM_ARM8 = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/aarch64.cat"));
            MM_POWER = new ParserCat().parse(new File(CAT_RESOURCE_PATH + "cat/power.cat"));
        } catch (IOException e) {
            LogManager.getRootLogger().error(e.getMessage());
        }
    }

    private final Supplier<Arch> archSupplier;
    private Wmm wmm;

    public Wmm get() {
        return wmm;
    }

    public WmmProvider(Supplier<Arch> archSupplier) {
        this.archSupplier = archSupplier;
    }

    @Override
    protected void before() throws Throwable {
        switch (archSupplier.get()) {
            case TSO:
                wmm = MM_TSO;
                break;
            case ARM8:
                wmm = MM_ARM8;
                break;
            case POWER:
                wmm = MM_POWER;
                break;
        }
    }
}
