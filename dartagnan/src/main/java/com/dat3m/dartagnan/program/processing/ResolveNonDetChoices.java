package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.lang.svcomp.NonDetChoice;

public class ResolveNonDetChoices implements ProgramProcessor {

    private ResolveNonDetChoices() { }

    public static ResolveNonDetChoices newInstance() {
        return new ResolveNonDetChoices();
    }

    @Override
    public void run(Program program) {
        program.getThreads().forEach(this::resolveNonDetChoices);
    }

    private void resolveNonDetChoices(Function func) {
        final Program prog = func.getProgram();
        for (NonDetChoice choice : func.getEvents(NonDetChoice.class)) {
            final Type valueType = choice.getResultRegister().getType();
            final Expression constant = prog.newConstant(valueType);

            final Local assignment = EventFactory.newLocal(choice.getResultRegister(), constant);
            assignment.copyAllMetadataFrom(choice);
            choice.replaceBy(assignment);
        }
    }
}
