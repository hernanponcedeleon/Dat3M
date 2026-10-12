package com.dat3m.ui.witness;

import com.dat3m.ui.theme.Theme;
import com.dat3m.ui.witness.WitnessGraph.Edge;
import com.dat3m.ui.witness.WitnessGraph.Kind;
import com.dat3m.ui.witness.WitnessGraph.Node;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.geom.CubicCurve2D;
import java.awt.geom.Line2D;
import java.awt.geom.Path2D;
import java.awt.geom.Point2D;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.BiPredicate;
import java.util.function.Consumer;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.PO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;
import static com.dat3m.ui.witness.WitnessGraph.FR;

// Draws a witness execution: one column per thread, events in program order from top to bottom.
public class WitnessGraphView extends JComponent implements Scrollable {

    private static final int NODE_WIDTH = 200;
    private static final int NODE_HEIGHT = 52;
    private static final int COLUMN_GAP = 120;
    private static final int ROW_GAP = 40;
    private static final int MARGIN = 40;
    private static final int HEADER_HEIGHT = 44;
    private static final int GRID = 24;
    // Blue, purple, teal, magenta and brown: apart from the black, green, red and orange of the standard relations.
    private static final Color[] MODEL_RELATION_COLORS_LIGHT = {
            new Color(0x2545D3), new Color(0x7A4FBF), new Color(0x0A7F86), new Color(0xB3267F), new Color(0x8A5A2B)};
    private static final Color[] MODEL_RELATION_COLORS_DARK = {
            new Color(0x8FB0FF), new Color(0xC3A6FF), new Color(0x5FD3D0), new Color(0xF28AC6), new Color(0xD9A66B)};
    private static final double[] MODEL_RELATION_OFFSETS = {-5, 5, -15, 15, -20, 20};
    private static final Set<String> DEFAULT_REDUCED_RELATIONS = Set.of(PO, RF, CO, FR);
    private static final double MIN_SCALE = 0.4;
    private static final double MAX_SCALE = 2.5;

    private WitnessGraph graph;
    private final Set<String> visibleRelations = new HashSet<>();
    // The relations of the memory model that were shown so far, in the order in which they were added.
    private final List<String> modelRelations = new ArrayList<>();
    // The relations whose transitive edges are left out.
    private final Set<String> reducedRelations = new HashSet<>();
    private final Set<Integer> hiddenNodes = new HashSet<>();
    private final Set<Kind> hiddenKinds = EnumSet.noneOf(Kind.class);
    // The layout only covers the visible nodes. Hiding nodes closes the gaps they leave.
    private final Map<Integer, Rectangle2D> layout = new HashMap<>();
    private final List<Edge> visibleEdges = new ArrayList<>();
    private String highlightedAddress;
    private Node selected;
    private double scale = 1.0;
    private Consumer<Node> selectionListener = node -> { };
    private Runnable stateListener = () -> { };

    public WitnessGraphView() {
        setOpaque(true);
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent event) {
                select(findNode(event.getX() / scale, event.getY() / scale));
                showMenu(event);
            }

            @Override
            public void mouseReleased(MouseEvent event) {
                showMenu(event);
            }
        });
        addMouseWheelListener(event -> {
            if (event.isControlDown() || event.isMetaDown()) {
                zoom(event.getWheelRotation() < 0 ? 1.1 : 1 / 1.1);
            } else {
                // Let the enclosing scroll pane handle ordinary scrolling.
                getParent().dispatchEvent(SwingUtilities.convertMouseEvent(this, event, getParent()));
            }
        });
    }

    public void setGraph(WitnessGraph graph, Set<String> visibleRelations) {
        this.graph = graph;
        this.visibleRelations.clear();
        this.visibleRelations.addAll(visibleRelations);
        this.modelRelations.clear();
        this.reducedRelations.clear();
        this.reducedRelations.addAll(DEFAULT_REDUCED_RELATIONS);
        this.hiddenNodes.clear();
        this.hiddenKinds.clear();
        this.highlightedAddress = null;
        this.scale = 1.0;
        select(null);
        relayout();
    }

    // ================================= Hiding and highlighting =================================

    public void hide(Node node) {
        hiddenNodes.add(node.id());
        relayout();
    }

    public void showHiddenEvents() {
        hiddenNodes.clear();
        relayout();
    }

    // The number of events that were hidden individually.
    public int getHiddenEventCount() {
        return hiddenNodes.size();
    }

    public void setKindVisible(Kind kind, boolean visible) {
        if (visible) {
            hiddenKinds.remove(kind);
        } else {
            hiddenKinds.add(kind);
        }
        relayout();
    }

    // Emphasizes the events that access the address. Null removes the emphasis.
    public void setHighlightedAddress(String address) {
        highlightedAddress = address;
        stateListener.run();
        repaint();
    }

    public String getHighlightedAddress() {
        return highlightedAddress;
    }

    // The listener is notified whenever events get hidden, shown or highlighted.
    public void setStateListener(Runnable listener) {
        this.stateListener = listener;
    }

    private boolean isVisible(Node node) {
        return !hiddenNodes.contains(node.id()) && !hiddenKinds.contains(node.kind());
    }

    private boolean isHighlighted(Node node) {
        return highlightedAddress != null && highlightedAddress.equals(node.address());
    }

    private void relayout() {
        layout.clear();
        visibleEdges.clear();
        if (graph != null) {
            final Map<Integer, List<Node>> columns = new HashMap<>();
            for (Node node : graph.nodes()) {
                if (!isVisible(node)) {
                    continue;
                }
                final List<Node> column = columns.computeIfAbsent(node.column(), key -> new ArrayList<>());
                layout.put(node.id(), new Rectangle2D.Double(
                        MARGIN + node.column() * (NODE_WIDTH + COLUMN_GAP),
                        MARGIN + HEADER_HEIGHT + column.size() * (NODE_HEIGHT + ROW_GAP),
                        NODE_WIDTH, NODE_HEIGHT));
                column.add(node);
            }
            // Edges are only computed for the relations that are shown, since relations can be large.
            for (String relation : visibleRelations) {
                visibleEdges.addAll(getVisibleEdges(relation, columns));
            }
            if (selected != null && !isVisible(selected)) {
                select(null);
            }
        }
        stateListener.run();
        revalidate();
        repaint();
    }

    // The edges of the relation between the visible events, without transitive edges if the relation is reduced.
    private List<Edge> getVisibleEdges(String relation, Map<Integer, List<Node>> columns) {
        final boolean isReduced = isReduced(relation);
        if (relation.equals(PO)) {
            // The program order follows from the order of the events in their columns.
            final List<Edge> edges = new ArrayList<>();
            for (List<Node> column : columns.values()) {
                for (int i = 0; i < column.size() && !column.get(i).isInit(); i++) {
                    for (int j = i + 1; j < (isReduced ? Math.min(i + 2, column.size()) : column.size()); j++) {
                        edges.add(new Edge(PO, column.get(i).id(), column.get(j).id()));
                    }
                }
            }
            return edges;
        }
        final List<Edge> edges = getAllEdges(relation).stream()
                .filter(edge -> layout.containsKey(edge.from()) && layout.containsKey(edge.to()))
                .toList();
        if (!isReduced) {
            return edges;
        }
        if (relation.equals(FR)) {
            // A read is only connected to the earliest writes that overwrite the value it read.
            final Set<Edge> coherence = new HashSet<>(getAllEdges(CO));
            return edges.stream()
                    .filter(edge -> edges.stream().noneMatch(other -> other.from() == edge.from()
                            && coherence.contains(new Edge(CO, other.to(), edge.to()))))
                    .toList();
        }
        final List<Edge> reduced = removeTransitiveEdges(edges);
        if (relation.equals(CO)) {
            // Like in the graphical witnesses, coherence edges within a thread are omitted because they follow from po.
            return reduced.stream()
                    .filter(edge -> graph.nodes().get(edge.from()).column() != graph.nodes().get(edge.to()).column())
                    .toList();
        }
        return reduced;
    }

    private List<Edge> getAllEdges(String relation) {
        final List<Edge> modelRelation = graph.modelRelations().get(relation);
        return modelRelation != null ? modelRelation
                : graph.edges().stream().filter(edge -> edge.relation().equals(relation)).toList();
    }

    /*
        Removes every edge (a, c) for which some event b lies strictly between a and c, i.e.,
        b is reachable from a and reaches c, but neither reaches a nor is reachable from c.
        On acyclic relations this is the transitive reduction. Edges within cycles are all kept.
     */
    private static List<Edge> removeTransitiveEdges(List<Edge> edges) {
        final Map<Integer, Set<Integer>> successors = new HashMap<>();
        edges.forEach(edge -> successors.computeIfAbsent(edge.from(), key -> new HashSet<>()).add(edge.to()));
        final Map<Integer, Set<Integer>> reachable = new HashMap<>();
        for (Integer start : successors.keySet()) {
            final Set<Integer> reached = new HashSet<>();
            final Deque<Integer> worklist = new ArrayDeque<>(successors.get(start));
            while (!worklist.isEmpty()) {
                final Integer next = worklist.pop();
                if (reached.add(next)) {
                    worklist.addAll(successors.getOrDefault(next, Set.of()));
                }
            }
            reachable.put(start, reached);
        }
        final BiPredicate<Integer, Integer> reaches = (from, to) -> reachable.getOrDefault(from, Set.of()).contains(to);
        return edges.stream()
                .filter(edge -> reachable.get(edge.from()).stream().noneMatch(between ->
                        reaches.test(between, edge.to())
                                && !reaches.test(between, edge.from())
                                && !reaches.test(edge.to(), between)))
                .toList();
    }

    private void showMenu(MouseEvent event) {
        if (!event.isPopupTrigger() || graph == null) {
            return;
        }
        final Node node = findNode(event.getX() / scale, event.getY() / scale);
        final JPopupMenu menu = new JPopupMenu();
        if (node != null) {
            menu.add("Hide event").addActionListener(ignored -> hide(node));
            if (node.address() != null && !isHighlighted(node)) {
                menu.add("Highlight accesses to " + node.address())
                        .addActionListener(ignored -> setHighlightedAddress(node.address()));
            }
        }
        if (highlightedAddress != null) {
            menu.add("Remove highlight").addActionListener(ignored -> setHighlightedAddress(null));
        }
        if (!hiddenNodes.isEmpty()) {
            menu.add("Show hidden events").addActionListener(ignored -> showHiddenEvents());
        }
        if (menu.getComponentCount() > 0) {
            menu.show(this, event.getX(), event.getY());
        }
    }

    public void setRelationVisible(String relation, boolean visible) {
        if (visible) {
            visibleRelations.add(relation);
            if (graph != null && graph.modelRelations().containsKey(relation) && !modelRelations.contains(relation)) {
                modelRelations.add(relation);
            }
        } else {
            visibleRelations.remove(relation);
        }
        relayout();
    }

    // A reduced relation is shown without the edges that are implied by its other edges.
    public void setReduced(String relation, boolean reduced) {
        if (reduced) {
            reducedRelations.add(relation);
        } else {
            reducedRelations.remove(relation);
        }
        relayout();
    }

    public boolean isReduced(String relation) {
        return reducedRelations.contains(relation);
    }

    public void setSelectionListener(Consumer<Node> listener) {
        this.selectionListener = listener;
    }

    public void zoom(double factor) {
        scale = Math.max(MIN_SCALE, Math.min(MAX_SCALE, scale * factor));
        revalidate();
        repaint();
    }

    public Color colorOf(String relation) {
        final Theme.Palette p = Theme.p();
        return switch (relation) {
            case PO -> p.po();
            case RF -> p.rf();
            case CO -> p.co();
            case FR -> p.fr();
            // Relations of the memory model get their colors in the order in which they were added.
            default -> {
                final Color[] colors = Theme.isDark() ? MODEL_RELATION_COLORS_DARK : MODEL_RELATION_COLORS_LIGHT;
                yield colors[Math.max(0, modelRelations.indexOf(relation)) % colors.length];
            }
        };
    }

    public static Stroke strokeOf(String relation, float width) {
        return switch (relation) {
            case FR -> new BasicStroke(width, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND, 1f, new float[]{6f, 5f}, 0f);
            default -> new BasicStroke(width, BasicStroke.CAP_ROUND, BasicStroke.JOIN_ROUND);
        };
    }

    // Renders the whole graph, independent of the current zoom level and scroll position.
    public BufferedImage toImage(double resolution) {
        final Dimension size = getGraphSize();
        final BufferedImage image = new BufferedImage((int) Math.ceil(size.width * resolution),
                (int) Math.ceil(size.height * resolution), BufferedImage.TYPE_INT_RGB);
        final Graphics2D g2 = Theme.smooth(image.createGraphics());
        g2.setColor(Theme.p().ground());
        g2.fillRect(0, 0, image.getWidth(), image.getHeight());
        g2.scale(resolution, resolution);
        paintGraph(g2);
        g2.dispose();
        return image;
    }

    // ================================= Layout =================================

    private Dimension getGraphSize() {
        if (graph == null || graph.columns().isEmpty()) {
            return new Dimension(2 * MARGIN, 2 * MARGIN);
        }
        final int columns = graph.columns().size();
        final double bottom = layout.values().stream().mapToDouble(Rectangle2D::getMaxY).max()
                .orElse(MARGIN + HEADER_HEIGHT);
        return new Dimension(
                2 * MARGIN + columns * NODE_WIDTH + (columns - 1) * COLUMN_GAP,
                (int) bottom + MARGIN);
    }

    private Rectangle2D boundsOf(Node node) {
        return layout.get(node.id());
    }

    private Node findNode(double x, double y) {
        if (graph == null) {
            return null;
        }
        return graph.nodes().stream()
                .filter(node -> layout.containsKey(node.id()) && boundsOf(node).contains(x, y))
                .findFirst().orElse(null);
    }

    private void select(Node node) {
        selected = node;
        selectionListener.accept(node);
        repaint();
    }

    @Override
    public Dimension getPreferredSize() {
        final Dimension size = getGraphSize();
        return new Dimension((int) Math.ceil(size.width * scale), (int) Math.ceil(size.height * scale));
    }

    // ================================= Painting =================================

    @Override
    protected void paintComponent(Graphics g) {
        final Graphics2D g2 = Theme.smooth(g.create());
        final Rectangle clip = g2.getClipBounds();
        g2.setColor(Theme.p().ground());
        g2.fill(clip);
        g2.setColor(Theme.p().grid());
        for (int x = clip.x - clip.x % GRID; x < clip.x + clip.width; x += GRID) {
            for (int y = clip.y - clip.y % GRID; y < clip.y + clip.height; y += GRID) {
                g2.fillRect(x, y, 1, 1);
            }
        }
        g2.scale(scale, scale);
        paintGraph(g2);
        g2.dispose();
    }

    private void paintGraph(Graphics2D g2) {
        if (graph == null) {
            return;
        }
        final Theme.Palette p = Theme.p();

        g2.setFont(Theme.tracked(Theme.ui(11f, Font.BOLD), 0.06f));
        g2.setColor(p.muted());
        for (int column = 0; column < graph.columns().size(); column++) {
            g2.drawString(graph.columns().get(column).toUpperCase(),
                    MARGIN + column * (NODE_WIDTH + COLUMN_GAP), MARGIN + 12);
        }

        // While a memory location is highlighted, everything that is unrelated to it fades into the background.
        final Composite opaque = g2.getComposite();
        final Composite faded = AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.3f);
        for (Edge edge : visibleEdges) {
            if (visibleRelations.contains(edge.relation())) {
                final boolean isRelated = isHighlighted(graph.nodes().get(edge.from())) && isHighlighted(graph.nodes().get(edge.to()));
                g2.setComposite(highlightedAddress == null || isRelated ? opaque : faded);
                paintEdge(g2, edge);
            }
        }
        for (Node node : graph.nodes()) {
            if (layout.containsKey(node.id())) {
                g2.setComposite(highlightedAddress == null || isHighlighted(node) ? opaque : faded);
                paintNode(g2, node);
            }
        }
        g2.setComposite(opaque);
    }

    private void paintNode(Graphics2D g2, Node node) {
        final Theme.Palette p = Theme.p();
        final Rectangle2D bounds = boundsOf(node);
        final boolean isSelected = node.equals(selected);
        final Shape box = new java.awt.geom.RoundRectangle2D.Double(
                bounds.getX(), bounds.getY(), bounds.getWidth(), bounds.getHeight(), 12, 12);

        final boolean isHighlighted = isHighlighted(node);
        g2.setColor(isSelected ? p.selection() : isHighlighted ? p.highlightFill() : node.isInit() ? p.panel() : p.nodeFill());
        g2.fill(box);
        g2.setColor(isSelected ? p.accent() : isHighlighted ? p.highlightLine() : p.nodeLine());
        g2.setStroke(isSelected || isHighlighted ? new BasicStroke(2f)
                : node.isInit() ? new BasicStroke(1f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_ROUND, 1f, new float[]{4f, 3f}, 0f)
                : new BasicStroke(1f));
        g2.draw(box);

        final int textX = (int) bounds.getX() + 12;
        final int textWidth = NODE_WIDTH - 24;
        g2.setFont(Theme.mono(13f).deriveFont(Font.BOLD));
        g2.setColor(p.ink());
        g2.drawString(fit(node.label(), g2.getFontMetrics(), textWidth), textX, (int) bounds.getY() + 22);
        g2.setFont(Theme.mono(11f));
        g2.setColor(p.muted());
        g2.drawString(fit(node.sublabel(), g2.getFontMetrics(), textWidth), textX, (int) bounds.getY() + 40);
    }

    private static String fit(String text, FontMetrics metrics, int width) {
        if (metrics.stringWidth(text) <= width) {
            return text;
        }
        int length = text.length();
        while (length > 0 && metrics.stringWidth(text.substring(0, length) + "…") > width) {
            length--;
        }
        return text.substring(0, length) + "…";
    }

    private void paintEdge(Graphics2D g2, Edge edge) {
        final Node from = graph.nodes().get(edge.from());
        final Node to = graph.nodes().get(edge.to());
        final Rectangle2D a = boundsOf(from);
        final Rectangle2D b = boundsOf(to);
        final boolean isHighlighted = selected != null && (from.equals(selected) || to.equals(selected));
        final float width = isHighlighted ? 2.5f : 1.5f;
        final Color color = colorOf(edge.relation());

        final Shape line;
        final Point2D tip;
        final Point2D beforeTip;
        final Point2D labelAnchor;
        if (edge.relation().equals(PO) && Math.abs(b.getMinY() - a.getMaxY() - ROW_GAP) < 0.5) {
            // Neighbours in a column are connected by a straight line.
            final Point2D start = new Point2D.Double(a.getCenterX(), a.getMaxY());
            tip = new Point2D.Double(b.getCenterX(), b.getMinY());
            beforeTip = start;
            line = new Line2D.Double(start, tip);
            labelAnchor = new Point2D.Double(start.getX() + 16, (start.getY() + tip.getY()) / 2);
        } else if (from.column() == to.column()) {
            // Other edges within a column bulge out to the right, so that they do not cross the events in between.
            final double bulge = Math.min(COLUMN_GAP - 30, 30 + 14 * Math.abs(b.getY() - a.getY()) / (NODE_HEIGHT + ROW_GAP));
            final Point2D start = new Point2D.Double(a.getMaxX(), a.getCenterY());
            tip = new Point2D.Double(b.getMaxX(), b.getCenterY());
            beforeTip = new Point2D.Double(tip.getX() + bulge, tip.getY());
            line = new CubicCurve2D.Double(start.getX(), start.getY(), start.getX() + bulge, start.getY(),
                    beforeTip.getX(), beforeTip.getY(), tip.getX(), tip.getY());
            labelAnchor = new Point2D.Double(start.getX() + 0.75 * bulge, (start.getY() + tip.getY()) / 2);
        } else if (Math.abs(from.column() - to.column()) == 1) {
            // Edges between neighbouring columns leave and enter at the facing sides.
            final boolean leftToRight = from.column() < to.column();
            final double offset = offsetOf(edge.relation());
            final Point2D start = new Point2D.Double(leftToRight ? a.getMaxX() : a.getMinX(), a.getCenterY() + offset);
            tip = new Point2D.Double(leftToRight ? b.getMinX() : b.getMaxX(), b.getCenterY() + offset);
            final double reach = Math.max(40, Math.abs(tip.getX() - start.getX()) / 2) * (leftToRight ? 1 : -1);
            beforeTip = new Point2D.Double(tip.getX() - reach, tip.getY());
            line = new CubicCurve2D.Double(start.getX(), start.getY(), start.getX() + reach, start.getY(),
                    beforeTip.getX(), beforeTip.getY(), tip.getX(), tip.getY());
            // Labels sit near the start, where edges of different sources have not yet converged.
            // They are staggered, so that the labels of parallel edges do not cover each other.
            final double distance = 26 + (offset + 10) * 2.2;
            labelAnchor = new Point2D.Double(start.getX() + (leftToRight ? distance : -distance),
                    start.getY() + (tip.getY() - start.getY()) * 0.1);
        } else {
            // Edges that skip columns travel through the gap above the row of their target and enter it from the top,
            // so that they do not cross the events of the columns in between.
            final int direction = from.column() < to.column() ? 1 : -1;
            final double offset = offsetOf(edge.relation());
            final Point2D start = new Point2D.Double(direction > 0 ? a.getMaxX() : a.getMinX(), a.getCenterY() + offset);
            final boolean isTopRow = b.getMinY() <= MARGIN + HEADER_HEIGHT;
            final double laneY = b.getMinY() - (isTopRow ? HEADER_HEIGHT - 26 : ROW_GAP / 2.0) + offset / 2;
            final double laneStart = start.getX() + direction * (COLUMN_GAP / 2.0 + 20);
            tip = new Point2D.Double(b.getCenterX() - direction * (40 - 2 * offset), b.getMinY());
            beforeTip = new Point2D.Double(tip.getX(), laneY);
            final Path2D.Double path = new Path2D.Double();
            path.moveTo(start.getX(), start.getY());
            path.curveTo(start.getX() + direction * 40, start.getY(), laneStart - direction * 40, laneY, laneStart, laneY);
            path.lineTo(tip.getX() - direction * 12, laneY);
            path.quadTo(tip.getX(), laneY, tip.getX(), tip.getY());
            line = path;
            labelAnchor = new Point2D.Double(laneStart + direction * (24 + (offset + 10) * 2.2), laneY);
        }

        g2.setColor(color);
        g2.setStroke(strokeOf(edge.relation(), width));
        g2.draw(line);
        g2.setStroke(new BasicStroke(width));
        g2.fill(arrowHead(beforeTip, tip, isHighlighted ? 10 : 8));

        if (!edge.relation().equals(PO)) {
            g2.setFont(Theme.mono(11f));
            final FontMetrics metrics = g2.getFontMetrics();
            final int labelWidth = metrics.stringWidth(edge.relation());
            final int x = (int) labelAnchor.getX() - labelWidth / 2;
            final int y = (int) labelAnchor.getY();
            g2.setColor(Theme.p().ground());
            g2.fillRoundRect(x - 3, y - metrics.getAscent() / 2 - 3, labelWidth + 6, metrics.getAscent() + 4, 6, 6);
            g2.setColor(color);
            g2.drawString(edge.relation(), x, y + metrics.getAscent() / 2 - 1);
        }
    }

    // Relations get distinct heights so that edges between the same events do not overlap.
    private double offsetOf(String relation) {
        return switch (relation) {
            case RF -> -10;
            case CO -> 10;
            case FR -> 0;
            default -> MODEL_RELATION_OFFSETS[Math.max(0, modelRelations.indexOf(relation)) % MODEL_RELATION_OFFSETS.length];
        };
    }

    private static Shape arrowHead(Point2D from, Point2D tip, double size) {
        final double angle = Math.atan2(tip.getY() - from.getY(), tip.getX() - from.getX());
        final Path2D.Double head = new Path2D.Double();
        head.moveTo(tip.getX(), tip.getY());
        head.lineTo(tip.getX() - size * Math.cos(angle - Math.PI / 7), tip.getY() - size * Math.sin(angle - Math.PI / 7));
        head.lineTo(tip.getX() - size * Math.cos(angle + Math.PI / 7), tip.getY() - size * Math.sin(angle + Math.PI / 7));
        head.closePath();
        return head;
    }

    // ================================= Scrolling =================================

    @Override
    public Dimension getPreferredScrollableViewportSize() {
        return getPreferredSize();
    }

    @Override
    public int getScrollableUnitIncrement(Rectangle visibleRect, int orientation, int direction) {
        return GRID;
    }

    @Override
    public int getScrollableBlockIncrement(Rectangle visibleRect, int orientation, int direction) {
        return orientation == SwingConstants.VERTICAL ? visibleRect.height : visibleRect.width;
    }

    // The view fills the viewport if the graph is smaller, so that the background grid covers everything.
    @Override
    public boolean getScrollableTracksViewportWidth() {
        return getParent() != null && getParent().getWidth() > getPreferredSize().width;
    }

    @Override
    public boolean getScrollableTracksViewportHeight() {
        return getParent() != null && getParent().getHeight() > getPreferredSize().height;
    }
}
