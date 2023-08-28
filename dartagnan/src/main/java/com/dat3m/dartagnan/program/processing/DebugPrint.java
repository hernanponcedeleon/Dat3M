package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.printer.Printer;

public class DebugPrint implements ProgramProcessor {

    private final String printHeader;
    private final Printer.Mode printerMode;

    private DebugPrint(String printHeader, Printer.Mode mode) {
        this.printHeader = printHeader;
        this.printerMode = mode;
    }

    public static DebugPrint withHeader(String header, Printer.Mode mode) { return new DebugPrint(header, mode);}
    public static DebugPrint newInstance(Printer.Mode mode) { return withHeader("DebugPrint", mode); }

    @Override
    public void run(Program program) {
        System.out.println("======== " + printHeader +  " ========");
        System.out.println(new Printer().setMode(printerMode).print(program));
        System.out.println("======================================");
    }
}
