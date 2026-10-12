package com.dat3m.ui.components;

import com.dat3m.ui.theme.Theme;

import javax.swing.*;
import java.awt.*;

// A panel-colored surface for scroll panes that only scroll vertically: it always takes the width of the viewport.
public class Column extends Surface implements Scrollable {

    public Column(LayoutManager layout) {
        super(layout, () -> Theme.p().panel());
    }

    @Override
    public Dimension getPreferredScrollableViewportSize() {
        return getPreferredSize();
    }

    @Override
    public int getScrollableUnitIncrement(Rectangle visibleRect, int orientation, int direction) {
        return 16;
    }

    @Override
    public int getScrollableBlockIncrement(Rectangle visibleRect, int orientation, int direction) {
        return visibleRect.height;
    }

    @Override
    public boolean getScrollableTracksViewportWidth() {
        return true;
    }

    // Fills the viewport if there is spare room, so that content can be pinned to the bottom.
    @Override
    public boolean getScrollableTracksViewportHeight() {
        return getParent() != null && getParent().getHeight() > getPreferredSize().height;
    }
}
