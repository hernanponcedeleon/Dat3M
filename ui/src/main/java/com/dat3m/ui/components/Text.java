package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;

// A label whose font and color follow its role in the current theme.
public class Text extends JLabel {

    public enum Role {BODY, STRONG, MUTED, SECTION, TITLE, HEADLINE, BRAND, MONO, MONO_MUTED}

    private final Role role;

    public Text(String text, Role role) {
        super(role == Role.SECTION ? text.toUpperCase() : text);
        this.role = role;
        applyTheme();
    }

    @Override
    public void updateUI() {
        super.updateUI();
        if (role != null) {
            applyTheme();
        }
    }

    private void applyTheme() {
        final Theme.Palette p = Theme.p();
        switch (role) {
            case BODY -> style(Theme.ui(13f, Font.PLAIN), p.ink());
            case STRONG -> style(Theme.ui(13f, Font.BOLD), p.ink());
            case MUTED -> style(Theme.ui(13f, Font.PLAIN), p.muted());
            case SECTION -> style(Theme.tracked(Theme.ui(11f, Font.BOLD), 0.06f), p.muted());
            case TITLE -> style(Theme.ui(14f, Font.BOLD), p.ink());
            case HEADLINE -> style(Theme.ui(20f, Font.BOLD), p.ink());
            case BRAND -> style(Theme.ui(16f, Font.BOLD), p.ink());
            case MONO -> style(Theme.mono(13f), p.ink());
            case MONO_MUTED -> style(Theme.mono(12f), p.muted());
        }
    }

    private void style(Font font, Color color) {
        setFont(font);
        setForeground(color);
    }
}
