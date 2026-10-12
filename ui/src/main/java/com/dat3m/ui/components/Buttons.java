package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;

public final class Buttons {

    private Buttons() {
    }

    // The single most important action of a screen.
    public static JButton primary(String text, Icon icon) {
        return new Primary(text, icon);
    }

    public static JButton plain(String text, Icon icon) {
        final JButton button = new JButton(text, icon);
        button.setIconTextGap(8);
        return button;
    }

    public static JButton icon(Icon icon, String description) {
        final JButton button = new JButton(icon);
        button.putClientProperty("JButton.buttonType", "toolBarButton");
        button.setToolTipText(description);
        button.getAccessibleContext().setAccessibleName(description);
        button.setPreferredSize(new Dimension(32, 32));
        return button;
    }

    private static final class Primary extends JButton {

        private boolean initialized;

        private Primary(String text, Icon icon) {
            super(text, icon);
            setIconTextGap(8);
            initialized = true;
            applyTheme();
        }

        @Override
        public void updateUI() {
            super.updateUI();
            if (initialized) {
                applyTheme();
            }
        }

        private void applyTheme() {
            setBackground(Theme.p().accent());
            setForeground(Theme.p().onAccent());
            setFont(Theme.ui(13f, Font.BOLD));
        }
    }
}
