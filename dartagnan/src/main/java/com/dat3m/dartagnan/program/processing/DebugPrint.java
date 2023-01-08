package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.printer.Printer;

public class DebugPrint implements ProgramProcessor {

    private final String printHeader;

    private DebugPrint(String printHeader) {
        this.printHeader = printHeader;
    }

    public static DebugPrint withHeader(String header) { return new DebugPrint(header);}
    public static DebugPrint newInstance() { return withHeader("DebugPrint"); }

    @Override
    public void run(Program program) {
        System.out.println("======== " + printHeader +  " ========");
        System.out.println(new Printer().print(program));
        System.out.println("======================================");
    }
}
