package com.dat3m.dartagnan.utils;

import java.util.concurrent.TimeUnit;

public class Utils {

    private Utils() {
    }

    public static String toTimeString(long milliseconds) {
        final long hours = TimeUnit.MILLISECONDS.toHours(milliseconds);
        milliseconds -= TimeUnit.HOURS.toMillis(hours);
        final long minutes = TimeUnit.MILLISECONDS.toMinutes(milliseconds);
        milliseconds -= TimeUnit.MINUTES.toMillis(minutes);
        final long seconds = TimeUnit.MILLISECONDS.toSeconds(milliseconds);
        milliseconds -= TimeUnit.SECONDS.toMillis(seconds);

        if (hours == 0 && minutes == 0) {
            return String.format("%d.%d secs", seconds, milliseconds);
        } else if (hours == 0) {
            return String.format("%d:%02d mins", minutes, seconds);
        } else {
            return String.format("%d:%02d:%02d hours", hours, minutes, seconds);
        }
    }
}
