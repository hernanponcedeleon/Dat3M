package com.dat3m.dartagnan.litmus;

import com.dat3m.dartagnan.utils.Result;
import org.junit.runners.Parameterized;

import java.io.IOException;

public class LitmusAARCH64MSATest extends LitmusAARCH64Test {

    @Parameterized.Parameters(name = "{index}: {0}, {1}")
    public static Iterable<Object[]> data() throws IOException {
        return buildLitmusTests("local/mixedsizetests", "ARM8", "-allowed");
    }

    public LitmusAARCH64MSATest(String path, Result expected) {
        super(path, expected);
    }
}
