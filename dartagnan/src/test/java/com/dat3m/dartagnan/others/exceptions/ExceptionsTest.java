package com.dat3m.dartagnan.exceptions;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import java.lang.UnsupportedOperationException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Program.SourceLanguage;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.analysis.BranchEquivalence;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Skip;
import com.dat3m.dartagnan.program.processing.NormalizeLoops;

import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;
import java.math.BigInteger;

import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;

public class ExceptionsTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

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
        t.newRegister("r1", types.getIntegerType(64));
        // Adding same register a second time
        t.newRegister("r1", types.getIntegerType(64));
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
        // Both arguments should have same precision
        Expression a = expressions.makeValue(BigInteger.ONE, types.getIntegerType(32));
        Expression b = expressions.makeValue(BigInteger.ONE, types.getIntegerType(64));
        ExpressionFactory.getInstance().makeAdd(a, b);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullLabel() {
        EventFactory.newJump(expressions.makeFalse(), null);
    }

    @Test(expected = NullPointerException.class)
    public void JumpWithNullExpr() {
        EventFactory.newJump(null, EventFactory.newLabel("DUMMY"));
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

    @Test(expected = UnsupportedOperationException.class)
    public void UnsupportedLoopNormalization() throws Exception {
        Program p = new ProgramParser().parse(new File(getTestResourcePath("exceptions/unsupported-loop-normalization.ll")));
        Function main = p.getFunctionByName("main").get();
        NormalizeLoops.newInstance().run(main);
    }
}