package com.dat3m.dartagnan.frontend;

import org.antlr.v4.runtime.CharStream;

public interface ParserInterface<T> {

    T parse(CharStream charStream);
}
