package dartagnan.program.event.utils;

import dartagnan.program.Register;

import java.util.Set;

public interface RegReaderData extends EventInterface {

    Set<Register> getDataRegs();
}
