package com.dat3m.dartagnan.program.event;

public class Tag {

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
}
