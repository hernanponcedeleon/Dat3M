package com.dat3m.dartagnan.miscellaneous;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;

import java.io.File;

import static org.junit.Assert.assertNotNull;

public class PrinterTest {

	// Test to call toString() of most events
	
	@Test()
	public void PrintBpl1() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-1-O0.bpl"));
		assertNotNull(new Printer().print(p));
    	LoopUnrolling.newInstance().run(p);
    	Compilation.newInstance().run(p);
		assertNotNull(new Printer().print(p));
	}

	@Test()
	public void PrintBpl2() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "locks/linuxrwlock-3.bpl"));
		assertNotNull(new Printer().print(p));
    	LoopUnrolling.newInstance().run(p);
    	Compilation.newInstance().run(p);
		assertNotNull(new Printer().print(p));
	}

	@Test()
	public void PrintX86() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/MP+mfence-rmw+rmw-mfence.litmus"));
		assertNotNull(new Printer().print(p));
		assertNotNull(p.getAss().toString());
	}

	@Test()
	public void PrintPPC() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/MP+lwsync+data-wsi-rfi-ctrlisync.litmus"));
		assertNotNull(new Printer().print(p));
		assertNotNull(p.getAss().toString());
	}

	@Test()
	public void PrintAARCH64() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/MP+popl+poap.litmus"));
		assertNotNull(new Printer().print(p));
		assertNotNull(p.getAss().toString());
	}

	@Test()
	public void PrintLinux() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/C-rcu-link-after.litmus"));
		assertNotNull(new Printer().print(p));
		assertNotNull(p.getAss().toString());
	}

	@Test()
	public void PrintLinux2() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/LKMM/dart/C-atomic-fetch-simple-01.litmus"));
		assertNotNull(new Printer().print(p));
		assertNotNull(p.getAss().toString());
	}
	
	@Test()
	public void PrintLinux3() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/LKMM/manual/atomic/C-atomic-01.litmus"));
		assertNotNull(new Printer().print(p));
		assertNotNull(p.getAss().toString());
	}

	@Test()
	public void TSOtoString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/tso.cat"));
		assertNotNull(cat.toString());
	}

	@Test()
	public void AARCH64toString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/aarch64.cat"));
		assertNotNull(cat.toString());
	}

	@Test()
	public void PowertoString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/power.cat"));
		assertNotNull(cat.toString());
	}

	@Test()
	public void LinuxtoString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/linux-kernel.cat"));
		assertNotNull(cat.toString());
	}
}