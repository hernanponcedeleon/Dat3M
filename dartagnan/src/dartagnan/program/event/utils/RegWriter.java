package dartagnan.program.event.utils;

import com.microsoft.z3.IntExpr;
import dartagnan.program.Register;

public interface RegWriter {

    Register getResultRegister();

    default IntExpr getResultRegisterExpr(){
        throw new UnsupportedOperationException("RegResultExpr is available only for basic events");
    }
}
