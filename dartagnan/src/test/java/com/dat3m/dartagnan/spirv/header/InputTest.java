package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class InputTest extends AbstractTest {

    private final String input;

    public InputTest(String input) {
        this.input = input;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"""
                ; @Input: %v1=1
                ; @Input: %v2=2
                ; @Input: %v3=3
                ; @Input: %v4 = {11, 12, 13}
                ; @Input: %v5 = {21, 22, 23}
                ; @Input: %v6 = {{31, 32}, {33}}
                ; @Input: %v7 = {41, 42, 43}
                ; @Input: %v8 = {{51}}
                """},
                {"""
                ; @Input: %v1=1, %v2=2, %v3=3, %v4 = {11, 12, 13}, %v5 = {21, 22, 23}
                ; @Input: %v6 = {{31, 32}, {33}}, %v7 = {41, 42, 43}, %v8 = {{51}}
                """}
        });
    }

    @Test
    public void testValues() {
        Program program = parse(input);
        Map<String, MemoryObject> memory = program.getMemory().getObjects().stream()
                .collect(Collectors.toMap(MemoryObject::getName, Function.identity()));

        check(memory.get("%v1"), 0, 1);
        check(memory.get("%v2"), 0, 2);
        check(memory.get("%v3"), 0, 3);

        check(memory.get("%v4"), 0, 11);
        check(memory.get("%v4"), 8, 12);
        check(memory.get("%v4"), 16, 13);

        check(memory.get("%v5"), 0, 21);
        check(memory.get("%v5"), 8, 22);
        check(memory.get("%v5"), 16, 23);

        check(memory.get("%v6"), 0, 31);
        check(memory.get("%v6"), 8, 32);
        check(memory.get("%v6"), 16, 33);

        check(memory.get("%v7"), 0, 41);
        check(memory.get("%v7"), 4, 42);
        check(memory.get("%v7"), 8, 43);

        check(memory.get("%v8"), 0, 51);
    }

    private void check(MemoryObject memObj, int idx, int expected) {
        assertEquals(expected, ((IntLiteral) memObj.getInitialValue(idx)).getValueAsInt());
    }
}
