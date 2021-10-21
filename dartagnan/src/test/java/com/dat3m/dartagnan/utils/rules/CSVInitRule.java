package com.dat3m.dartagnan.utils.rules;

import com.dat3m.dartagnan.utils.ResourceHelper;
import org.apache.logging.log4j.LogManager;
import org.junit.rules.TestWatcher;
import org.junit.runner.Description;

import java.io.IOException;

// To be uses as a ClassRule
public class CSVInitRule extends TestWatcher {
    private final String[] csvFileNames;

    public CSVInitRule(String... fileNames) {
        this.csvFileNames = fileNames;
    }

    @Override
    protected void starting(Description description) {
        try {
            for (String fileName : csvFileNames) {
                ResourceHelper.initialiseCSVFile(description.getTestClass(), fileName);
            }
        } catch (IOException e) {
            LogManager.getRootLogger().error(e.getMessage());
        }
    }
}
