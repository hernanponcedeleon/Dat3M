package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.exception.ParsingException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class BadIndexTest extends AbstractTest {

    private final String input;
    private final String error;

    public BadIndexTest(String input, String error) {
        this.input = input;
        this.error = error;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"; @Output: forall %v8[0][0][0]==0",
                        "Index is too deep for variable '%v8[0][0][0]'"},
                {"; @Output: forall %v8[0]==0",
                        "Index is not deep enough for variable '%v8[0]'"},
                {"; @Output: forall %v8[1][0]==0",
                        "Index is out of bounds for variable '%v8[1]'"},
                {"; @Output: forall %v8[0][1]==0",
                        "Index is out of bounds for variable '%v8[0][1]'"},
                {"; @Input: %v8={{{0}}}",
                        "Mismatching value type for variable '%v8[0][0]', expected 'bv64' but received '{ bv64 }'"},
                {"; @Input: %v8={0}",
                        "Mismatching value type for variable '%v8[0]', expected '[1 x bv64]' but received 'bv64'"},
                {"; @Input: %v8={{0}, {0}}",
                        "Unexpected number of elements in variable '%v8', expected 1 but received 2"},
                {"; @Input: %v8={{0, 0}}",
                        "Unexpected number of elements in variable '%v8[0]', expected 1 but received 2"},
        });
    }

    @Test
    public void test() {
        try {
            // when
            parse(input);
            fail("Should throw exception");
        } catch (ParsingException e) {
            // then
            assertEquals(error, e.getMessage());
        }
    }
}
