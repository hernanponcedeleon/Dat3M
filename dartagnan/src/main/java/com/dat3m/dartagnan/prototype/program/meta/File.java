package com.dat3m.dartagnan.prototype.program.meta;

public final class File implements Metadata {

    private final String path;

    public File(String p) {
        path = p;
    }

    @Override
    public String toString() {
        return "DIFile(path: \"" + path + "\")";
    }
}