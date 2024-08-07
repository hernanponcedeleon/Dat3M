package com.dat3m.dartagnan.spirv.header;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.specification.AbstractAssert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.Arrays;

import static com.dat3m.dartagnan.program.specification.AbstractAssert.*;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class AssertTest extends AbstractTest {

    private final String input;
    private final String expValue;
    private final String expType;

    public AssertTest(String input, String expValue, String expType) {
        this.input = input;
        this.expValue = expValue;
        this.expType = expType;
    }

    @Parameterized.Parameters()
    public static Iterable<Object[]> data() {
        return Arrays.asList(new Object[][]{
                // scalar
                {"; @Output: forall %v1==1 and %v2>2 and %v3<3",
                        "%v1==bv64(1) && %v2>bv64(2) && %v3<bv64(3)",
                        ASSERT_TYPE_FORALL},
                {"; @Output: forall 1!=%v1 and 2>%v2 and 3<%v3",
                        "bv64(1)!=%v1 && bv64(2)>%v2 && bv64(3)<%v3",
                        ASSERT_TYPE_FORALL},

                // vector
                {"; @Output: forall %v4[0]<=1 and %v4[1]>=2 and %v4[2]==3",
                        "%v4[0]<=bv64(1) && %v4[1]>=bv64(2) && %v4[2]==bv64(3)",
                        ASSERT_TYPE_FORALL},
                {"; @Output: forall 1<=%v4[0] and 2>=%v4[1] and 3==%v4[2]",
                        "bv64(1)<=%v4[0] && bv64(2)>=%v4[1] && bv64(3)==%v4[2]",
                        ASSERT_TYPE_FORALL},

                // array
                {"; @Output: forall (%v5[0]==1 and %v5[1]==2 and %v5[2]==3)",
                        "%v5[0]==bv64(1) && %v5[1]==bv64(2) && %v5[2]==bv64(3)",
                        ASSERT_TYPE_FORALL},
                {"; @Output: forall (1==%v5[0] and 2==%v5[1] and 3==%v5[2])",
                        "bv64(1)==%v5[0] && bv64(2)==%v5[1] && bv64(3)==%v5[2]",
                        ASSERT_TYPE_FORALL},

                // struct
                {"; @Output: forall (%v6[0][0]==1 and %v6[0][1]==2 and %v6[1][0]==3)",
                        "%v6[0][0]==bv64(1) && %v6[0][1]==bv64(2) && %v6[1][0]==bv64(3)",
                        ASSERT_TYPE_FORALL},
                {"; @Output: forall (1==%v6[0][0] and 2==%v6[0][1] and 3==%v6[1][0])",
                        "bv64(1)==%v6[0][0] && bv64(2)==%v6[0][1] && bv64(3)==%v6[1][0]",
                        ASSERT_TYPE_FORALL},

                // bit width
                {"; @Output: forall (%v7[0]==1 and %v7[1]==2 and %v7[2]==3)",
                        "%v7[0]==bv64(1) && %v7[1]==bv64(2) && %v7[2]==bv64(3)",
                        ASSERT_TYPE_FORALL},

                // precedence
                {"; @Output: forall %v1==1 and %v2==2 or %v3==3",
                        "(%v1==bv64(1) && %v2==bv64(2) || %v3==bv64(3))",
                        ASSERT_TYPE_FORALL},
                {"; @Output: forall %v1==1 and (%v2==2 or %v3==3)",
                        "%v1==bv64(1) && (%v2==bv64(2) || %v3==bv64(3))",
                        ASSERT_TYPE_FORALL},

                // assert types
                {"; @Output: exists (%v1==1 and %v2==2 and %v3==3)",
                        "%v1==bv64(1) && %v2==bv64(2) && %v3==bv64(3)",
                        ASSERT_TYPE_EXISTS},
                {"""
                ; @Output: forall (%v1==1)
                ; @Output: forall (%v2==2 and %v3==3)
                """,
                        "%v1==bv64(1) && %v2==bv64(2) && %v3==bv64(3)",
                        ASSERT_TYPE_FORALL},
                {"""
                ; @Output: not exists (%v1!=1)
                ; @Output: not exists (%v2!=2 or %v3!=3)
                """,
                        "(%v1!=bv64(1) || (%v2!=bv64(2) || %v3!=bv64(3)))",
                        ASSERT_TYPE_NOT_EXISTS},
        });
    }

    @Test
    public void testAssertions() {
        // when
        Program program = parse(input);
        AbstractAssert ast = program.getSpecification();

        // then
        assertEquals(expValue, ast.toString());
        assertEquals(expType, ast.getType());
    }
}
