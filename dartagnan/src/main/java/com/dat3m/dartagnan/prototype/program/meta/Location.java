package com.dat3m.dartagnan.prototype.program.meta;

public class Location implements Metadata {

    private final int line;
    private final int column;
    private final Subprogram scope;

    public Location(int l, int c, Subprogram s) {
        line = l;
        column = c;
        scope = s;
    }

    @Override
    public String toString() {
        return "DILocation(line: " + line + ", column: " + column + ", scope: " + scope + ")";
    }
}
