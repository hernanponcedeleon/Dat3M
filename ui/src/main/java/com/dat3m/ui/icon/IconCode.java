package com.dat3m.ui.icon;

import com.dat3m.ui.Dat3M;

import java.net.URL;

public enum IconCode {
    DAT3M, DARTAGNAN;

    @Override
    public String toString() {
        return switch (this) {
            case DAT3M -> "Dat3M";
            case DARTAGNAN -> "Dartagnan";
        };
    }

    public URL getPath() {
        return switch (this) {
            case DAT3M -> getResource("/dat3m.png");
            case DARTAGNAN -> getResource("/dartagnan.jpg");
        };
    }

    private URL getResource(String filename) {
        return Dat3M.class.getResource(filename);
    }
}
