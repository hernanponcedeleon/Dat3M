package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.processing.BranchReordering;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;

public class ExceptionsTest {

    @Test(expected = MalformedProgramException.class)
    public void RegisterAlreadyExist() throws Exception {
        Program program = new Program(SourceLanguage.LITMUS);
        Thread t = program.newThread("0");
        t.newRegister("r1", -1);
        // Adding same register a second time
        t.newRegister("r1", -1);
    }

    @Test(expected = IllegalArgumentException.class)
    public void reorderAfterUnrollException() throws Exception {
        Program program = new Program(SourceLanguage.LITMUS);
        program.newThread("0");
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setOId(e.getGlobalId()));
        LoopUnrolling.newInstance().run(program);
        // Reordering cannot be called after unrolling
        BranchReordering.newInstance().run(program);
    }

    @Test(expected = IllegalArgumentException.class)
    public void analyzeBeforeUnrollException() throws Exception {
        Program program = new Program(SourceLanguage.LITMUS);
        program.newThread("0");
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setOId(e.getGlobalId()));
        Configuration config = Configuration.defaultConfiguration();
        // The program must be unrolled before being analyzed
        BranchEquivalence.fromConfig(program, config);
    }

    @Test(expected = IllegalArgumentException.class)
    public void diffPrecisionInt() throws Exception {
        // Both arguments should have same precision
        new IExprBin(new Register("a", 0, 32), IOpBin.PLUS, new Register("b", 0, 64));
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullLabel() throws Exception {
        EventFactory.newJump(BConst.FALSE, null);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullExpr() throws Exception {
        EventFactory.newJump(null, EventFactory.newLabel("DUMMY"));
    }

    @Test(expected = MalformedProgramException.class)
    public void AtomicEndWithoutBegin() throws Exception {
        new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/AtomicEndWithoutBegin.bpl"));
    }

    @Test(expected = MalformedProgramException.class)
    public void IllegalJump() throws Exception {
        new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/IllegalJump.litmus"));
    }

    @Test(expected = IllegalStateException.class)
    public void LocationNotInitialized() throws Exception {
        new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/LocationNotInitialized.litmus"));
    }

    @Test(expected = IllegalStateException.class)
    public void RegisterNotInitialized() throws Exception {
        new ProgramParser().parse(new File(ResourceHelper.TEST_RESOURCE_PATH + "exceptions/RegisterNotInitialized.litmus"));
    }
}