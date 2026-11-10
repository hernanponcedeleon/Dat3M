package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.Dealloc;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class PointerWidthVerificationTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Parameterized.Parameters(name = "pointer width: {0}")
    public static List<Integer> pointerWidths() {
        return List.of(32, 64);
    }

    @Parameterized.Parameter
    public int pointerWidth;

    private Program program;
    private Function function;
    private IntegerType addressType;
    private IntegerType wrongWidthType;

    @Before
    public void setUp() {
        program = new Program(new Memory(false, pointerWidth), Program.SourceLanguage.LLVM);
        function = new Function("f", types.getFunctionType(types.getVoidType(), List.of()), List.of(), 0, null);
        program.addFunction(function);
        addressType = program.getArchType();
        wrongWidthType = types.getIntegerType(pointerWidth == 32 ? 64 : 32);
    }

    @Test
    public void acceptsProgramWidthAndIndependentIntegerWidths() {
        final Register address = function.newRegister("address", addressType);
        final Register value = function.newRegister("value", types.getByteType());
        final Expression count = expressions.makeValue(1, types.getIntegerType(16));
        final Expression alignment = expressions.makeValue(8, types.getIntegerType(16));
        final Expression gep = expressions.makeGetElementPointer(types.getByteType(), address, List.of(count));
        final Alloc allocation = new Alloc(address, types.getByteType(), count, alignment, false, false);
        final Load load = EventFactory.newLoad(value, gep);
        final Store store = EventFactory.newStore(gep, value);
        final Dealloc deallocation = EventFactory.newDealloc(address);
        function.append(List.of(allocation, load, store, deallocation));
        final MemoryObject object = program.getMemory().allocate(8);
        final Expression initialValue = expressions.makeGetElementPointer(types.getByteType(), object, List.of(count));
        object.setInitialValue(0, initialValue);

        PointerWidthVerification.newInstance().run(program);

        assertSame(count, allocation.getArraySize());
        assertSame(alignment, allocation.getAlignment());
        assertSame(gep, load.getAddress());
        assertSame(gep, store.getAddress());
        assertSame(address, deallocation.getAddress());
        assertSame(initialValue, object.getInitialValue(0));
    }

    @Test
    public void rejectsWrongAllocationResultWidth() {
        final Register address = function.newRegister("address", wrongWidthType);
        function.append(EventFactory.newAlloc(address, types.getByteType(),
                expressions.makeValue(1, wrongWidthType), false, false));

        assertRejected("Allocation result");
    }

    @Test
    public void rejectsNonIntegerAllocationResult() {
        final Register address = function.newRegister("address", types.getBooleanType());
        final Expression count = expressions.makeValue(1, addressType);
        final Expression alignment = expressions.makeValue(8, addressType);
        function.append(new Alloc(address, types.getByteType(), count, alignment, false, false));

        assertRejected("Allocation result");
    }

    @Test
    public void rejectsWrongLoadAddressWidth() {
        final Register value = function.newRegister("value", types.getByteType());
        function.append(EventFactory.newLoad(value, expressions.makeZero(wrongWidthType)));

        assertRejected("Memory address");
    }

    @Test
    public void rejectsWrongStoreAddressWidth() {
        function.append(EventFactory.newStore(expressions.makeZero(wrongWidthType),
                expressions.makeValue(1, types.getByteType())));

        assertRejected("Memory address");
    }

    @Test
    public void rejectsWrongDeallocationAddressWidth() {
        function.append(EventFactory.newDealloc(expressions.makeZero(wrongWidthType)));

        assertRejected("Memory address");
    }

    @Test
    public void rejectsWrongGepBaseInsideCast() {
        final Register address = function.newRegister("address", addressType);
        function.append(EventFactory.newLocal(address, expressions.makeCast(wrongGep(), addressType)));

        assertRejected("GEP base");
    }

    @Test
    public void rejectsWrongGepBaseInInitialValue() {
        program.getMemory().allocate(8).setInitialValue(0, wrongGep());

        assertRejected("GEP base");
    }

    @Test
    public void rejectsWrongGepBaseInSpecification() {
        program.setSpecification(Program.SpecificationType.EXISTS,
                expressions.makeEQ(wrongGep(), expressions.makeZero(wrongWidthType)));

        assertRejected("GEP base");
    }

    @Test
    public void rejectsWrongGepBaseInFilter() {
        program.setFilterSpecification(expressions.makeEQ(wrongGep(), expressions.makeZero(wrongWidthType)));

        assertRejected("GEP base");
    }

    @Test
    public void rejectsWrongAddressInThread() {
        final Thread thread = new Thread("thread", function.getFunctionType(), List.of(), 1,
                EventFactory.newThreadStart(null));
        program.addThread(thread);
        thread.append(EventFactory.newStore(expressions.makeZero(wrongWidthType),
                expressions.makeValue(1, types.getByteType())));

        assertRejected("Memory address");
    }

    @Test
    public void processingRejectsWrongGepBeforeLowering() throws InvalidConfigurationException {
        final Register address = function.newRegister("address", addressType);
        function.append(EventFactory.newLocal(address, expressions.makeCast(wrongGep(), addressType)));
        final ProcessingManager processing = ProcessingManager.fromConfig(Configuration.defaultConfiguration());

        final MalformedProgramException error = assertThrows(MalformedProgramException.class,
                () -> processing.run(program));
        assertTrue(error.getMessage(), error.getMessage().contains("GEP base"));
    }

    private Expression wrongGep() {
        return expressions.makeGetElementPointer(types.getByteType(), expressions.makeZero(wrongWidthType),
                List.of(expressions.makeValue(1, types.getIntegerType(16))));
    }

    private void assertRejected(String description) {
        final MalformedProgramException error = assertThrows(MalformedProgramException.class,
                () -> PointerWidthVerification.newInstance().run(program));
        assertTrue(error.getMessage(), error.getMessage().contains(description));
        assertTrue(error.getMessage(), error.getMessage().contains("expected a " + pointerWidth + "-bit pointer"));
    }
}
