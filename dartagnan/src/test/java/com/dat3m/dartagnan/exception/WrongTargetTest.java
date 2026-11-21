package com.dat3m.dartagnan.exception;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;


import static com.dat3m.dartagnan.configuration.OptionNames.TARGET;
import static com.dat3m.dartagnan.test.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.test.TestHelper.parseProgram;

public class WrongTargetTest {

    private static Compilation compilationTo(Arch target) throws InvalidConfigurationException {
        return Compilation.fromConfig(Configuration.builder().setOption(TARGET, target.toString()).build());
    }

    @Test(expected = IllegalArgumentException.class)
    public void X86CompiledToNone() throws Exception {
        Program p = parseProgram(getRootPath("litmus/X86/2+2W+mfence-rmws.litmus"));
        LoopUnrolling.newInstance().run(p);
        Compilation comp = compilationTo(Arch.C11);
        comp.run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void X86CompiledToPower() throws Exception {
        Program p = parseProgram(getRootPath("litmus/X86/2+2W+mfence-rmws.litmus"));
        LoopUnrolling.newInstance().run(p);
        Compilation comp = compilationTo(Arch.POWER);
        comp.run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void X86CompiledToARM8() throws Exception {
        Program p = parseProgram(getRootPath("litmus/X86/2+2W+mfence-rmws.litmus"));
        LoopUnrolling.newInstance().run(p);
        Compilation comp = compilationTo(Arch.ARM8);
        comp.run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void ARMCompiledToNone() throws Exception {
        Program p = parseProgram(getRootPath("litmus/AARCH64/ATOM/2+2W+poxxs.litmus"));
        LoopUnrolling.newInstance().run(p);
        Compilation comp = compilationTo(Arch.C11);
        comp.run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void ARMCompiledToTSO() throws Exception {
        Program p = parseProgram(getRootPath("litmus/AARCH64/ATOM/2+2W+poxxs.litmus"));
        LoopUnrolling.newInstance().run(p);
        Compilation comp = compilationTo(Arch.TSO);
        comp.run(p);
    }
}
