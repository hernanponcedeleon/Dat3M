package com.dat3m.dartagnan.witness.graphviz;

import java.util.Map;
import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.*;

public class ColorMap {

    private static final Logger logger = LoggerFactory.getLogger(ColorMap.class);

    private final Map<String, String> relationColors = new HashMap<>();
    private int nextColorIndex = 0;

    // Kelly palette
    private static final String[] KELLY_COLORS = {
        "\"#FFB300\"", // vivid yellow
        "\"#FF6800\"", // vivid orange
        "\"#A6BDD7\"", // very light blue
        "\"#CEA262\"", // grayish yellow
        "\"#817066\"", // medium gray
        "\"#F6768E\"", // pink
        "\"#00538A\"", // strong blue
        "\"#FF7A5C\"", // coral
        "\"#FF8E00\"", // orange-yellow
        "\"#F4C800\"", // yellow
        "\"#593315\"", // brown
        "\"#F13A13\"", // reddish orange
        "\"#232C16\"", // olive green
        "\"#B32851\""  // purplish red
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
        if (nextColorIndex == KELLY_COLORS.length - 1) {
            logger.warn("Not enough distinct colors; palette will repeat. Consider reducing the number of shown relations.");
        }
        String color = KELLY_COLORS[nextColorIndex];
        nextColorIndex = (nextColorIndex + 1) % KELLY_COLORS.length;
        return color;
    }
}