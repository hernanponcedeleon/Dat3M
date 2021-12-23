package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.ResourceHelper;
import com.dat3m.dartagnan.wmm.utils.Arch;

import java.io.File;

import org.junit.Test;

public class WrongTargetTest {

    @Test(expected = UnsupportedOperationException.class)
    public void X86CompiledToNone() throws Exception {
    	Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/X86/2+2W+mfence-rmws.litmus"));
    	p.unroll(1, 0);
    	p.compile(Arch.NONE, 0);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void X86CompiledToPower() throws Exception {
    	Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/X86/2+2W+mfence-rmws.litmus"));
    	p.unroll(1, 0);
    	p.compile(Arch.POWER, 0);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void X86CompiledToARM8() throws Exception {
    	Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/X86/2+2W+mfence-rmws.litmus"));
    	p.unroll(1, 0);
    	p.compile(Arch.ARM8, 0);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void ARMCompiledToNone() throws Exception {
    	Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/AARCH64/ATOM/2+2W+poxxs.litmus"));
    	p.unroll(1, 0);
    	p.compile(Arch.NONE, 0);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void ARMCompiledToTSO() throws Exception {
    	Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/AARCH64/ATOM/2+2W+poxxs.litmus"));
    	p.unroll(1, 0);
    	p.compile(Arch.TSO, 0);
    }

    @Test(expected = UnsupportedOperationException.class)
    public void ARMCompiledToPower() throws Exception {
    	Program p = new ProgramParser().parse(new File(ResourceHelper.LITMUS_RESOURCE_PATH + "litmus/AARCH64/ATOM/2+2W+poxxs.litmus"));
    	p.unroll(1, 0);
    	p.compile(Arch.POWER, 0);
    }
}
