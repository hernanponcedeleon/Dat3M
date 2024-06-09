package com.dat3m.ui.icon;

import javax.swing.*;
import java.awt.*;
import java.util.HashMap;
import java.util.Map;

public class IconHelper {

    private static Map<IconCode, Map<Integer, ImageIcon>> data = new HashMap<>();

    public static ImageIcon getIcon(IconCode code) {
        return getIcon(code, -1);
    }

    public static ImageIcon getIcon(IconCode code, int height) {
        data.putIfAbsent(code, new HashMap<>());
        Map<Integer, ImageIcon> heightMap = data.get(code);
        height = Math.max(-1, height);
        if (!heightMap.containsKey(height)) {
            heightMap.put(height, mkIcon(code, height));
        }
        return heightMap.get(height);
    }

    private static ImageIcon mkIcon(IconCode code, int height) {
        ImageIcon origImage = new ImageIcon(code.getPath(), code.toString());
        if (height == -1) {
            return origImage;
        }

        if (height > origImage.getIconHeight()) {
            System.err.println("Warning: scaling image large its original size might degrade image quality");
        }

        int width = origImage.getIconWidth() * height / origImage.getIconHeight();
        Image image = origImage.getImage();
        Image scaledImage = image.getScaledInstance(width, height, Image.SCALE_SMOOTH);
        return new ImageIcon(scaledImage);
    }
}
