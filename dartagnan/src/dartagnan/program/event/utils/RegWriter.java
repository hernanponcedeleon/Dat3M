package dartagnan.program.event.utils;

import dartagnan.program.Register;

public interface RegWriter {

    Register getModifiedReg();

    default int getSsaRegIndex(){
        return 0;
    }
}
