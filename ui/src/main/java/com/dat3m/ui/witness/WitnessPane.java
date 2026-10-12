package com.dat3m.ui.witness;

import com.dat3m.ui.components.Buttons;
import com.dat3m.ui.components.Chip;
import com.dat3m.ui.components.Column;
import com.dat3m.ui.components.HeaderBar;
import com.dat3m.ui.components.Icons;
import com.dat3m.ui.components.Surface;
import com.dat3m.ui.components.Text;
import com.dat3m.ui.theme.Theme;
import com.dat3m.ui.witness.WitnessGraph.AxiomInfo;
import com.dat3m.ui.witness.WitnessGraph.Edge;
import com.dat3m.ui.witness.WitnessGraph.MemoryValue;
import com.dat3m.ui.witness.WitnessGraph.Node;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.PO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.dat3m.ui.utils.Utils.showError;
import static com.dat3m.ui.witness.WitnessGraph.FR;

// The screen that shows a witness execution together with details about its events.
public class WitnessPane extends JPanel {

    private static final int INSPECTOR_WIDTH = 300;
    private static final Set<String> DEFAULT_RELATIONS = Set.of(PO, RF, CO);
    private static final Map<String, String> RELATION_DESCRIPTIONS = Map.of(
            PO, "program order", RF, "read from", CO, "coherence", FR, "from read");

    private final HeaderBar header;
    private final Chip verdictChip = new Chip("", Chip.Kind.NEUTRAL);
    private final Text verdictText = new Text("", Text.Role.MONO);
    private final WitnessGraphView graphView = new WitnessGraphView();
    private final JPanel eventPanel = new JPanel(new GridBagLayout());
    private final JPanel relationsPanel = new JPanel();
    private final JPanel memoryPanel = new JPanel(new GridBagLayout());
    private final JPanel axiomsPanel = new JPanel(new GridBagLayout());
    private final JFileChooser exportChooser = new JFileChooser();

    private WitnessGraph graph;

    public WitnessPane(Runnable backAction) {
        super(new BorderLayout());

        final JButton backButton = Buttons.plain("Workbench", Icons.arrowLeft());
        backButton.addActionListener(event -> backAction.run());
        final JButton exportButton = Buttons.plain("Export PNG", Icons.save());
        exportButton.addActionListener(event -> exportImage());
        header = new HeaderBar(backButton, exportButton);
        add(header, BorderLayout.NORTH);

        exportChooser.setFileFilter(new FileNameExtensionFilter("*.png", "png"));
        graphView.setSelectionListener(this::showEvent);

        final JPanel center = new JPanel(new BorderLayout());
        center.add(newVerdictStrip(), BorderLayout.NORTH);
        final JScrollPane graphScroll = new JScrollPane(graphView);
        graphScroll.setBorder(BorderFactory.createEmptyBorder());
        center.add(graphScroll, BorderLayout.CENTER);
        center.add(newAxiomsStrip(), BorderLayout.SOUTH);
        add(center, BorderLayout.CENTER);
        add(newInspector(), BorderLayout.EAST);
    }

    public void showWitness(WitnessGraph graph, String programName, String verdict, Chip.Kind kind, String description) {
        this.graph = graph;
        header.setLocation(programName, "witness");
        verdictChip.setState(verdict, kind);
        verdictText.setText(description);

        final Set<String> visible = new HashSet<>(DEFAULT_RELATIONS);
        visible.retainAll(graph.relations());
        graphView.setGraph(graph, visible);

        relationsPanel.removeAll();
        for (String relation : List.of(PO, RF, CO, FR)) {
            if (graph.relations().contains(relation)) {
                relationsPanel.add(newRelationToggle(relation, visible.contains(relation)));
            }
        }

        memoryPanel.removeAll();
        int row = 0;
        for (MemoryValue value : graph.finalMemory()) {
            addRow(memoryPanel, row++, new Text(value.address(), Text.Role.MONO), new Text(value.value(), Text.Role.MONO));
        }
        if (graph.finalMemory().isEmpty()) {
            addRow(memoryPanel, 0, new Text("No memory was written.", Text.Role.MUTED), null);
        }

        axiomsPanel.removeAll();
        row = 0;
        for (AxiomInfo axiom : graph.axioms()) {
            final Text status = new Text(axiom.status(), axiom.isViolated() ? Text.Role.STRONG : Text.Role.MUTED);
            addRow(axiomsPanel, row++, new Text(axiom.term(), Text.Role.MONO), status);
        }

        showEvent(null);
        revalidate();
        repaint();
    }

    // ================================= Construction =================================

    private JComponent newVerdictStrip() {
        final Surface strip = Surface.panel(new FlowLayout(FlowLayout.LEFT, 12, 0)).lines(0, 0, 1, 0).padding(14, 12, 14, 12);
        strip.add(verdictChip);
        strip.add(verdictText);

        final Surface zoom = Surface.panel(new FlowLayout(FlowLayout.RIGHT, 4, 0)).lines(0, 0, 1, 0).padding(10, 12, 10, 12);
        final JButton zoomOut = Buttons.icon(Icons.minus(), "Zoom out");
        zoomOut.addActionListener(event -> graphView.zoom(1 / 1.2));
        final JButton zoomIn = Buttons.icon(Icons.plus(), "Zoom in");
        zoomIn.addActionListener(event -> graphView.zoom(1.2));
        zoom.add(zoomOut);
        zoom.add(zoomIn);

        final JPanel row = new JPanel(new BorderLayout());
        row.add(strip, BorderLayout.CENTER);
        row.add(zoom, BorderLayout.EAST);
        return row;
    }

    private JComponent newAxiomsStrip() {
        final Surface strip = Surface.panel(new BorderLayout(0, 8)).lines(1, 0, 0, 0).padding(16, 24, 16, 24);
        strip.add(new Text("Axioms of the memory model", Text.Role.SECTION), BorderLayout.NORTH);
        axiomsPanel.setOpaque(false);
        final JPanel top = new JPanel(new BorderLayout());
        top.setOpaque(false);
        top.add(axiomsPanel, BorderLayout.NORTH);
        final JScrollPane scroll = new JScrollPane(top);
        scroll.setBorder(BorderFactory.createEmptyBorder());
        scroll.setOpaque(false);
        scroll.getViewport().setOpaque(false);
        scroll.setPreferredSize(new Dimension(0, 96));
        strip.add(scroll, BorderLayout.CENTER);
        return strip;
    }

    private JComponent newInspector() {
        final Column inspector = new Column(new GridBagLayout());
        inspector.padding(20, 16, 20, 16);
        final GridBagConstraints constraints = new GridBagConstraints();
        constraints.gridx = 0;
        constraints.weightx = 1;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.anchor = GridBagConstraints.NORTHWEST;

        eventPanel.setOpaque(false);
        relationsPanel.setOpaque(false);
        relationsPanel.setLayout(new BoxLayout(relationsPanel, BoxLayout.Y_AXIS));
        memoryPanel.setOpaque(false);

        constraints.insets = new Insets(0, 0, 10, 0);
        inspector.add(new Text("Selected event", Text.Role.SECTION), constraints);
        constraints.insets = new Insets(0, 0, 28, 0);
        inspector.add(eventPanel, constraints);
        constraints.insets = new Insets(0, 0, 10, 0);
        inspector.add(new Text("Relations", Text.Role.SECTION), constraints);
        constraints.insets = new Insets(0, 0, 28, 0);
        inspector.add(relationsPanel, constraints);
        constraints.insets = new Insets(0, 0, 10, 0);
        inspector.add(new Text("Final memory", Text.Role.SECTION), constraints);
        constraints.insets = new Insets(0, 0, 0, 0);
        inspector.add(memoryPanel, constraints);
        constraints.weighty = 1;
        inspector.add(Box.createGlue(), constraints);

        final JScrollPane scroll = new JScrollPane(inspector,
                JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
        scroll.setBorder(BorderFactory.createEmptyBorder());
        scroll.setPreferredSize(new Dimension(INSPECTOR_WIDTH, 0));
        final Surface frame = Surface.panel(new BorderLayout()).lines(0, 1, 0, 0);
        frame.add(scroll, BorderLayout.CENTER);
        return frame;
    }

    private JComponent newRelationToggle(String relation, boolean isVisible) {
        final JCheckBox toggle = new JCheckBox();
        toggle.setSelected(isVisible);
        toggle.setOpaque(false);
        toggle.getAccessibleContext().setAccessibleName("Show " + relation);
        toggle.addActionListener(event -> graphView.setRelationVisible(relation, toggle.isSelected()));

        final JComponent swatch = new JComponent() {
            @Override
            protected void paintComponent(Graphics g) {
                final Graphics2D g2 = Theme.smooth(g.create());
                g2.setColor(WitnessGraphView.colorOf(relation));
                g2.setStroke(WitnessGraphView.strokeOf(relation, 2f));
                g2.drawLine(1, getHeight() / 2, getWidth() - 1, getHeight() / 2);
                g2.dispose();
            }
        };
        swatch.setPreferredSize(new Dimension(24, 16));

        final JPanel row = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 2));
        row.setOpaque(false);
        row.setAlignmentX(Component.LEFT_ALIGNMENT);
        row.add(toggle);
        row.add(swatch);
        row.add(new Text(relation, Text.Role.MONO));
        row.add(new Text(RELATION_DESCRIPTIONS.getOrDefault(relation, ""), Text.Role.MUTED));
        return row;
    }

    private static void addRow(JPanel panel, int row, JComponent key, JComponent value) {
        final GridBagConstraints constraints = new GridBagConstraints();
        constraints.gridy = row;
        constraints.anchor = GridBagConstraints.NORTHWEST;
        constraints.insets = new Insets(0, 0, 8, 16);
        constraints.gridx = 0;
        if (value == null) {
            constraints.gridwidth = 2;
            constraints.weightx = 1;
            constraints.fill = GridBagConstraints.HORIZONTAL;
            panel.add(key, constraints);
            return;
        }
        panel.add(key, constraints);
        constraints.gridx = 1;
        constraints.weightx = 1;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.insets = new Insets(0, 0, 8, 0);
        panel.add(value, constraints);
    }

    // ================================= Behaviour =================================

    private void showEvent(Node node) {
        eventPanel.removeAll();
        if (node == null) {
            addRow(eventPanel, 0, new Text("Click an event to inspect it.", Text.Role.MUTED), null);
        } else {
            final Text title = new Text(node.label(), Text.Role.MONO);
            title.setFont(Theme.mono(15f).deriveFont(Font.BOLD));
            addRow(eventPanel, 0, title, null);
            int row = 1;
            for (Map.Entry<String, String> detail : node.details().entrySet()) {
                addRow(eventPanel, row++, new Text(detail.getKey(), Text.Role.MUTED), wrapped(detail.getValue()));
            }
            for (Edge edge : graph.edges()) {
                if (edge.relation().equals(RF) && edge.to() == node.id()) {
                    final Node source = graph.nodes().get(edge.from());
                    final String origin = source.isInit() ? "init " : graph.columns().get(source.column()) + ": ";
                    addRow(eventPanel, row++, new Text("Reads from", Text.Role.MUTED), wrapped(origin + source.label()));
                }
            }
        }
        eventPanel.revalidate();
        eventPanel.repaint();
    }

    // Long values, e.g., instructions, wrap instead of widening the inspector.
    private static JComponent wrapped(String text) {
        final JTextArea area = new JTextArea(text) {
            @Override
            public void updateUI() {
                super.updateUI();
                setFont(Theme.mono(13f));
                setForeground(Theme.p().ink());
            }
        };
        area.setEditable(false);
        area.setLineWrap(true);
        area.setWrapStyleWord(false);
        area.setOpaque(false);
        area.setBorder(BorderFactory.createEmptyBorder());
        area.setColumns(14);
        return area;
    }

    private void exportImage() {
        if (graph == null || exportChooser.showSaveDialog(this) != JFileChooser.APPROVE_OPTION) {
            return;
        }
        File file = exportChooser.getSelectedFile();
        if (!file.getName().toLowerCase().endsWith(".png")) {
            file = new File(file.getParentFile(), file.getName() + ".png");
        }
        if (file.exists() && JOptionPane.showConfirmDialog(this, file.getName() + " already exists. Replace it?",
                "Export witness", JOptionPane.OK_CANCEL_OPTION) != JOptionPane.OK_OPTION) {
            return;
        }
        try {
            ImageIO.write(graphView.toImage(2.0), "png", file);
        } catch (IOException e) {
            showError(e.getMessage(), "Error while exporting the witness");
        }
    }
}
