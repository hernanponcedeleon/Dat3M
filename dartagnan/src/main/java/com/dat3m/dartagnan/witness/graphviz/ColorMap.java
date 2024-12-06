package com.dat3m.dartagnan.witness.graphviz;

import java.awt.Color;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.PO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;


class ColorMap {
    private final Map<String, String> fixedColorMap = new HashMap<>();
    private final Set<String> usedColors = new HashSet<>();
    private int currentHue = 0;
    private int step = 72;
    private float saturation = 1.0f;
    private float brightness = 1.0f;

    ColorMap() {
        // Black for PO
        fixedColorMap.put(PO, colorToHex(Color.getHSBColor(0.0f, 0.0f, 0.0f)));
        // Green for RF
        fixedColorMap.put(RF, colorToHex(Color.getHSBColor(0.33f, 1.0f, 1.0f)));
        // Red for CO
        fixedColorMap.put(CO, colorToHex(Color.getHSBColor(0.0f, 1.0f, 1.0f)));

        usedColors.addAll(fixedColorMap.values());
    }

    String getColor(String relName) {
        if (fixedColorMap.containsKey(relName)) {
            return fixedColorMap.get(relName);
        }
        return generateColor();
    }

    private String generateColor() {
        updateHue();
        float hue = currentHue / 360.0f;
        String c = colorToHex(Color.getHSBColor(hue, saturation, brightness));
        if (usedColors.contains(c)) {
            c = generateColor();
        }
        usedColors.add(c);
        return c;
    }

    private String colorToHex(Color c) {
        return String.format("\"#%02x%02x%02x\"", c.getRed(), c.getGreen(), c.getBlue());
    }

    private void updateHue() {
        currentHue += step;
        if (currentHue >= 360) {
            currentHue -= 360;
            step /= 2;
            if (currentHue == 0) {
                updateHue();
            }
        }
    }
}