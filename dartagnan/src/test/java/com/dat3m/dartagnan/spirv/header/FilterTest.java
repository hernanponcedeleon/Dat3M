package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.program.Program;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class FilterTest extends AbstractTest {

    private final String input;
    private final String expValue;

    public FilterTest(String input, String expValue) {
        this.input = input;
        this.expValue = expValue;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"; @Filter: %v1!=0",
                        "%v1 != bv64(0)"},
                {"; @Filter: %v1==1 and %v2>2 and %v3<3",
                        "(%v1 == bv64(1)) && (%v2 > bv64(2)) && (%v3 < bv64(3))"},
        });
    }

    @Test
    public void testAssertions() {
        // when
        Program program = parse(input);

        // then
        assertEquals(expValue, program.getFilterSpecification().toString());
    }
}
