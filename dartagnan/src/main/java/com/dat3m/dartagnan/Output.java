package com.dat3m.dartagnan;

import com.dat3m.dartagnan.utils.ExitCode;

public record Output(ExitCode exitCode, String summary) {

    @Override
    public String toString() {
        return summary;
    }
}
