package com.dat3m.testgen.util;

public class Types {
    
    static public enum base {
        undefined,
        co,
        ext,
        po,
        read,
        rf,
        rmw,
        write,
        loc,
        tag_sc,
        tag_rel,
        tag_acq,
        tag_rlx
    };

    static public enum instruction {
        UNDEFINED,
        R,
        W
    };

    static public enum memory {
        UNDEFINED,
        ADDRESS,
        REGISTER
    }

    static public enum order {
        NONE,
        SC,
        REL,
        ACQ,
        RLX
    }

}
