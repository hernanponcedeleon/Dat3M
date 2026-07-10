package com.dat3m.dartagnan.utils;

import com.google.common.io.Files;

import java.io.File;
import java.util.concurrent.TimeUnit;

public class Utils {

    private Utils() {
    }

    public static String getNameWithoutExtension(File file) {
        return getNameWithoutExtension(file.getName());
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
