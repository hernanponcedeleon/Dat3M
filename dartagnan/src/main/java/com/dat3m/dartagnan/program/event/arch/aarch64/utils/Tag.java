package com.dat3m.dartagnan.program.event.arch.aarch64.utils;

import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Tag.*;

public final class Tag {
    public static final String RX       = "RX";
    public static final String REL      = "L";
    public static final String ACQ      = "A";
    public static final String ACQ_PC   = "Q";

	// The Mo in the condition refers to those in atomic.utils.Mo
	// The returned ones are the ones defined in this class.
	// Having all these Mo classes is annoying, but it is not 
	// trivial to get rid of them (see #62)
    
    public static String extractStoreMo(String cMo) {
        return cMo.equals(SC) || cMo.equals(RELEASE) || cMo.equals(ACQUIRE_RELEASE) ? REL : RX;
    }

    public static String extractLoadMo(String cMo) {
        //TODO: What about CONSUME loads?
        return cMo.equals(SC) || cMo.equals(ACQUIRE) || cMo.equals(ACQUIRE_RELEASE) ? ACQ : RX;
    }
}
