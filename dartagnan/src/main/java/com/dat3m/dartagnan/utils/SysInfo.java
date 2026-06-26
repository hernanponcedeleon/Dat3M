package com.dat3m.dartagnan.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class SysInfo {

    private static final Logger logger = LoggerFactory.getLogger(SysInfo.class);

    public static String logOSInfo() {
        String osInfo = String.format("OS: %s | Arch: %s | Version: %s",
                System.getProperty("os.name"),
                System.getProperty("os.arch"),
                System.getProperty("os.version"));
        logger.info(osInfo);
        return osInfo;
    }

    public static String logClangInfo() {
        try {
            ProcessBuilder pb = new ProcessBuilder("clang", "--version");
            Process process = pb.start();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                String firstLine = reader.readLine();
                String version = (firstLine != null) ? firstLine : "unknown";
                logger.info("Clang version: {}", version);
                return version;
            }
        } catch (IOException e) {
            String errorMsg = "Clang not detected or not in PATH";
            logger.warn("Failed to retrieve clang version: {}", errorMsg, e);
            return errorMsg;
        }
    }
}