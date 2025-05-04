package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.exception.ParsingException;

import java.util.List;

public class ThreadGrid {

    private final int thCount;
    private final int sgCount;
    private final int wgCount;
    private final int qfCount;
    private final int dvCount;

    public ThreadGrid(int thCount, int sgCount, int wgCount, int qfCount, int dvCount) {
        List<Integer> elements = List.of(thCount, sgCount, wgCount, qfCount, dvCount);
        if (elements.stream().anyMatch(i -> i <= 0)) {
            throw new ParsingException("Thread grid dimensions must be positive");
        }
        this.thCount = thCount;
        this.sgCount = sgCount;
        this.wgCount = wgCount;
        this.qfCount = qfCount;
        this.dvCount = dvCount;
    }

    public int sgSize() {
        return thCount;
    }

    public int wgSize() {
        return thCount * sgCount;
    }

    public int qfSize() {
        return thCount * sgCount * wgCount;
    }

    public int dvSize() {
        return thCount * sgCount * wgCount * qfCount;
    }

    public int sysSize() { // Number of cross-device threads
        return thCount * sgCount * wgCount * qfCount * dvCount;
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
        return (tid % sysSize()) / dvSize();
    }
}
