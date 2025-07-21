package com.dat3m.dartagnan.others.miscellaneous;

import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.processing.MemToReg;
import org.junit.Test;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class ProcessingTest {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    @Test
    public void memToReg0() throws InvalidConfigurationException {
        final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
        final Function f = new Function("f", types.getFunctionType(types.getVoidType(), List.of()), List.of(), 0, null);
        program.addFunction(f);
        final Register r0 = f.newRegister("r0", types.getArchType());
        final Register r1 = f.newRegister("r1", types.getBooleanType());
        final Event alloc = newAlloc(r0, types.getBooleanType(), 1);
        final Event storeFalse = EventFactory.newStore(r0, expressions.makeFalse());
        final Event loadFalse = EventFactory.newLoad(r1, r0);
        final Event storeTrue = EventFactory.newStore(r0, expressions.makeNot(r1));
        final Event loadTrue = EventFactory.newLoad(r1, r0);
        final Event assertTrue = EventFactory.newAssert(r1, "assert true");
        f.append(List.of(alloc, storeFalse, loadFalse, storeTrue, loadTrue, assertTrue));
        final Configuration config = Configuration.builder().build();
        MemToReg.fromConfig(config).run(f);
        final List<Event> events = f.getEvents();
        assertEquals(5, events.size());
        assertLocal(events.get(0));
        assertLocal(events.get(1));
        assertLocal(events.get(2));
        assertLocal(events.get(3));
        assertComparable(assertTrue, events.get(4));
    }

    @Test
    public void memToReg1() throws InvalidConfigurationException {
        final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
        final Function f = new Function("f", types.getFunctionType(types.getVoidType(), List.of()), List.of(), 0, null);
        program.addFunction(f);
        final Register r0 = f.newRegister("r0", types.getArchType());
        final Register r1 = f.newRegister("r1", types.getArchType());
        final Register r2 = f.newRegister("r2", types.getArchType());
        final Register r3 = f.newRegister("r3", types.getBooleanType());
        final Event allocX = newAlloc(r0, types.getBooleanType(), 2);
        final Event allocY = newAlloc(r1, types.getArchType(), 1);
        final Event storeIndex = EventFactory.newStore(r1,
                expressions.makeITE(
                        program.newConstant(types.getBooleanType()),
                        expressions.makeValue(1, types.getArchType()),
                        expressions.makeValue(0, types.getArchType())));
        final Event loadIndex = EventFactory.newLoad(r2, r1);
        final Event storeTrue = EventFactory.newStore(expressions.makeAdd(r0, r2), expressions.makeTrue());
        final Event loadTrue = EventFactory.newLoad(r3, expressions.makeAdd(r0, r2));
        final Event assertTrue = EventFactory.newAssert(r3, "assert true");
        f.append(List.of(allocX, allocY, storeIndex, loadIndex, storeTrue, loadTrue, assertTrue));
        final Configuration config = Configuration.builder().build();
        MemToReg.fromConfig(config).run(f);
        final List<Event> events = f.getEvents();
        assertEquals(6, events.size());
        assertComparable(allocX, events.get(0));
        assertLocal(events.get(1));
        assertLocal(events.get(2));
        assertComparable(storeTrue, events.get(3));
        assertComparable(loadTrue, events.get(4));
        assertComparable(assertTrue, events.get(5));
    }

    @Test
    public void memToReg2() throws InvalidConfigurationException {
        final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
        final Function f = new Function("f", types.getFunctionType(types.getVoidType(), List.of()), List.of(), 0, null);
        program.addFunction(f);
        final Register r0 = f.newRegister("r0", types.getArchType());
        final Register r1 = f.newRegister("r1", types.getArchType());
        final Register r2 = f.newRegister("r2", types.getArchType());
        final Register r3 = f.newRegister("r3", types.getBooleanType());
        final Event allocX = newAlloc(r0, types.getBooleanType(), 2);
        final Event allocY = newAlloc(r1, types.getArchType(), 1);
        final Label labelThen = EventFactory.newLabel("then");
        final Label labelEndIf = EventFactory.newLabel("endIf");
        final Event jumpNondet = EventFactory.newJump(program.newConstant(types.getBooleanType()), labelThen);
        final Event gotoEndIf = EventFactory.newGoto(labelEndIf);
        final Event store0 = EventFactory.newStore(r1, expressions.makeValue(0, types.getArchType()));
        final Event store1 = EventFactory.newStore(r1, expressions.makeValue(1, types.getArchType()));
        final Event loadIndex = EventFactory.newLoad(r2, r1);
        final Event storeTrue = EventFactory.newStore(expressions.makeAdd(r0, r2), expressions.makeTrue());
        final Event loadTrue = EventFactory.newLoad(r3, expressions.makeAdd(r0, r2));
        final Event assertTrue = EventFactory.newAssert(r3, "assert true");
        f.append(List.of(allocX, allocY,
                jumpNondet, store0, gotoEndIf, labelThen, store1, labelEndIf,
                loadIndex, storeTrue, loadTrue, assertTrue));
        final Configuration config = Configuration.builder().build();
        MemToReg.fromConfig(config).run(f);
        final List<Event> events = f.getEvents();
        assertEquals(11, events.size());
        assertComparable(allocX, events.get(0));
        assertComparable(jumpNondet, events.get(1));
        assertLocal(events.get(2));
        assertComparable(gotoEndIf, events.get(3));
        assertComparable(labelThen, events.get(4));
        assertLocal(events.get(5));
        assertComparable(labelEndIf, events.get(6));
        assertLocal(events.get(7));
        assertComparable(storeTrue, events.get(8));
        assertComparable(loadTrue, events.get(9));
        assertComparable(assertTrue, events.get(10));
    }

    @Test
    public void memToReg3() throws InvalidConfigurationException {
        final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
        final Function f = new Function("f", types.getFunctionType(types.getVoidType(), List.of()), List.of(), 0, null);
        program.addFunction(f);
        final Register r0 = f.newRegister("r0", types.getArchType());
        final Register r1 = f.newRegister("r1", types.getArchType());
        final Register r2 = f.newRegister("r2", types.getArchType());
        final Register r3 = f.newRegister("r3", types.getBooleanType());
        final Event allocX = newAlloc(r0, types.getBooleanType(), 2);
        final Event allocY = newAlloc(r1, types.getArchType(), 1);
        final Label labelThen = EventFactory.newLabel("then");
        final Label labelEndIf = EventFactory.newLabel("endIf");
        final Event jumpNondet = EventFactory.newJump(program.newConstant(types.getBooleanType()), labelThen);
        final Event gotoEndIf = EventFactory.newGoto(labelEndIf);
        final Event store0 = EventFactory.newStore(r1, r0);
        final Event store1 = EventFactory.newStore(r1, expressions.makeAdd(r0, expressions.makeValue(1, types.getArchType())));
        final Event loadIndex = EventFactory.newLoad(r2, r1);
        final Event storeTrue = EventFactory.newStore(r2, expressions.makeTrue());
        final Event loadTrue = EventFactory.newLoad(r3, r2);
        final Event assertTrue = EventFactory.newAssert(r3, "assert true");
        f.append(List.of(allocX, allocY,
                jumpNondet, store0, gotoEndIf, labelThen, store1, labelEndIf,
                loadIndex, storeTrue, loadTrue, assertTrue));
        final Configuration config = Configuration.builder().build();
        MemToReg.fromConfig(config).run(f);
        final List<Event> events = f.getEvents();
        assertEquals(11, events.size());
        assertComparable(allocX, events.get(0));
        assertComparable(jumpNondet, events.get(1));
        assertLocal(events.get(2));
        assertComparable(gotoEndIf, events.get(3));
        assertComparable(labelThen, events.get(4));
        assertLocal(events.get(5));
        assertComparable(labelEndIf, events.get(6));
        assertLocal(events.get(7));
        assertComparable(storeTrue, events.get(8));
        assertComparable(loadTrue, events.get(9));
        assertComparable(assertTrue, events.get(10));
    }

    private Event newAlloc(Register address, Type type, int count) {
        return EventFactory.newAlloc(address, type, expressions.makeValue(count, types.getArchType()), false, true);
    }

    private void assertLocal(Event event) {
        assertTrue(event instanceof Local);
    }

    private void assertComparable(Event expected, Event actual) {
        assertEquals(expected, actual);
    }
}
