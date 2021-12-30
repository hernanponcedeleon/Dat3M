package com.dat3m.dartagnan.miscellaneous;

import java.io.File;

import org.junit.Test;

import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;

public class PrinterTest {

	// Test to call toString() of most events
	
	@Test()
	public void PrintBpl1() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "boogie/concurrency/fib_bench-1-O0.bpl"));
		assert(new Printer().print(p) != null);
		p.unroll(1, 0);
		p.compile(Arch.NONE, 0);
		assert(new Printer().print(p) != null);
	}

	@Test()
	public void PrintBpl2() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "locks/linuxrwlock-3.bpl"));
		assert(new Printer().print(p) != null);
		p.unroll(1, 0);
		p.compile(Arch.NONE, 0);
		assert(new Printer().print(p) != null);
	}

	@Test()
	public void PrintX86() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/MP+mfence-rmw+rmw-mfence.litmus"));
		assert(new Printer().print(p) != null);
	}

	@Test()
	public void PrintPPC() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/MP+lwsync+data-wsi-rfi-ctrlisync.litmus"));
		assert(new Printer().print(p) != null);
	}

	@Test()
	public void PrintAARCH64() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/MP+popl+poap.litmus"));
		assert(new Printer().print(p) != null);
	}

	@Test()
	public void PrintLinux() throws Exception {
		Program p = new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "litmus/C-rcu-link-after.litmus"));
		assert(new Printer().print(p) != null);
	}

	@Test()
	public void TSOtoString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/tso.cat"));
		assert(cat.toString() != null);
	}

	@Test()
	public void AARCH64toString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/aarch64.cat"));
		assert(cat.toString() != null);
	}

	@Test()
	public void PowertoString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/power.cat"));
		assert(cat.toString() != null);
	}

	@Test()
	public void LinuxtoString() throws Exception {
		Wmm cat = new ParserCat().parse(new File(ResourceHelper.CAT_RESOURCE_PATH+ "cat/linux-kernel.cat"));
		assert(cat.toString() != null);
	}
}