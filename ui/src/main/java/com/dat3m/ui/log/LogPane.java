package com.dat3m.ui.log;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.AppenderBase;
import com.dat3m.ui.theme.Theme;
import org.slf4j.LoggerFactory;

import javax.swing.*;
import java.awt.*;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

public class LogPane extends JPanel {

    private static final DateTimeFormatter TIMESTAMP_FORMAT = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss")
            .withZone(ZoneId.systemDefault());

    private final JTextArea logArea = new JTextArea() {
        @Override
        public void updateUI() {
            super.updateUI();
            setFont(Theme.mono(12f));
            setBackground(Theme.p().panel());
            setForeground(Theme.p().ink());
        }
    };
    private final Logger rootLogger = (Logger) LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME);
    private final JComboBox<Level> levelSelector = new JComboBox<>(new Level[]{
            Level.TRACE, Level.DEBUG, Level.INFO, Level.WARN, Level.ERROR
    });

    public LogPane() {
        super(new BorderLayout());

        logArea.setEditable(false);
        logArea.setBorder(BorderFactory.createEmptyBorder(12, 24, 12, 24));
        logArea.getAccessibleContext().setAccessibleName("Log");

        levelSelector.setSelectedItem(rootLogger.getEffectiveLevel());
        levelSelector.setToolTipText("Log level");
        levelSelector.getAccessibleContext().setAccessibleName("Log level");
        levelSelector.addActionListener(ignored -> rootLogger.setLevel((Level) levelSelector.getSelectedItem()));

        final JScrollPane scroll = new JScrollPane(logArea);
        scroll.setBorder(BorderFactory.createEmptyBorder());
        add(scroll, BorderLayout.CENTER);

        final AppenderBase<ILoggingEvent> appender = new AppenderBase<>() {
            @Override
            protected void append(ILoggingEvent event) {
                SwingUtilities.invokeLater(() -> appendLogEvent(event));
            }
        };
        appender.start();
        rootLogger.addAppender(appender);
    }

    // The selector is placed by the owner of the pane, next to the tab of the log.
    public JComboBox<Level> getLevelSelector() {
        return levelSelector;
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
