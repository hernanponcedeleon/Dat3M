package com.dat3m.dartagnan.program.arch.aarch64.utils;

import static com.dat3m.dartagnan.program.atomic.utils.Mo.*;

public final class Mo {
    public static final String RX       = "RX";
    public static final String REL      = "L";
    public static final String ACQ      = "A";
    public static final String ACQ_PC   = "Q";

    public static String extractStoreMo(String cMo) {
        return cMo.equals(SC) || cMo.equals(RELEASE) || cMo.equals(ACQ_REL) ? REL : RX;
    }

    public static String extractLoadMo(String cMo) {
        //TODO: What about CONSUME loads?
        return cMo.equals(SC) || cMo.equals(ACQ) || cMo.equals(ACQ_REL) ? ACQ : RX;
    }
}
