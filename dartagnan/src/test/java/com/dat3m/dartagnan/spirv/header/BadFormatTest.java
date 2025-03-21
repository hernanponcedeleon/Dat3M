package com.dat3m.dartagnan.spirv.header;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class BadFormatTest extends AbstractTest {

    private final String input;
    private final String error;

    public BadFormatTest(String input, String error) {
        this.input = input;
        this.error = error;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Input: %v1=7
                ; @Output: forall (%v1==7 and %v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Duplicated input definition '%v1'"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%undefined!=456)
                ; @Config: 1, 1, 1
                """,
                        "Reference to undefined expression '%undefined'"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: not exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Mixed assertion type is not supported"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: forall (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Mixed assertion type is not supported"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Output: exists (%v2==123 and %v3==0)
                ; @Config: 1, 1, 1
                """,
                        "Multiline assertion is not supported for type EXISTS"},
                {"""
                ; @Input: %v1=7, %v2=123, %v3=0
                ; @Output: exists (%v1!=7)
                ; @Filter: %v1!=7
                ; @Filter: %v2!=123
                ; @Config: 1, 1, 1
                """,
                        "Multiline filters are not supported"},
        });
    }

    @Test
    public void testValidFormatHeader() {
        try {
            parse(input);
            fail("Should throw exception");
        } catch (Exception e) {
            assertEquals(error, e.getMessage());
        }
    }
}