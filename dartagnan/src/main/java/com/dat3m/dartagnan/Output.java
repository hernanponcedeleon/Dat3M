package com.dat3m.dartagnan;

public record Output(Dartagnan.ExitCode exitCode, String summary) {

    @Override
    public String toString() {
        return summary;
    }
}
