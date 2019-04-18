package com.dat3m.ui.editor;

import static java.lang.String.valueOf;
import static javax.swing.text.Utilities.getRowEnd;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JComponent;
import javax.swing.event.CaretEvent;
import javax.swing.event.CaretListener;
import javax.swing.text.BadLocationException;
import javax.swing.text.Element;
import javax.swing.text.JTextComponent;

class LineNumbersView extends JComponent implements CaretListener, ActionListener {

    private final JTextComponent editor;

    LineNumbersView(JTextComponent editor) {
        this.editor = editor;
        editor.addCaretListener(this);
        Dimension size = new Dimension(28, editor.getHeight());
        setPreferredSize(size);
        setSize(size);
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);

        Rectangle clip = g.getClipBounds();
        int currentOffset = editor.viewToModel(new Point(0, clip.y));
        int endOffset = editor.viewToModel(new Point(0, clip.y + clip.height));

        while (currentOffset <= endOffset) {
            try {
                // Computes the line number based on the offset
                int lineNumber = editor.getDocument().getDefaultRootElement().getElementIndex(currentOffset) + 1;
                // x position of the line number is fixed
                int x = getInsets().left + 2;
                // y position is different for each line number
                int y = getOffsetY(currentOffset);

                g.setFont(new Font(Font.MONOSPACED, Font.BOLD, editor.getFont().getSize()));
                g.setColor(isCurrentLine(currentOffset) ? Color.RED : Color.BLACK);
                g.drawString(valueOf(lineNumber), x, y);

                // Update offset
                currentOffset = getRowEnd(editor, currentOffset) + 1;
            } catch (BadLocationException e) {
                e.printStackTrace();
            }
        }
    }

    private int getOffsetY(int offset) throws BadLocationException {
        int descent = editor.getFontMetrics(editor.getFont()).getDescent();
        Rectangle r = editor.modelToView(offset);
        return r.y + r.height - descent;
    }

    private boolean isCurrentLine(int offset) {
        Element root = editor.getDocument().getDefaultRootElement();
        return root.getElementIndex(offset) == root.getElementIndex(editor.getCaretPosition());
    }

    @Override
    public void caretUpdate(CaretEvent e) {
        repaint();
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        repaint();
    }
}