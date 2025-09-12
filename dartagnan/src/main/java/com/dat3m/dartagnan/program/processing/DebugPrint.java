package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.printer.Printer;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;

public class DebugPrint implements ProgramProcessor {

    private final String printHeader;
    private final Printer printer;

    private DebugPrint(String printHeader, Printer.Mode mode, Configuration configuration)
            throws InvalidConfigurationException {
        this.printHeader = printHeader;
        printer = Printer.fromConfig(configuration).setMode(mode);
    }

    public static DebugPrint withHeader(String header, Printer.Mode mode, Configuration configuration) throws InvalidConfigurationException {
        return new DebugPrint(header, mode, configuration);
    }

    public static DebugPrint fromConfig(Printer.Mode mode, Configuration configuration) throws InvalidConfigurationException {
        return withHeader("DebugPrint", mode, configuration);
    }

    @Override
    public void run(Program program) {
        System.out.println("======== " + printHeader +  " ========");
        System.out.println(printer.print(program));
        System.out.println("======================================");
    }
}
