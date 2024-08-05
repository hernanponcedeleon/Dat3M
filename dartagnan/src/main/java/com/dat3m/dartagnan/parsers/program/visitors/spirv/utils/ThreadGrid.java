package com.dat3m.dartagnan.parsers.program.visitors.spirv.utils;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.program.ScopeHierarchy;

import java.util.List;

public class ThreadGrid {

    private final int sg;
    private final int wg;
    private final int qf;
    private final int dv;

    public ThreadGrid(int sg, int wg, int qf, int dv) {
        List<Integer> elements = List.of(sg, wg, qf, dv);
        if (elements.stream().anyMatch(i -> i <= 0)) {
            throw new ParsingException("Thread grid dimensions must be positive");
        }
        this.sg = sg;
        this.wg = wg;
        this.qf = qf;
        this.dv = dv;
    }

    public int sgSize() {
        return sg;
    }

    public int wgSize() {
        return sg * wg;
    }

    public int qfSize() {
        return sg * wg * qf;
    }

    public int dvSize() {
        return sg * wg * qf * dv;
    }

    public int thId(int tid) {
        return tid % sgSize();
    }

    public int sgId(int tid) {
        return (tid % wgSize()) / sgSize();
    }

    public int wgId(int tid) {
        return (tid % qfSize()) / wgSize();
    }

    public int qfId(int tid) {
        return (tid % dvSize()) / qfSize();
    }

    public int dvId(int tid) {
        return tid / dvSize();
    }

    public ScopeHierarchy getScoreHierarchy(int tid) {
        return ScopeHierarchy.ScopeHierarchyForVulkan(qfId(tid), wgId(tid), sgId(tid));

    }
}
