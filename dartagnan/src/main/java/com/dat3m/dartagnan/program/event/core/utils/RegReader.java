package com.dat3m.dartagnan.program.event.core.utils;

import com.dat3m.dartagnan.program.Register;

import java.util.Set;

public interface RegReader {
    Set<Register.Read> getRegisterReads();
}
