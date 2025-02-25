package com.dat3m.dartagnan.others;

import org.junit.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class GlobalSettingsTest {

    private final Path pathOutputDirectory = Paths.get("target/output");

    @Test
    public void shouldCreateOutputDirectoryInCreateMode() throws IOException {
        // given
        Files.deleteIfExists(pathOutputDirectory);

        // when
        GlobalSettings.getOrCreateOutputDirectory();

        // then
        assertTrue(Files.exists(pathOutputDirectory));
        assertTrue(Files.isDirectory(pathOutputDirectory));
    }

    @Test
    public void shouldNotCreateOutputDirectoryInGetMode() throws IOException {
        // given
        Files.deleteIfExists(pathOutputDirectory);

        // when
        GlobalSettings.getOutputDirectory();

        // then
        assertFalse(Files.exists(pathOutputDirectory));
    }
}
