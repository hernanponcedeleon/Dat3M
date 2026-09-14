package com.dat3m.dartagnan.wmm.metadata;

import com.dat3m.dartagnan.utils.metadata.Metadata;

public record CutAnnotation() implements Metadata {

    private static final CutAnnotation SINGLETON = new CutAnnotation();
    public static CutAnnotation get() { return SINGLETON; }
}
