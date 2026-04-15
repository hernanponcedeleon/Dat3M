package com.dat3m.dartagnan.witness.graphviz;

import java.util.Map;
import java.util.HashMap;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

class ColorMap {

    private final Map<String, String> relationColors = new HashMap<>();
    private int nextColorIndex = 0;

    // Kelly palette
    private static final String[] KELLY_COLORS = {
        "\"#FFB300\"", "\"#803E75\"", "\"#FF6800\"", "\"#A6BDD7\"", "\"#C10020\"",
        "\"#CEA262\"", "\"#817066\"", "\"#007D34\"", "\"#F6768E\"", "\"#00538A\"",
        "\"#FF7A5C\"", "\"#53377A\"", "\"#FF8E00\"", "\"#B32851\"", "\"#F4C800\"",
        "\"#7F180D\"", "\"#93AA00\"", "\"#593315\"", "\"#F13A13\"", "\"#232C16\""
    };

    ColorMap() {
        // Fixed colors
        relationColors.put(PO, "\"#000000\""); // black
        relationColors.put(RF, "\"#00AA00\""); // green
        relationColors.put(CO, "\"#FF0000\""); // red
        relationColors.put(SI, "\"#800080\""); // purple
    }

    String getColor(String relName) {
        return relationColors.computeIfAbsent(relName, k -> nextPaletteColor());
    }

    private String nextPaletteColor() {
        String color = KELLY_COLORS[nextColorIndex];
        nextColorIndex = (nextColorIndex + 1) % KELLY_COLORS.length;
        return color;
    }
}