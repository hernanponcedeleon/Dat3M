package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public class C11OrigLocksTest extends C11LocksTest {

    public C11OrigLocksTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "c11-orig");
    }
}