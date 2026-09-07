package com.dat3m.dartagnan.utils;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.verification.ResultStatus;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static com.dat3m.dartagnan.verification.ResultStatus.FAIL;
import static com.dat3m.dartagnan.verification.ResultStatus.PASS;

public class ResourceHelper {

    public static Path getRootPath(String path) {
        return Path.of("..").resolve(path);
    }

    public static Path getTestResourcePath(String path) {
        return Path.of("src", "test", "resources").resolve(path);
    }

    public static Path getCatPathFromName(String name) {
        return getRootPath("cat/%s.cat".formatted(name));
    }

    public static Path getCatPath(Arch architecture, String nameOverride) {
        final String name = nameOverride != null ? nameOverride : getWmmNameFromArchitecture(architecture);
        return getCatPathFromName(name);
    }

    public static ImmutableMap<Path, ResultStatus> getExpectedResults(String arch, String postfix) throws IOException {
        Path path = getTestResourcePath(arch + postfix + "-expected.csv");
        var data = ImmutableMap.<Path, ResultStatus>builder();
        Files.readAllLines(path).stream().filter(ResourceHelper::isValidEntry).forEach(str -> {
            String[] line = str.split(",");
            if (line.length == 2) {
                data.put(getRootPath(line[0]), Integer.parseInt(line[1]) == 1 ? PASS : FAIL);
            }
        });
        return data.build();
    }

    public static ImmutableSet<Path> getSkipSet() throws IOException {
        return Files.readAllLines(getTestResourcePath("dartagnan-skip.csv")).stream()
                .filter(ResourceHelper::isValidEntry)
                .map(ResourceHelper::getRootPath)
                .collect(ImmutableSet.toImmutableSet());
    }

    private static boolean isValidEntry(String line) {
        return !line.isBlank() && !line.startsWith("//");
    }

    private static String getWmmNameFromArchitecture(Arch architecture) {
        return switch (architecture) {
            case TSO -> "tso";
            case ARM8 -> "aarch64";
            case POWER -> "power";
            case RISCV -> "riscv";
            case LKMM -> "linux-kernel";
            case IMM -> "imm";
            case VULKAN -> "vulkan";
            case OPENCL -> "opencl";
            default -> throw new IllegalArgumentException("The provided architecture %s has no associated memory model".formatted(architecture));
        };
    }
}
