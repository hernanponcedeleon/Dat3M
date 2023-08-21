package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public class StaticMemoryInitializer implements ProgramProcessor {

    private StaticMemoryInitializer() {
    }

    public static StaticMemoryInitializer newInstance() { return new StaticMemoryInitializer(); }

    @Override
    public void run(Program program) {
        if (program.getFormat() == Program.SourceLanguage.BOOGIE) {
            program.getFunctionByName("__SMACK_static_init").ifPresent(this::initMemory);
        }
    }


    private void initMemory(Function initFunc) {
        for (Store store : initFunc.getEvents(Store.class)) {
            final Expression address = store.getAddress();
            final Expression value = store.getMemValue();

            Expression rootAddress = address;
            int offset = 0;
            while (rootAddress instanceof IExprBin expr) {
                offset += expr.getRHS().reduce().getValueAsInt();
                rootAddress = expr.getLHS();
            }
            if (rootAddress instanceof MemoryObject memObj) {
                memObj.appendInitialValue(offset, value.reduce());
            } else {
                final String error = "Initialization error: cannot handle " + store;
                throw new MalformedProgramException(error);
            }
        }



    }
}
