package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.junit.Test;
import org.junit.runners.Parameterized;

import java.util.Arrays;
import java.util.Map;

import static java.util.Map.entry;
import static org.junit.Assert.*;

public class SpirvHeaderValueTest extends AbstractSpirvHeaderTest {

    private final Map<String, String> values;

    public SpirvHeaderValueTest(String header, Map<String, String> values) {
        super(header);
        this.values = values;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {"""
                ; @   Input   : %v1=7, %v2=123, %v3=0
                ; @  Output : forall (%v1==7 and %v2==123 and %v3==0)
                ;       @ Config : 1, 1, 1
                """,
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {"""
                ; @Config: 1, 1, 1
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Input: %v1=7, %v2=123, %v3=0
                """,
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; SPIR-V
                ; Version: 1.0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; Schema: 0
                ; @Config: 1, 1, 1
                """,
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0, %v4 = {11, 22, 33}
                ; @Output: forall (%v1==7 and %v4[0]==0 and %v4[1]==0 and %v4[2]==0)
                ; @Config: 1, 1, 1
                """,
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)"),
                                entry("%v4", "0: bv64(11), 8: bv64(22), 16: bv64(33)")
                        )},
                {"""
                ; @Input: %v1=7
                ; @Input: %v2=123, %v3=0
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        Map.ofEntries(
                                entry("%v1", "bv64(7)"),
                                entry("%v2", "bv64(123)"),
                                entry("%v3", "bv64(0)")
                        )},
        });
    }

    @Test
    public void testValueHeader() {
        Program program = parse();
        for (Map.Entry<String, String> entry : values.entrySet()) {
            MemoryObject v = program.getMemory().getObjects().stream()
                    .filter(o -> o.getName().equals(entry.getKey())).findFirst().orElseThrow();
            if (entry.getValue().contains(",")) {
                String[] values = Arrays.stream(entry.getValue().split(","))
                        .map(String::trim)
                        .toArray(String[]::new);
                for (String s : values) {
                    String[] offsetAndValue = s.split(":");
                    assertEquals(v.getInitialValue(Integer.parseInt(offsetAndValue[0])).toString(), offsetAndValue[1].trim());
                }
            } else {
                assertEquals(v.getInitialValue(0).toString(), entry.getValue());
            }
        }
    }
}
