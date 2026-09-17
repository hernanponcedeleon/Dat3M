package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public record SpirvVersion(int major, int minor) implements Comparable<SpirvVersion> {

    public static final SpirvVersion UNKNOWN = new SpirvVersion(0, 0);
    private static final Pattern VERSION_PATTERN = Pattern.compile(
            "(?m)^\\s*;\\s*Version:\\s*(\\d+)\\.(\\d+)\\s*$");

    public static SpirvVersion parse(String input) {
        Matcher matcher = VERSION_PATTERN.matcher(input);
        return matcher.find()
                ? new SpirvVersion(Integer.parseInt(matcher.group(1)), Integer.parseInt(matcher.group(2)))
                : UNKNOWN;
    }

    public boolean isAtLeast(SpirvVersion other) {
        return compareTo(other) >= 0;
    }

    @Override
    public int compareTo(SpirvVersion other) {
        int majorComparison = Integer.compare(major, other.major);
        return majorComparison != 0 ? majorComparison : Integer.compare(minor, other.minor);
    }

    @Override
    public String toString() {
        return major + "." + minor;
    }
}
