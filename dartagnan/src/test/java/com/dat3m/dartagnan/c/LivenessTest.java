package com.dat3m.dartagnan.c;

import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.rules.CSVLogger;
import com.dat3m.dartagnan.utils.rules.Provider;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;

import static com.dat3m.dartagnan.utils.ResourceHelper.TEST_RESOURCE_PATH;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.configuration.Arch.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LivenessTest extends AbstractCTest {
	
    public LivenessTest(String name, Arch target, Result expected) {
        super(name, target, expected);
    }

    @Override
    protected Provider<String> getProgramPathProvider() {
        return Provider.fromSupplier(() -> TEST_RESOURCE_PATH + name + ".bpl");
    }

    @Override
    protected long getTimeout() {
        return 60000;
    }

    @Override
    protected Provider<EnumSet<Property>> getPropertyProvider() {
        return Provider.fromSupplier(() -> EnumSet.of(Property.LIVENESS));
    }

	@Parameterized.Parameters(name = "{index}: {0}, target={1}")
    public static Iterable<Object[]> data() throws IOException {
    	return Arrays.asList(new Object[][]{
	            {"locks/ttas-5", TSO, UNKNOWN},
	            {"locks/ttas-5", ARM8, UNKNOWN},
	            {"locks/ttas-5", POWER, UNKNOWN},
	            {"locks/ttas-5", RISCV, UNKNOWN},
	            {"locks/ttas-5-acq2rx", TSO, UNKNOWN},
	            {"locks/ttas-5-acq2rx", ARM8, UNKNOWN},
	            {"locks/ttas-5-acq2rx", POWER, UNKNOWN},
	            {"locks/ttas-5-acq2rx", RISCV, UNKNOWN},
	            {"locks/ttas-5-rel2rx", TSO, UNKNOWN},
	            {"locks/ttas-5-rel2rx", ARM8, UNKNOWN},
	            {"locks/ttas-5-rel2rx", POWER, UNKNOWN},
	            {"locks/ttas-5-rel2rx", RISCV, UNKNOWN},
	            {"locks/ticketlock-3", TSO, PASS},
	            {"locks/ticketlock-3", ARM8, PASS},
	            {"locks/ticketlock-3", POWER, PASS},
	            {"locks/ticketlock-3", RISCV, PASS},
	            {"locks/ticketlock-3-acq2rx", TSO, PASS},
	            {"locks/ticketlock-3-acq2rx", ARM8, PASS},
	            {"locks/ticketlock-3-acq2rx", POWER, PASS},
	            {"locks/ticketlock-3-acq2rx", RISCV, PASS},
	            {"locks/ticketlock-3-rel2rx", TSO, PASS},
	            {"locks/ticketlock-3-rel2rx", ARM8, PASS},
	            {"locks/ticketlock-3-rel2rx", POWER, PASS},
	            {"locks/ticketlock-3-rel2rx", RISCV, PASS},
                {"locks/mutex-3", TSO, UNKNOWN},
                {"locks/mutex-3", ARM8, UNKNOWN},
                {"locks/mutex-3", POWER, UNKNOWN},
                {"locks/mutex-3", RISCV, UNKNOWN},
                {"locks/mutex-3-acq2rx_futex", TSO, UNKNOWN},
                {"locks/mutex-3-acq2rx_futex", ARM8, FAIL},
                {"locks/mutex-3-acq2rx_futex", POWER, FAIL},
                {"locks/mutex-3-acq2rx_futex", RISCV, FAIL},
                {"locks/mutex-3-acq2rx_lock", TSO, UNKNOWN},
                {"locks/mutex-3-acq2rx_lock", ARM8, UNKNOWN},
                {"locks/mutex-3-acq2rx_lock", POWER, UNKNOWN},
                {"locks/mutex-3-acq2rx_lock", RISCV, UNKNOWN},
                {"locks/mutex-3-rel2rx_futex", TSO, UNKNOWN},
                {"locks/mutex-3-rel2rx_futex", ARM8, FAIL},
                {"locks/mutex-3-rel2rx_futex", POWER, FAIL},
                {"locks/mutex-3-rel2rx_futex", RISCV, FAIL},
                {"locks/mutex-3-rel2rx_unlock", TSO, UNKNOWN},
                {"locks/mutex-3-rel2rx_unlock", ARM8, UNKNOWN},
                {"locks/mutex-3-rel2rx_unlock", POWER, UNKNOWN},
                {"locks/mutex-3-rel2rx_unlock", RISCV, UNKNOWN},
                {"locks/spinlock-5", TSO, UNKNOWN},
                {"locks/spinlock-5", ARM8, UNKNOWN},
                {"locks/spinlock-5", POWER, UNKNOWN},
                {"locks/spinlock-5", RISCV, UNKNOWN},
                {"locks/spinlock-5-acq2rx", TSO, UNKNOWN},
                {"locks/spinlock-5-acq2rx", ARM8, UNKNOWN},
                {"locks/spinlock-5-acq2rx", POWER, UNKNOWN},
                {"locks/spinlock-5-acq2rx", RISCV, UNKNOWN},
                {"locks/spinlock-5-rel2rx", TSO, UNKNOWN},
                {"locks/spinlock-5-rel2rx", ARM8, UNKNOWN},
                {"locks/spinlock-5-rel2rx", POWER, UNKNOWN},
                {"locks/spinlock-5-rel2rx", RISCV, UNKNOWN},
                {"locks/linuxrwlock-3", TSO, UNKNOWN},
                {"locks/linuxrwlock-3", ARM8, UNKNOWN},
                {"locks/linuxrwlock-3", POWER, UNKNOWN},
                {"locks/linuxrwlock-3", RISCV, UNKNOWN},
                {"locks/linuxrwlock-3-acq2rx", TSO, UNKNOWN},
                {"locks/linuxrwlock-3-acq2rx", ARM8, UNKNOWN},
                {"locks/linuxrwlock-3-acq2rx", POWER, UNKNOWN},
                {"locks/linuxrwlock-3-acq2rx", RISCV, UNKNOWN},
                {"locks/linuxrwlock-3-rel2rx", TSO, UNKNOWN},
                {"locks/linuxrwlock-3-rel2rx", ARM8, UNKNOWN},
                {"locks/linuxrwlock-3-rel2rx", POWER, UNKNOWN},
                {"locks/linuxrwlock-3-rel2rx", RISCV, UNKNOWN},
                {"locks/mutex_musl-3", TSO, UNKNOWN},
                {"locks/mutex_musl-3", ARM8, UNKNOWN},
                {"locks/mutex_musl-3", POWER, UNKNOWN},
                {"locks/mutex_musl-3", RISCV, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_futex", TSO, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_futex", ARM8, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_futex", POWER, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_futex", RISCV, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_lock", TSO, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_lock", ARM8, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_lock", POWER, UNKNOWN},
                {"locks/mutex_musl-3-acq2rx_lock", RISCV, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_futex", TSO, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_futex", ARM8, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_futex", POWER, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_futex", RISCV, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_unlock", TSO, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_unlock", ARM8, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_unlock", POWER, UNKNOWN},
                {"locks/mutex_musl-3-rel2rx_unlock", RISCV, UNKNOWN},
                {"locks/seqlock-6", TSO, UNKNOWN},
                {"locks/seqlock-6", ARM8, UNKNOWN},
                {"locks/seqlock-6", POWER, UNKNOWN},
                {"locks/seqlock-6", RISCV, UNKNOWN},
                {"lkmm/qspinlock-liveness", LKMM, FAIL},
                {"lkmm/qspinlock-liveness", ARM8, PASS},
                {"lkmm/qspinlock-liveness", POWER, PASS},
                {"lkmm/qspinlock-liveness", RISCV, PASS},
		});
    }

    @Test
	@CSVLogger.FileName("csv/refinement")
	public void testRefinement() throws Exception {
		RefinementSolver s = RefinementSolver.run(contextProvider.get(), proverProvider.get(), taskProvider.get());
		assertEquals(expected, s.getResult());
	}
}