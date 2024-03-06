package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.mocks.MockSpirvParser;
import org.junit.Test;

import java.math.BigInteger;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class VisitorOpsConstantTest {

    private static final TypeFactory FACTORY = TypeFactory.getInstance();
    private final ProgramBuilderSpv builder = new ProgramBuilderSpv();

    @Test
    public void testSupportedTypes() {
        // given
        String input = """
                %b_true = OpConstantTrue %bool
                %b_false = OpConstantFalse %bool
                %i_2 = OpConstant %int 2
                %i_7 = OpConstant %int 7
                %b_null = OpConstantNull %bool
                %i_null = OpConstantNull %int
                """;

        BooleanType bType = FACTORY.getBooleanType();
        builder.addType("%bool", bType);
        IntegerType iType = FACTORY.getIntegerType();
        builder.addType("%int", iType);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(6, data.size());
        assertEquals(new BConst(bType, true), data.get("%b_true"));
        assertEquals(new BConst(bType, false), data.get("%b_false"));
        assertEquals(new IValue(new BigInteger("2"), iType), data.get("%i_2"));
        assertEquals(new IValue(new BigInteger("7"), iType), data.get("%i_7"));
        assertEquals(new BConst(bType, false), data.get("%b_null"));
        assertEquals(new IValue(new BigInteger("0"), iType), data.get("%i_null"));
    }

    @Test
    public void testOpConstantBool() {
        // given
        String input = """
                %true_1 = OpConstantTrue %bool
                %true_2 = OpConstantTrue %bool
                %false_1 = OpConstantFalse %bool
                %false_2 = OpConstantFalse %bool
                """;

        BooleanType bType = FACTORY.getBooleanType();
        builder.addType("%bool", bType);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(4, data.size());
        assertEquals(new BConst(bType, true), data.get("%true_1"));
        assertEquals(new BConst(bType, true), data.get("%true_2"));
        assertEquals(new BConst(bType, false), data.get("%false_1"));
        assertEquals(new BConst(bType, false), data.get("%false_2"));
    }

    @Test
    public void testOpConstant() {
        // given
        String input = """
                %i_1 = OpConstant %int16 5
                %i_2 = OpConstant %int16 5
                %i_3 = OpConstant %int16 10
                %i_4 = OpConstant %int32 10
                %i_5 = OpConstant %int32 20
                """;

        IntegerType iType16 = FACTORY.getIntegerType(16);
        builder.addType("%int16", iType16);
        IntegerType iType32 = FACTORY.getIntegerType(32);
        builder.addType("%int32", iType32);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(5, data.size());
        assertEquals(new IValue(new BigInteger("5"), iType16), data.get("%i_1"));
        assertEquals(new IValue(new BigInteger("5"), iType16), data.get("%i_2"));
        assertEquals(new IValue(new BigInteger("10"), iType16), data.get("%i_3"));
        assertEquals(new IValue(new BigInteger("10"), iType32), data.get("%i_4"));
        assertEquals(new IValue(new BigInteger("20"), iType32), data.get("%i_5"));
    }

    @Test(expected = ParsingException.class)
    public void testOpConstantUnsupported() {
        // given
        String input = "%const = OpConstant %bool 12345";

        BooleanType bType = FACTORY.getBooleanType();
        builder.addType("%bool", bType);

        // when
        parseConstants(input);
    }

    @Test
    public void testOpConstantNull() {
        // given
        String input = """
                %null_1 = OpConstantNull %int16
                %null_2 = OpConstantNull %int16
                %null_3 = OpConstantNull %int32
                %null_4 = OpConstantNull %bool
                """;

        BooleanType bType = FACTORY.getBooleanType();
        builder.addType("%bool", bType);
        IntegerType iType16 = FACTORY.getIntegerType(16);
        builder.addType("%int16", iType16);
        IntegerType iType32 = FACTORY.getIntegerType(32);
        builder.addType("%int32", iType32);

        // when
        Map<String, Expression> data = parseConstants(input);

        // then
        assertEquals(4, data.size());
        assertEquals(new IValue(new BigInteger("0"), iType16), data.get("%null_1"));
        assertEquals(new IValue(new BigInteger("0"), iType16), data.get("%null_2"));
        assertEquals(new IValue(new BigInteger("0"), iType32), data.get("%null_3"));
        assertEquals(new BConst(bType, false), data.get("%null_4"));
    }

    @Test(expected = ParsingException.class)
    public void testRedefiningConstantValue() {
        // given
        String input = """
                %const = OpConstant %int 1
                %const = OpConstant %int 2
                """;

        IntegerType iType = FACTORY.getIntegerType();
        builder.addType("%int", iType);

        // when
        parseConstants(input);
    }

    @Test(expected = ParsingException.class)
    public void testRedefiningConstantType() {
        // given
        String input = """
                %const = OpConstant %int16 1
                %const = OpConstant %int32 1
                """;

        IntegerType iType16 = FACTORY.getIntegerType(16);
        builder.addType("%int16", iType16);
        IntegerType iType32 = FACTORY.getIntegerType(32);
        builder.addType("%int32", iType32);

        // when
        parseConstants(input);
    }

    @Test(expected = ParsingException.class)
    public void testDuplicatedDefinition() {
        // given
        String input = """
                %const = OpConstant %int 1
                %const = OpConstant %int 1
                """;

        IntegerType iType = FACTORY.getIntegerType();
        builder.addType("%int", iType);

        // when
        parseConstants(input);
    }

    private Map<String, Expression> parseConstants(String input) {
        new MockSpirvParser(input).spv().accept(new VisitorOpsConstant(builder));
        return builder.getExpressions();
    }
}
