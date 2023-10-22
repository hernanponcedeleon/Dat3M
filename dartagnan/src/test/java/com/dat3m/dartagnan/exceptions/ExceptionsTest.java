package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.memory.Memory;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;
import java.math.BigInteger;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

public class ExceptionsTest {

    private static final TypeFactory types = TypeFactory.getInstance();

    @Test(expected = MalformedProgramException.class)
    public void noThread() {
        ProgramBuilder pb = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        // Thread 1 does not exist
        pb.addChild(1, new Skip());
    }

    @Test(expected = MalformedProgramException.class)
    public void RegisterAlreadyExist() {
        ProgramBuilder pb = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        Thread t = pb.newThread(0);
        t.newRegister("r1", types.getIntegerType());
        // Adding same register a second time
        t.newRegister("r1", types.getIntegerType());
    }

    @Test(expected = IllegalArgumentException.class)
    public void analyzeBeforeUnrollException() throws Exception {
        ProgramBuilder pb = ProgramBuilder.forLanguage(SourceLanguage.LITMUS);
        pb.newThread(0);
        Program p = pb.build();
        Configuration config = Configuration.defaultConfiguration();
        // The program must be unrolled before being able to construct an Encoder for it
        BranchEquivalence.fromConfig(p, config);
    }

    @Test(expected = IllegalArgumentException.class)
    public void diffPrecisionInt() {
        final Program program = new Program(new Memory(), SourceLanguage.LITMUS);
        final ExpressionFactory expressions = program.getEventFactory().getExpressionFactory();
        // Both arguments should have same precision
        Expression a = expressions.makeValue(BigInteger.ONE, types.getIntegerType(32));
        Expression b = expressions.makeValue(BigInteger.ONE, types.getIntegerType(64));
        expressions.makeADD(a, b);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullLabel() {
        final var program = new Program(new Memory(), SourceLanguage.LITMUS);
        final EventFactory events = program.getEventFactory();
        final ExpressionFactory expressions = events.getExpressionFactory();
        events.newJump(expressions.makeFalse(), null);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullExpr() {
        final var program = new Program(new Memory(), SourceLanguage.LITMUS);
        final EventFactory events = program.getEventFactory();
        events.newJump(null, events.newLabel("DUMMY"));
    }

    @Test(expected = MalformedProgramException.class)
    public void IllegalJump() throws Exception {
        new ProgramParser().parse(new File(getTestResourcePath("exceptions/IllegalJump.litmus")));
    }

    @Test(expected = IllegalStateException.class)
    public void LocationNotInitialized() throws Exception {
        new ProgramParser().parse(new File(getTestResourcePath("exceptions/LocationNotInitialized.litmus")));
    }

    @Test(expected = IllegalStateException.class)
    public void RegisterNotInitialized() throws Exception {
        new ProgramParser().parse(new File(getTestResourcePath("exceptions/RegisterNotInitialized.litmus")));
    }
}