package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.utils.rules.Providers;
import com.dat3m.dartagnan.verification.solving.AssumeSolver;
import com.dat3m.dartagnan.verification.solving.OnlineRefinementSolver;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;

import static com.dat3m.dartagnan.configuration.Arch.C11;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.Result.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class RC11LocksTest extends AbstractCTest {

    public RC11LocksTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> getTestResourcePath("locks/" + name + ".ll"));
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<Wmm> getWmmProvider() {
        return Providers.createWmmFromName(() -> "rc11");
    }

    @Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"ttas", C11, UNKNOWN},
                {"ttas-acq2rx", C11, FAIL},
                {"ttas-rel2rx", C11, FAIL},
                {"ticketlock", C11, PASS},
                {"ticketlock-acq2rx", C11, FAIL},
                {"ticketlock-rel2rx", C11, FAIL},
                {"mutex", C11, UNKNOWN},
                {"mutex-acq2rx_futex", C11, UNKNOWN},
                {"mutex-acq2rx_lock", C11, FAIL},
                {"mutex-rel2rx_futex", C11, UNKNOWN},
                {"mutex-rel2rx_unlock", C11, FAIL},
                {"spinlock", C11, PASS},
                {"spinlock-acq2rx", C11, FAIL},
                {"spinlock-rel2rx", C11, FAIL},
                {"linuxrwlock", C11, UNKNOWN},
                {"linuxrwlock-acq2rx", C11, FAIL},
                {"linuxrwlock-rel2rx", C11, FAIL},
                {"mutex_musl", C11, UNKNOWN},
                {"mutex_musl-acq2rx_futex", C11, UNKNOWN},
                {"mutex_musl-acq2rx_lock", C11, FAIL},
                {"mutex_musl-rel2rx_futex", C11, UNKNOWN},
                {"mutex_musl-rel2rx_unlock", C11, FAIL},
                {"seqlock", C11, PASS},
                {"clh_mutex", C11, UNKNOWN},
                {"clh_mutex-acq2rx", C11, FAIL},
                {"ticket_awnsb_mutex", C11, PASS},
                {"ticket_awnsb_mutex-acq2rx", C11, FAIL},
        });
    }

    //    @Test
    public void testAssume() throws Exception {
        AssumeSolver s = AssumeSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    @Test
    public void testRefinement() throws Exception {
        RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }

    @Test
    public void testOnlineRefinement() throws Exception {
        OnlineRefinementSolver s = OnlineRefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
        assertEquals(expected, s.getResult());
    }
}