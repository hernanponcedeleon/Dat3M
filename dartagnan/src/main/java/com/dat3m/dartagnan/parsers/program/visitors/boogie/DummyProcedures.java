package com.dat3m.dartagnan.parsers.program.visitors.boogie;

import com.dat3m.dartagnan.parsers.BoogieParser;

import java.util.Arrays;
import java.util.List;

public class DummyProcedures {

    public static List<String> DUMMYPROCEDURES = Arrays.asList(
            "boogie_si_record",
            "printf",
            "printk.");

    public static boolean handleDummyProcedures(VisitorBoogie visitor, BoogieParser.Call_cmdContext ctx) {
        final String funcName = visitor.getFunctionNameFromCallContext(ctx);
        return DUMMYPROCEDURES.stream().anyMatch(funcName::startsWith);
    }
}