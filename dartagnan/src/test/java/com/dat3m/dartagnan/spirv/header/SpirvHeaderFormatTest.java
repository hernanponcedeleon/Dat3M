package com.dat3m.dartagnan.spirv.header;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class SpirvHeaderFormatTest extends AbstractSpirvHeaderTest {

    private final boolean passed;
    private final String msg;

    public SpirvHeaderFormatTest(String header, String msg, boolean passed) {
        super(header);
        this.msg = msg;
        this.passed = passed;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"""
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """,
                        "Empty input should not have thrown any exception", true},
                {"""
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                """,
                        "Missing input should not have thrown any exception", true},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output:
                ; @Config: 1, 1, 1
                """,
                        "Empty output should not have thrown any exception", true},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Config: 1, 1, 1
                """,
                        "Missing output should not have thrown any exception", true},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                """,
                        "Missing config should not have thrown any exception", true},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                """,
                        "Missing header should not have thrown any exception", true},
                {"""
                ; @Input:
                ; @Output: forall (0)
                ; @Config: 1, 1, 1
                ; @Config: 1, 1, 1
                """,
                        "Multiple configs should not have thrown any exception", true},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Input: %v1=7
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Duplicated definition '%v1'", false},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v5!=456)
                ; @Config: 1, 1, 1
                """,
                        "Undefined memory object '%v5'", false},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: not exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Existential assertions can not be used in conjunction with other assertions", false},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Existential assertions can not be used in conjunction with other assertions", false},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Existential assertions can not be used in conjunction with other assertions", false},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                ; @Config: 1, 1, 0
                """,
                        "Thread grid dimensions must be positive", false},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: forall (0)
                ; @Config: 100, 100, 100
                """,
                        "Thread grid dimensions must be less than 128", false},
        });
    }

    @Test
    public void testValidFormatHeader() {
        if (passed) {
            parse();
        } else {
            try {
                parse();
                fail("Should throw exception");
            } catch (Exception e) {
                assertEquals(msg, e.getMessage());
            }
        }
    }
}