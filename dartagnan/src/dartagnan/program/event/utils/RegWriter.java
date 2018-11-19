package dartagnan.program.event.utils;

import dartagnan.program.Register;

public interface RegWriter extends EventInterface {

    Register getModifiedReg();

    default int getSsaRegIndex(){
        return 0;
    }
}
