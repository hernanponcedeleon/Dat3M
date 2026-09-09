package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.wmm.Wmm;
import org.junit.Test;

import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.utils.TestHelper.parseProgram;
import static com.dat3m.dartagnan.utils.TestHelper.parseWmm;
import static org.junit.Assert.assertNotNull;

public class PrinterTest {

    // Test to call toString() of most events

    @Test()
    public void Printll() throws Exception {
        Program p = parseProgram(getTestResourcePath("locks/linuxrwlock.ll"));
        assertNotNull(Printer.newInstance().print(p));
        Compilation.newInstance().run(p);
        LoopUnrolling.newInstance().run(p);
        assertNotNull(Printer.newInstance().print(p));
    }

    @Test()
    public void PrintX86() throws Exception {
        Program p = parseProgram(getTestResourcePath("litmus/MP+mfence-rmw+rmw-mfence.litmus"));
        assertNotNull(Printer.newInstance().print(p));
        assertNotNull(p.getSpecification().toString());
    }

    @Test()
    public void PrintPPC() throws Exception {
        Program p = parseProgram(getTestResourcePath("litmus/MP+lwsync+data-wsi-rfi-ctrlisync.litmus"));
        assertNotNull(Printer.newInstance().print(p));
        assertNotNull(p.getSpecification().toString());
    }

    @Test()
    public void PrintAARCH64() throws Exception {
        Program p = parseProgram(getTestResourcePath("litmus/MP+popl+poap.litmus"));
        assertNotNull(Printer.newInstance().print(p));
        assertNotNull(p.getSpecification().toString());
    }

    @Test()
    public void PrintLinux() throws Exception {
        Program p = parseProgram(getTestResourcePath("litmus/C-rcu-link-after.litmus"));
        assertNotNull(Printer.newInstance().print(p));
        assertNotNull(p.getSpecification().toString());
    }

    @Test()
    public void PrintLinux2() throws Exception {
        Program p = parseProgram(getRootPath("litmus/LKMM/dart/C-atomic-fetch-simple-01.litmus"));
        assertNotNull(Printer.newInstance().print(p));
        assertNotNull(p.getSpecification().toString());
    }

    @Test()
    public void PrintLinux3() throws Exception {
        Program p = parseProgram(getRootPath("litmus/LKMM/manual/atomic/C-atomic-01.litmus"));
        assertNotNull(Printer.newInstance().print(p));
        assertNotNull(p.getSpecification().toString());
    }

    @Test()
    public void TSOtoString() throws Exception {
        Wmm cat = parseWmm(getRootPath("cat/tso.cat"));
        assertNotNull(cat.toString());
    }

    @Test()
    public void AARCH64toString() throws Exception {
        Wmm cat = parseWmm(getRootPath("cat/aarch64.cat"));
        assertNotNull(cat.toString());
    }

    @Test()
    public void PowertoString() throws Exception {
        Wmm cat = parseWmm(getRootPath("cat/power.cat"));
        assertNotNull(cat.toString());
    }

    @Test()
    public void LinuxtoString() throws Exception {
        Wmm cat = parseWmm(getRootPath("cat/linux-kernel.cat"));
        assertNotNull(cat.toString());
    }
}