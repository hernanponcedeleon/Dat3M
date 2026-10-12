package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;
import java.util.function.Supplier;

// A panel with a themed fill, optional hairlines on its sides and inner padding.
public class Surface extends JPanel {

    private final Supplier<Color> fill;
    private Insets lines = new Insets(0, 0, 0, 0);
    private Insets padding = new Insets(0, 0, 0, 0);

    public Surface(LayoutManager layout, Supplier<Color> fill) {
        super(layout);
        this.fill = fill;
        applyTheme();
    }

    public static Surface panel(LayoutManager layout) {
        return new Surface(layout, () -> Theme.p().panel());
    }

    public static Surface ground(LayoutManager layout) {
        return new Surface(layout, () -> Theme.p().ground());
    }

    public Surface lines(int top, int left, int bottom, int right) {
        lines = new Insets(top, left, bottom, right);
        applyTheme();
        return this;
    }

    public Surface padding(int top, int left, int bottom, int right) {
        padding = new Insets(top, left, bottom, right);
        applyTheme();
        return this;
    }

    @Override
    public void updateUI() {
        super.updateUI();
        if (fill != null) {
            applyTheme();
        }
    }

    private void applyTheme() {
        setBackground(fill.get());
        setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createMatteBorder(lines.top, lines.left, lines.bottom, lines.right, Theme.p().line()),
                BorderFactory.createEmptyBorder(padding.top, padding.left, padding.bottom, padding.right)));
    }
}
