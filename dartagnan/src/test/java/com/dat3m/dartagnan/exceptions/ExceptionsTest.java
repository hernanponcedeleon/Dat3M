package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.metadata.OriginalId;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.processing.BranchReordering;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import com.dat3m.dartagnan.program.processing.LoopUnrolling;
import com.dat3m.dartagnan.utils.ResourceHelper;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;

public class ExceptionsTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    @Test(expected = MalformedProgramException.class)
    public void RegisterAlreadyExist() throws Exception {
        Program program = new Program(SourceLanguage.LITMUS);
        Thread t = program.newThread("0");
        t.newRegister("r1", types.getNumberType());
        // Adding same register a second time
        t.newRegister("r1", types.getNumberType());
    }

    @Test(expected = IllegalArgumentException.class)
    public void reorderAfterUnrollException() throws Exception {
        Program program = new Program(SourceLanguage.LITMUS);
        program.newThread("0");
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
        LoopUnrolling.newInstance().run(program);
        // Reordering cannot be called after unrolling
        BranchReordering.newInstance().run(program);
    }

    @Test(expected = IllegalArgumentException.class)
    public void analyzeBeforeUnrollException() throws Exception {
        Program program = new Program(SourceLanguage.LITMUS);
        program.newThread("0");
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setMetadata(new OriginalId(e.getGlobalId())));
        Configuration config = Configuration.defaultConfiguration();
        // The program must be unrolled before being analyzed
        BranchEquivalence.fromConfig(program, config);
    }

    @Test(expected = IllegalArgumentException.class)
    public void diffPrecisionInt() throws Exception {
        // Both arguments should have same precision
        Register r1 = new Register("r1", 0, types.getIntegerType(32));
        Register r2 = new Register("r2", 0, types.getIntegerType(64));
        ExpressionFactory.getInstance().makeBinary(r1, IOpBin.PLUS, r2);
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