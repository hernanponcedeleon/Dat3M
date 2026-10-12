package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;

// The top bar of a screen: brand and location on the left, the screen's actions on the right.
public class HeaderBar extends Surface {

    private final Text location = new Text("", Text.Role.MONO_MUTED);
    private final Text subject = new Text("", Text.Role.MONO);

    public HeaderBar(JComponent... actions) {
        super(new BorderLayout(24, 0), () -> Theme.p().panel());
        lines(0, 0, 1, 0);
        padding(10, 16, 10, 16);

        final Box left = Box.createHorizontalBox();
        left.add(new JLabel(Icons.logo()));
        left.add(Box.createHorizontalStrut(12));
        left.add(new Text("Dartagnan", Text.Role.BRAND));
        left.add(Box.createHorizontalStrut(12));
        final Surface divider = new Surface(null, () -> Theme.p().line());
        divider.setMaximumSize(new Dimension(1, 20));
        divider.setPreferredSize(new Dimension(1, 20));
        left.add(divider);
        left.add(Box.createHorizontalStrut(12));
        left.add(location);
        left.add(subject);
        add(left, BorderLayout.WEST);

        final Box right = Box.createHorizontalBox();
        for (int i = 0; i < actions.length; i++) {
            if (i > 0) {
                right.add(Box.createHorizontalStrut(12));
            }
            right.add(actions[i]);
        }
        add(right, BorderLayout.EAST);
    }

    // Shows "location / subject", e.g., the directory and name of the loaded program.
    public void setLocation(String location, String subject) {
        this.location.setText(location.isEmpty() ? "" : location + " / ");
        this.subject.setText(subject);
    }
}
