package dartagnan.program.event.utils;

import com.google.common.collect.ImmutableSet;
import dartagnan.program.Register;

public interface RegReaderData {

    ImmutableSet<Register> getDataRegs();
}
