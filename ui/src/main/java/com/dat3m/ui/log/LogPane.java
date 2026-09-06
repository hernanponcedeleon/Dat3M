package com.dat3m.ui.log;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.AppenderBase;
import org.slf4j.LoggerFactory;

import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

import static java.awt.FlowLayout.LEFT;

public class LogPane extends JPanel {

    private static final int PREFERRED_HEIGHT = 240;
    private static final DateTimeFormatter TIMESTAMP_FORMAT = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss")
            .withZone(ZoneId.systemDefault());

    private final JTextArea logArea = new JTextArea();
    private final Logger rootLogger = (Logger) LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME);

    public LogPane() {
        super(new BorderLayout());
        final TitledBorder border = BorderFactory.createTitledBorder("Log");
        border.setTitleJustification(TitledBorder.CENTER);
        setBorder(border);
        setMinimumSize(new Dimension(0, 120));
        setPreferredSize(new Dimension(0, PREFERRED_HEIGHT));

        logArea.setEditable(false);
        logArea.setFont(new Font(Font.MONOSPACED, Font.PLAIN, logArea.getFont().getSize()));

        final JComboBox<Level> levelSelector = new JComboBox<>(new Level[]{
                Level.TRACE, Level.DEBUG, Level.INFO, Level.WARN, Level.ERROR
        });
        levelSelector.setSelectedItem(rootLogger.getEffectiveLevel());
        levelSelector.addActionListener(ignored -> rootLogger.setLevel((Level) levelSelector.getSelectedItem()));

        final JPanel controls = new JPanel(new FlowLayout(LEFT));
        controls.add(new JLabel("Log level:"));
        controls.add(levelSelector);
        add(controls, BorderLayout.NORTH);
        add(new JScrollPane(logArea), BorderLayout.CENTER);

        final AppenderBase<ILoggingEvent> appender = new AppenderBase<>() {
            @Override
            protected void append(ILoggingEvent event) {
                SwingUtilities.invokeLater(() -> appendLogEvent(event));
            }
        };
        appender.start();
        rootLogger.addAppender(appender);
    }

    public void clear() {
        logArea.setText("");
    }

    private void appendLogEvent(ILoggingEvent event) {
        final String loggerName = event.getLoggerName();
        final int packageSeparator = loggerName.lastIndexOf('.');
        final String source = packageSeparator < 0 ? loggerName : loggerName.substring(packageSeparator + 1);
        logArea.append("[%s] [%s] %s - %s%n".formatted(
                TIMESTAMP_FORMAT.format(Instant.ofEpochMilli(event.getTimeStamp())),
                event.getLevel(),
                source,
                event.getFormattedMessage()
        ));
        logArea.setCaretPosition(logArea.getDocument().getLength());
    }
}
