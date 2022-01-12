package com.dat3m.dartagnan.program.event;

import static com.dat3m.dartagnan.program.event.lang.catomic.utils.Tag.*;

public class Tag {
    private Tag() { }

    public static final String ANY          = "_";
    public static final String INIT         = "IW";
    public static final String READ         = "R";
    public static final String WRITE        = "W";
    public static final String MEMORY       = "M";
    public static final String FENCE        = "F";
    public static final String RMW          = "RMW";
    public static final String EXCL         = "EXCL";
    public static final String STRONG       = "STRONG";
    public static final String LOCAL        = "T";
    public static final String LABEL        = "LB";
    public static final String CMP          = "C";
    public static final String IFI          = "IFI";	// Internal jump in Ifs to goto end 
    public static final String JUMP    		= "J";
    public static final String VISIBLE      = "V";
    public static final String REG_WRITER   = "rW";
    public static final String REG_READER   = "rR";
    public static final String ASSERTION    = "ASS";
    public static final String BOUND   		= "BOUND";
    public static final String SVCOMPATOMIC	= "A-SVCOMP";
    public static final String LOCK    		= "L";
    public static final String PTHREAD    	= "PTHREAD";

    public static final class ARMv8 {
        private ARMv8() { }

        public static final String MO_RX = "MO_RX";
        public static final String MO_REL = "L";
        public static final String MO_ACQ = "A";
        public static final String MO_ACQ_PC = "Q";

        // The Mo in the condition refers to those in atomic.utils.Mo
        // The returned ones are the ones defined in this class.
        // Having all these Mo classes is annoying, but it is not
        // trivial to get rid of them (see #62)

        public static String extractStoreMoFromCMo(String cMo) {
            return cMo.equals(SC) || cMo.equals(RELEASE) || cMo.equals(ACQUIRE_RELEASE) ? MO_REL : MO_RX;
        }

        public static String extractLoadMoFromCMo(String cMo) {
            //TODO: What about CONSUME loads?
            return cMo.equals(SC) || cMo.equals(ACQUIRE) || cMo.equals(ACQUIRE_RELEASE) ? MO_ACQ : MO_RX;
        }
    }

    public static class TSO {
        private TSO() {}

        public static final String ATOM      = "A";
    }
}
