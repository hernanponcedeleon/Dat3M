package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.Path2D;
import java.awt.geom.RoundRectangle2D;

// Small vector icons that are drawn in the foreground color of their component.
public final class Icons {

    private Icons() {
    }

    public static Icon play() {
        return new Glyph(12, path("M 2.5 1.5 L 10.5 6 L 2.5 10.5 Z"), true);
    }

    public static Icon stop() {
        return new Glyph(12, new RoundRectangle2D.Double(1.5, 1.5, 9, 9, 3, 3), true);
    }

    public static Icon open() {
        return new Glyph(16, path("M 1.5 12.5 L 1.5 3.5 L 6 3.5 L 7.5 5 L 13.5 5 L 13.5 7 "
                + "M 1.5 12.5 L 3.5 7 L 14.5 7 L 12.5 12.5 Z"), false);
    }

    public static Icon save() {
        return new Glyph(16, path("M 8 2 L 8 10 M 4.5 6.5 L 8 10 L 11.5 6.5 M 2.5 13.5 L 13.5 13.5"), false);
    }

    public static Icon copy() {
        return new Glyph(16, path("M 5.5 5.5 L 13.5 5.5 L 13.5 13.5 L 5.5 13.5 Z "
                + "M 10.5 5.5 L 10.5 2.5 L 2.5 2.5 L 2.5 10.5 L 5.5 10.5"), false);
    }

    public static Icon arrowRight() {
        return new Glyph(12, path("M 2 6 L 10 6 M 6.5 2.5 L 10 6 L 6.5 9.5"), false);
    }

    public static Icon arrowLeft() {
        return new Glyph(12, path("M 10 6 L 2 6 M 5.5 2.5 L 2 6 L 5.5 9.5"), false);
    }

    public static Icon plus() {
        return new Glyph(16, path("M 8 3.5 L 8 12.5 M 3.5 8 L 12.5 8"), false);
    }

    public static Icon minus() {
        return new Glyph(16, path("M 3.5 8 L 12.5 8"), false);
    }

    public static Icon logo() {
        return new Logo();
    }

    // Understands the absolute commands M, L and Z of SVG path data.
    private static Shape path(String data) {
        final Path2D.Double path = new Path2D.Double();
        final String[] tokens = data.trim().split("\\s+");
        int i = 0;
        while (i < tokens.length) {
            switch (tokens[i]) {
                case "M" -> {
                    path.moveTo(Double.parseDouble(tokens[i + 1]), Double.parseDouble(tokens[i + 2]));
                    i += 3;
                }
                case "L" -> {
                    path.lineTo(Double.parseDouble(tokens[i + 1]), Double.parseDouble(tokens[i + 2]));
                    i += 3;
                }
                case "Z" -> {
                    path.closePath();
                    i++;
                }
                default -> throw new IllegalArgumentException("Unsupported path command: " + tokens[i]);
            }
        }
        return path;
    }

    private record Glyph(int size, Shape shape, boolean filled) implements Icon {

        @Override
        public void paintIcon(Component c, Graphics g, int x, int y) {
            final Graphics2D g2 = Theme.smooth(g.create());
            g2.translate(x, y);
            g2.setColor(c.isEnabled() ? c.getForeground() : Theme.p().muted());
            if (filled) {
                g2.fill(shape);
            } else {
                g2.setStroke(new BasicStroke(1.5f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
                g2.draw(shape);
            }
            g2.dispose();
        }

        @Override
        public int getIconWidth() {
            return size;
        }

        @Override
        public int getIconHeight() {
            return size;
        }
    }

    private static final class Logo implements Icon {

        private static final int SIZE = 28;
        private static final Shape RAPIER = path("M 8 20 L 20 8 M 16.5 8 L 20 8 L 20 11.5 M 8 16 L 12 20");

        @Override
        public void paintIcon(Component c, Graphics g, int x, int y) {
            final Graphics2D g2 = Theme.smooth(g.create());
            g2.translate(x, y);
            g2.setColor(Theme.p().ink());
            g2.fillRoundRect(0, 0, SIZE, SIZE, 12, 12);
            g2.setColor(Theme.p().panel());
            g2.setStroke(new BasicStroke(2f, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND));
            g2.draw(RAPIER);
            g2.dispose();
        }

        @Override
        public int getIconWidth() {
            return SIZE;
        }

        @Override
        public int getIconHeight() {
            return SIZE;
        }
    }
}
