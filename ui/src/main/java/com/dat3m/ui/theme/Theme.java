package com.dat3m.ui.theme;

import com.formdev.flatlaf.FlatDarkLaf;
import com.formdev.flatlaf.FlatLaf;
import com.formdev.flatlaf.FlatLightLaf;

import javax.swing.*;
import java.awt.*;
import java.awt.font.TextAttribute;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/*
    Central place for the colors and fonts of the UI.
    Components read the current palette in their updateUI(), which FlatLaf triggers on every theme switch.
 */
public final class Theme {

    public record Palette(
            Color ground, Color panel, Color raised, Color line, Color ink, Color muted,
            Color accent, Color onAccent, Color track, Color selection,
            Color codeBlock, Color codeBlockInk,
            Color passFill, Color passInk, Color failFill, Color failInk, Color neutralFill, Color neutralInk,
            Color po, Color rf, Color fr, Color co,
            Color nodeFill, Color nodeLine, Color grid, Color highlightFill, Color highlightLine,
            Color keyword, Color comment, Color string, Color number) {
    }

    private static final Palette LIGHT = new Palette(
            c(0xF3F4F7), c(0xFFFFFF), c(0xFFFFFF), c(0xDADEE6), c(0x151A26), c(0x566072),
            c(0x2545D3), c(0xFFFFFF), c(0xE9ECF2), c(0xE8ECFC),
            c(0x151A26), c(0xE6E9EF),
            c(0xE8ECFC), c(0x1A329C), c(0xFFF0E0), c(0x8F3D00), c(0xEEF0F4), c(0x566072),
            c(0x000000), c(0x1E8E3E), c(0xC2570C), c(0xD32F2F),
            c(0xFFFFFF), c(0xC9CEDA), c(0xDDE1E8), c(0xFFF3C4), c(0xA86F00),
            c(0x2545D3), c(0x6B7385), c(0x8F3D00), c(0x0A6B6B));

    private static final Palette DARK = new Palette(
            c(0x0E1117), c(0x151A22), c(0x1B212B), c(0x2B3340), c(0xE6E9EF), c(0x9AA3B5),
            c(0x8FB0FF), c(0x0E1117), c(0x0E1117), c(0x1C2740),
            c(0x0E1117), c(0xE6E9EF),
            c(0x16223F), c(0xA9C1FF), c(0x2E1F10), c(0xF7B978), c(0x1B212B), c(0x9AA3B5),
            c(0xE6E9EF), c(0x5FD068), c(0xF2A65A), c(0xFF6B6B),
            c(0x1B212B), c(0x3A4456), c(0x232B38), c(0x3A2F0B), c(0xF2C94C),
            c(0x8FB0FF), c(0x8A93A5), c(0xF7B978), c(0x6FD3C7));

    private static final List<String> UI_FONTS = List.of("IBM Plex Sans");
    private static final List<String> MONO_FONTS = List.of("IBM Plex Mono", "JetBrains Mono", "Menlo", "Consolas");

    private static boolean dark = false;
    private static String monoFamily = Font.MONOSPACED;

    private Theme() {
    }

    public static Palette p() {
        return dark ? DARK : LIGHT;
    }

    public static boolean isDark() {
        return dark;
    }

    public static void install(boolean useDark) {
        dark = useDark;
        final Palette p = p();

        final Map<String, String> extraDefaults = new HashMap<>();
        extraDefaults.put("@accentColor", hex(p.accent()));
        extraDefaults.put("@background", hex(p.panel()));
        extraDefaults.put("@foreground", hex(p.ink()));
        FlatLaf.setGlobalExtraDefaults(extraDefaults);

        final Set<String> families = Set.of(GraphicsEnvironment.getLocalGraphicsEnvironment().getAvailableFontFamilyNames());
        UI_FONTS.stream().filter(families::contains).findFirst()
                .ifPresent(family -> UIManager.put("defaultFont", new Font(family, Font.PLAIN, 13)));
        monoFamily = MONO_FONTS.stream().filter(families::contains).findFirst().orElse(Font.MONOSPACED);

        UIManager.put("Component.arc", 6);
        UIManager.put("Button.arc", 6);
        UIManager.put("TextComponent.arc", 6);
        UIManager.put("ScrollBar.width", 10);
        UIManager.put("SplitPaneDivider.gripDotCount", 0);

        if (dark) {
            FlatDarkLaf.setup();
        } else {
            FlatLightLaf.setup();
        }
        FlatLaf.updateUI();
    }

    public static Font ui(float size, int style) {
        Font base = UIManager.getFont("defaultFont");
        if (base == null) {
            base = UIManager.getFont("Label.font");
        }
        if (base == null) {
            base = new Font(Font.SANS_SERIF, Font.PLAIN, 13);
        }
        return base.deriveFont(style, size);
    }

    public static Font mono(float size) {
        return new Font(monoFamily, Font.PLAIN, 1).deriveFont(size);
    }

    public static Font tracked(Font font, float tracking) {
        return font.deriveFont(Map.of(TextAttribute.TRACKING, tracking));
    }

    public static Graphics2D smooth(Graphics g) {
        final Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setRenderingHint(RenderingHints.KEY_STROKE_CONTROL, RenderingHints.VALUE_STROKE_PURE);
        g2.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        return g2;
    }

    private static Color c(int rgb) {
        return new Color(rgb);
    }

    private static String hex(Color color) {
        return "#%06X".formatted(color.getRGB() & 0xFFFFFF);
    }
}
