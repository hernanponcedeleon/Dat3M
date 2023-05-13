package com.dat3m.dartagnan.program.event.metadata;

import com.dat3m.dartagnan.programNew.meta.Metadata;

public class History implements Metadata {

    private int originalId;
    private int unrollingId;
    private int compilationId;

    public History(int oId, int uId, int cId) {
        this.originalId = oId;
        this.unrollingId = uId;
        this.compilationId = cId;
    }

    public History withOId(int oId) {
        return new History(oId, this.unrollingId, this.compilationId);
    }

    public History withUId(int uId) {
        return new History(this. originalId, uId, this.compilationId);
    }

    public History withCId(int cId) {
        return new History(this.originalId, this.unrollingId, cId);
    }

    public int getOriginalId() { return originalId; }
    public int getUnrollingId() { return unrollingId; }
    public int getCompilationId() { return compilationId; }

    public boolean hasOriginalId() { return originalId != -1; }
    public boolean hasUnrollingId() { return unrollingId != -1; }
    public boolean hasCompilationId() { return compilationId != -1; }

}
