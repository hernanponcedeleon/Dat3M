package com.dat3m.ui.options;

import javax.swing.*;
import java.util.HashMap;
import java.util.Map;

public class ConfigField extends JTextField {

    public Map<String, String> getConfiguration() {
        final Map<String, String> config = new HashMap<>();
        for (String c : getText().split(" ")) {
            int separator = c.indexOf('=');
            if (separator != -1 && c.startsWith("--")) {
                config.put(c.substring(2, separator), c.substring(separator + 1));
            }
        }
        return config;
    }
}
