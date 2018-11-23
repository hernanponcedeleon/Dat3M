package dartagnan.program.event.utils;

import dartagnan.program.Register;
import dartagnan.program.memory.Location;

import java.util.Set;

public interface RegReaderAddress {

    Register getAddressReg();

    void setMaxLocationSet(Set<Location> locations);
}