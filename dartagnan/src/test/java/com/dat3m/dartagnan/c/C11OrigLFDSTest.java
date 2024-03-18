package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.OptionNames;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

@RunWith(Parameterized.class)
public class C11OrigLFDSTest extends C11LFDSTest {

    public C11OrigLFDSTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Configuration getConfiguration() throws InvalidConfigurationException {
        return Configuration.builder()
                .copyFrom(super.getConfiguration())
                .setOption(OptionNames.INIT_DYNAMIC_ALLOCATIONS, "true")
                .build();
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "c11-orig");
    }
}