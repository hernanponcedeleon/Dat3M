package com.dat3m.dartagnan.frontend.llvm;

import java.util.List;

import org.antlr.v4.runtime.CharStream;

import com.dat3m.dartagnan.program.event.Event;


public abstract class ParserAsm {
    public abstract List<Event> parse(CharStream charStream);
}
