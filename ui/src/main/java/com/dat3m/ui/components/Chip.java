package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;

// A pill-shaped status label, e.g., for verification verdicts.
public class Chip extends JComponent {

    public enum Kind {PASS, FAIL, NEUTRAL}

    private static final int HEIGHT = 24;
    private static final int PADDING = 10;
    private static final int DOT = 8;
    private static final int GAP = 6;

    private String text;
    private Kind kind;

    public Chip(String text, Kind kind) {
        this.text = text.toUpperCase();
        this.kind = kind;
    }

    public void setState(String text, Kind kind) {
        this.text = text.toUpperCase();
        this.kind = kind;
        revalidate();
        repaint();
    }

    private Font chipFont() {
        return Theme.tracked(Theme.ui(11f, Font.BOLD), 0.04f);
    }

    @Override
    public Dimension getPreferredSize() {
        final int textWidth = getFontMetrics(chipFont()).stringWidth(text);
        return new Dimension(2 * PADDING + DOT + GAP + textWidth, HEIGHT);
    }

    @Override
    public Dimension getMaximumSize() {
        return getPreferredSize();
    }

    @Override
    public Dimension getMinimumSize() {
        return getPreferredSize();
    }

    @Override
    protected void paintComponent(Graphics g) {
        final Graphics2D g2 = Theme.smooth(g.create());
        final Theme.Palette p = Theme.p();
        final Color fill = switch (kind) {
            case PASS -> p.passFill();
            case FAIL -> p.failFill();
            case NEUTRAL -> p.neutralFill();
        };
        final Color ink = switch (kind) {
            case PASS -> p.passInk();
            case FAIL -> p.failInk();
            case NEUTRAL -> p.neutralInk();
        };
        g2.setColor(fill);
        g2.fillRoundRect(0, 0, getWidth(), HEIGHT, HEIGHT, HEIGHT);
        g2.setColor(ink);
        g2.fillOval(PADDING, (HEIGHT - DOT) / 2, DOT, DOT);
        g2.setFont(chipFont());
        final FontMetrics metrics = g2.getFontMetrics();
        g2.drawString(text, PADDING + DOT + GAP, (HEIGHT - metrics.getHeight()) / 2 + metrics.getAscent());
        g2.dispose();
    }
}
