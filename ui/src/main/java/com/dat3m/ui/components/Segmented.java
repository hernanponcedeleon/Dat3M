package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;
import java.util.LinkedHashMap;
import java.util.Map;

// A row of mutually exclusive choices, used where there are only few options.
public class Segmented<T> extends JPanel {

    private static final int HEIGHT = 36;

    private final Map<T, JToggleButton> buttons = new LinkedHashMap<>();

    public Segmented(T[] values, T selected) {
        super(new GridLayout(1, 0, 2, 0));
        setOpaque(false);
        setBorder(BorderFactory.createEmptyBorder(2, 2, 2, 2));
        final ButtonGroup group = new ButtonGroup();
        for (T value : values) {
            final JToggleButton button = new Segment(value.toString());
            button.setSelected(value.equals(selected));
            group.add(button);
            buttons.put(value, button);
            add(button);
        }
    }

    public T getSelected() {
        return buttons.entrySet().stream()
                .filter(entry -> entry.getValue().isSelected())
                .map(Map.Entry::getKey)
                .findFirst().orElseThrow();
    }

    public void setSelected(T value) {
        final JToggleButton button = buttons.get(value);
        if (button != null) {
            button.setSelected(true);
        }
    }

    public void addChangeListener(Runnable listener) {
        buttons.values().forEach(button -> button.addActionListener(ignored -> listener.run()));
    }

    @Override
    public Dimension getPreferredSize() {
        return new Dimension(super.getPreferredSize().width, HEIGHT);
    }

    @Override
    protected void paintComponent(Graphics g) {
        final Graphics2D g2 = Theme.smooth(g.create());
        g2.setColor(Theme.p().track());
        g2.fillRoundRect(0, 0, getWidth(), getHeight(), 10, 10);
        g2.dispose();
    }

    private static final class Segment extends JToggleButton {

        private Segment(String text) {
            super(text);
            setContentAreaFilled(false);
            setBorderPainted(false);
            setFocusPainted(true);
        }

        @Override
        protected void paintComponent(Graphics g) {
            final Graphics2D g2 = Theme.smooth(g.create());
            if (isSelected()) {
                g2.setColor(Theme.p().raised());
                g2.fillRoundRect(0, 0, getWidth(), getHeight(), 8, 8);
                g2.setColor(Theme.p().line());
                g2.drawRoundRect(0, 0, getWidth() - 1, getHeight() - 1, 8, 8);
            }
            g2.dispose();
            setForeground(isSelected() ? Theme.p().ink() : Theme.p().muted());
            super.paintComponent(g);
        }
    }
}
