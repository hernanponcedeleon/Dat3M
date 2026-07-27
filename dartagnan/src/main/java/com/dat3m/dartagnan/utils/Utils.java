package com.dat3m.dartagnan.utils;

import com.google.common.io.Files;

import java.nio.file.Path;
import java.util.concurrent.TimeUnit;

public class Utils {

    private Utils() {
    }

    public static boolean containsSubpath(Path path, Path subpath) {
        return path.toString().contains(subpath.toString());
    }

    public static Path subpath(Path path, int from) {
        return path.subpath(from, path.getNameCount() - 1);
    }

    public static String getFileExtension(Path path) {
        return Files.getFileExtension(path.getFileName().toString());
    }

    public static String getNameWithoutExtension(Path path) {
        return getNameWithoutExtension(path.getFileName().toString());
    }

    public static String getNameWithoutExtension(String fileName) {
        return Files.getNameWithoutExtension(fileName);
    }

    public static String toTimeString(long milliseconds) {
        final long hours = TimeUnit.MILLISECONDS.toHours(milliseconds);
        milliseconds -= TimeUnit.HOURS.toMillis(hours);
        final long minutes = TimeUnit.MILLISECONDS.toMinutes(milliseconds);
        milliseconds -= TimeUnit.MINUTES.toMillis(minutes);
        final long seconds = TimeUnit.MILLISECONDS.toSeconds(milliseconds);
        milliseconds -= TimeUnit.SECONDS.toMillis(seconds);

        if (hours == 0 && minutes == 0) {
            return String.format("%d.%03d secs", seconds, milliseconds);
        } else if (hours == 0) {
            return String.format("%d:%02d mins", minutes, seconds);
        } else {
            return String.format("%d:%02d:%02d hours", hours, minutes, seconds);
        }
    }
}
