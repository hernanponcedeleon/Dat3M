package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.processing.BranchReordering;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;

public class ExceptionsTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    @Test(expected = MalformedProgramException.class)
    public void noThread() throws Exception {
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        // Thread 1 does not exists
        pb.addChild(1, new Skip());
    }

    @Test(expected = MalformedProgramException.class)
    public void RegisterAlreadyExist() throws Exception {
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        pb.initThread(0);
        Thread t = pb.build().getThreads().get(0);
        t.newRegister("r1", types.getIntegerType());
        // Adding same register a second time
        t.newRegister("r1", types.getIntegerType());
    }

    @Test(expected = IllegalArgumentException.class)
    public void reorderAfterUnrollException() throws Exception {
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        pb.initThread(0);
        Program p = pb.build();
        LoopUnrolling.newInstance().run(p);
        // Reordering cannot be called after unrolling
        BranchReordering.newInstance().run(p);
    }

    @Test(expected = IllegalArgumentException.class)
    public void analyzeBeforeUnrollException() throws Exception {
        ProgramBuilder pb = new ProgramBuilder(SourceLanguage.LITMUS);
        pb.initThread(0);
        Program p = pb.build();
        Configuration config = Configuration.defaultConfiguration();
        // The program must be unrolled before being able to construct an Encoder for it
        BranchEquivalence.fromConfig(p, config);
    }

    @Test(expected = IllegalArgumentException.class)
    public void diffPrecisionInt() throws Exception {
        // Both arguments should have same precision
        Register a = new Register("a", 0, types.getIntegerType(32));
        Register b = new Register("b", 0, types.getIntegerType(64));
        ExpressionFactory.getInstance().makeADD(a, b);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullLabel() throws Exception {
        EventFactory.newJump(ExpressionFactory.getInstance().makeFalse(), null);
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