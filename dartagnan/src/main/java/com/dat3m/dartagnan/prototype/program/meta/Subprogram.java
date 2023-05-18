package com.dat3m.dartagnan.prototype.program.meta;

public class Subprogram implements Metadata {

    private final String name;
    private final File scope;

    public Subprogram(String n, File s) {
        name = n;
        scope = s;
    }

    @Override
    public String toString() {
        return "DISubprogram(name: \"" + name + "\", scope: \"" + scope + "\")";
    }
}
