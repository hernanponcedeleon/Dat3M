package com.dat3m.dartagnan.logger;

import java.io.IOException;
import java.io.InputStream;
import java.text.MessageFormat;
import java.util.ResourceBundle;
import java.util.logging.LogManager;

import com.dat3m.dartagnan.analysis.Base;

public class ConsoleLogger implements System.Logger {

    public static System.Logger LOGGER = System.getLogger("Dartagnan");
    static {
        InputStream stream = Base.class.getClassLoader().getResourceAsStream("logging.properties");
        try {
            LogManager.getLogManager().readConfiguration(stream);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getName() {
        return "ConsoleLogger";
    }

    @Override
    public boolean isLoggable(Level level) {
        return true;
    }

    @Override
    public void log(Level level, ResourceBundle bundle, String msg, Throwable thrown) {
        System.out.printf("ConsoleLogger [%s]: %s - %s%n", level, msg, thrown);
    }

    @Override
    public void log(Level level, ResourceBundle bundle, String format, Object... params) {
        System.out.printf("ConsoleLogger [%s]: %s%n", level, 
          MessageFormat.format(format, params));
    }
}