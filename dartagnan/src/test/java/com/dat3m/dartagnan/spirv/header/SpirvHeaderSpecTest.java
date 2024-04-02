package com.dat3m.dartagnan.spirv.header;


import com.dat3m.dartagnan.program.Program;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class SpirvHeaderSpecTest extends AbstractSpirvHeaderTest {

    private final String msg;

    public SpirvHeaderSpecTest(String header, String msg) {
        super(header);
        this.msg = msg;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "exists:%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: not exists (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "not exists:%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "forall:%v1==bv64(7) && %v2==bv64(123) && %v3==bv64(0)"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (%v1==7)
                ; @Output: not exists (%v2!=123 or %v3!=0)
                ; @Config: 1, 1, 1
                """,
                        "forall:%v1==bv64(7) && !%v2!=bv64(123) && !%v3!=bv64(0)"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: not exists (%v1!=7)
                ; @Output: not exists (%v2!=123 or %v3!=0)
                ; @Config: 1, 1, 1
                """,
                        "forall:!%v1!=bv64(7) && !%v2!=bv64(123) && !%v3!=bv64(0)"},
        });
    }

    @Test
    public void testSpecHeader() {
        Program program = parse();
        String[] msgSplit = msg.split(":");
        String specType = msgSplit[0];
        String spec = msgSplit[1];
        assertEquals(spec, program.getSpecification().toString());
        assertEquals(specType, program.getSpecification().getType());
    }
}