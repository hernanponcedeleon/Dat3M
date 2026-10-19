package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.geom.Area;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Path2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.util.List;

/*
    The icon of the application: the musketeer d'Artagnan, reduced to his hat with its plume, moustache and goatee.
    It is drawn as vector graphics on a 64x64 grid, so that it stays sharp at every size.
 */
public final class AppIcon {

    private static final double GRID = 64;
    private static final Color TILE = new Color(0x151A26);
    private static final Color FIGURE = new Color(0xFFFFFF);
    private static final Color PLUME = new Color(0x8FB0FF);

    private static final Shape HAT = newHat();
    private static final Shape PLUME_SHAPE = newPlume();
    private static final Shape FACE = newFace();

    private AppIcon() {
    }

    // The sizes that window managers commonly ask for.
    public static List<Image> images() {
        return List.of(image(16, 0), image(32, 0), image(48, 0), image(64, 0), image(128, 0), image(256, 0));
    }

    // Docks expect some transparent space around the icon, which the margin provides as a fraction of the size.
    public static BufferedImage image(int size, double margin) {
        final BufferedImage image = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
        final Graphics2D g2 = Theme.smooth(image.createGraphics());
        final double inset = size * margin;
        g2.translate(inset, inset);
        paint(g2, size - 2 * inset, TILE, FIGURE, PLUME);
        g2.dispose();
        return image;
    }

    public static void paint(Graphics2D g2, double size, Color tile, Color figure, Color plume) {
        final AffineTransform original = g2.getTransform();
        g2.scale(size / GRID, size / GRID);
        g2.setColor(tile);
        g2.fill(new RoundRectangle2D.Double(0, 0, GRID, GRID, 28, 28));
        g2.setColor(plume);
        g2.fill(PLUME_SHAPE);
        g2.setColor(figure);
        g2.fill(HAT);
        g2.fill(FACE);
        g2.setTransform(original);
    }

    // A wide, slightly tilted brim with a low crown.
    private static Shape newHat() {
        final Area hat = new Area(AffineTransform.getRotateInstance(Math.toRadians(-8), 32, 26)
                .createTransformedShape(new Ellipse2D.Double(4, 20.5, 56, 11)));
        final Path2D.Double crown = new Path2D.Double();
        crown.moveTo(19, 27);
        crown.curveTo(18, 18, 24, 13, 32, 12.5);
        crown.curveTo(40, 12, 45, 16, 45.5, 24);
        crown.closePath();
        hat.add(new Area(crown));
        return hat;
    }

    // The feather rises from the band of the hat and sweeps back over its crown.
    private static Shape newPlume() {
        final Path2D.Double plume = new Path2D.Double();
        plume.moveTo(47, 22);
        plume.curveTo(50, 7, 30, 0, 11, 10);
        plume.curveTo(24, 7.5, 37, 11, 40, 21);
        plume.closePath();
        return plume;
    }

    // A moustache with curled tips above a pointed goatee.
    private static Shape newFace() {
        final Path2D.Double half = new Path2D.Double();
        half.moveTo(32, 40.5);
        half.curveTo(28, 38, 23, 41, 19, 40);
        half.curveTo(16, 39.3, 14.5, 37, 15, 34.5);
        half.curveTo(12.5, 38, 14.5, 45.5, 21, 45.5);
        half.curveTo(26, 45.5, 30, 45, 32, 43.5);
        half.closePath();
        final Area face = new Area(half);
        face.add(new Area(new AffineTransform(-1, 0, 0, 1, 64, 0).createTransformedShape(half)));
        final Path2D.Double goatee = new Path2D.Double();
        goatee.moveTo(29.5, 48);
        goatee.curveTo(31, 49, 33, 49, 34.5, 48);
        goatee.curveTo(34.3, 52, 33.2, 55.5, 32, 58);
        goatee.curveTo(30.8, 55.5, 29.7, 52, 29.5, 48);
        goatee.closePath();
        face.add(new Area(goatee));
        return face.createTransformedArea(AffineTransform.getTranslateInstance(0, 2));
    }
}
