package com.dat3m.dartagnan.program.processing.libraries;

public enum CLibImplementation {
    GLIBC, // ~ Linux
    DARWIN_LIBC, // ~ MacOs
    MINGW, // ~ Windows (MinGW-w64: Microsoft CRT + winpthreads)
}
