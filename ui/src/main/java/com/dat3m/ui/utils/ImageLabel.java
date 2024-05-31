package com.dat3m.ui.utils;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;

public class ImageLabel extends JLabel {
    final ImageIcon imageIcon;
    final Image originalImage;
    final int originalWidth, originalHeight;
    double zoomLevel = 1.0;

    public ImageLabel(ImageIcon imageIcon) {
        super(imageIcon);
        this.imageIcon = imageIcon;
        originalImage = imageIcon.getImage();
        originalWidth = originalImage.getWidth(null);
        originalHeight = originalImage.getHeight(null);
    }

    public void zoom(double zoom) {
        this.zoomLevel *= zoom;
        setDimensions((int)(originalWidth * zoomLevel), (int)(originalHeight * zoomLevel));
    }

    public void setDimensions(int width, int height) {
        BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = resizedImage.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g.drawImage(originalImage, 0, 0, width, height, null);
        g.dispose();

        imageIcon.setImage(resizedImage);

        Container parent = this.getParent();
        if (parent != null) {
            parent.repaint();
        }
        this.repaint();
    }
}